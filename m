Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AC4362133
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 10:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777025189; cv=none; b=B5EBAdQ7IiPP7EYuQSv0tXSDnn88RYDyHygvFN7nRmgg6lRFbGy1kiACJeuGzM0r7BYzTLBj9UCzGYZ7mPDfmo3SNJ0jUtVDTyiuXhv9dPaolzH2XCMkNo84RMZH5hXRmdzyYmaZ5e2UIUDzTSik09u2/vpWTAOcDdjsvdjwX8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777025189; c=relaxed/simple;
	bh=r0o6LUz0xG0ZnrNVXGukgy1hCB9fHgtfWhCWve45sVA=;
	h=Date:To:From:Subject:Message-Id; b=ob0q9Rdt+ehFMek62eA577ZPE0IP4xXE2uPsMx21lXjH175OflnlljesWw/5v96nIH7ExVFr9tZOHV23vlDbCHl9XT9C8jYucj6Ad5mT2e3bvkFW5vQdpuiNfs7p7nuDCr6CSKF2IqJ3pRTt6cbcPHvdA85zsJv3tM3RWYSQL2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cUJ2k4Co; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cUJ2k4Co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FEFC19425;
	Fri, 24 Apr 2026 10:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777025189;
	bh=r0o6LUz0xG0ZnrNVXGukgy1hCB9fHgtfWhCWve45sVA=;
	h=Date:To:From:Subject:From;
	b=cUJ2k4CoTIPDkIJw2/02F/dgalBhFAoWetbfO5WocmC5hEMPRr/Uz3gvAkRMo5fXq
	 UXAAxDsTqQvhhM2JnnfL+8mGgXEBqUIUT4qvZhJ7nyraj/I1yfJE6amVPfnzpnQpYy
	 eWhI12wmFeFG8RjloB0/PRw7VWYFM3eufWETMY0Q=
Date: Fri, 24 Apr 2026 03:06:28 -0700
To: mm-commits@vger.kernel.org,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-replace-hardcoded-page-size-values-in-test_zswap.patch added to mm-new branch
Message-Id: <20260424100629.58FEFC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/cgroup: replace hardcoded page size values in test_zswap
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-replace-hardcoded-page-size-values-in-test_zswap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-replace-hardcoded-page-size-values-in-test_zswap.patch

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
Subject: selftests/cgroup: replace hardcoded page size values in test_zswap
Date: Fri, 24 Apr 2026 12:00:56 +0800

test_zswap uses hardcoded values of 4095 and 4096 throughout as page
stride and page size, which are only correct on systems with a 4K page
size.  On architectures with larger pages (e.g., 64K on arm64 or ppc64),
these constants cause memory to be touched at sub-page granularity,
leading to inefficient access patterns and incorrect page count
calculations, which can cause test failures.

Replace all hardcoded 4095 and 4096 values with a global pagesize variable
initialized from sysconf(_SC_PAGESIZE) at startup, and remove the
redundant local sysconf() calls scattered across individual functions.  No
functional change on 4K page size systems.

Link: https://lore.kernel.org/20260424040059.12940-6-li.wang@linux.dev
Signed-off-by: Li Wang <li.wang@linux.dev>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |   45 ++++++++++--------
 1 file changed, 25 insertions(+), 20 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-replace-hardcoded-page-size-values-in-test_zswap
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -15,6 +15,8 @@
 #include "kselftest.h"
 #include "cgroup_util.h"
 
+static int page_size;
+
 #define PATH_ZSWAP "/sys/module/zswap"
 #define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
 
@@ -73,11 +75,11 @@ static int allocate_and_read_bytes(const
 
 	if (!mem)
 		return -1;
-	for (int i = 0; i < size; i += 4095)
+	for (int i = 0; i < size; i += page_size)
 		mem[i] = 'a';
 
 	/* Go through the allocated memory to (z)swap in and out pages */
-	for (int i = 0; i < size; i += 4095) {
+	for (int i = 0; i < size; i += page_size) {
 		if (mem[i] != 'a')
 			ret = -1;
 	}
@@ -93,7 +95,7 @@ static int allocate_bytes(const char *cg
 
 	if (!mem)
 		return -1;
-	for (int i = 0; i < size; i += 4095)
+	for (int i = 0; i < size; i += page_size)
 		mem[i] = 'a';
 	free(mem);
 	return 0;
@@ -167,7 +169,7 @@ static int test_swapin_nozswap(const cha
 	int ret = KSFT_FAIL;
 	char *test_group, mem_max_buf[32];
 	long swap_peak, zswpout, min_swap;
-	size_t allocation_size = sysconf(_SC_PAGESIZE) * 512;
+	size_t allocation_size = page_size * 512;
 
 	min_swap = allocation_size / 4;
 	snprintf(mem_max_buf, sizeof(mem_max_buf), "%zu", allocation_size * 3/4);
@@ -245,7 +247,7 @@ static int test_zswapin(const char *root
 		goto out;
 	}
 
-	if (zswpin < MB(24) / sysconf(_SC_PAGESIZE)) {
+	if (zswpin < MB(24) / page_size) {
 		ksft_print_msg("at least 24MB should be brought back from zswap\n");
 		goto out;
 	}
@@ -272,9 +274,8 @@ out:
  */
 static int attempt_writeback(const char *cgroup, void *arg)
 {
-	long pagesize = sysconf(_SC_PAGESIZE);
 	size_t memsize = MB(4);
-	char buf[pagesize];
+	char buf[page_size];
 	long zswap_usage;
 	bool wb_enabled = *(bool *) arg;
 	int ret = -1;
@@ -289,11 +290,11 @@ static int attempt_writeback(const char
 	 * half empty, this will result in data that is still compressible
 	 * and ends up in zswap, with material zswap usage.
 	 */
-	for (int i = 0; i < pagesize; i++)
-		buf[i] = i < pagesize/2 ? (char) i : 0;
+	for (int i = 0; i < page_size; i++)
+		buf[i] = i < page_size/2 ? (char) i : 0;
 
-	for (int i = 0; i < memsize; i += pagesize)
-		memcpy(&mem[i], buf, pagesize);
+	for (int i = 0; i < memsize; i += page_size)
+		memcpy(&mem[i], buf, page_size);
 
 	/* Try and reclaim allocated memory */
 	if (cg_write_numeric(cgroup, "memory.reclaim", memsize)) {
@@ -304,8 +305,8 @@ static int attempt_writeback(const char
 	zswap_usage = cg_read_long(cgroup, "memory.zswap.current");
 
 	/* zswpin */
-	for (int i = 0; i < memsize; i += pagesize) {
-		if (memcmp(&mem[i], buf, pagesize)) {
+	for (int i = 0; i < memsize; i += page_size) {
+		if (memcmp(&mem[i], buf, page_size)) {
 			ksft_print_msg("invalid memory\n");
 			goto out;
 		}
@@ -441,7 +442,7 @@ static int test_no_invasive_cgroup_shrin
 	if (cg_enter_current(control_group))
 		goto out;
 	control_allocation = malloc(control_allocation_size);
-	for (int i = 0; i < control_allocation_size; i += 4095)
+	for (int i = 0; i < control_allocation_size; i += page_size)
 		control_allocation[i] = 'a';
 	if (cg_read_key_long(control_group, "memory.stat", "zswapped") < 1)
 		goto out;
@@ -481,7 +482,7 @@ static int no_kmem_bypass_child(const ch
 		values->child_allocated = true;
 		return -1;
 	}
-	for (long i = 0; i < values->target_alloc_bytes; i += 4095)
+	for (long i = 0; i < values->target_alloc_bytes; i += page_size)
 		((char *)allocation)[i] = 'a';
 	values->child_allocated = true;
 	pause();
@@ -529,7 +530,7 @@ static int test_no_kmem_bypass(const cha
 	min_free_kb_low = sys_info.totalram / 500000;
 	values->target_alloc_bytes = (sys_info.totalram - min_free_kb_high * 1000) +
 		sys_info.totalram * 5 / 100;
-	stored_pages_threshold = sys_info.totalram / 5 / 4096;
+	stored_pages_threshold = sys_info.totalram / 5 / page_size;
 	trigger_allocation_size = sys_info.totalram / 20;
 
 	/* Set up test memcg */
@@ -556,7 +557,7 @@ static int test_no_kmem_bypass(const cha
 
 		if (!trigger_allocation)
 			break;
-		for (int i = 0; i < trigger_allocation_size; i += 4095)
+		for (int i = 0; i < trigger_allocation_size; i += page_size)
 			trigger_allocation[i] = 'b';
 		usleep(100000);
 		free(trigger_allocation);
@@ -567,8 +568,8 @@ static int test_no_kmem_bypass(const cha
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
 			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
-			int delta = stored_pages * 4096 - zswapped;
-			int result_ok = delta < stored_pages * 4096 / 4;
+			int delta = stored_pages * page_size - zswapped;
+			int result_ok = delta < stored_pages * page_size / 4;
 
 			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
 			break;
@@ -622,7 +623,7 @@ static int allocate_random_and_wait(cons
 	close(fd);
 
 	/* Touch all pages to ensure they're faulted in */
-	for (size_t i = 0; i < size; i += PAGE_SIZE)
+	for (size_t i = 0; i < size; i += page_size)
 		mem[i] = mem[i];
 
 	/* Use MADV_PAGEOUT to push pages into zswap */
@@ -752,6 +753,10 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 	int i;
 
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

