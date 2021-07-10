Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B59C07E9B
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 21:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DDBE6135C
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 21:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhGJVsK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 10 Jul 2021 17:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhGJVsJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 10 Jul 2021 17:48:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4EDE6135E;
        Sat, 10 Jul 2021 21:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625953523;
        bh=yVjIkjiwsUeyuLj9pdiwF0hEO+hXqQX+PsYURj2+2Nc=;
        h=Date:From:To:Subject:From;
        b=e1CijzwZ9VrDja81UGREqgbeuVopsqXQH71NtEaSf3ZsXp52z+9TgZaQzmwzZPZw3
         U/5kRnhQ3lXZFKYO6ws1WaOs9u2OLKolKurFMjY91YncqasU32Ax8O44JLDwug9MTR
         RZmwtwFHshodSpEYYsrXAPciYLauFoCwON/lvbak=
Date:   Sat, 10 Jul 2021 14:45:23 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        slava@dubeyko.com, skhan@linuxfoundation.org,
        gustavoars@kernel.org, gregkh@linuxfoundation.org,
        desmondcheongzx@gmail.com
Subject:  + hfs-add-lock-nesting-notation-to-hfs_find_init.patch
 added to -mm tree
Message-ID: <20210710214523.Jcw4k%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: add lock nesting notation to hfs_find_init
has been added to the -mm tree.  Its filename is
     hfs-add-lock-nesting-notation-to-hfs_find_init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hfs-add-lock-nesting-notation-to-hfs_find_init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hfs-add-lock-nesting-notation-to-hfs_find_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Subject: hfs: add lock nesting notation to hfs_find_init

Syzbot reports a possible recursive lock:
https://syzkaller.appspot.com/bug?id=f007ef1d7a31a469e3be7aeb0fde0769b18585db

This happens due to missing lock nesting information.  From the logs, we
see that a call to hfs_fill_super is made to mount the hfs filesystem. 
While searching for the root inode, the lock on the catalog btree is
grabbed.  Then, when the parent of the root isn't found, a call to
__hfs_bnode_create is made to create the parent of the root.  This
eventually leads to a call to hfs_ext_read_extent which grabs a lock on
the extents btree.

Since the order of locking is catalog btree -> extents btree, this lock
hierarchy does not lead to a deadlock.

To tell lockdep that this locking is safe, we add nesting notation to
distinguish between catalog btrees, extents btrees, and attributes btrees
(for HFS+).  This has already been done in hfsplus.

Link: https://lkml.kernel.org/r/20210701030756.58760-4-desmondcheongzx@gmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Reported-by: syzbot+b718ec84a87b7e73ade4@syzkaller.appspotmail.com
Tested-by: syzbot+b718ec84a87b7e73ade4@syzkaller.appspotmail.com
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/bfind.c |   14 +++++++++++++-
 fs/hfs/btree.h |    7 +++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

--- a/fs/hfs/bfind.c~hfs-add-lock-nesting-notation-to-hfs_find_init
+++ a/fs/hfs/bfind.c
@@ -25,7 +25,19 @@ int hfs_find_init(struct hfs_btree *tree
 	fd->key = ptr + tree->max_key_len + 2;
 	hfs_dbg(BNODE_REFS, "find_init: %d (%p)\n",
 		tree->cnid, __builtin_return_address(0));
-	mutex_lock(&tree->tree_lock);
+	switch (tree->cnid) {
+	case HFS_CAT_CNID:
+		mutex_lock_nested(&tree->tree_lock, CATALOG_BTREE_MUTEX);
+		break;
+	case HFS_EXT_CNID:
+		mutex_lock_nested(&tree->tree_lock, EXTENTS_BTREE_MUTEX);
+		break;
+	case HFS_ATTR_CNID:
+		mutex_lock_nested(&tree->tree_lock, ATTR_BTREE_MUTEX);
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
--- a/fs/hfs/btree.h~hfs-add-lock-nesting-notation-to-hfs_find_init
+++ a/fs/hfs/btree.h
@@ -13,6 +13,13 @@ typedef int (*btree_keycmp)(const btree_
 
 #define NODE_HASH_SIZE  256
 
+/* B-tree mutex nested subclasses */
+enum hfs_btree_mutex_classes {
+	CATALOG_BTREE_MUTEX,
+	EXTENTS_BTREE_MUTEX,
+	ATTR_BTREE_MUTEX,
+};
+
 /* A HFS BTree held in memory */
 struct hfs_btree {
 	struct super_block *sb;
_

Patches currently in -mm which might be from desmondcheongzx@gmail.com are

hfs-add-missing-clean-up-in-hfs_fill_super.patch
hfs-fix-high-memory-mapping-in-hfs_bnode_read.patch
hfs-add-lock-nesting-notation-to-hfs_find_init.patch

