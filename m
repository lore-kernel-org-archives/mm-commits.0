From: akpm@linux-foundation.org
Subject: + kselftests-cgroup-add-perpcu-memory-accounting-test.patch
 added to -mm tree
Date: Wed, 17 Jun 2020 16:35:05 -0700
Message-ID: <20200617233505.wR1wD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbgFQXfH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 19:35:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tobin@kernel.org, tj@kernel.org, shakeelb@google.com, rientjes@google.com, penberg@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net, longman@redhat.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, dennis@kernel.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: kselftests: cgroup: add perpcu memory accounting test
has been added to the -mm tree.  Its filename is
     kselftests-cgroup-add-perpcu-memory-accounting-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kselftests-cgroup-add-perpcu-memory-accounting-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kselftests-cgroup-add-perpcu-memory-accounting-test.patch

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
Subject: kselftests: cgroup: add perpcu memory accounting test

Add a simple test to check the percpu memory accounting.  The test creates
a cgroup tree with 1000 child cgroups and checks values of memory.current
and memory.stat::percpu.

Link: http://lkml.kernel.org/r/20200608230819.832349-6-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_kmem.c |   70 ++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_kmem.c~kselftests-cgroup-add-perpcu-memory-accounting-test
+++ a/tools/testing/selftests/cgroup/test_kmem.c
@@ -18,6 +18,15 @@
 #include "cgroup_util.h"
 
 
+/*
+ * Memory cgroup charging and vmstat data aggregation is performed using
+ * percpu batches 32 pages big (look at MEMCG_CHARGE_BATCH). So the maximum
+ * discrepancy between charge and vmstat entries is number of cpus multiplied
+ * by 32 pages multiplied by 2.
+ */
+#define MAX_VMSTAT_ERROR (4096 * 32 * 2 * get_nprocs())
+
+
 static int alloc_dcache(const char *cgroup, void *arg)
 {
 	unsigned long i;
@@ -180,7 +189,7 @@ static int test_kmem_memcg_deletion(cons
 		goto cleanup;
 
 	sum = slab + anon + file + kernel_stack;
-	if (abs(sum - current) < 4096 * 32 * 2 * get_nprocs()) {
+	if (abs(sum - current) < MAX_VMSTAT_ERROR) {
 		ret = KSFT_PASS;
 	} else {
 		printf("memory.current = %ld\n", current);
@@ -331,6 +340,64 @@ cleanup:
 	return ret;
 }
 
+/*
+ * This test creates a sub-tree with 1000 memory cgroups.
+ * Then it checks that the memory.current on the parent level
+ * is greater than 0 and approximates matches the percpu value
+ * from memory.stat.
+ */
+static int test_percpu_basic(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *parent, *child;
+	long current, percpu;
+	int i;
+
+	parent = cg_name(root, "percpu_basic_test");
+	if (!parent)
+		goto cleanup;
+
+	if (cg_create(parent))
+		goto cleanup;
+
+	if (cg_write(parent, "cgroup.subtree_control", "+memory"))
+		goto cleanup;
+
+	for (i = 0; i < 1000; i++) {
+		child = cg_name_indexed(parent, "child", i);
+		if (!child)
+			return -1;
+
+		if (cg_create(child))
+			goto cleanup_children;
+
+		free(child);
+	}
+
+	current = cg_read_long(parent, "memory.current");
+	percpu = cg_read_key_long(parent, "memory.stat", "percpu ");
+
+	if (current > 0 && percpu > 0 && abs(current - percpu) <
+	    MAX_VMSTAT_ERROR)
+		ret = KSFT_PASS;
+	else
+		printf("memory.current %ld\npercpu %ld\n",
+		       current, percpu);
+
+cleanup_children:
+	for (i = 0; i < 1000; i++) {
+		child = cg_name_indexed(parent, "child", i);
+		cg_destroy(child);
+		free(child);
+	}
+
+cleanup:
+	cg_destroy(parent);
+	free(parent);
+
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct kmem_test {
 	int (*fn)(const char *root);
@@ -341,6 +408,7 @@ struct kmem_test {
 	T(test_kmem_proc_kpagecgroup),
 	T(test_kmem_kernel_stacks),
 	T(test_kmem_dead_cgroups),
+	T(test_percpu_basic),
 };
 #undef T
 
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
