Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B808136215B
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 10:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777025185; cv=none; b=BbACLmmGZg1ev2T+YMi0aqpHMZoNRpLBA/mbv2nePYsJ6NZU/vep1do1am8v+D5nZdYQLvDw3h5IU6ClgMyK++sGjrwbC6bIj+/bLOJJTXLhmoJX6N1I7pY//xAfOpN71+XbQMZpDs3uBoEVZCBvGHfhZDUkle5wyTLrbbi63IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777025185; c=relaxed/simple;
	bh=A4RHLxq5Lz/7IIDqLgCHhzSvcV6oA7LvLbGWoWulZjE=;
	h=Date:To:From:Subject:Message-Id; b=n2TV+NarCJzFNEEIu0bpzg45uNkg5Vq87fFnYJkSQLD7aLc0T0eSGoAXBJhr4WxerLv3OfPSAPtOcYhd9O5fHUd0llPLMr+0m6JXFNZGUj9Bd1ZvyNAK0OFftQM3FxJhePqBUIfBUwRr3V9J9/Bm9aX+nEY0XTm4KV0C3zeS9n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SqOaBc+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SqOaBc+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CF5C19425;
	Fri, 24 Apr 2026 10:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777025185;
	bh=A4RHLxq5Lz/7IIDqLgCHhzSvcV6oA7LvLbGWoWulZjE=;
	h=Date:To:From:Subject:From;
	b=SqOaBc+oSdtGQ2GPDebPLenCXQNM+4JfDoZF77RRwvOPnq4OyQiV4RWeIsTC2Bl7D
	 EF8rXt7ppaJkl4czWl8Q/2LCIEnKgT+lrdRGxIxMFoQgyoN0cc7SUyh5bN2FRqDhBQ
	 ymw4o570YZY8Bt0jZZWjUvtsQ6X19H75OG/M1l6E=
Date: Fri, 24 Apr 2026 03:06:24 -0700
To: mm-commits@vger.kernel.org,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-rename-page_size-to-buf_size-in-cgroup_util.patch added to mm-new branch
Message-Id: <20260424100625.43CF5C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/cgroup: rename PAGE_SIZE to BUF_SIZE in cgroup_util
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-rename-page_size-to-buf_size-in-cgroup_util.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-rename-page_size-to-buf_size-in-cgroup_util.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Li Wang <li.wang@linux.dev>
Subject: selftests/cgroup: rename PAGE_SIZE to BUF_SIZE in cgroup_util
Date: Fri, 24 Apr 2026 12:00:55 +0800

The cgroup utility code defines a local PAGE_SIZE macro hardcoded to 4096,
which is used primarily as a generic buffer size for reading cgroup and
proc files.  This naming is misleading because the value has nothing to do
with the actual page size of the system.  On architectures with larger
pages (e.g., 64K on arm64 or ppc64), the name suggests a relationship that
does not exist.  Additionally, the name can shadow or conflict with
PAGE_SIZE definitions from system headers, leading to confusion or subtle
bugs.

To resolve this, rename the macro to BUF_SIZE to accurately reflect its
purpose as a general I/O buffer size.

Furthermore, test_memcontrol currently relies on this hardcoded 4K value
to stride through memory and trigger page faults.  Update this logic to
use the actual system page size dynamically.  This micro-optimizes the
memory faulting process by ensuring it iterates correctly and efficiently
based on the underlying architecture's true page size.  (This part from
Waiman)

Link: https://lore.kernel.org/20260424040059.12940-5-li.wang@linux.dev
Signed-off-by: Li Wang <li.wang@linux.dev>
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/lib/cgroup_util.c         |   18 ++++-----
 tools/testing/selftests/cgroup/lib/include/cgroup_util.h |    4 +-
 tools/testing/selftests/cgroup/test_core.c               |    2 -
 tools/testing/selftests/cgroup/test_freezer.c            |    2 -
 tools/testing/selftests/cgroup/test_memcontrol.c         |   19 ++++++----
 5 files changed, 25 insertions(+), 20 deletions(-)

--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c~selftests-cgroup-rename-page_size-to-buf_size-in-cgroup_util
+++ a/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -140,7 +140,7 @@ int cg_read_strcmp_wait(const char *cgro
 
 int cg_read_strstr(const char *cgroup, const char *control, const char *needle)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 
 	if (cg_read(cgroup, control, buf, sizeof(buf)))
 		return -1;
@@ -170,7 +170,7 @@ long cg_read_long_fd(int fd)
 
 long cg_read_key_long(const char *cgroup, const char *control, const char *key)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	char *ptr;
 
 	if (cg_read(cgroup, control, buf, sizeof(buf)))
@@ -206,7 +206,7 @@ long cg_read_key_long_poll(const char *c
 
 long cg_read_lc(const char *cgroup, const char *control)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	const char delim[] = "\n";
 	char *line;
 	long cnt = 0;
@@ -258,7 +258,7 @@ int cg_write_numeric(const char *cgroup,
 static int cg_find_root(char *root, size_t len, const char *controller,
 			bool *nsdelegate)
 {
-	char buf[10 * PAGE_SIZE];
+	char buf[10 * BUF_SIZE];
 	char *fs, *mount, *type, *options;
 	const char delim[] = "\n\t ";
 
@@ -313,7 +313,7 @@ int cg_create(const char *cgroup)
 
 int cg_wait_for_proc_count(const char *cgroup, int count)
 {
-	char buf[10 * PAGE_SIZE] = {0};
+	char buf[10 * BUF_SIZE] = {0};
 	int attempts;
 	char *ptr;
 
@@ -338,7 +338,7 @@ int cg_wait_for_proc_count(const char *c
 
 int cg_killall(const char *cgroup)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	char *ptr = buf;
 
 	/* If cgroup.kill exists use it. */
@@ -548,7 +548,7 @@ int cg_run_nowait(const char *cgroup,
 
 int proc_mount_contains(const char *option)
 {
-	char buf[4 * PAGE_SIZE];
+	char buf[4 * BUF_SIZE];
 	ssize_t read;
 
 	read = read_text("/proc/mounts", buf, sizeof(buf));
@@ -560,7 +560,7 @@ int proc_mount_contains(const char *opti
 
 int cgroup_feature(const char *feature)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	ssize_t read;
 
 	read = read_text("/sys/kernel/cgroup/features", buf, sizeof(buf));
@@ -587,7 +587,7 @@ ssize_t proc_read_text(int pid, bool thr
 
 int proc_read_strstr(int pid, bool thread, const char *item, const char *needle)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 
 	if (proc_read_text(pid, thread, item, buf, sizeof(buf)) < 0)
 		return -1;
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h~selftests-cgroup-rename-page_size-to-buf_size-in-cgroup_util
+++ a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -2,8 +2,8 @@
 #include <stdbool.h>
 #include <stdlib.h>
 
-#ifndef PAGE_SIZE
-#define PAGE_SIZE 4096
+#ifndef BUF_SIZE
+#define BUF_SIZE 4096
 #endif
 
 #define MB(x) (x << 20)
--- a/tools/testing/selftests/cgroup/test_core.c~selftests-cgroup-rename-page_size-to-buf_size-in-cgroup_util
+++ a/tools/testing/selftests/cgroup/test_core.c
@@ -87,7 +87,7 @@ static int test_cgcore_destroy(const cha
 	int ret = KSFT_FAIL;
 	char *cg_test = NULL;
 	int child_pid;
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 
 	cg_test = cg_name(root, "cg_test");
 
--- a/tools/testing/selftests/cgroup/test_freezer.c~selftests-cgroup-rename-page_size-to-buf_size-in-cgroup_util
+++ a/tools/testing/selftests/cgroup/test_freezer.c
@@ -642,7 +642,7 @@ cleanup:
  */
 static int proc_check_stopped(int pid)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	int len;
 
 	len = proc_read_text(pid, 0, "stat", buf, sizeof(buf));
--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-cgroup-rename-page_size-to-buf_size-in-cgroup_util
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -26,6 +26,7 @@
 
 static bool has_localevents;
 static bool has_recursiveprot;
+static int page_size;
 
 int get_temp_fd(void)
 {
@@ -34,7 +35,7 @@ int get_temp_fd(void)
 
 int alloc_pagecache(int fd, size_t size)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	struct stat st;
 	int i;
 
@@ -61,7 +62,7 @@ int alloc_anon(const char *cgroup, void
 	char *buf, *ptr;
 
 	buf = malloc(size);
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	free(buf);
@@ -70,7 +71,7 @@ int alloc_anon(const char *cgroup, void
 
 int is_swap_enabled(void)
 {
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 	const char delim[] = "\n";
 	int cnt = 0;
 	char *line;
@@ -113,7 +114,7 @@ static int test_memcg_subtree_control(co
 {
 	char *parent, *child, *parent2 = NULL, *child2 = NULL;
 	int ret = KSFT_FAIL;
-	char buf[PAGE_SIZE];
+	char buf[BUF_SIZE];
 
 	/* Create two nested cgroups with the memory controller enabled */
 	parent = cg_name(root, "memcg_test_0");
@@ -184,7 +185,7 @@ static int alloc_anon_50M_check(const ch
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	current = cg_read_long(cgroup, "memory.current");
@@ -414,7 +415,7 @@ static int alloc_anon_noexit(const char
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	while (getppid() == ppid)
@@ -1000,7 +1001,7 @@ static int alloc_anon_50M_check_swap(con
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	mem_current = cg_read_long(cgroup, "memory.current");
@@ -1791,6 +1792,10 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 	int i, proc_status;
 
+	page_size = sysconf(_SC_PAGE_SIZE);
+	if (page_size <= 0)
+		page_size = BUF_SIZE;
+
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
_

Patches currently in -mm which might be from li.wang@linux.dev are

maintainers-update-li-wangs-email-address.patch
selftests-cgroup-skip-test_zswap-if-zswap-is-globally-disabled.patch
selftests-cgroup-avoid-oom-in-test_swapin_nozswap.patch
selftests-cgroup-use-runtime-page-size-for-zswpin-check.patch
selftests-cgroup-rename-page_size-to-buf_size-in-cgroup_util.patch
selftests-cgroup-replace-hardcoded-page-size-values-in-test_zswap.patch
selftest-cgroup-fix-zswap-test_no_invasive_cgroup_shrink-on-large-pagesize-system.patch
selftest-cgroup-fix-zswap-attempt_writeback-on-64k-pagesize-system.patch
selftests-cgroup-test_zswap-wait-for-asynchronous-writeback.patch

