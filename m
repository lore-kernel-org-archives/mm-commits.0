Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6866C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 05:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87A2C61BF9
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 05:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhKPFMs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Nov 2021 00:12:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239452AbhKPFMj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Nov 2021 00:12:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0099561BF9;
        Tue, 16 Nov 2021 05:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637039383;
        bh=npCVSot++39S2p35F7Lg3NsnQPIsqNSPl0/g/x9iPfE=;
        h=Date:From:To:Subject:From;
        b=WHATwQrSHUYRH9GlMXrA8R3RZfpZ6dnrUBs1lqEpmdmAZFF7j8zG7pfmMJSZvTXGy
         ea74vmyzgXsubHXN8+UT65fr1W2++kQpVPvXCQuRmz3qqrWPx3GemJGB7l3hEtmB+P
         Ny4nm6ubUI1RbglJXmq42sTJwrIH8sbNY2YBhw3k=
Date:   Mon, 15 Nov 2021 21:09:42 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, gladkov.alexey@gmail.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  + fs-proc-store-pde-data-into-inode-i_private.patch added
 to -mm tree
Message-ID: <20211116050942.Qf7R2_Il_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: proc: store PDE()->data into inode->i_private
has been added to the -mm tree.  Its filename is
     fs-proc-store-pde-data-into-inode-i_private.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-proc-store-pde-data-into-inode-i_private.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-store-pde-data-into-inode-i_private.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
fs-proc-store-pde-data-into-inode-i_private.patch
fs-proc-replace-pde_datainode-with-inode-i_private.patch
fs-proc-remove-pde_data.patch
fs-proc-use-define_proc_show_attribute-to-simplify-the-code.patch

