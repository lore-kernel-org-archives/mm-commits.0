Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CB3C1B08C
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3DE7613B2
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhGOEaC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 00:30:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236430AbhGOEaB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 00:30:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70E8C61380;
        Thu, 15 Jul 2021 04:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626323228;
        bh=H2vlNlo8faCnYTwf4DwHdOxymTkwkkSjiStHkHZLw/o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OienGAGnhvQSsUoH9AsH0VabDDzH1GsXLPHkGRaycrbeuxczgKb4VYcUBxWT45V7N
         jAQ6xJwkzI+luG3p16VTXBisE2ADQtHexdBnJ+6KTFuWDCD02ffYYBqNLhyqf1vg80
         Fw8mx19DGKCZuwLZ3Y58xsKc8KJJtCg6VeUg8eXM=
Date:   Wed, 14 Jul 2021 21:27:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, desmondcheongzx@gmail.com,
        gregkh@linuxfoundation.org, gustavoars@kernel.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        skhan@linuxfoundation.org, slava@dubeyko.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 12/13] hfs: add lock nesting notation to
 hfs_find_init
Message-ID: <20210715042708.eP0VysJim%akpm@linux-foundation.org>
In-Reply-To: <20210714212609.fad116e584ba1194981a6294@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
