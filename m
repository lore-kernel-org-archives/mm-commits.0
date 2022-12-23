Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF11C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 23 Dec 2022 18:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbiLWSmc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Dec 2022 13:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbiLWSmb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Dec 2022 13:42:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501E41EEF0
        for <mm-commits@vger.kernel.org>; Fri, 23 Dec 2022 10:42:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A55FC61BBC
        for <mm-commits@vger.kernel.org>; Fri, 23 Dec 2022 18:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7D4C433D2;
        Fri, 23 Dec 2022 18:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671820949;
        bh=fBNazYoSRL49OXfHOccDmMf3W22L+W4wAUY0/vLbLj4=;
        h=Date:To:From:Subject:From;
        b=Kddh5P2PLOdYdY0VngepyGiTRBos1qvsspNMigIIupgVTXH1SxiMYGk5H9U4LFy7C
         Yq7RYHpux8081GNhNXbNgFqvkc6UVz8tLowE3GUKrl/OHhQKDC2kj0suej73C6qGSG
         8MQoR388uR0pElyto6wFA8Ud4yHpfV3zadoFP52w=
Date:   Fri, 23 Dec 2022 10:42:28 -0800
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        nadav.amit@gmail.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch added to mm-unstable branch
Message-Id: <20221223184229.0A7D4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect: drop pgprot_t parameter from change_protection()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch

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
Subject: mm/mprotect: drop pgprot_t parameter from change_protection()
Date: Fri, 23 Dec 2022 16:56:16 +0100

Being able to provide a custom protection opens the door for
inconsistencies and BUGs: for example, accidentally allowing for more
permissions than desired by other mechanisms (e.g., softdirty tracking). 
vma->vm_page_prot should be the single source of truth.

Only PROT_NUMA is special: there is no way we can erroneously allow
for more permissions when removing all permissions. Special-case using
the MM_CP_PROT_NUMA flag.

Link: https://lkml.kernel.org/r/20221223155616.297723-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-mprotect-drop-pgprot_t-parameter-from-change_protection
+++ a/include/linux/mm.h
@@ -2134,8 +2134,7 @@ bool can_change_pte_writable(struct vm_a
 			     pte_t pte);
 extern unsigned long change_protection(struct mmu_gather *tlb,
 			      struct vm_area_struct *vma, unsigned long start,
-			      unsigned long end, pgprot_t newprot,
-			      unsigned long cp_flags);
+			      unsigned long end, unsigned long cp_flags);
 extern int mprotect_fixup(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			  struct vm_area_struct **pprev, unsigned long start,
 			  unsigned long end, unsigned long newflags);
--- a/mm/mempolicy.c~mm-mprotect-drop-pgprot_t-parameter-from-change_protection
+++ a/mm/mempolicy.c
@@ -635,8 +635,7 @@ unsigned long change_prot_numa(struct vm
 
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
-	nr_updated = change_protection(&tlb, vma, addr, end, PAGE_NONE,
-				       MM_CP_PROT_NUMA);
+	nr_updated = change_protection(&tlb, vma, addr, end, MM_CP_PROT_NUMA);
 	if (nr_updated)
 		count_vm_numa_events(NUMA_PTE_UPDATES, nr_updated);
 
--- a/mm/mprotect.c~mm-mprotect-drop-pgprot_t-parameter-from-change_protection
+++ a/mm/mprotect.c
@@ -507,13 +507,21 @@ static unsigned long change_protection_r
 
 unsigned long change_protection(struct mmu_gather *tlb,
 		       struct vm_area_struct *vma, unsigned long start,
-		       unsigned long end, pgprot_t newprot,
-		       unsigned long cp_flags)
+		       unsigned long end, unsigned long cp_flags)
 {
+	pgprot_t newprot = vma->vm_page_prot;
 	unsigned long pages;
 
 	BUG_ON((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL);
 
+	/*
+	 * Ordinary protection updates (mprotect, uffd-wp, softdirty tracking)
+	 * are expected to reflect their requirements via VMA flags such that
+	 * vma_set_page_prot() will adjust vma->vm_page_prot accordingly.
+	 */
+	if (cp_flags & MM_CP_PROT_NUMA)
+		newprot = PAGE_NONE;
+
 	if (is_vm_hugetlb_page(vma))
 		pages = hugetlb_change_protection(vma, start, end, newprot,
 						  cp_flags);
@@ -642,7 +650,7 @@ success:
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
 	vma_set_page_prot(vma);
 
-	change_protection(tlb, vma, start, end, vma->vm_page_prot, mm_cp_flags);
+	change_protection(tlb, vma, start, end, mm_cp_flags);
 
 	/*
 	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
--- a/mm/userfaultfd.c~mm-mprotect-drop-pgprot_t-parameter-from-change_protection
+++ a/mm/userfaultfd.c
@@ -730,8 +730,7 @@ void uffd_wp_range(struct mm_struct *dst
 	if (vma_wants_manual_pte_write_upgrade(dst_vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
 	tlb_gather_mmu(&tlb, dst_mm);
-	change_protection(&tlb, dst_vma, start, start + len, vma->vm_page_prot,
-			  mm_cp_flags);
+	change_protection(&tlb, dst_vma, start, start + len, mm_cp_flags);
 	tlb_finish_mmu(&tlb);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-hugetlb-fix-pte-marker-handling-in-hugetlb_change_protection.patch
mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch
mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch

