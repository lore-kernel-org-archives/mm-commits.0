Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EC5C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235141AbjDFDEE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235093AbjDFDDj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:03:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BB9900A
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBA8B6403D
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53350C433EF;
        Thu,  6 Apr 2023 03:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750217;
        bh=atyo7acRgVYeYOLGwHK0EPxrMlmO7aOoJwgwEh/jhLU=;
        h=Date:To:From:Subject:From;
        b=wa5p82JuAiV8NqG59c/4omO7oy5gt7S+CiGN29gXTAXo7Wcc7UoqWmEYJPIfaYoxX
         BGN4XhJcv6EGr0EI+tluBUkwtVx5RssruEhCIBeQkLQ7AiXNX1BtxbaeXEPEUebuPG
         prb0r9ipUg5pMtFzzya2UUz2zLXyfHApEEOGW1fk=
Date:   Wed, 05 Apr 2023 20:03:36 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-move-vma_prepare-before-vma_adjust_trans_huge.patch removed from -mm tree
Message-Id: <20230406030337.53350C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: move vma_prepare before vma_adjust_trans_huge
has been removed from the -mm tree.  Its filename was
     mm-mmap-move-vma_prepare-before-vma_adjust_trans_huge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/mmap: move vma_prepare before vma_adjust_trans_huge
Date: Mon, 27 Feb 2023 09:36:13 -0800

vma_prepare() acquires all locks required before VMA modifications.  Move
vma_prepare() before vma_adjust_trans_huge() so that VMA is locked before
any modification.

Link: https://lkml.kernel.org/r/20230227173632.3292573-15-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-move-vma_prepare-before-vma_adjust_trans_huge
+++ a/mm/mmap.c
@@ -683,12 +683,12 @@ int vma_expand(struct vma_iterator *vmi,
 	if (vma_iter_prealloc(vmi))
 		goto nomem;
 
+	vma_prepare(&vp);
 	vma_adjust_trans_huge(vma, start, end, 0);
 	/* VMA iterator points to previous, so set to start if necessary */
 	if (vma_iter_addr(vmi) != start)
 		vma_iter_set(vmi, start);
 
-	vma_prepare(&vp);
 	vma->vm_start = start;
 	vma->vm_end = end;
 	vma->vm_pgoff = pgoff;
@@ -723,8 +723,8 @@ int vma_shrink(struct vma_iterator *vmi,
 		return -ENOMEM;
 
 	init_vma_prep(&vp, vma);
-	vma_adjust_trans_huge(vma, start, end, 0);
 	vma_prepare(&vp);
+	vma_adjust_trans_huge(vma, start, end, 0);
 
 	if (vma->vm_start < start)
 		vma_iter_clear(vmi, vma->vm_start, start);
@@ -1010,12 +1010,12 @@ struct vm_area_struct *vma_merge(struct
 	if (vma_iter_prealloc(vmi))
 		return NULL;
 
-	vma_adjust_trans_huge(vma, vma_start, vma_end, adj_start);
 	init_multi_vma_prep(&vp, vma, adjust, remove, remove2);
 	VM_WARN_ON(vp.anon_vma && adjust && adjust->anon_vma &&
 		   vp.anon_vma != adjust->anon_vma);
 
 	vma_prepare(&vp);
+	vma_adjust_trans_huge(vma, vma_start, vma_end, adj_start);
 	if (vma_start < vma->vm_start || vma_end > vma->vm_end)
 		vma_expanded = true;
 
@@ -2214,10 +2214,10 @@ int __split_vma(struct vma_iterator *vmi
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
 
-	vma_adjust_trans_huge(vma, vma->vm_start, addr, 0);
 	init_vma_prep(&vp, vma);
 	vp.insert = new;
 	vma_prepare(&vp);
+	vma_adjust_trans_huge(vma, vma->vm_start, addr, 0);
 
 	if (new_below) {
 		vma->vm_start = addr;
@@ -2920,9 +2920,9 @@ static int do_brk_flags(struct vma_itera
 		if (vma_iter_prealloc(vmi))
 			goto unacct_fail;
 
-		vma_adjust_trans_huge(vma, vma->vm_start, addr + len, 0);
 		init_vma_prep(&vp, vma);
 		vma_prepare(&vp);
+		vma_adjust_trans_huge(vma, vma->vm_start, addr + len, 0);
 		vma->vm_end = addr + len;
 		vm_flags_set(vma, VM_SOFTDIRTY);
 		vma_iter_store(vmi, vma);
_

Patches currently in -mm which might be from surenb@google.com are


