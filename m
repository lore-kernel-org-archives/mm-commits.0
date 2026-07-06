Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3614302F3;
	Mon,  6 Jul 2026 18:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783361189; cv=none; b=H7Qhx+UY3qw1AQwx/AgUvVAsrmuTUroewhHBK0KtXHB5hqFkDnUcMRdB+uSSlGQsCsJQ4CLbtBbiTzUJFIQQsDoNaAYQ7dijcVSsqeazgYV8+ejYj/YF34aBt6gSNu1b7RP2+ac8e9GQIGukiu59qUWLeQzFmdBXaKZW72uhGag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783361189; c=relaxed/simple;
	bh=U/XU5QSt04WZywyqElkxbILKieKrJREY3mz7f8xdNPc=;
	h=Date:To:From:Subject:Message-Id; b=RzE7AgH08M6MJN9obXuO2qZXuTDrvH4vKIB1HSeHmI5DiQg7tAUVTQANxAzrbQYVD0H77apGkH4yc/6+4bw/wYsX/oBgzuAzPVVA3kSm5lyRuzGaeKK9trhdsraV9vKs7AC6vzH5wHftsZu1ABHHcGtUpYwHC7jqe6FbDsIEQ50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CHBIGUb6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CHBIGUb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00371F00A3A;
	Mon,  6 Jul 2026 18:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783361184;
	bh=DX+8hr1aSZWh+N2wGr+OQFCFR1ChliSGeKsc8pyNpcU=;
	h=Date:To:From:Subject;
	b=CHBIGUb6hXZOm5amHSMFLuxTSQBTiOQWupvgMDcuJbDJOswlOvzMGoENiLQbdxqXY
	 sSJ3wRw2TSLKP/C+p78bpoAAui6AYjbq3WWXKXaoBNSwOaFHSF3D3o7iMMRGkt/4yf
	 c3dEqYmGiRonPlUpmTYU47HnIh/YkPOmdFBKMBDc=
Date: Mon, 06 Jul 2026 11:06:24 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@collabora.com,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes.patch added to mm-hotfixes-unstable branch
Message-Id: <20260706180624.C00371F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: fix PAGEMAP_SCAN written state for unpopulated ptes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: fs/proc/task_mmu: fix PAGEMAP_SCAN written state for unpopulated ptes
Date: Mon, 6 Jul 2026 11:43:08 +0100

PAGEMAP_SCAN reports an unpopulated pte on a uffd-wp VMA differently
depending on which path serves the request.  The PAGE_IS_WRITTEN fast path
in pagemap_scan_pmd_entry() treats a pte_none (no uffd-wp marker) as
written and, under PM_SCAN_WP_MATCHING, arms a marker.  The generic path
does not: pagemap_page_category() returns 0 for pte_none, so a request
that cannot use the fast path (extra category bit, category_anyof_mask or
category_inverted) reports the same pte as clean and skips arming it.

So a range that was populated and then MADV_DONTNEED'd reads as written
via one mask and clean via another, and in the latter case is not re-armed
for the next round -- an incremental-dump consumer (e.g.  CRIU) using a
richer mask drops the zapped range and stops tracking writes to it.

Return PAGE_IS_WRITTEN for a pte_none on a uffd-wp VMA, mirroring the
present and swap branches just below which already report it whenever the
entry is not write-protected.

Add a pagemap_ioctl selftest that asserts the two paths agree over a
MADV_DONTNEED'd range.

Link: https://lore.kernel.org/20260706104308.34741-1-kirill@shutemov.name
Fixes: 12f6b01a0bcb ("fs/proc/task_mmu: add fast paths to get/clear PAGE_IS_WRITTEN flag")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c                         |   14 ++++
 tools/testing/selftests/mm/pagemap_ioctl.c |   55 ++++++++++++++++++-
 2 files changed, 67 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes
+++ a/fs/proc/task_mmu.c
@@ -2432,8 +2432,20 @@ static unsigned long pagemap_page_catego
 {
 	unsigned long categories;
 
-	if (pte_none(pte))
+	if (pte_none(pte)) {
+		/*
+		 * An unpopulated pte carries no uffd-wp marker, so like any
+		 * other entry that is not write-protected it reads as written
+		 * on a uffd-wp VMA. This matches the PAGE_IS_WRITTEN fast path
+		 * in pagemap_scan_pmd_entry(); without it a scan forced onto
+		 * this generic path (extra category bits, anyof or inverted
+		 * masks) would report the same pte differently and, under
+		 * PM_SCAN_WP_MATCHING, skip arming its marker.
+		 */
+		if (userfaultfd_wp(vma))
+			return PAGE_IS_WRITTEN;
 		return 0;
+	}
 
 	if (pte_present(pte)) {
 		struct page *page;
--- a/tools/testing/selftests/mm/pagemap_ioctl.c~fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1051,6 +1051,56 @@ static void test_simple(void)
 	ksft_test_result(i == TEST_ITERATIONS, "Test %s\n", __func__);
 }
 
+/*
+ * A range that was populated and then MADV_DONTNEED'd is genuine pte_none
+ * with no uffd-wp marker. Such a pte must read the same regardless of which
+ * PAGEMAP_SCAN path serves the request: the PAGE_IS_WRITTEN fast path and the
+ * generic path (reached e.g. via category_anyof_mask) must agree.
+ */
+static void unpopulated_scan_test(void)
+{
+	int npages = 16, i;
+	long mem_size = npages * page_size;
+	struct page_region regions[16];
+	long fast = 0, slow = 0, ret;
+	char *mem;
+
+	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED)
+		ksft_exit_fail_msg("%s mmap failed\n", __func__);
+
+	wp_init(mem, mem_size);
+
+	/* Populate, then drop: the ptes become pte_none without a marker. */
+	memset(mem, 1, mem_size);
+	if (madvise(mem, mem_size, MADV_DONTNEED))
+		ksft_exit_fail_msg("%s MADV_DONTNEED failed\n", __func__);
+
+	/* Fast path: category_mask == return_mask == PAGE_IS_WRITTEN. */
+	ret = pagemap_ioctl(mem, mem_size, regions, npages, 0, 0,
+			    PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
+	if (ret < 0)
+		ksft_exit_fail_msg("%s fast scan failed\n", __func__);
+	for (i = 0; i < ret; i++)
+		fast += LEN(regions[i]);
+
+	/* Generic path: same query expressed via category_anyof_mask. */
+	ret = pagemap_ioctl(mem, mem_size, regions, npages, 0, 0,
+			    0, PAGE_IS_WRITTEN, 0, PAGE_IS_WRITTEN);
+	if (ret < 0)
+		ksft_exit_fail_msg("%s generic scan failed\n", __func__);
+	for (i = 0; i < ret; i++)
+		slow += LEN(regions[i]);
+
+	ksft_test_result(fast == slow,
+			 "%s unpopulated ptes agree across scan paths (%ld vs %ld)\n",
+			 __func__, fast, slow);
+
+	wp_free(mem, mem_size);
+	munmap(mem, mem_size);
+}
+
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
@@ -1559,7 +1609,7 @@ int main(int __attribute__((unused)) arg
 	if (!hugetlb_setup_default(4))
 		ksft_print_msg("HugeTLB test will be skipped\n");
 
-	ksft_set_plan(117);
+	ksft_set_plan(118);
 
 	page_size = getpagesize();
 	hpage_size = read_pmd_pagesize();
@@ -1737,6 +1787,9 @@ int main(int __attribute__((unused)) arg
 	/* 17. ZEROPFN tests */
 	zeropfn_tests();
 
+	/* 18. Unpopulated pte scan-path consistency */
+	unpopulated_scan_test();
+
 	close(pagemap_fd);
 	ksft_finished();
 }
_

Patches currently in -mm which might be from kas@kernel.org are

mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork.patch
fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes.patch

