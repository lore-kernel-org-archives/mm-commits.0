Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552893B14D0;
	Thu,  9 Jul 2026 21:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783634378; cv=none; b=hYC6rO8pzcnoGmEe8AliDwqzpuO4gr8kpX+e8FJWmBvn3kQ8Rbv4TOpEmy4CCLq45POmm+grrbc9aO2YzJoVTu/XZHl7+3o92wWoK5J1zO+a6Gn1kueu7jygGf2uEwTNs7pdlhdDVdyRrQ/ks+tMP2kmNeifWNtE93CnV3HdwIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783634378; c=relaxed/simple;
	bh=nZEfOqakGhrPhkXxd8r6kHvrN4AfqAqTnSXyBK6zciY=;
	h=Date:To:From:Subject:Message-Id; b=Rdzl3Ae6vtahpVuNY8jFl7HilXuP4Dludh+6NP8f2awnsLkUICkQU+IEIZCewbxLqgtvO+ADMRwh4KZybpxN0M4YjYWR5ocQxydQgCd2dQXicgHwWfdPJO7GiI0uvWp7AlIGYGIi9ry0o/62b64WDjdQPm7WLCV9GU3ExEgHESM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uxN3wKaK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uxN3wKaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BA41F000E9;
	Thu,  9 Jul 2026 21:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783634376;
	bh=5tK1sldEP4KMoyI7+NHCua1UXH3emOrx5R2z7xRRzu8=;
	h=Date:To:From:Subject;
	b=uxN3wKaKMrR0KGa0XZ2GPrd2BL5eOKWdDDDhTHjx8GhVkUzfuBplJnk7bHmCQ/GBX
	 LE6svK/3J187X3hRiInLvpjG5QqDuXgtxFEivr0EmLaAGiUgw9AdeV4ZSYkrCi+haY
	 /F9SsaZaM2jK5aC/QaNGM+XmWBnJIF1Pl1yPUW7E=
Date: Thu, 09 Jul 2026 14:59:36 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@collabora.com,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,sashiko-bot@kernel.org,rppt@kernel.org,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-fix-pagemap_scan-written-state-for-pmd-holes.patch added to mm-hotfixes-unstable branch
Message-Id: <20260709215936.C8BA41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-task_mmu-fix-pagemap_scan-written-state-for-pmd-holes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-fix-pagemap_scan-written-state-for-pmd-holes.patch

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
Subject: fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes
Date: Thu, 9 Jul 2026 13:16:29 +0100

PAGEMAP_SCAN reports an unpopulated PTE in a uffd-wp VMA as written, but a
range with no page table at all -- a PMD hole -- is skipped:
pagemap_scan_pte_hole() tests p->cur_vma_category, which never carries
PAGE_IS_WRITTEN, so the hole is neither reported nor (under
PM_SCAN_WP_MATCHING) armed.

MADV_DONTNEED has fill-with-zeros semantics: it changes the contents of
the range to zeroes (a subsequent read maps the zero page), which write
tracking must report as written.  An anonymous THP is write-protected in
place as a huge PMD, so a full-PMD MADV_DONTNEED clears it to pmd_none --
a hole -- and the zeroing goes unreported.  A write-tracking
checkpoint/migration tool (e.g.  CRIU) then treats the range as unchanged
and keeps its previous contents, so after restore or live migration the
process reads stale data instead of zeroes -- data corruption.

Report a hole in a non-hugetlb uffd-wp VMA as written, matching the
pte_none handling in pagemap_page_category(); the existing
PM_SCAN_WP_MATCHING path then arms it via uffd_wp_range().

hugetlb is excluded: pagemap_hugetlb_category() reports an empty hugetlb
entry (huge_pte_none) as not-written, unlike pagemap_page_category(),
which reports pte_none as written.  pagemap_scan_pte_hole() fires for a
hugetlb slot only when it has no page table; keeping that not-written
matches how an allocated-but-empty hugetlb entry reads, so the hole and
the empty-entry cases agree within the VMA.

Add a pagemap_ioctl selftest covering the anon-THP PMD-hole case.

Link: https://lore.kernel.org/20260709121629.205562-1-kirill@shutemov.name
Fixes: 2bad466cc9d9 ("mm/uffd: UFFD_FEATURE_WP_UNPOPULATED")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260707151349.92143-1-kirill@shutemov.name
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Assisted-by: Claude:claude-fable-5
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
Cc: <stable@vger.kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c                         |   27 ++++++++-
 tools/testing/selftests/mm/pagemap_ioctl.c |   56 ++++++++++++++++++-
 2 files changed, 80 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-fix-pagemap_scan-written-state-for-pmd-holes
+++ a/fs/proc/task_mmu.c
@@ -3049,12 +3049,35 @@ static int pagemap_scan_pte_hole(unsigne
 {
 	struct pagemap_scan_private *p = walk->private;
 	struct vm_area_struct *vma = walk->vma;
+	unsigned long categories;
 	int ret, err;
 
-	if (!vma || !pagemap_scan_is_interesting_page(p->cur_vma_category, p))
+	if (!vma)
 		return 0;
 
-	ret = pagemap_scan_output(p->cur_vma_category, p, addr, &end);
+	/*
+	 * An unpopulated range with no page table -- e.g. a 2MB anon THP
+	 * dropped via MADV_DONTNEED, which pagemap_page_category() never sees
+	 * -- reads as written on a uffd-wp VMA, matching the pte_none case
+	 * there. Reporting it also lets the PM_SCAN_WP_MATCHING arming below
+	 * install markers (uffd_wp_range() allocates the page table under
+	 * WP_UNPOPULATED), so the next scan sees it clean until re-written.
+	 *
+	 * hugetlb is excluded: pagemap_hugetlb_category() reports an empty
+	 * hugetlb entry (huge_pte_none) as not-written, unlike
+	 * pagemap_page_category(), which reports pte_none as written. This
+	 * path fires for a hugetlb slot only when it has no page table;
+	 * keeping that not-written matches how an allocated-but-empty
+	 * hugetlb entry reads, so the two agree within the VMA.
+	 */
+	categories = p->cur_vma_category;
+	if (userfaultfd_wp(vma) && !is_vm_hugetlb_page(vma))
+		categories |= PAGE_IS_WRITTEN;
+
+	if (!pagemap_scan_is_interesting_page(categories, p))
+		return 0;
+
+	ret = pagemap_scan_output(categories, p, addr, &end);
 	if (addr == end)
 		return ret;
 
--- a/tools/testing/selftests/mm/pagemap_ioctl.c~fs-proc-task_mmu-fix-pagemap_scan-written-state-for-pmd-holes
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1102,6 +1102,59 @@ static void unpopulated_scan_test(void)
 	munmap(mem, mem_size);
 }
 
+/*
+ * A 2MB anon THP dropped with MADV_DONTNEED leaves a pmd_none hole with no
+ * page table, which pagemap_page_category() never sees. PAGEMAP_SCAN must
+ * still report it as written on a uffd-wp VMA, via pagemap_scan_pte_hole().
+ */
+static void unpopulated_thp_hole_test(void)
+{
+	long npages, written = 0, ret, i;
+	struct page_region regions[16];
+	char *area, *mem;
+
+	if (!hpage_size) {
+		ksft_test_result_skip("%s THP not supported\n", __func__);
+		return;
+	}
+	npages = hpage_size / page_size;
+
+	/* Get a PMD-aligned range so the range can be a single THP. */
+	area = mmap(NULL, 2 * hpage_size, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (area == MAP_FAILED)
+		ksft_exit_fail_msg("%s mmap failed\n", __func__);
+	mem = (char *)(((unsigned long)area + hpage_size - 1) & ~(hpage_size - 1));
+
+	memset(mem, 1, hpage_size);
+	if (madvise(mem, hpage_size, MADV_COLLAPSE) ||
+	    !check_huge_anon(mem, 1, hpage_size)) {
+		ksft_test_result_skip("%s could not form a THP\n", __func__);
+		munmap(area, 2 * hpage_size);
+		return;
+	}
+
+	wp_init(mem, hpage_size);
+
+	/* Drop the whole PMD: it is cleared to a pmd_none hole. */
+	if (madvise(mem, hpage_size, MADV_DONTNEED))
+		ksft_exit_fail_msg("%s MADV_DONTNEED failed\n", __func__);
+
+	ret = pagemap_ioctl(mem, hpage_size, regions, 16, 0, 0,
+			    PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
+	if (ret < 0)
+		ksft_exit_fail_msg("%s scan failed\n", __func__);
+	for (i = 0; i < ret; i++)
+		written += LEN(regions[i]);
+
+	ksft_test_result(written == npages,
+			 "%s pmd-hole reported written (%ld of %ld)\n",
+			 __func__, written, npages);
+
+	wp_free(mem, hpage_size);
+	munmap(area, 2 * hpage_size);
+}
+
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
@@ -1610,7 +1663,7 @@ int main(int __attribute__((unused)) arg
 	if (!hugetlb_setup_default(4))
 		ksft_print_msg("HugeTLB test will be skipped\n");
 
-	ksft_set_plan(118);
+	ksft_set_plan(119);
 
 	page_size = getpagesize();
 	hpage_size = read_pmd_pagesize();
@@ -1790,6 +1843,7 @@ int main(int __attribute__((unused)) arg
 
 	/* 18. Unpopulated pte scan-path consistency */
 	unpopulated_scan_test();
+	unpopulated_thp_hole_test();
 
 	close(pagemap_fd);
 	ksft_finished();
_

Patches currently in -mm which might be from kas@kernel.org are

fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes.patch
mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork.patch
fs-proc-task_mmu-fix-pagemap_scan-written-state-for-pmd-holes.patch
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
documentation-userfaultfd-document-rwp-working-set-tracking.patch

