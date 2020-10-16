Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FA2C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5438220639
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881542;
	bh=VF153pYGyqhBuJBXzKiHnKhJsyuifvUuZO6omSNXQA0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wvhkOUZ/ZuQx1vUhhC8/7XIPEQeyvdgmKj0m8cbx22yCZ2gMyrUMsBwEXJFRnvcLr
	 Ub93Z9oGZjX03WhwrSixIbq0c0k+Q3JjKeRlpY1CHebBjK1kxS6PMXPz9kldORb5eB
	 pYK47+IdyHWS4QfsBvi3YoTKra1xTEiL/I+1HdYA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408670AbgJPUwV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408456AbgJPUwV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:21 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3D3320878;
        Fri, 16 Oct 2020 20:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881539;
        bh=VF153pYGyqhBuJBXzKiHnKhJsyuifvUuZO6omSNXQA0=;
        h=Date:From:To:Subject:From;
        b=HUqN9o9G1Q6mNobG6glKW8CvxWLUL3E4ALJyivKFD+2gZhJQEAAcZ8cNLQCdT1JUi
         CH+kHC/uPP2lZp50Q7TRZiknjSgHReswhMMG2c20T5bp3IZf8spmoVvabxPSSE7vI2
         PEINaGkJOzBufhB64MsPu2hlnCLSY0vfaUMhNGIk=
Date:   Fri, 16 Oct 2020 13:52:19 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged] mm-use-helper-function-put_write_access.patch
 removed from -mm tree
Message-ID: <20201016205219.2tyg0W9PO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use helper function put_write_access()
has been removed from the -mm tree.  Its filename was
     mm-use-helper-function-put_write_access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: use helper function put_write_access()

In commit 1da177e4c3f4 ("Linux-2.6.12-rc2"), the helper put_write_access()
came with the atomic_dec operation of the i_writecount field.  But it
forgot to use this helper in __vma_link_file() and dup_mmap().

Link: https://lkml.kernel.org/r/20200924115235.5111-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 mm/mmap.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/fork.c~mm-use-helper-function-put_write_access
+++ a/kernel/fork.c
@@ -556,7 +556,7 @@ static __latent_entropy int dup_mmap(str
 
 			get_file(file);
 			if (tmp->vm_flags & VM_DENYWRITE)
-				atomic_dec(&inode->i_writecount);
+				put_write_access(inode);
 			i_mmap_lock_write(mapping);
 			if (tmp->vm_flags & VM_SHARED)
 				mapping_allow_writable(mapping);
--- a/mm/mmap.c~mm-use-helper-function-put_write_access
+++ a/mm/mmap.c
@@ -619,7 +619,7 @@ static void __vma_link_file(struct vm_ar
 		struct address_space *mapping = file->f_mapping;
 
 		if (vma->vm_flags & VM_DENYWRITE)
-			atomic_dec(&file_inode(file)->i_writecount);
+			put_write_access(file_inode(file));
 		if (vma->vm_flags & VM_SHARED)
 			mapping_allow_writable(mapping);
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

