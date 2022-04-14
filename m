Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC84C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 20:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242814AbiDNU6b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 16:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiDNU6a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 16:58:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7862FCD648
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 13:56:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23FECB82A67
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 20:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5234C385A5;
        Thu, 14 Apr 2022 20:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649969761;
        bh=l89+WUhC0Gu+zPZLsWUr5d8P7O6W9rpk6TwUnJZWgJ4=;
        h=Date:To:From:Subject:From;
        b=c0twqZpzKSCE5SUOKdrCXZ8FTIYOWZ/mv5Zj0ozLEtMkZHfBJKwP88plVtkQfWqTE
         eiazdffPzk5SOOruSyJ9HQGJbWQfOnV37OszMK/DUQOpO9PA5nomCeGys75FbYsyg8
         GefbQpPomevl3/snEYdmVH72zwJaDhmHWEWIBuqk=
Date:   Thu, 14 Apr 2022 13:56:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        m.szyprowski@samsung.com, mike.kravetz@oracle.com,
        kirill@shutemov.name, jglisse@redhat.com, hughd@google.com,
        david@redhat.com, axelrasmussen@google.com, apopple@nvidia.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-check-against-orig_pte-for-finish_fault-fix.patch added to -mm tree
Message-Id: <20220414205601.A5234C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-check-against-orig_pte-for-finish_fault-fix
has been added to the -mm tree.  Its filename is
     mm-check-against-orig_pte-for-finish_fault-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-check-against-orig_pte-for-finish_fault-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-check-against-orig_pte-for-finish_fault-fix.patch

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


--- a/include/linux/mm_types.h~mm-check-against-orig_pte-for-finish_fault-fix
+++ a/include/linux/mm_types.h
@@ -814,6 +814,8 @@ typedef struct {
  * @FAULT_FLAG_UNSHARE: The fault is an unsharing request to unshare (and mark
  *                      exclusive) a possibly shared anonymous page that is
  *                      mapped R/O.
+ * @FAULT_FLAG_ORIG_PTE_VALID: whether the fault has vmf->orig_pte cached.
+ *                        We should only access orig_pte if this flag set.
  *
  * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
  * whether we would allow page faults to retry by specifying these two
@@ -850,6 +852,7 @@ enum fault_flag {
 	FAULT_FLAG_INSTRUCTION =	1 << 8,
 	FAULT_FLAG_INTERRUPTIBLE =	1 << 9,
 	FAULT_FLAG_UNSHARE =		1 << 10,
+	FAULT_FLAG_ORIG_PTE_VALID =	1 << 11,
 };
 
 #endif /* _LINUX_MM_TYPES_H */
--- a/mm/memory.c~mm-check-against-orig_pte-for-finish_fault-fix
+++ a/mm/memory.c
@@ -4194,6 +4194,15 @@ void do_set_pte(struct vm_fault *vmf, st
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
@@ -4252,7 +4261,7 @@ vm_fault_t finish_fault(struct vm_fault
 				      vmf->address, &vmf->ptl);
 	ret = 0;
 	/* Re-check under ptl */
-	if (likely(pte_same(*vmf->pte, vmf->orig_pte)))
+	if (likely(!vmf_pte_changed(vmf)))
 		do_set_pte(vmf, page, vmf->address);
 	else
 		ret = VM_FAULT_NOPAGE;
@@ -4720,13 +4729,7 @@ static vm_fault_t handle_pte_fault(struc
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
@@ -4750,6 +4753,7 @@ static vm_fault_t handle_pte_fault(struc
 		 */
 		vmf->pte = pte_offset_map(vmf->pmd, vmf->address);
 		vmf->orig_pte = *vmf->pte;
+		vmf->flags |= FAULT_FLAG_ORIG_PTE_VALID;
 
 		/*
 		 * some architectures can have larger ptes than wordsize,
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-remove-stub-for-non_swap_entry.patch
mm-introduce-pte_marker-swap-entry.patch
mm-introduce-pte_marker-swap-entry-fix.patch
mm-teach-core-mm-about-pte-markers.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-check-against-orig_pte-for-finish_fault-fix.patch
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
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch

