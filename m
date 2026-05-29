Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3360D36EAB9
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027594; cv=none; b=ZzCRYz28ondF/MseeIfRSERNSxW155LrLlvcJ5yfNqesELf5tRQ7e65ATqYDGph5piIielJIQwTXqDINWluMWYNS3+SyL8D4HVw4WXuQxz6lCIpv8jvpLMAVrRZ5x/oe8Gmg13HLN/M2LS6VI+NGE2zhGnR11Fm2/E+xgBCudO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027594; c=relaxed/simple;
	bh=c/axTSpFMHQE8tuEPyAcN7KS/4XtmzH7STnlvtytVuE=;
	h=Date:To:From:Subject:Message-Id; b=RNTu3MABkXLbGPKpR6C976+boWyEMkVUs9eMhbAdiW5KnS1MHaWZly10K5QfwS85J5g4Oa9LUk1z4G3fDO1KoxX/rzEVeAfMSs+g6TS4pkOVWTDGybz5HK/pOHxb37DPwGDEKNoNt+sLbh0TJTfaEEP1p52D3jIgg+wJl+Qqu20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i2L9BPz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i2L9BPz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076131F00893;
	Fri, 29 May 2026 04:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027593;
	bh=v/2165gnvd0FY4hR0kRxJazpkfB+osZsKQkulpJ2tOI=;
	h=Date:To:From:Subject;
	b=i2L9BPz6UjQkUyiRmfQFvZ8KWR+b2kjzKv+XNK67JL7HDSbfnDGoDHeVOi+U24XzP
	 BkN97jcdbFEr9FTLGrfXDPw+wwYk0KG0SENAns3cJ8S+/AReNSjuQUdkbdJt44HP7y
	 aiXyQV+VFdVZKCr4YTuQ21C/wZb+hanIOUvVel1g=
Date: Thu, 28 May 2026 21:06:32 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,yosryahmed@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,longman@redhat.com,jiayuan.chen@linux.dev,hannes@cmpxchg.org,chengming.zhou@linux.dev,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-replace-hardcoded-page-size-values-in-test_zswap.patch removed from -mm tree
Message-Id: <20260529040633.076131F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/cgroup: replace hardcoded page size values in test_zswap
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-replace-hardcoded-page-size-values-in-test_zswap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


