From: akpm@linux-foundation.org
Subject: +
 kselftests-cgroup-add-kernel-memory-accounting-tests.patch added to -mm tree
Date: Wed, 17 Jun 2020 16:34:29 -0700
Message-ID: <20200617233429.YkQ5O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726945AbgFQXec (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 19:34:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tobin@kernel.org, tj@kernel.org, shakeelb@google.com, rientjes@google.com, penberg@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net, longman@redhat.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, dennis@kernel.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: kselftests: cgroup: add kernel memory accounting tests
has been added to the -mm tree.  Its filename is
     kselftests-cgroup-add-kernel-memory-accounting-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kselftests-cgroup-add-kernel-memory-accounting-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kselftests-cgroup-add-kernel-memory-accounting-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: kselftests: cgroup: add kernel memory accounting tests

Add some tests to cover the kernel memory accounting functionality.  These
are covering some issues (and changes) we had recently.

1) A test which allocates a lot of negative dentries, checks memcg slab
   statistics, creates memory pressure by setting memory.max to some low
   value and checks that some number of slabs was reclaimed.

2) A test which covers side effects of memcg destruction: it creates
   and destroys a large number of sub-cgroups, each containing a
   multi-threaded workload which allocates and releases some kernel
   memory.  Then it checks that the charge ans memory.stats do add up on
   the parent level.

3) A test which reads /proc/kpagecgroup and implicitly checks that it
   doesn't crash the system.

4) A test which spawns a large number of threads and checks that the
   kernel stacks accounting works as expected.

5) A test which checks that living charged slab objects are not
   preventing the memory cgroup from being released after being deleted by
   a user.

Link: http://lkml.kernel.org/r/20200608230654.828134-19-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/.gitignore  |    1 
 tools/testing/selftests/cgroup/Makefile    |    2 
 tools/testing/selftests/cgroup/test_kmem.c |  382 +++++++++++++++++++
 3 files changed, 385 insertions(+)

--- a/tools/testing/selftests/cgroup/.gitignore~kselftests-cgroup-add-kernel-memory-accounting-tests
+++ a/tools/testing/selftests/cgroup/.gitignore
@@ -2,3 +2,4 @@
 test_memcontrol
 test_core
 test_freezer
+test_kmem
\ No newline at end of file
--- a/tools/testing/selftests/cgroup/Makefile~kselftests-cgroup-add-kernel-memory-accounting-tests
+++ a/tools/testing/selftests/cgroup/Makefile
@@ -6,11 +6,13 @@ all:
 TEST_FILES     := with_stress.sh
 TEST_PROGS     := test_stress.sh
 TEST_GEN_PROGS = test_memcontrol
+TEST_GEN_PROGS += test_kmem
 TEST_GEN_PROGS += test_core
 TEST_GEN_PROGS += test_freezer
 
 include ../lib.mk
 
 $(OUTPUT)/test_memcontrol: cgroup_util.c ../clone3/clone3_selftests.h
+$(OUTPUT)/test_kmem: cgroup_util.c ../clone3/clone3_selftests.h
 $(OUTPUT)/test_core: cgroup_util.c ../clone3/clone3_selftests.h
 $(OUTPUT)/test_freezer: cgroup_util.c ../clone3/clone3_selftests.h
--- /dev/null
+++ a/tools/testing/selftests/cgroup/test_kmem.c
@@ -0,0 +1,382 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+
+#include <linux/limits.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <sys/wait.h>
+#include <errno.h>
+#include <sys/sysinfo.h>
+#include <pthread.h>
+
+#include "../kselftest.h"
+#include "cgroup_util.h"
+
+
+static int alloc_dcache(const char *cgroup, void *arg)
+{
+	unsigned long i;
+	struct stat st;
+	char buf[128];
+
+	for (i = 0; i < (unsigned long)arg; i++) {
+		snprintf(buf, sizeof(buf),
+			"/something-non-existent-with-a-long-name-%64lu-%d",
+			 i, getpid());
+		stat(buf, &st);
+	}
+
+	return 0;
+}
+
+/*
+ * This test allocates 100000 of negative dentries with long names.
+ * Then it checks that "slab" in memory.stat is larger than 1M.
+ * Then it sets memory.high to 1M and checks that at least 1/2
+ * of slab memory has been reclaimed.
+ */
+static int test_kmem_basic(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *cg = NULL;
+	long slab0, slab1, current;
+
+	cg = cg_name(root, "kmem_basic_test");
+	if (!cg)
+		goto cleanup;
+
+	if (cg_create(cg))
+		goto cleanup;
+
+	if (cg_run(cg, alloc_dcache, (void *)100000))
+		goto cleanup;
+
+	slab0 = cg_read_key_long(cg, "memory.stat", "slab ");
+	if (slab0 < (1 << 20))
+		goto cleanup;
+
+	cg_write(cg, "memory.high", "1M");
+	slab1 = cg_read_key_long(cg, "memory.stat", "slab ");
+	if (slab1 <= 0)
+		goto cleanup;
+
+	current = cg_read_long(cg, "memory.current");
+	if (current <= 0)
+		goto cleanup;
+
+	if (slab1 < slab0 / 2 && current < slab0 / 2)
+		ret = KSFT_PASS;
+cleanup:
+	cg_destroy(cg);
+	free(cg);
+
+	return ret;
+}
+
+static void *alloc_kmem_fn(void *arg)
+{
+	alloc_dcache(NULL, (void *)100);
+	return NULL;
+}
+
+static int alloc_kmem_smp(const char *cgroup, void *arg)
+{
+	int nr_threads = 2 * get_nprocs();
+	pthread_t *tinfo;
+	unsigned long i;
+	int ret = -1;
+
+	tinfo = calloc(nr_threads, sizeof(pthread_t));
+	if (tinfo == NULL)
+		return -1;
+
+	for (i = 0; i < nr_threads; i++) {
+		if (pthread_create(&tinfo[i], NULL, &alloc_kmem_fn,
+				   (void *)i)) {
+			free(tinfo);
+			return -1;
+		}
+	}
+
+	for (i = 0; i < nr_threads; i++) {
+		ret = pthread_join(tinfo[i], NULL);
+		if (ret)
+			break;
+	}
+
+	free(tinfo);
+	return ret;
+}
+
+static int cg_run_in_subcgroups(const char *parent,
+				int (*fn)(const char *cgroup, void *arg),
+				void *arg, int times)
+{
+	char *child;
+	int i;
+
+	for (i = 0; i < times; i++) {
+		child = cg_name_indexed(parent, "child", i);
+		if (!child)
+			return -1;
+
+		if (cg_create(child)) {
+			cg_destroy(child);
+			free(child);
+			return -1;
+		}
+
+		if (cg_run(child, fn, NULL)) {
+			cg_destroy(child);
+			free(child);
+			return -1;
+		}
+
+		cg_destroy(child);
+		free(child);
+	}
+
+	return 0;
+}
+
+/*
+ * The test creates and destroys a large number of cgroups. In each cgroup it
+ * allocates some slab memory (mostly negative dentries) using 2 * NR_CPUS
+ * threads. Then it checks the sanity of numbers on the parent level:
+ * the total size of the cgroups should be roughly equal to
+ * anon + file + slab + kernel_stack.
+ */
+static int test_kmem_memcg_deletion(const char *root)
+{
+	long current, slab, anon, file, kernel_stack, sum;
+	int ret = KSFT_FAIL;
+	char *parent;
+
+	parent = cg_name(root, "kmem_memcg_deletion_test");
+	if (!parent)
+		goto cleanup;
+
+	if (cg_create(parent))
+		goto cleanup;
+
+	if (cg_write(parent, "cgroup.subtree_control", "+memory"))
+		goto cleanup;
+
+	if (cg_run_in_subcgroups(parent, alloc_kmem_smp, NULL, 100))
+		goto cleanup;
+
+	current = cg_read_long(parent, "memory.current");
+	slab = cg_read_key_long(parent, "memory.stat", "slab ");
+	anon = cg_read_key_long(parent, "memory.stat", "anon ");
+	file = cg_read_key_long(parent, "memory.stat", "file ");
+	kernel_stack = cg_read_key_long(parent, "memory.stat", "kernel_stack ");
+	if (current < 0 || slab < 0 || anon < 0 || file < 0 ||
+	    kernel_stack < 0)
+		goto cleanup;
+
+	sum = slab + anon + file + kernel_stack;
+	if (abs(sum - current) < 4096 * 32 * 2 * get_nprocs()) {
+		ret = KSFT_PASS;
+	} else {
+		printf("memory.current = %ld\n", current);
+		printf("slab + anon + file + kernel_stack = %ld\n", sum);
+		printf("slab = %ld\n", slab);
+		printf("anon = %ld\n", anon);
+		printf("file = %ld\n", file);
+		printf("kernel_stack = %ld\n", kernel_stack);
+	}
+
+cleanup:
+	cg_destroy(parent);
+	free(parent);
+
+	return ret;
+}
+
+/*
+ * The test reads the entire /proc/kpagecgroup. If the operation went
+ * successfully (and the kernel didn't panic), the test is treated as passed.
+ */
+static int test_kmem_proc_kpagecgroup(const char *root)
+{
+	unsigned long buf[128];
+	int ret = KSFT_FAIL;
+	ssize_t len;
+	int fd;
+
+	fd = open("/proc/kpagecgroup", O_RDONLY);
+	if (fd < 0)
+		return ret;
+
+	do {
+		len = read(fd, buf, sizeof(buf));
+	} while (len > 0);
+
+	if (len == 0)
+		ret = KSFT_PASS;
+
+	close(fd);
+	return ret;
+}
+
+static void *pthread_wait_fn(void *arg)
+{
+	sleep(100);
+	return NULL;
+}
+
+static int spawn_1000_threads(const char *cgroup, void *arg)
+{
+	int nr_threads = 1000;
+	pthread_t *tinfo;
+	unsigned long i;
+	long stack;
+	int ret = -1;
+
+	tinfo = calloc(nr_threads, sizeof(pthread_t));
+	if (tinfo == NULL)
+		return -1;
+
+	for (i = 0; i < nr_threads; i++) {
+		if (pthread_create(&tinfo[i], NULL, &pthread_wait_fn,
+				   (void *)i)) {
+			free(tinfo);
+			return(-1);
+		}
+	}
+
+	stack = cg_read_key_long(cgroup, "memory.stat", "kernel_stack ");
+	if (stack >= 4096 * 1000)
+		ret = 0;
+
+	free(tinfo);
+	return ret;
+}
+
+/*
+ * The test spawns a process, which spawns 1000 threads. Then it checks
+ * that memory.stat's kernel_stack is at least 1000 pages large.
+ */
+static int test_kmem_kernel_stacks(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *cg = NULL;
+
+	cg = cg_name(root, "kmem_kernel_stacks_test");
+	if (!cg)
+		goto cleanup;
+
+	if (cg_create(cg))
+		goto cleanup;
+
+	if (cg_run(cg, spawn_1000_threads, NULL))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+cleanup:
+	cg_destroy(cg);
+	free(cg);
+
+	return ret;
+}
+
+/*
+ * This test sequentionally creates 30 child cgroups, allocates some
+ * kernel memory in each of them, and deletes them. Then it checks
+ * that the number of dying cgroups on the parent level is 0.
+ */
+static int test_kmem_dead_cgroups(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *parent;
+	long dead;
+	int i;
+
+	parent = cg_name(root, "kmem_dead_cgroups_test");
+	if (!parent)
+		goto cleanup;
+
+	if (cg_create(parent))
+		goto cleanup;
+
+	if (cg_write(parent, "cgroup.subtree_control", "+memory"))
+		goto cleanup;
+
+	if (cg_run_in_subcgroups(parent, alloc_dcache, (void *)100, 30))
+		goto cleanup;
+
+	for (i = 0; i < 5; i++) {
+		dead = cg_read_key_long(parent, "cgroup.stat",
+					"nr_dying_descendants ");
+		if (dead == 0) {
+			ret = KSFT_PASS;
+			break;
+		}
+		/*
+		 * Reclaiming cgroups might take some time,
+		 * let's wait a bit and repeat.
+		 */
+		sleep(1);
+	}
+
+cleanup:
+	cg_destroy(parent);
+	free(parent);
+
+	return ret;
+}
+
+#define T(x) { x, #x }
+struct kmem_test {
+	int (*fn)(const char *root);
+	const char *name;
+} tests[] = {
+	T(test_kmem_basic),
+	T(test_kmem_memcg_deletion),
+	T(test_kmem_proc_kpagecgroup),
+	T(test_kmem_kernel_stacks),
+	T(test_kmem_dead_cgroups),
+};
+#undef T
+
+int main(int argc, char **argv)
+{
+	char root[PATH_MAX];
+	int i, ret = EXIT_SUCCESS;
+
+	if (cg_find_unified_root(root, sizeof(root)))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+
+	/*
+	 * Check that memory controller is available:
+	 * memory is listed in cgroup.controllers
+	 */
+	if (cg_read_strstr(root, "cgroup.controllers", "memory"))
+		ksft_exit_skip("memory controller isn't available\n");
+
+	if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
+		if (cg_write(root, "cgroup.subtree_control", "+memory"))
+			ksft_exit_skip("Failed to set memory controller\n");
+
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		switch (tests[i].fn(root)) {
+		case KSFT_PASS:
+			ksft_test_result_pass("%s\n", tests[i].name);
+			break;
+		case KSFT_SKIP:
+			ksft_test_result_skip("%s\n", tests[i].name);
+			break;
+		default:
+			ret = EXIT_FAILURE;
+			ksft_test_result_fail("%s\n", tests[i].name);
+			break;
+		}
+	}
+
+	return ret;
+}
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state.patch
mm-memcg-prepare-for-byte-sized-vmstat-items.patch
mm-memcg-convert-vmstat-slab-counters-to-bytes.patch
mm-slub-implement-slub-version-of-obj_to_index.patch
mm-memcg-slab-obj_cgroup-api.patch
mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages.patch
mm-memcg-slab-save-obj_cgroup-for-non-root-slab-objects.patch
mm-memcg-slab-charge-individual-slab-objects-instead-of-pages.patch
mm-memcg-slab-deprecate-memorykmemslabinfo.patch
mm-memcg-slab-move-memcg_kmem_bypass-to-memcontrolh.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-accounted-allocations.patch
mm-memcg-slab-simplify-memcg-cache-creation.patch
mm-memcg-slab-remove-memcg_kmem_get_cache.patch
mm-memcg-slab-deprecate-slab_root_caches.patch
mm-memcg-slab-remove-redundant-check-in-memcg_accumulate_slabinfo.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations.patch
kselftests-cgroup-add-kernel-memory-accounting-tests.patch
tools-cgroup-add-memcg_slabinfopy-tool.patch
percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
