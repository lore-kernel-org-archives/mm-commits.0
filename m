Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590C5C11F67
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40EB861D0B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhF2Cik (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231802AbhF2Cih (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:38:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78E3B61D09;
        Tue, 29 Jun 2021 02:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934169;
        bh=JNst1ybGabkkan8IiBqS4JpFNHRRhC1bp+YdQ8d9X+g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IrovJbZ6OGBZQyYPEWOm4rd9a87TA6TMN0zn+bx7mEsP6LL6wjojqmWuB8nT3UUOd
         TbMMawoO7cJvLcTjUrujBBTctdUZqEDkG2Pz2q2Fr0mO5R1goyLuGKHotLBoloiIJB
         KB64Ac05fILoMU+A96gitkvpt5ilaz7S99X7ntVc=
Date:   Mon, 28 Jun 2021 19:36:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gregkh@linuxfoundation.org, hch@lst.de,
        jack@suse.cz, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [patch 055/192] fs: move ramfs_aops to libfs
Message-ID: <20210629023609.gRHCAkndK%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: fs: move ramfs_aops to libfs

Move the ramfs aops to libfs and reuse them for kernfs and configfs. 
Thosw two did not wire up ->set_page_dirty before and now get
__set_page_dirty_no_writeback, which is the right one for no-writeback
address_space usage.

Drop the now unused exports of the libfs helpers only used for ramfs-style
pagecache usage.

Link: https://lkml.kernel.org/r/20210614061512.3966143-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/inode.c |    8 +-------
 fs/kernfs/inode.c   |    8 +-------
 fs/libfs.c          |   17 +++++++++++++----
 fs/ramfs/inode.c    |    9 +--------
 include/linux/fs.h  |    5 +----
 5 files changed, 17 insertions(+), 30 deletions(-)

--- a/fs/configfs/inode.c~fs-move-ramfs_aops-to-libfs
+++ a/fs/configfs/inode.c
@@ -28,12 +28,6 @@
 static struct lock_class_key default_group_class[MAX_LOCK_DEPTH];
 #endif
 
-static const struct address_space_operations configfs_aops = {
-	.readpage	= simple_readpage,
-	.write_begin	= simple_write_begin,
-	.write_end	= simple_write_end,
-};
-
 static const struct inode_operations configfs_inode_operations ={
 	.setattr	= configfs_setattr,
 };
@@ -114,7 +108,7 @@ struct inode *configfs_new_inode(umode_t
 	struct inode * inode = new_inode(s);
 	if (inode) {
 		inode->i_ino = get_next_ino();
-		inode->i_mapping->a_ops = &configfs_aops;
+		inode->i_mapping->a_ops = &ram_aops;
 		inode->i_op = &configfs_inode_operations;
 
 		if (sd->s_iattr) {
--- a/fs/kernfs/inode.c~fs-move-ramfs_aops-to-libfs
+++ a/fs/kernfs/inode.c
@@ -17,12 +17,6 @@
 
 #include "kernfs-internal.h"
 
-static const struct address_space_operations kernfs_aops = {
-	.readpage	= simple_readpage,
-	.write_begin	= simple_write_begin,
-	.write_end	= simple_write_end,
-};
-
 static const struct inode_operations kernfs_iops = {
 	.permission	= kernfs_iop_permission,
 	.setattr	= kernfs_iop_setattr,
@@ -203,7 +197,7 @@ static void kernfs_init_inode(struct ker
 {
 	kernfs_get(kn);
 	inode->i_private = kn;
-	inode->i_mapping->a_ops = &kernfs_aops;
+	inode->i_mapping->a_ops = &ram_aops;
 	inode->i_op = &kernfs_iops;
 	inode->i_generation = kernfs_gen(kn);
 
--- a/fs/libfs.c~fs-move-ramfs_aops-to-libfs
+++ a/fs/libfs.c
@@ -512,7 +512,7 @@ int simple_setattr(struct user_namespace
 }
 EXPORT_SYMBOL(simple_setattr);
 
-int simple_readpage(struct file *file, struct page *page)
+static int simple_readpage(struct file *file, struct page *page)
 {
 	clear_highpage(page);
 	flush_dcache_page(page);
@@ -520,7 +520,6 @@ int simple_readpage(struct file *file, s
 	unlock_page(page);
 	return 0;
 }
-EXPORT_SYMBOL(simple_readpage);
 
 int simple_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
@@ -568,7 +567,7 @@ EXPORT_SYMBOL(simple_write_begin);
  *
  * Use *ONLY* with simple_readpage()
  */
-int simple_write_end(struct file *file, struct address_space *mapping,
+static int simple_write_end(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata)
 {
@@ -597,7 +596,17 @@ int simple_write_end(struct file *file,
 
 	return copied;
 }
-EXPORT_SYMBOL(simple_write_end);
+
+/*
+ * Provides ramfs-style behavior: data in the pagecache, but no writeback.
+ */
+const struct address_space_operations ram_aops = {
+	.readpage	= simple_readpage,
+	.write_begin	= simple_write_begin,
+	.write_end	= simple_write_end,
+	.set_page_dirty	= __set_page_dirty_no_writeback,
+};
+EXPORT_SYMBOL(ram_aops);
 
 /*
  * the inodes created here are not hashed. If you use iunique to generate
--- a/fs/ramfs/inode.c~fs-move-ramfs_aops-to-libfs
+++ a/fs/ramfs/inode.c
@@ -53,13 +53,6 @@ struct ramfs_fs_info {
 static const struct super_operations ramfs_ops;
 static const struct inode_operations ramfs_dir_inode_operations;
 
-static const struct address_space_operations ramfs_aops = {
-	.readpage	= simple_readpage,
-	.write_begin	= simple_write_begin,
-	.write_end	= simple_write_end,
-	.set_page_dirty	= __set_page_dirty_no_writeback,
-};
-
 struct inode *ramfs_get_inode(struct super_block *sb,
 				const struct inode *dir, umode_t mode, dev_t dev)
 {
@@ -68,7 +61,7 @@ struct inode *ramfs_get_inode(struct sup
 	if (inode) {
 		inode->i_ino = get_next_ino();
 		inode_init_owner(&init_user_ns, inode, dir, mode);
-		inode->i_mapping->a_ops = &ramfs_aops;
+		inode->i_mapping->a_ops = &ram_aops;
 		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
 		mapping_set_unevictable(inode->i_mapping);
 		inode->i_atime = inode->i_mtime = inode->i_ctime = current_time(inode);
--- a/include/linux/fs.h~fs-move-ramfs_aops-to-libfs
+++ a/include/linux/fs.h
@@ -3422,13 +3422,10 @@ extern void noop_invalidatepage(struct p
 		unsigned int length);
 extern ssize_t noop_direct_IO(struct kiocb *iocb, struct iov_iter *iter);
 extern int simple_empty(struct dentry *);
-extern int simple_readpage(struct file *file, struct page *page);
 extern int simple_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata);
-extern int simple_write_end(struct file *file, struct address_space *mapping,
-			loff_t pos, unsigned len, unsigned copied,
-			struct page *page, void *fsdata);
+extern const struct address_space_operations ram_aops;
 extern int always_delete_dentry(const struct dentry *);
 extern struct inode *alloc_anon_inode(struct super_block *);
 extern int simple_nosetlease(struct file *, long, struct file_lock **, void **);
_
