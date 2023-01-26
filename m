Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BB5C54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 22:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjAZWxy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 17:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjAZWxx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 17:53:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447CDC4
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 14:53:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCE2AB81F39
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 22:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83848C433D2;
        Thu, 26 Jan 2023 22:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674773629;
        bh=UdD+S3JeKX+bXWZaseZOGy94/+9p6FS6SSfZrlZk5+8=;
        h=Date:To:From:Subject:From;
        b=yuCS9BjP95ACFZzxItS833f4njWDRO+hgpbaGnD2SguEVpPf0QGg0atLRvZIK5RWp
         EsomXxUQONwrocSyOi0RnlMav1waE3CrTPrS35Jie4TcwYonW00RXe1sw4+fisnP/p
         lS6/8w2nCQk25ZzcciAukbWTcxv6CQ8VleqxhL88=
Date:   Thu, 26 Jan 2023 14:53:49 -0800
To:     mm-commits@vger.kernel.org, sanan.hasanov@Knights.ucf.edu,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-munmap-splitting-order-and-move_vma-fix.patch added to mm-unstable branch
Message-Id: <20230126225349.83848C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: fix vma iterator initialization
has been added to the -mm mm-unstable branch.  Its filename is
     mm-change-munmap-splitting-order-and-move_vma-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-munmap-splitting-order-and-move_vma-fix.patch

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

 mm/mremap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
nommu-pass-through-vma-iterator-to-shrink_vma.patch
mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store.patch
madvise-use-split_vma-instead-of-__split_vma-fix.patch
mm-change-munmap-splitting-order-and-move_vma-fix.patch
mm-mremap-convert-vma_adjust-to-vma_expand.patch
ipc-shm-introduce-new-do_vma_munmap-to-munmap.patch

