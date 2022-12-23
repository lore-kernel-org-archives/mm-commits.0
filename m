Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03329C3DA79
	for <mm-commits@archiver.kernel.org>; Fri, 23 Dec 2022 18:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbiLWSmc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Dec 2022 13:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiLWSmb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Dec 2022 13:42:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502B41F624
        for <mm-commits@vger.kernel.org>; Fri, 23 Dec 2022 10:42:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4D25B82109
        for <mm-commits@vger.kernel.org>; Fri, 23 Dec 2022 18:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B28AC433F0;
        Fri, 23 Dec 2022 18:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671820947;
        bh=F4Z6k/XITOhvMzuaEt/hkzsBsCRXcnjzSXJwr0AGIfk=;
        h=Date:To:From:Subject:From;
        b=K+/y7ux21MhHgrva92pDW9/ZGvCN6q5H5jZvMRBy649WMDCTMNgwPQ+3NpeTKk+qO
         18/p9K24TWLRk2K2NDyK/TLKTXjKskK/nP4jTZjHWhIufMJeBxekSo/vykCrWUDiug
         /LzSUfcn0vXd5N8G0+F/rAvkI6+XYNMh/LPKGmMU=
Date:   Fri, 23 Dec 2022 10:42:26 -0800
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        nadav.amit@gmail.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch added to mm-unstable branch
Message-Id: <20221223184227.8B28AC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/userfaultfd: rely on vma->vm_page_prot in uffd_wp_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/userfaultfd: rely on vma->vm_page_prot in uffd_wp_range()
Date: Fri, 23 Dec 2022 16:56:15 +0100

Patch series "mm: uffd-wp + change_protection() cleanups".

Cleanup page protection handling in uffd-wp when calling
change_protection() and improve unprotecting uffd=wp in private mappings,
trying to set PTEs writable again if possible just like we do during
mprotect() when upgrading write permissions.  Make the change_protection()
interface harder to get wrong :)

I consider both pages primarily cleanups, although patch #1 fixes a corner
case with uffd-wp and softdirty tracking for shmem.  @Peter, please let me
know if we should flag patch #1 as pure cleanup -- I have no idea how
important softdirty tracking on shmem is.


This patch (of 2):

uffd_wp_range() currently calculates page protection manually using
vm_get_page_prot().  This will ignore any other reason for active
writenotify: one mechanism applicable to shmem is softdirty tracking.

For example, the following sequence

1) Write to mapped shmem page
2) Clear softdirty
3) Register uffd-wp covering the mapped page
4) Unregister uffd-wp covering the mapped page
5) Write to page again

will not set the modified page softdirty, because uffd_wp_range() will
ignore that writenotify is required for softdirty tracking and simply map
the page writable again using change_protection().  Similarly, instead of
unregistering, protecting followed by un-protecting the page using uffd-wp
would result in the same situation.

Now that we enable writenotify whenever enabling uffd-wp on a VMA,
vma->vm_page_prot will already properly reflect our requirements: the
default is to write-protect all PTEs.  However, for shared mappings we
would now not remap the PTEs writable if possible when unprotecting, just
like for private mappings (COW).  To compensate, set
MM_CP_TRY_CHANGE_WRITABLE just like mprotect() does to try mapping
individual PTEs writable.

For private mappings, this change implies that we will now always try
setting PTEs writable when un-protecting, just like when upgrading write
permissions using mprotect(), which is an improvement.

For shared mappings, we will only set PTEs writable if
can_change_pte_writable()/can_change_pmd_writable() indicates that it's
ok.  For ordinary shmem, this will be the case when PTEs are dirty, which
should usually be the case -- otherwise we could special-case shmem in
can_change_pte_writable()/can_change_pmd_writable() easily, because shmem
itself doesn't require writenotify.

Note that hugetlb does not yet implement MM_CP_TRY_CHANGE_WRITABLE, so we
won't try setting PTEs writable when unprotecting or when unregistering
uffd-wp.  This can be added later on top by implementing
MM_CP_TRY_CHANGE_WRITABLE.

While commit ffd05793963a ("userfaultfd: wp: support write protection for
userfault vma range") introduced that code, it should only be applicable
to uffd-wp on shared mappings -- shmem (hugetlb does not support softdirty
tracking).  I don't think this corner cases justifies to cc stable.  Let's
just handle it correctly and prepare for change_protection() cleanups.

Link: https://lkml.kernel.org/r/20221223155616.297723-1-david@redhat.com
Link: https://lkml.kernel.org/r/20221223155616.297723-2-david@redhat.com
Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/userfaultfd.c~mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range
+++ a/mm/userfaultfd.c
@@ -713,17 +713,25 @@ ssize_t mcopy_continue(struct mm_struct
 void uffd_wp_range(struct mm_struct *dst_mm, struct vm_area_struct *dst_vma,
 		   unsigned long start, unsigned long len, bool enable_wp)
 {
+	unsigned int mm_cp_flags;
 	struct mmu_gather tlb;
-	pgprot_t newprot;
 
 	if (enable_wp)
-		newprot = vm_get_page_prot(dst_vma->vm_flags & ~(VM_WRITE));
+		mm_cp_flags = MM_CP_UFFD_WP;
 	else
-		newprot = vm_get_page_prot(dst_vma->vm_flags);
+		mm_cp_flags = MM_CP_UFFD_WP_RESOLVE;
 
+	/*
+	 * vma->vm_page_prot already reflects that uffd-wp is enabled for this
+	 * VMA (see userfaultfd_set_vm_flags()) and that all PTEs are supposed
+	 * to be write-protected as default whenever protection changes.
+	 * Try upgrading write permissions manually.
+	 */
+	if (vma_wants_manual_pte_write_upgrade(dst_vma))
+		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
 	tlb_gather_mmu(&tlb, dst_mm);
-	change_protection(&tlb, dst_vma, start, start + len, newprot,
-			  enable_wp ? MM_CP_UFFD_WP : MM_CP_UFFD_WP_RESOLVE);
+	change_protection(&tlb, dst_vma, start, start + len, vma->vm_page_prot,
+			  mm_cp_flags);
 	tlb_finish_mmu(&tlb);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-hugetlb-fix-pte-marker-handling-in-hugetlb_change_protection.patch
mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch
mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch

