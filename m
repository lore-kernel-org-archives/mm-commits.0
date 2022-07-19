Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A858C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 22:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240718AbiGSWEQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 18:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240719AbiGSWEP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 18:04:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A4A6051F
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 15:04:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAD79B81C77
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 22:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AD2C341C6;
        Tue, 19 Jul 2022 22:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658268250;
        bh=HLRXjPrHSeOHF3ULJoIGkmeY2iMYgpqYKyVVOwnctpI=;
        h=Date:To:From:Subject:From;
        b=wypJqtNtHBpIf+Q3+bapU/FGpR7wJbVw0eYXHLwie0xcw4h9LxRt/VovilpETL+Y5
         4ARRjdwAwtW00wPH/fntXIZ/MovEQxMXN2MhEvj1Kmc+mfmMHfjljbZpqsc1cbh7+w
         C35Xpq6zmuAGkIzHM/lKhW7/haI6p0TlmOrOiFQE=
Date:   Tue, 19 Jul 2022 15:04:09 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-fix-hugetlb-accounting-error-in-__split_vma.patch added to mm-unstable branch
Message-Id: <20220719220410.91AD2C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: fix hugetlb accounting error in __split_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mmap-fix-hugetlb-accounting-error-in-__split_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmap-fix-hugetlb-accounting-error-in-__split_vma.patch

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
Subject: mmap: fix hugetlb accounting error in __split_vma()
Date: Tue, 19 Jul 2022 20:15:41 +0000

When splitting a vma fails due to allocations of the maple tree nodes,
the error path in __split_vma() calls new->vm_ops->close(new).  The
page accounting is actually in the close() operation for hugetlb, so it
accounts for the removal of 1/2 of the VMA which was not adjusted.  This
results in a negative exit value.  To avoid the negative charge, set
vm_start = vm_end and vm_pgoff = 0.

At the same time, move the vma_adjust_trans_huge() call below the
allocation call for the maple tree to avoid any other issues that may be
caused in such a scenario.

There is also a potential accounting issue in special mappings from
insert_vm_struct() failing to allocate, so reverse the charge there as
well.

Link: https://lkml.kernel.org/r/20220719201523.3561958-1-Liam.Howlett@oracle.com
Fixes: 2ee236fe53a8 ("mm: start tracking VMAs with maple tree")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: syzbot+28eb226ee1d37f08087a@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mmap-fix-hugetlb-accounting-error-in-__split_vma
+++ a/mm/mmap.c
@@ -711,10 +711,11 @@ int __vma_adjust(struct vm_area_struct *
 				return error;
 		}
 	}
-	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
+
 	if (mas_preallocate(&mas, vma, GFP_KERNEL))
 		return -ENOMEM;
 
+	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
 	if (file) {
 		mapping = file->f_mapping;
 		root = &mapping->i_mmap;
@@ -2252,6 +2253,9 @@ int __split_vma(struct mm_struct *mm, st
 	if (!err)
 		return 0;
 
+	/* Avoid vm accounting in close() operation */
+	new->vm_start = new->vm_end;
+	new->vm_pgoff = 0;
 	/* Clean everything up if vma_adjust failed. */
 	if (new->vm_ops && new->vm_ops->close)
 		new->vm_ops->close(new);
@@ -3199,11 +3203,13 @@ void exit_mmap(struct mm_struct *mm)
  */
 int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
+	unsigned long charged = vma_pages(vma);
+
 	if (find_vma_intersection(mm, vma->vm_start, vma->vm_end))
 		return -ENOMEM;
 
 	if ((vma->vm_flags & VM_ACCOUNT) &&
-	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
+	     security_vm_enough_memory_mm(mm, charged))
 		return -ENOMEM;
 
 	/*
@@ -3223,8 +3229,10 @@ int insert_vm_struct(struct mm_struct *m
 		vma->vm_pgoff = vma->vm_start >> PAGE_SHIFT;
 	}
 
-	if (vma_link(mm, vma))
+	if (vma_link(mm, vma)) {
+		vm_unacct_memory(charged);
 		return -ENOMEM;
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch
maple-tree-add-new-data-structure-fix-3.patch
mmap-fix-hugetlb-accounting-error-in-__split_vma.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

