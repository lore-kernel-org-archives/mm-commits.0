From: akpm@linux-foundation.org
Subject: - vfs-add-__d_instantiate-helper.patch removed from -mm tree
Date: Fri, 24 Oct 2008 12:41:07 -0700
Message-ID: <200810241941.m9OJf7cr001150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753101AbYJXTlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Oct 2008 15:41:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: add __d_instantiate() helper
has been removed from the -mm tree.  Its filename was
     vfs-add-__d_instantiate-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: add __d_instantiate() helper
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

This adds __d_instantiate() for users which is already taking
dcache_lock, and replace with it.

The part of d_add_ci() isn't equivalent. But it should be needed
fsnotify_d_instantiate() actually, because the path is to add the
inode to negative dentry.  fsnotify_d_instantiate() should be called
after change from negative to positive.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff -puN fs/dcache.c~vfs-add-__d_instantiate-helper fs/dcache.c
--- a/fs/dcache.c~vfs-add-__d_instantiate-helper
+++ a/fs/dcache.c
@@ -981,6 +981,15 @@ struct dentry *d_alloc_name(struct dentr
 	return d_alloc(parent, &q);
 }
 
+/* the caller must hold dcache_lock */
+static void __d_instantiate(struct dentry *dentry, struct inode *inode)
+{
+	if (inode)
+		list_add(&dentry->d_alias, &inode->i_dentry);
+	dentry->d_inode = inode;
+	fsnotify_d_instantiate(dentry, inode);
+}
+
 /**
  * d_instantiate - fill in inode information for a dentry
  * @entry: dentry to complete
@@ -1000,10 +1009,7 @@ void d_instantiate(struct dentry *entry,
 {
 	BUG_ON(!list_empty(&entry->d_alias));
 	spin_lock(&dcache_lock);
-	if (inode)
-		list_add(&entry->d_alias, &inode->i_dentry);
-	entry->d_inode = inode;
-	fsnotify_d_instantiate(entry, inode);
+	__d_instantiate(entry, inode);
 	spin_unlock(&dcache_lock);
 	security_d_instantiate(entry, inode);
 }
@@ -1033,7 +1039,7 @@ static struct dentry *__d_instantiate_un
 	unsigned int hash = entry->d_name.hash;
 
 	if (!inode) {
-		entry->d_inode = NULL;
+		__d_instantiate(entry, NULL);
 		return NULL;
 	}
 
@@ -1052,9 +1058,7 @@ static struct dentry *__d_instantiate_un
 		return alias;
 	}
 
-	list_add(&entry->d_alias, &inode->i_dentry);
-	entry->d_inode = inode;
-	fsnotify_d_instantiate(entry, inode);
+	__d_instantiate(entry, inode);
 	return NULL;
 }
 
@@ -1213,10 +1217,8 @@ struct dentry *d_splice_alias(struct ino
 			d_move(new, dentry);
 			iput(inode);
 		} else {
-			/* d_instantiate takes dcache_lock, so we do it by hand */
-			list_add(&dentry->d_alias, &inode->i_dentry);
-			dentry->d_inode = inode;
-			fsnotify_d_instantiate(dentry, inode);
+			/* already taking dcache_lock, so d_add() by hand */
+			__d_instantiate(dentry, inode);
 			spin_unlock(&dcache_lock);
 			security_d_instantiate(dentry, inode);
 			d_rehash(dentry);
@@ -1299,8 +1301,7 @@ struct dentry *d_add_ci(struct dentry *d
 		 * d_instantiate() by hand because it takes dcache_lock which
 		 * we already hold.
 		 */
-		list_add(&found->d_alias, &inode->i_dentry);
-		found->d_inode = inode;
+		__d_instantiate(found, inode);
 		spin_unlock(&dcache_lock);
 		security_d_instantiate(found, inode);
 		return found;
@@ -1833,7 +1834,7 @@ struct dentry *d_materialise_unique(stru
 
 	if (!inode) {
 		actual = dentry;
-		dentry->d_inode = NULL;
+		__d_instantiate(dentry, NULL);
 		goto found_lock;
 	}
 
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch
fat-document-additional-vfat-mount-options.patch
fat-move-fs-vfat-and-fs-msdos-to-fs-fat.patch
fat-split-include-msdos_fsh.patch
fat-fix-and-cleanup-timestamp-conversion.patch
fat-use-generic_file_llseek-for-directory.patch
fat-cleanup-fat_parse_long-error-handling.patch
fat-improve-fat_hash.patch
fat-fix-fat_ent_update_ptr-for-fat12.patch
fat-use-fat_detach-in-fat_clear_inode.patch
vfat-fix-vfat_find-error-path-in-vfat_lookup.patch
fat-fix-cleanup-dcache-handling-for-vfat.patch
fat-kill-d_invalidate-in-vfat_lookup.patch
fat-cleanup-msdos_lookup.patch
fat-cleanup-fat-attribute-stuff.patch
fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0.patch
fat-fix-attr_ro-for-directory.patch
fat-fix-_fat_bmap-race.patch
fat-add-printf-attribute-to-fat_fs_panic.patch
fat-mmu_private-race-fix.patch
fat-i_pos-race-fix.patch
fat-i_blocks-warning-fix.patch

