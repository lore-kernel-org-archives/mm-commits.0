Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656DAC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243873AbiDFB4b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347341AbiDEUeK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:34:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEFBFDE19
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:17:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C238F61990
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D898C385A5;
        Tue,  5 Apr 2022 20:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189804;
        bh=SiBTvC7xrIw+VSNvajjz1h4YUC+E/Nz+CY8dU6jNdvQ=;
        h=Date:To:From:Subject:From;
        b=B0h5tIvZOeB5zWdRFL6DoOVX+EatFMBrv78xg1oepU0lhHgtIA8Yz3WD+PqL4DdyI
         FOw8waQ6oWfHuTx0JiuUtERrA2NI3vV12aXV/hqbxsuugDb5rqoz/8ULfbh5aIkus5
         BKTM/lNwZfT4IM6RVDQcvNNG6wULvK90S6RWcMGg=
Date:   Tue, 05 Apr 2022 13:16:43 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch added to -mm tree
Message-Id: <20220405201644.1D898C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: handle uffd-wp special pte in page fault handler
has been added to the -mm tree.  Its filename is
     mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/shmem: handle uffd-wp special pte in page fault handler

File-backed memories are prone to unmap/swap so the ptes are always
unstable, because they can be easily faulted back later using the page
cache.  This could lead to uffd-wp getting lost when unmapping or swapping
out such memory.  One example is shmem.  PTE markers are needed to store
those information.

This patch prepares it by handling uffd-wp pte markers first it is applied
elsewhere, so that the page fault handler can recognize uffd-wp pte
markers.

The handling of uffd-wp pte markers is similar to missing fault, it's just
that we'll handle this "missing fault" when we see the pte markers,
meanwhile we need to make sure the marker information is kept during
processing the fault.

This is a slow path of uffd-wp handling, because zapping of wr-protected
shmem ptes should be rare.  So far it should only trigger in two
conditions:

  (1) When trying to punch holes in shmem_fallocate(), there is an
      optimization to zap the pgtables before evicting the page.

  (2) When swapping out shmem pages.

Because of this, the page fault handling is simplifed too by not sending
the wr-protect message in the 1st page fault, instead the page will be
installed read-only, so the uffd-wp message will be generated in the next
fault, which will trigger the do_wp_page() path of general uffd-wp
handling.

Disable fault-around for all uffd-wp registered ranges for extra safety
just like uffd-minor fault, and clean the code up.

Link: https://lkml.kernel.org/r/20220405014844.14239-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/userfaultfd_k.h |   17 ++++++++
 mm/memory.c                   |   67 +++++++++++++++++++++++++++-----
 2 files changed, 75 insertions(+), 9 deletions(-)

--- a/include/linux/userfaultfd_k.h~mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler
+++ a/include/linux/userfaultfd_k.h
@@ -96,6 +96,18 @@ static inline bool uffd_disable_huge_pmd
 	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
 }
 
+/*
+ * Don't do fault around for either WP or MINOR registered uffd range.  For
+ * MINOR registered range, fault around will be a total disaster and ptes can
+ * be installed without notifications; for WP it should mostly be fine as long
+ * as the fault around checks for pte_none() before the installation, however
+ * to be super safe we just forbid it.
+ */
+static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
+}
+
 static inline bool userfaultfd_missing(struct vm_area_struct *vma)
 {
 	return vma->vm_flags & VM_UFFD_MISSING;
@@ -236,6 +248,11 @@ static inline void userfaultfd_unmap_com
 {
 }
 
+static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
+{
+	return false;
+}
+
 #endif /* CONFIG_USERFAULTFD */
 
 static inline bool pte_marker_entry_uffd_wp(swp_entry_t entry)
--- a/mm/memory.c~mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler
+++ a/mm/memory.c
@@ -3555,6 +3555,39 @@ static inline bool should_try_to_free_sw
 		page_count(page) == 2;
 }
 
+static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
+{
+	vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
+				       vmf->address, &vmf->ptl);
+	/*
+	 * Be careful so that we will only recover a special uffd-wp pte into a
+	 * none pte.  Otherwise it means the pte could have changed, so retry.
+	 */
+	if (is_pte_marker(*vmf->pte))
+		pte_clear(vmf->vma->vm_mm, vmf->address, vmf->pte);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	return 0;
+}
+
+/*
+ * This is actually a page-missing access, but with uffd-wp special pte
+ * installed.  It means this pte was wr-protected before being unmapped.
+ */
+static vm_fault_t pte_marker_handle_uffd_wp(struct vm_fault *vmf)
+{
+	/*
+	 * Just in case there're leftover special ptes even after the region
+	 * got unregistered - we can simply clear them.  We can also do that
+	 * proactively when e.g. when we do UFFDIO_UNREGISTER upon some uffd-wp
+	 * ranges, but it should be more efficient to be done lazily here.
+	 */
+	if (unlikely(!userfaultfd_wp(vmf->vma) || vma_is_anonymous(vmf->vma)))
+		return pte_marker_clear(vmf);
+
+	/* do_fault() can handle pte markers too like none pte */
+	return do_fault(vmf);
+}
+
 static vm_fault_t handle_pte_marker(struct vm_fault *vmf)
 {
 	swp_entry_t entry = pte_to_swp_entry(vmf->orig_pte);
@@ -3568,8 +3601,11 @@ static vm_fault_t handle_pte_marker(stru
 	if (WARN_ON_ONCE(vma_is_anonymous(vmf->vma) || !marker))
 		return VM_FAULT_SIGBUS;
 
-	/* TODO: handle pte markers */
-	return 0;
+	if (pte_marker_entry_uffd_wp(entry))
+		return pte_marker_handle_uffd_wp(vmf);
+
+	/* This is an unknown pte marker */
+	return VM_FAULT_SIGBUS;
 }
 
 /*
@@ -4153,6 +4189,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 void do_set_pte(struct vm_fault *vmf, struct page *page, unsigned long addr)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	bool uffd_wp = pte_marker_uffd_wp(vmf->orig_pte);
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	bool prefault = vmf->address != addr;
 	pte_t entry;
@@ -4167,6 +4204,8 @@ void do_set_pte(struct vm_fault *vmf, st
 
 	if (write)
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	if (unlikely(uffd_wp))
+		entry = pte_mkuffd_wp(pte_wrprotect(entry));
 	/* copy-on-write page */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
@@ -4340,9 +4379,21 @@ static vm_fault_t do_fault_around(struct
 	return vmf->vma->vm_ops->map_pages(vmf, start_pgoff, end_pgoff);
 }
 
+/* Return true if we should do read fault-around, false otherwise */
+static inline bool should_fault_around(struct vm_fault *vmf)
+{
+	/* No ->map_pages?  No way to fault around... */
+	if (!vmf->vma->vm_ops->map_pages)
+		return false;
+
+	if (uffd_disable_fault_around(vmf->vma))
+		return false;
+
+	return fault_around_bytes >> PAGE_SHIFT > 1;
+}
+
 static vm_fault_t do_read_fault(struct vm_fault *vmf)
 {
-	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret = 0;
 
 	/*
@@ -4350,12 +4401,10 @@ static vm_fault_t do_read_fault(struct v
 	 * if page by the offset is not ready to be mapped (cold cache or
 	 * something).
 	 */
-	if (vma->vm_ops->map_pages && fault_around_bytes >> PAGE_SHIFT > 1) {
-		if (likely(!userfaultfd_minor(vmf->vma))) {
-			ret = do_fault_around(vmf);
-			if (ret)
-				return ret;
-		}
+	if (should_fault_around(vmf)) {
+		ret = do_fault_around(vmf);
+		if (ret)
+			return ret;
 	}
 
 	ret = __do_fault(vmf);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-introduce-pte_marker-swap-entry.patch
mm-teach-core-mm-about-pte-markers.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-uffd-pte_marker_uffd_wp.patch
mm-shmem-take-care-of-uffdio_copy_mode_wp.patch
mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch
mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed.patch
mm-shmem-allow-uffd-wr-protect-none-pte-for-file-backed-mem.patch
mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch
mm-shmem-handle-uffd-wp-during-fork.patch
mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch
mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch
mm-hugetlb-take-care-of-uffdio_copy_mode_wp.patch
mm-hugetlb-handle-uffdio_writeprotect.patch
mm-hugetlb-handle-pte-markers-in-page-faults.patch
mm-hugetlb-allow-uffd-wr-protect-none-ptes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch

