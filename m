Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2639C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 14:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348556AbiELOFn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 10:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355020AbiELOFl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 10:05:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D405E0AF
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 07:05:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C897461AEC
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 14:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC99C385B8;
        Thu, 12 May 2022 14:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652364338;
        bh=sHaHyzbchqL1EDG5YitcI9DgcXb8s93g0xv7xXXuzs8=;
        h=Date:To:From:Subject:From;
        b=JzwslMEr2T5h/skOMW4RuSOj0fo67iD8wcGvLoN8C9BV0Ow3DURez2iLuYV80flZ5
         phZYoLMv8QqJ+gkJSpXTw0WAxn+7I/fBdF1e1FfJKo3+qBlRvCmsx5T8uQUiFbVl6Y
         UKnAcd/Xmm1fp2EvdFY4hUjymKpx0jf1lWtsY3bY=
Date:   Thu, 12 May 2022 07:05:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, abaci@linux.alibaba.com,
        yang.lee@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] nilfs2-fix-some-kernel-doc-comments.patch removed from -mm tree
Message-Id: <20220512140538.1DC99C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: Fix some kernel-doc comments
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-some-kernel-doc-comments.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: nilfs2: Fix some kernel-doc comments

The description of @flags in nilfs_dirty_inode() kernel-doc comment is
missing, and some functions had kernel-doc that used a hash instead of a
colon to separate the parameter name from the one line description.

Fix them to remove some warnings found by running scripts/kernel-doc,
which is caused by using 'make W=1'.

fs/nilfs2/inode.c:73: warning: Function parameter or member 'inode' not
described in 'nilfs_get_block'
fs/nilfs2/inode.c:73: warning: Function parameter or member 'blkoff' not
described in 'nilfs_get_block'
fs/nilfs2/inode.c:73: warning: Function parameter or member 'bh_result'
not described in 'nilfs_get_block'
fs/nilfs2/inode.c:73: warning: Function parameter or member 'create' not
described in 'nilfs_get_block'
fs/nilfs2/inode.c:145: warning: Function parameter or member 'file' not
described in 'nilfs_readpage'
fs/nilfs2/inode.c:145: warning: Function parameter or member 'page' not
described in 'nilfs_readpage'
fs/nilfs2/inode.c:968: warning: Function parameter or member 'flags' not
described in 'nilfs_dirty_inode'

Link: https://lkml.kernel.org/r/20220324024215.63479-1-yang.lee@linux.alibaba.com
Link: https://lkml.kernel.org/r/1652276316-7791-1-git-send-email-konishi.ryusuke@gmail.com
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/inode.c~nilfs2-fix-some-kernel-doc-comments
+++ a/fs/nilfs2/inode.c
@@ -63,10 +63,10 @@ void nilfs_inode_sub_blocks(struct inode
 
 /**
  * nilfs_get_block() - get a file block on the filesystem (callback function)
- * @inode - inode struct of the target file
- * @blkoff - file block number
- * @bh_result - buffer head to be mapped on
- * @create - indicate whether allocating the block or not when it has not
+ * @inode: inode struct of the target file
+ * @blkoff: file block number
+ * @bh_result: buffer head to be mapped on
+ * @create: indicate whether allocating the block or not when it has not
  *      been allocated yet.
  *
  * This function does not issue actual read request of the specified data
@@ -142,8 +142,8 @@ int nilfs_get_block(struct inode *inode,
 /**
  * nilfs_readpage() - implement readpage() method of nilfs_aops {}
  * address_space_operations.
- * @file - file struct of the file to be read
- * @page - the page to be read
+ * @file: file struct of the file to be read
+ * @page: the page to be read
  */
 static int nilfs_readpage(struct file *file, struct page *page)
 {
@@ -1088,6 +1088,7 @@ int __nilfs_mark_inode_dirty(struct inod
 /**
  * nilfs_dirty_inode - reflect changes on given inode to an inode block.
  * @inode: inode of the file to be registered.
+ * @flags: flags to determine the dirty state of the inode
  *
  * nilfs_dirty_inode() loads a inode block containing the specified
  * @inode and copies data from a nilfs_inode to a corresponding inode
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are


