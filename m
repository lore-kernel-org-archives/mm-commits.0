From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error.patch
 removed from -mm tree
Date: Fri, 27 May 2016 11:43:02 -0700
Message-ID: <57489536.iICEfg6EL9SERjXs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbcE0SnD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:43:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: do not emit extra newline on nilfs_warning() and nilfs_error()
has been removed from the -mm tree.  Its filename was
     nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: do not emit extra newline on nilfs_warning() and nilfs_error()

This updates call sites of nilfs_warning() and nilfs_error() so that they
don't add a duplicate newline.  These output functions are already
designed to add a trailing newline to the message.

Link: http://lkml.kernel.org/r/1462886671-3521-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c   |   10 +++++-----
 fs/nilfs2/bmap.c    |    2 +-
 fs/nilfs2/dir.c     |    4 ++--
 fs/nilfs2/inode.c   |    6 +++---
 fs/nilfs2/namei.c   |    2 +-
 fs/nilfs2/segment.c |    8 ++++----
 6 files changed, 16 insertions(+), 16 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error
+++ a/fs/nilfs2/alloc.c
@@ -619,7 +619,7 @@ void nilfs_palloc_commit_free_entry(stru
 
 	if (!nilfs_clear_bit_atomic(lock, group_offset, bitmap))
 		nilfs_warning(inode->i_sb, __func__,
-			      "entry number %llu already freed: ino=%lu\n",
+			      "entry number %llu already freed: ino=%lu",
 			      (unsigned long long)req->pr_entry_nr,
 			      (unsigned long)inode->i_ino);
 	else
@@ -660,7 +660,7 @@ void nilfs_palloc_abort_alloc_entry(stru
 
 	if (!nilfs_clear_bit_atomic(lock, group_offset, bitmap))
 		nilfs_warning(inode->i_sb, __func__,
-			      "entry number %llu already freed: ino=%lu\n",
+			      "entry number %llu already freed: ino=%lu",
 			      (unsigned long long)req->pr_entry_nr,
 			      (unsigned long)inode->i_ino);
 	else
@@ -769,7 +769,7 @@ int nilfs_palloc_freev(struct inode *ino
 			if (!nilfs_clear_bit_atomic(lock, group_offset,
 						    bitmap)) {
 				nilfs_warning(inode->i_sb, __func__,
-					      "entry number %llu already freed: ino=%lu\n",
+					      "entry number %llu already freed: ino=%lu",
 					      (unsigned long long)entry_nrs[j],
 					      (unsigned long)inode->i_ino);
 			} else {
@@ -814,7 +814,7 @@ int nilfs_palloc_freev(struct inode *ino
 							      last_nrs[k]);
 			if (ret && ret != -ENOENT) {
 				nilfs_warning(inode->i_sb, __func__,
-					      "failed to delete block of entry %llu: ino=%lu, err=%d\n",
+					      "failed to delete block of entry %llu: ino=%lu, err=%d",
 					      (unsigned long long)last_nrs[k],
 					      (unsigned long)inode->i_ino, ret);
 			}
@@ -833,7 +833,7 @@ int nilfs_palloc_freev(struct inode *ino
 			ret = nilfs_palloc_delete_bitmap_block(inode, group);
 			if (ret && ret != -ENOENT) {
 				nilfs_warning(inode->i_sb, __func__,
-					      "failed to delete bitmap block of group %lu: ino=%lu, err=%d\n",
+					      "failed to delete bitmap block of group %lu: ino=%lu, err=%d",
 					      group,
 					      (unsigned long)inode->i_ino, ret);
 			}
diff -puN fs/nilfs2/bmap.c~nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error fs/nilfs2/bmap.c
--- a/fs/nilfs2/bmap.c~nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error
+++ a/fs/nilfs2/bmap.c
@@ -42,7 +42,7 @@ static int nilfs_bmap_convert_error(stru
 
 	if (err == -EINVAL) {
 		nilfs_error(inode->i_sb, fname,
-			    "broken bmap (inode number=%lu)\n", inode->i_ino);
+			    "broken bmap (inode number=%lu)", inode->i_ino);
 		err = -EIO;
 	}
 	return err;
diff -puN fs/nilfs2/dir.c~nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error fs/nilfs2/dir.c
--- a/fs/nilfs2/dir.c~nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error
+++ a/fs/nilfs2/dir.c
@@ -628,8 +628,8 @@ int nilfs_empty_dir(struct inode *inode)
 		while ((char *)de <= kaddr) {
 			if (de->rec_len == 0) {
 				nilfs_error(inode->i_sb, __func__,
-					    "zero-length directory entry "
-					    "(kaddr=%p, de=%p)\n", kaddr, de);
+					    "zero-length directory entry (kaddr=%p, de=%p)",
+					    kaddr, de);
 				goto not_empty;
 			}
 			if (de->inode != 0) {
diff -puN fs/nilfs2/inode.c~nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error
+++ a/fs/nilfs2/inode.c
@@ -921,7 +921,7 @@ int nilfs_set_file_dirty(struct inode *i
 			/* This will happen when somebody is freeing
 			   this inode. */
 			nilfs_warning(inode->i_sb, __func__,
-				      "cannot get inode (ino=%lu)\n",
+				      "cannot get inode (ino=%lu)",
 				      inode->i_ino);
 			spin_unlock(&nilfs->ns_inode_lock);
 			return -EINVAL; /* NILFS_I_DIRTY may remain for
@@ -942,7 +942,7 @@ int __nilfs_mark_inode_dirty(struct inod
 	err = nilfs_load_inode_block(inode, &ibh);
 	if (unlikely(err)) {
 		nilfs_warning(inode->i_sb, __func__,
-			      "failed to reget inode block.\n");
+			      "failed to reget inode block.");
 		return err;
 	}
 	nilfs_update_inode(inode, ibh, flags);
@@ -969,7 +969,7 @@ void nilfs_dirty_inode(struct inode *ino
 
 	if (is_bad_inode(inode)) {
 		nilfs_warning(inode->i_sb, __func__,
-			      "tried to mark bad_inode dirty. ignored.\n");
+			      "tried to mark bad_inode dirty. ignored.");
 		dump_stack();
 		return;
 	}
diff -puN fs/nilfs2/namei.c~nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error fs/nilfs2/namei.c
--- a/fs/nilfs2/namei.c~nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error
+++ a/fs/nilfs2/namei.c
@@ -284,7 +284,7 @@ static int nilfs_do_unlink(struct inode
 
 	if (!inode->i_nlink) {
 		nilfs_warning(inode->i_sb, __func__,
-			      "deleting nonexistent file (%lu), %d\n",
+			      "deleting nonexistent file (%lu), %d",
 			      inode->i_ino, inode->i_nlink);
 		set_nlink(inode, 1);
 	}
diff -puN fs/nilfs2/segment.c~nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error
+++ a/fs/nilfs2/segment.c
@@ -1938,7 +1938,7 @@ static int nilfs_segctor_collect_dirty_f
 				ifile, ii->vfs_inode.i_ino, &ibh);
 			if (unlikely(err)) {
 				nilfs_warning(sci->sc_super, __func__,
-					      "failed to get inode block.\n");
+					      "failed to get inode block.");
 				return err;
 			}
 			mark_buffer_dirty(ibh);
@@ -2724,13 +2724,13 @@ static void nilfs_segctor_destroy(struct
 
 	if (!list_empty(&sci->sc_dirty_files)) {
 		nilfs_warning(sci->sc_super, __func__,
-			      "dirty file(s) after the final construction\n");
+			      "dirty file(s) after the final construction");
 		nilfs_dispose_list(nilfs, &sci->sc_dirty_files, 1);
 	}
 
 	if (!list_empty(&sci->sc_iput_queue)) {
 		nilfs_warning(sci->sc_super, __func__,
-			      "iput queue is not empty\n");
+			      "iput queue is not empty");
 		nilfs_dispose_list(nilfs, &sci->sc_iput_queue, 1);
 	}
 
@@ -2807,7 +2807,7 @@ void nilfs_detach_log_writer(struct supe
 	if (!list_empty(&nilfs->ns_dirty_files)) {
 		list_splice_init(&nilfs->ns_dirty_files, &garbage_list);
 		nilfs_warning(sb, __func__,
-			      "Hit dirty file after stopped log writer\n");
+			      "Hit dirty file after stopped log writer");
 	}
 	spin_unlock(&nilfs->ns_inode_lock);
 	up_write(&nilfs->ns_segctor_sem);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


