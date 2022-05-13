Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3415C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 02:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376572AbiEMCyP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 22:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbiEMCyO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 22:54:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C5A27BC40
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:54:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08C46B82BA8
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 02:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9B1C385B8;
        Fri, 13 May 2022 02:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652410449;
        bh=LF7LzJ3ycG7M/oMwpUJ7tpCZFLHJX4y86NfeTjEreII=;
        h=Date:To:From:Subject:From;
        b=Bw8RqDstfqq+5iVvJ8Dqt2uieDjM8teCTOLC1tdCzBulogkbZQYCWfEZ2rXh9iCfn
         LrtpZ37D1Na2jQT/zvyMkxd7iUrhzqvfzhNIcDd4MV5sYujVzu7lIvn4v4bOHZJXDR
         d9c22luTn21NjnBkhiFQqDlmwibORe06V88CRuCA=
Date:   Thu, 12 May 2022 19:54:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        m.szyprowski@samsung.com, mike.kravetz@oracle.com,
        kirill@shutemov.name, jglisse@redhat.com, hughd@google.com,
        david@redhat.com, axelrasmussen@google.com, apopple@nvidia.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-check-against-orig_pte-for-finish_fault-fix.patch removed from -mm tree
Message-Id: <20220513025409.9D9B1C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-check-against-orig_pte-for-finish_fault-fix
has been removed from the -mm tree.  Its filename was
     mm-check-against-orig_pte-for-finish_fault-fix.patch

This patch was dropped because it was folded into mm-check-against-orig_pte-for-finish_fault.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm-check-against-orig_pte-for-finish_fault-fix

fix crash reported by Marek

Link: https://lkml.kernel.org/r/Ylb9rXJyPm8/ao8f@xz-m1.local
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
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

 include/linux/mm_types.h |    3 +++
 mm/memory.c              |   20 ++++++++++++--------
 2 files changed, 15 insertions(+), 8 deletions(-)

--- a/include/linux/mm_types.h~mm-check-against-orig_pte-for-finish_fault-fix
+++ a/include/linux/mm_types.h
@@ -822,6 +822,8 @@ typedef struct {
  * @FAULT_FLAG_UNSHARE: The fault is an unsharing request to unshare (and mark
  *                      exclusive) a possibly shared anonymous page that is
  *                      mapped R/O.
+ * @FAULT_FLAG_ORIG_PTE_VALID: whether the fault has vmf->orig_pte cached.
+ *                        We should only access orig_pte if this flag set.
  *
  * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
  * whether we would allow page faults to retry by specifying these two
@@ -858,6 +860,7 @@ enum fault_flag {
 	FAULT_FLAG_INSTRUCTION =	1 << 8,
 	FAULT_FLAG_INTERRUPTIBLE =	1 << 9,
 	FAULT_FLAG_UNSHARE =		1 << 10,
+	FAULT_FLAG_ORIG_PTE_VALID =	1 << 11,
 };
 
 #endif /* _LINUX_MM_TYPES_H */
--- a/mm/memory.c~mm-check-against-orig_pte-for-finish_fault-fix
+++ a/mm/memory.c
@@ -4183,6 +4183,15 @@ void do_set_pte(struct vm_fault *vmf, st
 	set_pte_at(vma->vm_mm, addr, vmf->pte, entry);
 }
 
+static bool vmf_pte_changed(struct vm_fault *vmf)
+{
+	if (vmf->flags & FAULT_FLAG_ORIG_PTE_VALID) {
+		return !pte_same(*vmf->pte, vmf->orig_pte);
+	}
+
+	return !pte_none(*vmf->pte);
+}
+
 /**
  * finish_fault - finish page fault once we have prepared the page to fault
  *
@@ -4241,7 +4250,7 @@ vm_fault_t finish_fault(struct vm_fault
 				      vmf->address, &vmf->ptl);
 	ret = 0;
 	/* Re-check under ptl */
-	if (likely(pte_same(*vmf->pte, vmf->orig_pte)))
+	if (likely(!vmf_pte_changed(vmf)))
 		do_set_pte(vmf, page, vmf->address);
 	else
 		ret = VM_FAULT_NOPAGE;
@@ -4709,13 +4718,7 @@ static vm_fault_t handle_pte_fault(struc
 		 * concurrent faults and from rmap lookups.
 		 */
 		vmf->pte = NULL;
-		/*
-		 * Always initialize orig_pte.  This matches with below
-		 * code to have orig_pte to be the none pte if pte==NULL.
-		 * This makes the rest code to be always safe to reference
-		 * it, e.g. in finish_fault() we'll detect pte changes.
-		 */
-		pte_clear(vmf->vma->vm_mm, vmf->address, &vmf->orig_pte);
+		vmf->flags &= ~FAULT_FLAG_ORIG_PTE_VALID;
 	} else {
 		/*
 		 * If a huge pmd materialized under us just retry later.  Use
@@ -4739,6 +4742,7 @@ static vm_fault_t handle_pte_fault(struc
 		 */
 		vmf->pte = pte_offset_map(vmf->pmd, vmf->address);
 		vmf->orig_pte = *vmf->pte;
+		vmf->flags |= FAULT_FLAG_ORIG_PTE_VALID;
 
 		/*
 		 * some architectures can have larger ptes than wordsize,
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-introduce-pte_marker-swap-entry.patch
mm-teach-core-mm-about-pte-markers.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-uffd-pte_marker_uffd_wp.patch
mm-uffd-pte_marker_uffd_wp-fix.patch
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
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix.patch
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
mm-enable-pte-markers-by-default-fix.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch
mm-uffd-move-userfaultfd-configs-into-mm.patch

