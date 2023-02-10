Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E833C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBJAox (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjBJAow (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:44:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC02937540
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:44:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4941061B83
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D2CC433D2;
        Fri, 10 Feb 2023 00:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675989890;
        bh=rk0g+SDLBGfOfs5U0RJqQeqqND5ZZSUgm/Q+2FFXsHU=;
        h=Date:To:From:Subject:From;
        b=cs/3JhAjUj0HWs1eh7AG0nB2ic2A+gI1n1ht2gcf67R5RyXNr+dQ0yX3lHnGMqd42
         FECWvb3zzxYSRxucxE86PPsyqSj6L8w46xcG+HEpfDQb/J2BTdh4s6yWm3W0LAGFok
         edSz3T4Upmab8nQyeUuitYV0HF8ONzBAQpjx43LI=
Date:   Thu, 09 Feb 2023 16:44:49 -0800
To:     mm-commits@vger.kernel.org,
        syzbot+1d9ec4d1a334ae9e1ca6@syzkaller.appspotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] madvise-use-split_vma-instead-of-__split_vma-fix.patch removed from -mm tree
Message-Id: <20230210004450.A3D2CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/madvise: fix VMA_ITERATOR start position
has been removed from the -mm tree.  Its filename was
     madvise-use-split_vma-instead-of-__split_vma-fix.patch

This patch was dropped because it was folded into madvise-use-split_vma-instead-of-__split_vma.patch

------------------------------------------------------
From: Liam Howlett <Liam.Howlett@oracle.com>
Subject: mm/madvise: fix VMA_ITERATOR start position
Date: Wed, 25 Jan 2023 08:58:09 -0500

The WARN_ON() in vma_iter_store() detected an invalid VMA iterator state. 
Inspecting the code stack from the report shows that the VMA iterator is
never set to the correct start position.

Setting the initialization of the VMA iterator to use the address 'start'
fixes this issue.

Link: https://lkml.kernel.org/r/20230125135809.85262-1-Liam.Howlett@oracle.com
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Reported-by: <syzbot+1d9ec4d1a334ae9e1ca6@syzkaller.appspotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/madvise.c~madvise-use-split_vma-instead-of-__split_vma-fix
+++ a/mm/madvise.c
@@ -142,7 +142,7 @@ static int madvise_update_vma(struct vm_
 	struct mm_struct *mm = vma->vm_mm;
 	int error;
 	pgoff_t pgoff;
-	VMA_ITERATOR(vmi, mm, 0);
+	VMA_ITERATOR(vmi, mm, start);
 
 	if (new_flags == vma->vm_flags && anon_vma_name_eq(anon_vma_name(vma), anon_name)) {
 		*prev = vma;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch
maple_tree-fix-mas_prev-and-mas_find-state-handling.patch
ipc-shm-introduce-new-do_vma_munmap-to-munmap.patch
nommu-pass-through-vma-iterator-to-shrink_vma.patch
mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store.patch
madvise-use-split_vma-instead-of-__split_vma.patch
mm-change-munmap-splitting-order-and-move_vma-fix.patch
mm-mremap-convert-vma_adjust-to-vma_expand.patch
mm-mmap-remove-__vma_adjust-fix.patch

