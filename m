Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744E1C00528
	for <mm-commits@archiver.kernel.org>; Sat,  5 Aug 2023 16:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjHEQ4R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 5 Aug 2023 12:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjHEQ4P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 5 Aug 2023 12:56:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C2D4210
        for <mm-commits@vger.kernel.org>; Sat,  5 Aug 2023 09:56:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6901160B38
        for <mm-commits@vger.kernel.org>; Sat,  5 Aug 2023 16:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBC4C433C7;
        Sat,  5 Aug 2023 16:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691254573;
        bh=ssha2rhwbiFRlgn+cZKyllAPIYQElX32A5vJPpK9Aks=;
        h=Date:To:From:Subject:From;
        b=OyTQ+o/imup2SeA9PIDA/TsZGTL5QGrc6kyHHJ2PnL+rHhBPdN6eyco064HFF6CXS
         Oe4rbsXsV0wwIjjwKZFVj2EUg7OAwM6H366Lt0c8x/x47s8FpWV/Klkq+hIVwVg99m
         71GKBZFvJ5MamD8AJf38M6G8FEQC+GrIVzGWkacg=
Date:   Sat, 05 Aug 2023 09:56:13 -0700
To:     mm-commits@vger.kernel.org, torvalds@linuxfoundation.org,
        Liam.Howlett@oracle.com, jannh@google.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-always-lock-new-vma-before-inserting-into-vma-tree.patch added to mm-unstable branch
Message-Id: <20230805165613.BCBC4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: always lock new vma before inserting into vma tree
has been added to the -mm mm-unstable branch.  Its filename is
     mm-always-lock-new-vma-before-inserting-into-vma-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-always-lock-new-vma-before-inserting-into-vma-tree.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: always lock new vma before inserting into vma tree
Date: Fri, 4 Aug 2023 08:27:23 -0700

While it's not strictly necessary to lock a newly created vma before
adding it into the vma tree (as long as no further changes are performed
to it), it seems like a good policy to lock it and prevent accidental
changes after it becomes visible to the page faults. Lock the vma before
adding it into the vma tree.

Link: https://lkml.kernel.org/r/20230804152724.3090321-6-surenb@google.com
Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-always-lock-new-vma-before-inserting-into-vma-tree
+++ a/mm/mmap.c
@@ -403,6 +403,8 @@ static int vma_link(struct mm_struct *mm
 
 	vma_iter_store(&vmi, vma);
 
+	vma_start_write(vma);
+
 	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
 		i_mmap_lock_write(mapping);
@@ -463,7 +465,8 @@ static inline void vma_prepare(struct vm
 	vma_start_write(vp->vma);
 	if (vp->adj_next)
 		vma_start_write(vp->adj_next);
-	/* vp->insert is always a newly created VMA, no need for locking */
+	if (vp->insert)
+		vma_start_write(vp->insert);
 	if (vp->remove)
 		vma_start_write(vp->remove);
 	if (vp->remove2)
@@ -3093,6 +3096,7 @@ static int do_brk_flags(struct vma_itera
 	vma->vm_pgoff = addr >> PAGE_SHIFT;
 	vm_flags_init(vma, flags);
 	vma->vm_page_prot = vm_get_page_prot(flags);
+	vma_start_write(vma);
 	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
 		goto mas_store_fail;
 
@@ -3341,7 +3345,6 @@ struct vm_area_struct *copy_vma(struct v
 			get_file(new_vma->vm_file);
 		if (new_vma->vm_ops && new_vma->vm_ops->open)
 			new_vma->vm_ops->open(new_vma);
-		vma_start_write(new_vma);
 		if (vma_link(mm, new_vma))
 			goto out_vma_link;
 		*need_rmap_locks = false;
_

Patches currently in -mm which might be from surenb@google.com are

mm-enable-page-walking-api-to-lock-vmas-during-the-walk.patch
swap-remove-remnants-of-polling-from-read_swap_cache_async.patch
mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch
mm-handle-swap-page-faults-under-per-vma-lock.patch
mm-handle-userfaults-under-vma-lock.patch
mm-handle-userfaults-under-vma-lock-fix.patch
mm-for-config_per_vma_lock-equate-write-lock-assertion-for-vma-and-mmap.patch
mm-replace-mmap-with-vma-write-lock-assertions-when-operating-on-a-vma.patch
mm-lock-vma-explicitly-before-doing-vm_flags_reset-and-vm_flags_reset_once.patch
mm-always-lock-new-vma-before-inserting-into-vma-tree.patch
mm-move-vma-locking-out-of-vma_prepare-and-dup_anon_vma.patch

