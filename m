Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DE1C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450713AbiDFB5L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346576AbiDEUeI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:34:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54122FD6E3
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E4C8B81FDF
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA59C385A3;
        Tue,  5 Apr 2022 20:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189825;
        bh=MRToHUIq9y+drCh6lE2vrcW/Qo6Fe3cb0GmLjUt2xBQ=;
        h=Date:To:From:Subject:From;
        b=yLiJclmZMFa0tBQhYM6rKVoIhAA+L0AHhFiX+wyRFP612woZHVed9FYhg6lTFVOrM
         87hk6MrqIWtvUludF22ZBeTvjiIKu+Jj9uY9a7ekRBacDLTBNyan9wFAXVrojhlM6X
         4UIUu78uLRLudUzGgLDQBkGD471o1620H71KnXiE=
Date:   Tue, 05 Apr 2022 13:17:04 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-handle-pte-markers-in-page-faults.patch added to -mm tree
Message-Id: <20220405201705.3CA59C385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: handle pte markers in page faults
has been added to the -mm tree.  Its filename is
     mm-hugetlb-handle-pte-markers-in-page-faults.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-handle-pte-markers-in-page-faults.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-handle-pte-markers-in-page-faults.patch

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
Subject: mm/hugetlb: handle pte markers in page faults

Allow hugetlb code to handle pte markers just like none ptes.  It's mostly
there, we just need to make sure we don't assume hugetlb_no_page() only
handles none pte, so when detecting pte change we should use pte_same()
rather than pte_none().  We need to pass in the old_pte to do the
comparison.

Check the original pte to see whether it's a pte marker, if it is, we
should recover uffd-wp bit on the new pte to be installed, so that the
next write will be trapped by uffd.

Link: https://lkml.kernel.org/r/20220405014909.14761-1-peterx@redhat.com
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

 mm/hugetlb.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-handle-pte-markers-in-page-faults
+++ a/mm/hugetlb.c
@@ -5412,7 +5412,8 @@ static inline vm_fault_t hugetlb_handle_
 static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 			struct vm_area_struct *vma,
 			struct address_space *mapping, pgoff_t idx,
-			unsigned long address, pte_t *ptep, unsigned int flags)
+			unsigned long address, pte_t *ptep,
+			pte_t old_pte, unsigned int flags)
 {
 	struct hstate *h = hstate_vma(vma);
 	vm_fault_t ret = VM_FAULT_SIGBUS;
@@ -5539,7 +5540,8 @@ retry:
 
 	ptl = huge_pte_lock(h, mm, ptep);
 	ret = 0;
-	if (!huge_pte_none(huge_ptep_get(ptep)))
+	/* If pte changed from under us, retry */
+	if (!pte_same(huge_ptep_get(ptep), old_pte))
 		goto backout;
 
 	if (anon_rmap) {
@@ -5549,6 +5551,12 @@ retry:
 		page_dup_file_rmap(page, true);
 	new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
 				&& (vma->vm_flags & VM_SHARED)));
+	/*
+	 * If this pte was previously wr-protected, keep it wr-protected even
+	 * if populated.
+	 */
+	if (unlikely(pte_marker_uffd_wp(old_pte)))
+		new_pte = huge_pte_wrprotect(huge_pte_mkuffd_wp(new_pte));
 	set_huge_pte_at(mm, haddr, ptep, new_pte);
 
 	hugetlb_count_add(pages_per_huge_page(h), mm);
@@ -5666,8 +5674,10 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 	entry = huge_ptep_get(ptep);
-	if (huge_pte_none(entry)) {
-		ret = hugetlb_no_page(mm, vma, mapping, idx, address, ptep, flags);
+	/* PTE markers should be handled the same way as none pte */
+	if (huge_pte_none_mostly(entry)) {
+		ret = hugetlb_no_page(mm, vma, mapping, idx, address, ptep,
+				      entry, flags);
 		goto out_mutex;
 	}
 
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

