Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD0CC61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjBJApg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjBJApf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:45:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E38037540
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:45:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BB73B82395
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABE0C433D2;
        Fri, 10 Feb 2023 00:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675989930;
        bh=mos1fLnTrXP0mZbfppvnLDFlJojtbl1uevpM8VpY8w4=;
        h=Date:To:From:Subject:From;
        b=XIVUmiOy8oe/1/rfBhfqcmzgwlqjHVxlreRWGW1N1KnAvsqMf52Ns15Np+oUhRNbU
         0+/EkDkslsquFlyEmR2wNypvjLaTnzUTvGZocw2AGOO2eDyQNG+cWkCLVU+qp5hAei
         cZ5bPngeWkSBCTc8PIUna/5lHHyQQ6dl2VKtd8bU=
Date:   Thu, 09 Feb 2023 16:45:29 -0800
To:     mm-commits@vger.kernel.org, sanan.hasanov@Knights.ucf.edu,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-change-munmap-splitting-order-and-move_vma-fix.patch removed from -mm tree
Message-Id: <20230210004530.6ABE0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mremap: fix vma iterator initialization
has been removed from the -mm tree.  Its filename was
     mm-change-munmap-splitting-order-and-move_vma-fix.patch

This patch was dropped because it was folded into mm-change-munmap-splitting-order-and-move_vma.patch

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mremap: fix vma iterator initialization
Date: Thu, 26 Jan 2023 16:20:11 -0500

The vma iterator location is incorrect when there is a failure in the
move_vma() function which alters the address being modified.

Delay the initialization of the vma iterator until the address is stable.

Link: https://lkml.kernel.org/r/20230126212011.980350-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
  Link: https://lore.kernel.org/linux-mm/IA1PR07MB98306BC0F55667A760EABE91ABCE9@IA1PR07MB9830.namprd07.prod.outlook.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mremap.c~mm-change-munmap-splitting-order-and-move_vma-fix
+++ a/mm/mremap.c
@@ -585,7 +585,7 @@ static unsigned long move_vma(struct vm_
 	unsigned long hiwater_vm;
 	int err = 0;
 	bool need_rmap_locks;
-	VMA_ITERATOR(vmi, mm, old_addr);
+	struct vma_iterator vmi;
 
 	/*
 	 * We'd prefer to avoid failure later on in do_munmap:
@@ -701,6 +701,7 @@ static unsigned long move_vma(struct vm_
 		return new_addr;
 	}
 
+	vma_iter_init(&vmi, mm, old_addr);
 	if (do_vmi_munmap(&vmi, mm, old_addr, old_len, uf_unmap, false) < 0) {
 		/* OOM: unable to split vma, just get accounts right */
 		if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP))
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch
maple_tree-fix-mas_prev-and-mas_find-state-handling.patch
ipc-shm-introduce-new-do_vma_munmap-to-munmap.patch
nommu-pass-through-vma-iterator-to-shrink_vma.patch
mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store.patch
mm-change-munmap-splitting-order-and-move_vma.patch
mm-mremap-convert-vma_adjust-to-vma_expand.patch
mm-mmap-remove-__vma_adjust-fix.patch

