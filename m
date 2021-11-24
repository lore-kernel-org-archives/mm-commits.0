Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45DC6C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 22:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243316AbhKXWUs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245131AbhKXWUd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 17:20:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 651A960F55;
        Wed, 24 Nov 2021 22:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637792243;
        bh=G6PPHkoU/ow+YKnd4R6u33AHW//R47rLzc2cw2ektoQ=;
        h=Date:From:To:Subject:From;
        b=ms76pBKJyJuG09FbmMT/UekoM2FZr9gUAzmcCZjvigYjB9sSQFXpsoJpyQU2v4KBd
         RJswBZ/UjYmxU2GI5p0Sv4xlpq9E6Cm5p/8XP4unk7++ElpNqcQl+3hrqemd1OMvpX
         c1r5Yxw4/yOlfG0EySokcF8zUrIc9+8UFKAw8zvY=
Date:   Wed, 24 Nov 2021 14:17:22 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, gladkov.alexey@gmail.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  [to-be-updated]
 fs-proc-store-pde-data-into-inode-i_private.patch removed from -mm tree
Message-ID: <20211124221722.8FhJkj4p1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: proc: store PDE()->data into inode->i_private
has been removed from the -mm tree.  Its filename was
     fs-proc-store-pde-data-into-inode-i_private.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: fs: proc: store PDE()->data into inode->i_private

Patch series "remove PDE_DATA()".

I found a bug [1] some days ago, which is because we want to use
inode->i_private to pass user private data.  However, this is wrong on
proc fs.  We provide a specific function PDE_DATA() to get user private
data.  Actually, we can hide this detail by storing PDE()->data into
inode->i_private and removing PDE_DATA() completely.  The user could use
inode->i_private to get user private data just like debugfs does.  This
series is trying to remove PDE_DATA().

[1] https://lore.kernel.org/lkml/20211029032638.84884-1-songmuchun@bytedance.com/


This patch (of 4):

PDE_DATA(inode) is introduced to get user private data and hide the layout
of struct proc_dir_entry.  The inode->i_private is used to do the same
thing as well.  Save a copy of user private data to inode-> i_private when
proc inode is allocated.  This means the user also can get their private
data by inode->i_private.

Link: https://lkml.kernel.org/r/20211101093518.86845-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20211101093518.86845-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/inode.c~fs-proc-store-pde-data-into-inode-i_private
+++ a/fs/proc/inode.c
@@ -650,6 +650,7 @@ struct inode *proc_get_inode(struct supe
 		return NULL;
 	}
 
+	inode->i_private = de->data;
 	inode->i_ino = de->low_ino;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
 	PROC_I(inode)->pde = de;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-slab-make-slab-iterator-functions-static.patch
mm-memcontrol-make-cgroup_memory_nokmem-static.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch
fs-proc-replace-pde_datainode-with-inode-i_private.patch
fs-proc-remove-pde_data.patch
fs-proc-use-define_proc_show_attribute-to-simplify-the-code.patch

