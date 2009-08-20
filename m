From: akpm@linux-foundation.org
Subject: + tmpfs-convert-to-use-the-new-truncate-convention.patch added to -mm tree
Date: Thu, 20 Aug 2009 15:48:26 -0700
Message-ID: <200908202248.n7KMmQDH029602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932079AbZHTWtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 18:49:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, hch@lst.de, hirofumi@mail.parknet.co.jp, hugh.dickins@tiscali.co.uk, jack@suse.cz, miklos@szeredi.hu, sfrench@us.ibm.com, shaggy@linux.vnet.ibm.com, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     tmpfs: convert to use the new truncate convention
has been added to the -mm tree.  Its filename is
     tmpfs-convert-to-use-the-new-truncate-convention.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: convert to use the new truncate convention
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff -puN mm/shmem.c~tmpfs-convert-to-use-the-new-truncate-convention mm/shmem.c
--- a/mm/shmem.c~tmpfs-convert-to-use-the-new-truncate-convention
+++ a/mm/shmem.c
@@ -730,10 +730,11 @@ done2:
 	if (inode->i_mapping->nrpages && (info->flags & SHMEM_PAGEIN)) {
 		/*
 		 * Call truncate_inode_pages again: racing shmem_unuse_inode
-		 * may have swizzled a page in from swap since vmtruncate or
-		 * generic_delete_inode did it, before we lowered next_index.
-		 * Also, though shmem_getpage checks i_size before adding to
-		 * cache, no recheck after: so fix the narrow window there too.
+		 * may have swizzled a page in from swap since
+		 * truncate_pagecache or generic_delete_inode did it, before we
+		 * lowered next_index.  Also, though shmem_getpage checks
+		 * i_size before adding to cache, no recheck after: so fix the
+		 * narrow window there too.
 		 *
 		 * Recalling truncate_inode_pages_range and unmap_mapping_range
 		 * every time for punch_hole (which never got a chance to clear
@@ -763,19 +764,16 @@ done2:
 	}
 }
 
-static void shmem_truncate(struct inode *inode)
-{
-	shmem_truncate_range(inode, inode->i_size, (loff_t)-1);
-}
-
 static int shmem_notify_change(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
-	struct page *page = NULL;
 	int error;
 
 	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
-		if (attr->ia_size < inode->i_size) {
+		loff_t newsize = attr->ia_size;
+		struct page *page = NULL;
+
+		if (newsize < inode->i_size) {
 			/*
 			 * If truncating down to a partial page, then
 			 * if that page is already allocated, hold it
@@ -783,9 +781,9 @@ static int shmem_notify_change(struct de
 			 * truncate_partial_page cannnot miss it were
 			 * it assigned to swap.
 			 */
-			if (attr->ia_size & (PAGE_CACHE_SIZE-1)) {
+			if (newsize & (PAGE_CACHE_SIZE-1)) {
 				(void) shmem_getpage(inode,
-					attr->ia_size>>PAGE_CACHE_SHIFT,
+					newsize >> PAGE_CACHE_SHIFT,
 						&page, SGP_READ, NULL);
 				if (page)
 					unlock_page(page);
@@ -797,24 +795,29 @@ static int shmem_notify_change(struct de
 			 * if it's being fully truncated to zero-length: the
 			 * nrpages check is efficient enough in that case.
 			 */
-			if (attr->ia_size) {
+			if (newsize) {
 				struct shmem_inode_info *info = SHMEM_I(inode);
 				spin_lock(&info->lock);
 				info->flags &= ~SHMEM_PAGEIN;
 				spin_unlock(&info->lock);
 			}
 		}
+
+		error = simple_setsize(inode, newsize);
+		if (page)
+			page_cache_release(page);
+		if (error)
+			return error;
+		shmem_truncate_range(inode, newsize, (loff_t)-1);
 	}
 
 	error = inode_change_ok(inode, attr);
 	if (!error)
-		error = inode_setattr(inode, attr);
+		generic_setattr(inode, attr);
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	if (!error && (attr->ia_valid & ATTR_MODE))
 		error = generic_acl_chmod(inode, &shmem_acl_ops);
 #endif
-	if (page)
-		page_cache_release(page);
 	return error;
 }
 
@@ -822,11 +825,11 @@ static void shmem_delete_inode(struct in
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 
-	if (inode->i_op->truncate == shmem_truncate) {
+	if (inode->i_mapping->a_ops == &shmem_aops) {
 		truncate_inode_pages(inode->i_mapping, 0);
 		shmem_unacct_size(info->flags, inode->i_size);
 		inode->i_size = 0;
-		shmem_truncate(inode);
+		shmem_truncate_range(inode, 0, (loff_t)-1);
 		if (!list_empty(&info->swaplist)) {
 			mutex_lock(&shmem_swaplist_mutex);
 			list_del_init(&info->swaplist);
@@ -2018,7 +2021,6 @@ static const struct inode_operations shm
 };
 
 static const struct inode_operations shmem_symlink_inode_operations = {
-	.truncate	= shmem_truncate,
 	.readlink	= generic_readlink,
 	.follow_link	= shmem_follow_link,
 	.put_link	= shmem_put_link,
@@ -2438,7 +2440,7 @@ static const struct file_operations shme
 };
 
 static const struct inode_operations shmem_inode_operations = {
-	.truncate	= shmem_truncate,
+	.new_truncate	= 1,
 	.setattr	= shmem_notify_change,
 	.truncate_range	= shmem_truncate_range,
 #ifdef CONFIG_TMPFS_POSIX_ACL
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
ksm-no-debug-in-page_dup_rmap.patch
fs-turn-iprune_mutex-into-rwsem.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

