Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F2B3ED13B;
	Tue, 21 Jul 2026 00:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784594613; cv=none; b=gQqRq0Ck7vkK5coe47e9Avyi60VF+Mm7y38HbbY7wmmmeQrT+/JGZzXbICb8YsmmyLD/gBs+5yul56bvsYT3fphL7vJzdyfhF4NSlM7lFOLah6+7R0A9Q/9SN6V16J4ZjZFJyC5NgEV2t2gmpiKY6O+wyarCh3tI03jY615PN1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784594613; c=relaxed/simple;
	bh=6orYouV+bU/+7lyIjQdpZkfesi82tnRAh8UUQQDdwJo=;
	h=Date:To:From:Subject:Message-Id; b=cmt2MXgJnk/oej1aBuUsq11X+eMaAdR8H/6iaif9gMPhRRpv7egpW0VPD8E8oiiAsOpUu5DtE9z/9YLr2KALgJoPlYIaJ8ZaYK8Fzgimsvp1BEMyq8Oz6JrzeqPj1p4dsD6YEz6ehVRnncfN35582GsSM1mtFPH+KoVnWCoB0X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QqQPOLFw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QqQPOLFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8E01F00A3A;
	Tue, 21 Jul 2026 00:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784594612;
	bh=DDPXxeMu7+XgXKblRZh2cj6Bkfbcy5Cwv1bm/0BeyM8=;
	h=Date:To:From:Subject;
	b=QqQPOLFwqzK2zbgPyk0oRsB5nzBi6acEkGCBrI4ZhCdETmMdYp+28bRCalxBJzXHo
	 DXFz2xP46wlIfAhxhlLBKDKfNDp8pmhLG/+N1EyswxkbIF/llv/WqhUAUbA86GjkW1
	 uJLC0sBMs7084Bdf5DVxsNV1WlLn0WhnUuv8QiIg=
Date: Mon, 20 Jul 2026 17:43:31 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@collabora.com,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes.patch removed from -mm tree
Message-Id: <20260721004331.EB8E01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: fix PAGEMAP_SCAN written state for unpopulated ptes
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: fs/proc/task_mmu: fix PAGEMAP_SCAN written state for unpopulated ptes
Date: Tue, 7 Jul 2026 16:13:49 +0100

PAGEMAP_SCAN reports an unpopulated pte differently depending on which
path serves the request.  The PAGE_IS_WRITTEN fast path in
pagemap_scan_pmd_entry() reports a pte_none as written (and, under
PM_SCAN_WP_MATCHING, arms a marker); pagemap_page_category() returns 0 for
the same pte_none.  A request that cannot take the fast path (an extra
category bit, category_anyof_mask or category_inverted) therefore reports
the pte as clean and skips arming it.

A range that was populated and then MADV_DONTNEED'd reads as written via
one mask and clean via another, and in the latter case is not re-armed for
the next round -- an incremental-dump consumer (e.g.  CRIU) using a richer
mask drops the zapped range and stops tracking writes to it.

Report pte_none as written in pagemap_page_category() too.  A pte_none
carries no uffd-wp marker, i.e.  it is not write-protected -- the same
condition under which the present and swap cases already report
PAGE_IS_WRITTEN.  The fast path applies no VMA test, so neither does this.

The hugetlb and fully-unpopulated-PMD (no page table) scans have no
PAGE_IS_WRITTEN fast path, so they do not exhibit the per-entry divergence
and are left unchanged.

Add a pagemap_ioctl selftest that populates a range, drops it with
MADV_DONTNEED, and checks that the fast path and the generic
(category_anyof_mask) path both report every page written.

Link: https://lore.kernel.org/20260707151349.92143-1-kirill@shutemov.name
Fixes: 12f6b01a0bcb ("fs/proc/task_mmu: add fast paths to get/clear PAGE_IS_WRITTEN flag")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Assisted-by: Claude:claude-fable-5
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c                         |   14 ++++
 tools/testing/selftests/mm/pagemap_ioctl.c |   56 ++++++++++++++++++-
 2 files changed, 67 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes
+++ a/fs/proc/task_mmu.c
@@ -2432,8 +2432,18 @@ static unsigned long pagemap_page_catego
 {
 	unsigned long categories;
 
-	if (pte_none(pte))
-		return 0;
+	if (pte_none(pte)) {
+		/*
+		 * An unpopulated pte carries no uffd-wp marker, i.e. it is not
+		 * write-protected, the same condition under which the present
+		 * and swap cases below report PAGE_IS_WRITTEN. Report it here
+		 * too so this generic path agrees with the PAGE_IS_WRITTEN fast
+		 * path in pagemap_scan_pmd_entry(), which reports pte_none as
+		 * written and, under PM_SCAN_WP_MATCHING, arms a marker. The
+		 * fast path applies no VMA test, so neither does this.
+		 */
+		return PAGE_IS_WRITTEN;
+	}
 
 	if (pte_present(pte)) {
 		struct page *page;
--- a/tools/testing/selftests/mm/pagemap_ioctl.c~fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1051,6 +1051,57 @@ static void test_simple(void)
 	ksft_test_result(i == TEST_ITERATIONS, "Test %s\n", __func__);
 }
 
+/*
+ * A range that was populated and then MADV_DONTNEED'd is genuine pte_none
+ * with no uffd-wp marker. Such a pte must read the same regardless of which
+ * PAGEMAP_SCAN path serves the request: both the PAGE_IS_WRITTEN fast path and
+ * the generic path (reached e.g. via category_anyof_mask) must report every
+ * page written.
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
+	ksft_test_result(fast == npages && slow == npages,
+			 "%s unpopulated ptes reported written by both paths (%ld, %ld of %d)\n",
+			 __func__, fast, slow, npages);
+
+	wp_free(mem, mem_size);
+	munmap(mem, mem_size);
+}
+
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
@@ -1559,7 +1610,7 @@ int main(int __attribute__((unused)) arg
 	if (!hugetlb_setup_default(4))
 		ksft_print_msg("HugeTLB test will be skipped\n");
 
-	ksft_set_plan(117);
+	ksft_set_plan(118);
 
 	page_size = getpagesize();
 	hpage_size = read_pmd_pagesize();
@@ -1737,6 +1788,9 @@ int main(int __attribute__((unused)) arg
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

mm-huge_memory-unlock-i_mmap_rwsem-before-releasing-after-split-folios.patch
mm-decouple-protnone-helpers-from-config_numa_balancing.patch
mm-rename-uffd-wp-pte-bit-macros-to-uffd.patch
mm-rename-uffd-wp-pte-accessors-to-uffd.patch
userfaultfd-test-uffd-vma-flags-through-the-vma_flags_t-api.patch
mm-add-vm_uffd_rwp-vma-flag.patch
mm-add-mm_cp_uffd_rwp-change_protection-flag.patch
mm-preserve-rwp-marker-across-pte-rewrites.patch
mm-handle-vm_uffd_rwp-in-khugepaged-rmap-and-gup.patch
userfaultfd-add-uffdio_register_mode_rwp-and-uffdio_rwprotect-plumbing.patch
mm-userfaultfd-add-rwp-fault-delivery-and-expose-uffdio_register_mode_rwp.patch
mm-pagemap-add-page_is_accessed-for-rwp-tracking.patch
userfaultfd-add-uffd_feature_rwp_async-for-async-fault-resolution.patch
userfaultfd-add-uffdio_set_mode-for-runtime-sync-async-toggle.patch
selftests-mm-add-userfaultfd-rwp-tests.patch
documentation-userfaultfd-document-rwp-working-set-tracking.patch
selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes.patch
mm-huge_memory-remove-unused-can_split_folio.patch
mm-huge_memory-fold-split_folio_to_list_to_order-into-split_folio_to_order.patch

