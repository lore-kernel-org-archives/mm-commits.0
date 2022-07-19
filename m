Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FF3C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 19:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiGSTWf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 15:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbiGSTWe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 15:22:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADE745980
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 12:22:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02577B81CE5
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 19:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4B4C341CA;
        Tue, 19 Jul 2022 19:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658258550;
        bh=Gq/K9KEwjURCDApfZAPfk2cY9On1a6HvSXlGf3O1wvQ=;
        h=Date:To:From:Subject:From;
        b=2a+pvnlIYvZoqi1pYfveUIUoJf33kJXNe9XpNHMkCdzYEvT4O1NOKBGQkJYInZqnI
         I26wE4xJnzuxO40KKUcCkHlAMy9J0NSj5l833HgYeMLc5gfEpiuk7iUC/v1ZI6e78Q
         shSFQK5qeTOihbafB+Q55BWNJL++CmHVksM4U5vM=
Date:   Tue, 19 Jul 2022 12:22:29 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        hughd@google.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap-fix.patch added to mm-unstable branch
Message-Id: <20220719192230.9A4B4C341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: remove do_brk_munmap() optimization
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap-fix.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mmap: remove do_brk_munmap() optimization
Date: Tue, 19 Jul 2022 19:14:01 +0000

This optimization does not work with the locking.

Link: https://lkml.kernel.org/r/20220719191352.3366482-2-Liam.Howlett@oracle.com
Fixes: f12fee814843 (mm/mmap: change do_brk_flags() to expand existing VMA and add do_brk_munmap())
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   61 +---------------------------------------------------
 1 file changed, 2 insertions(+), 59 deletions(-)

--- a/mm/mmap.c~mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap-fix
+++ a/mm/mmap.c
@@ -2809,67 +2809,10 @@ static int do_brk_munmap(struct ma_state
 			 struct list_head *uf)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	struct vm_area_struct unmap;
-	unsigned long unmap_pages;
-	int ret = 1;
+	int ret;
 
 	arch_unmap(mm, newbrk, oldbrk);
-
-	if (likely((vma->vm_end < oldbrk) ||
-		   ((vma->vm_start == newbrk) && (vma->vm_end == oldbrk)))) {
-		/* remove entire mapping(s) */
-		mas_set(mas, newbrk);
-		if (vma->vm_start != newbrk)
-			mas_reset(mas); /* cause a re-walk for the first overlap. */
-		ret = __do_munmap(mm, newbrk, oldbrk - newbrk, uf, true);
-		goto munmap_full_vma;
-	}
-
-	vma_init(&unmap, mm);
-	unmap.vm_start = newbrk;
-	unmap.vm_end = oldbrk;
-	ret = userfaultfd_unmap_prep(&unmap, newbrk, oldbrk, uf);
-	if (ret)
-		return ret;
-	ret = 1;
-
-	/* Change the oldbrk of vma to the newbrk of the munmap area */
-	vma_adjust_trans_huge(vma, vma->vm_start, newbrk, 0);
-	if (mas_preallocate(mas, vma, GFP_KERNEL))
-		return -ENOMEM;
-
-	if (vma->anon_vma) {
-		anon_vma_lock_write(vma->anon_vma);
-		anon_vma_interval_tree_pre_update_vma(vma);
-	}
-
-	vma->vm_end = newbrk;
-	vma_init(&unmap, mm);
-	unmap.vm_start = newbrk;
-	unmap.vm_end = oldbrk;
-	if (vma->anon_vma)
-		vma_set_anonymous(&unmap);
-
-	vma_mas_remove(&unmap, mas);
-
-	vmacache_invalidate(vma->vm_mm);
-	if (vma->anon_vma) {
-		anon_vma_interval_tree_post_update_vma(vma);
-		anon_vma_unlock_write(vma->anon_vma);
-	}
-
-	unmap_pages = vma_pages(&unmap);
-	if (vma->vm_flags & VM_LOCKED)
-		mm->locked_vm -= unmap_pages;
-
-	mmap_write_downgrade(mm);
-	unmap_region(mm, &unmap, vma, newbrk, oldbrk);
-	/* Statistics */
-	vm_stat_account(mm, vma->vm_flags, -unmap_pages);
-	if (vma->vm_flags & VM_ACCOUNT)
-		vm_unacct_memory(unmap_pages);
-
-munmap_full_vma:
+	ret = __do_munmap(mm, newbrk, oldbrk - newbrk, uf, true);
 	validate_mm_mt(mm);
 	return ret;
 }
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
mm-mmap-use-maple-tree-for-unmapped_area_topdown-fix.patch
mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

