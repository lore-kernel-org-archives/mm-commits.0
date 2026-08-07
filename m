Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696663B4E9D
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068086; cv=none; b=oGVBlCY/tDDV3JecCDQ/JC5bg2av3qI7M1ZE3NtgL/+ZB0C9Vt5KNXaXjLF2Ncqr+s2fh5Ohdx3qUx8csliqEN9wxva0N3oJ2AAU3vpwzHz1CH+2WJja9rfMFEFknh3KtmXNYW4HSmT6euCJm5qKm/r/a9YT9PV5STvqhedM0Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068086; c=relaxed/simple;
	bh=aoozbKxJd0CgHMEneeyB14X+o6/OfZ8WtoEoKgh519k=;
	h=Date:To:From:Subject:Message-Id; b=CnCt3/pYIZ17eI6MkoS4neuttTQHB1b1DeLnECSu4HW9YhXHAGOTu/xSmZUiNUsI8jCoQp52iESXNt3MEwmQe1Nyr/udghbRTzbyl4w1MsHYwdJsNs1Q6QVLLEYdFTJTfadommFgb6lfdFt0l72HlBuQeBQzuSjrhC1V3h9Q1Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BjOK1Y2W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BjOK1Y2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3F51F000E9;
	Fri,  7 Aug 2026 02:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068084;
	bh=Y9yIIUcdWHLo3JBDLF9MJ+piuZV59FhEa+8dmIPrnBA=;
	h=Date:To:From:Subject;
	b=BjOK1Y2W2LxIe+Q5aUXxf99XBeD3vqxefiYCcBbx1ZxShMCr4+sddO5wOQpbFwgOd
	 /i2zq1CB2vzGgstTXuTSXDFUqO2pOPxIncJWQFFrwMRTRtKOEgzh8Ls7wjATWpX4L0
	 VYm+L5G4nke2htlNYrJXjv1Sr8pzmIQJUzY4jjtc=
Date: Thu, 06 Aug 2026 19:01:23 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes.patch removed from -mm tree
Message-Id: <20260807020124.3E3F51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add PAGEMAP_SCAN test for THP PMD holes
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: add PAGEMAP_SCAN test for THP PMD holes
Date: Wed, 15 Jul 2026 15:42:34 +0100

Add coverage for the PMD-hole case fixed by "fs/proc/task_mmu: fix
PAGEMAP_SCAN written state for PMD holes": a MAP_PRIVATE|MAP_ANON THP that
is uffd-wp'd and then dropped with MADV_DONTNEED leaves a pmd_none hole
with no page table, which PAGEMAP_SCAN must still report as written.

Factor the populate/drop/scan-both-paths sequence out of
unpopulated_scan_test() into a helper, and add unpopulated_thp_scan_test()
that reuses it with a THP.

Include <linux/mman.h> for MADV_COLLAPSE; <sys/mman.h> lacks it on older
glibc (e.g. 2.34). Same approach as commit fd5295afae91 ("selftests/mm:
hmm-tests: include linux/mman.h to access MADV_COLLAPSE").

Link: https://lore.kernel.org/aljWYfPRCVc6IB2b@thinkstation
Link: https://lore.kernel.org/20260715144234.442721-3-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |  102 +++++++++++++------
 1 file changed, 75 insertions(+), 27 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -8,6 +8,7 @@
 #include <errno.h>
 #include <malloc.h>
 #include <linux/types.h>
+#include <linux/mman.h>
 #include <linux/memfd.h>
 #include <linux/userfaultfd.h>
 #include <linux/fs.h>
@@ -1058,50 +1059,96 @@ static void test_simple(void)
  * the generic path (reached e.g. via category_anyof_mask) must report every
  * page written.
  */
-static void unpopulated_scan_test(void)
+/*
+ * Populate @mem (optionally collapsing it into a THP first), drop it with
+ * MADV_DONTNEED, then check PAGEMAP_SCAN reports the whole range written via
+ * both the fast and generic query paths. A dropped THP leaves a pmd_none hole
+ * with no page table, exercising pagemap_scan_pte_hole(); a base-page range
+ * leaves pte_none entries.
+ */
+static void unpopulated_written_test(const char *name, char *mem, long size,
+				     bool use_thp)
 {
-	int npages = 16, i;
-	long mem_size = npages * page_size;
+	long npages = size / page_size, fast = 0, slow = 0, ret;
 	struct page_region regions[16];
-	long fast = 0, slow = 0, ret;
-	char *mem;
-
-	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE,
-		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (mem == MAP_FAILED)
-		ksft_exit_fail_msg("%s mmap failed\n", __func__);
+	int i;
 
-	wp_init(mem, mem_size);
+	wp_init(mem, size);
 
-	/* Populate, then drop: the ptes become pte_none without a marker. */
-	memset(mem, 1, mem_size);
-	if (madvise(mem, mem_size, MADV_DONTNEED))
-		ksft_exit_fail_msg("%s MADV_DONTNEED failed\n", __func__);
+	/* Populate, optionally collapse to a THP, then drop it. */
+	memset(mem, 1, size);
+	if (use_thp &&
+	    (madvise(mem, size, MADV_COLLAPSE) ||
+	     !check_huge_anon(mem, size / hpage_size, hpage_size))) {
+		ksft_test_result_skip("%s could not form a THP\n", name);
+		goto out;
+	}
+	if (madvise(mem, size, MADV_DONTNEED)) {
+		ksft_test_result_fail("%s MADV_DONTNEED failed\n", name);
+		goto out;
+	}
 
 	/* Fast path: category_mask == return_mask == PAGE_IS_WRITTEN. */
-	ret = pagemap_ioctl(mem, mem_size, regions, npages, 0, 0,
+	ret = pagemap_ioctl(mem, size, regions, ARRAY_SIZE(regions), 0, 0,
 			    PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
-	if (ret < 0)
-		ksft_exit_fail_msg("%s fast scan failed\n", __func__);
-	for (i = 0; i < ret; i++)
+	for (i = 0; ret > 0 && i < ret; i++)
 		fast += LEN(regions[i]);
 
 	/* Generic path: same query expressed via category_anyof_mask. */
-	ret = pagemap_ioctl(mem, mem_size, regions, npages, 0, 0,
+	ret = pagemap_ioctl(mem, size, regions, ARRAY_SIZE(regions), 0, 0,
 			    0, PAGE_IS_WRITTEN, 0, PAGE_IS_WRITTEN);
-	if (ret < 0)
-		ksft_exit_fail_msg("%s generic scan failed\n", __func__);
-	for (i = 0; i < ret; i++)
+	for (i = 0; ret > 0 && i < ret; i++)
 		slow += LEN(regions[i]);
 
 	ksft_test_result(fast == npages && slow == npages,
-			 "%s unpopulated ptes reported written by both paths (%ld, %ld of %d)\n",
-			 __func__, fast, slow, npages);
+			 "%s unpopulated range reported written by both paths (%ld, %ld of %ld)\n",
+			 name, fast, slow, npages);
+out:
+	wp_free(mem, size);
+}
 
-	wp_free(mem, mem_size);
+static void unpopulated_scan_test(void)
+{
+	long mem_size = 16 * page_size;
+	char *mem;
+
+	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED) {
+		ksft_test_result_skip("%s mmap failed\n", __func__);
+		return;
+	}
+
+	unpopulated_written_test(__func__, mem, mem_size, false);
 	munmap(mem, mem_size);
 }
 
+/*
+ * Same as unpopulated_scan_test(), but the range is a THP: a full-PMD
+ * MADV_DONTNEED leaves a pmd_none hole with no page table.
+ */
+static void unpopulated_thp_scan_test(void)
+{
+	char *area, *mem;
+
+	if (!hpage_size) {
+		ksft_test_result_skip("%s THP not supported\n", __func__);
+		return;
+	}
+
+	/* Over-allocate so a PMD-aligned, THP-sized range fits inside. */
+	area = mmap(NULL, 2 * hpage_size, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (area == MAP_FAILED) {
+		ksft_test_result_skip("%s mmap failed\n", __func__);
+		return;
+	}
+	mem = (char *)(((unsigned long)area + hpage_size - 1) & ~(hpage_size - 1));
+
+	unpopulated_written_test(__func__, mem, hpage_size, true);
+	munmap(area, 2 * hpage_size);
+}
+
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
@@ -1610,7 +1657,7 @@ int main(int __attribute__((unused)) arg
 	if (!hugetlb_setup_default(4))
 		ksft_print_msg("HugeTLB test will be skipped\n");
 
-	ksft_set_plan(118);
+	ksft_set_plan(119);
 
 	page_size = getpagesize();
 	hpage_size = read_pmd_pagesize();
@@ -1790,6 +1837,7 @@ int main(int __attribute__((unused)) arg
 
 	/* 18. Unpopulated pte scan-path consistency */
 	unpopulated_scan_test();
+	unpopulated_thp_scan_test();
 
 	close(pagemap_fd);
 	ksft_finished();
_

Patches currently in -mm which might be from kas@kernel.org are


