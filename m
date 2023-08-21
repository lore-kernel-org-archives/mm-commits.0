Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35218EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjHUUmF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjHUUlC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:41:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CCFCE6
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D002461840
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD0DC433C7;
        Mon, 21 Aug 2023 20:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650438;
        bh=MR9FXzqy2w9rYk1gCGz8JLTgLdQ4Lwds9rULQq8AZV0=;
        h=Date:To:From:Subject:From;
        b=bO1G2nVNVWZW7xR5OI48A5xLuq2l907FkZjOMTTSc6FsS2xz18qEgBKRvH3kibifY
         p0D2nQH1I3GFWOg9Jmq7hHCog1zZR+H5wSVVf66fwG0sIwDfhx2i2VOLRTg3UL2TT2
         ig1TlaS6ubUrxEjI98xnYClF3MbvRQB6Dbk9CPRQ=
Date:   Mon, 21 Aug 2023 13:40:37 -0700
To:     mm-commits@vger.kernel.org, torvalds@linuxfoundation.org,
        Liam.Howlett@oracle.com, jannh@google.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-always-lock-new-vma-before-inserting-into-vma-tree.patch removed from -mm tree
Message-Id: <20230821204038.2FD0DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: always lock new vma before inserting into vma tree
has been removed from the -mm tree.  Its filename was
     mm-always-lock-new-vma-before-inserting-into-vma-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: always lock new vma before inserting into vma tree
Date: Fri, 4 Aug 2023 08:27:23 -0700

While it's not strictly necessary to lock a newly created vma before
adding it into the vma tree (as long as no further changes are performed
to it), it seems like a good policy to lock it and prevent accidental
changes after it becomes visible to the page faults. Lock the vma before
adding it into the vma tree.

[akpm@linux-foundation.org: fix reject fixing in vma_link(), per Jann]
Link: https://lkml.kernel.org/r/20230804152724.3090321-6-surenb@google.com
Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-always-lock-new-vma-before-inserting-into-vma-tree
+++ a/mm/mmap.c
@@ -401,6 +401,8 @@ static int vma_link(struct mm_struct *mm
 	if (vma_iter_prealloc(&vmi, vma))
 		return -ENOMEM;
 
+	vma_start_write(vma);
+
 	vma_iter_store(&vmi, vma);
 
 	if (vma->vm_file) {
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

swap-remove-remnants-of-polling-from-read_swap_cache_async.patch
mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch
mm-handle-swap-page-faults-under-per-vma-lock.patch
mm-handle-userfaults-under-vma-lock.patch
mm-handle-userfaults-under-vma-lock-fix.patch

