From: akpm@linux-foundation.org
Subject: + nilfs2-replace-nilfs_warning-with-nilfs_msg.patch added to -mm
 tree
Date: Thu, 02 Jun 2016 13:19:58 -0700
Message-ID: <575094ee.RdI0i1RV7vpw31Uq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbcFBUT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 16:19:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: replace nilfs_warning() with nilfs_msg()
has been added to the -mm tree.  Its filename is
     nilfs2-replace-nilfs_warning-with-nilfs_msg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-replace-nilfs_warning-with-nilfs_msg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-replace-nilfs_warning-with-nilfs_msg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: replace nilfs_warning() with nilfs_msg()

Use nilfs_msg() to output warning messages and get rid of nilfs_warning()
function.  This also removes function names from the messages unless we
embed them explicitly in format strings.  Instead, some messages are
revised to clarify the context.

Link: http://lkml.kernel.org/r/1464875891-5443-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c   |   45 +++++++++++++++++++-----------------------
 fs/nilfs2/ifile.c   |    4 +--
 fs/nilfs2/inode.c   |   21 ++++++++++---------
 fs/nilfs2/namei.c   |    6 ++---
 fs/nilfs2/nilfs.h   |    2 -
 fs/nilfs2/page.c    |   19 ++++++++---------
 fs/nilfs2/segment.c |   20 +++++++++---------
 fs/nilfs2/super.c   |   21 -------------------
 8 files changed, 57 insertions(+), 81 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-replace-nilfs_warning-with-nilfs_msg fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-replace-nilfs_warning-with-nilfs_msg
+++ a/fs/nilfs2/alloc.c
@@ -622,10 +622,10 @@ void nilfs_palloc_commit_free_entry(stru
 	lock = nilfs_mdt_bgl_lock(inode, group);
 
 	if (!nilfs_clear_bit_atomic(lock, group_offset, bitmap))
-		nilfs_warning(inode->i_sb, __func__,
-			      "entry number %llu already freed: ino=%lu",
-			      (unsigned long long)req->pr_entry_nr,
-			      (unsigned long)inode->i_ino);
+		nilfs_msg(inode->i_sb, KERN_WARNING,
+			  "%s (ino=%lu): entry number %llu already freed",
+			  __func__, inode->i_ino,
+			  (unsigned long long)req->pr_entry_nr);
 	else
 		nilfs_palloc_group_desc_add_entries(desc, lock, 1);
 
@@ -663,10 +663,10 @@ void nilfs_palloc_abort_alloc_entry(stru
 	lock = nilfs_mdt_bgl_lock(inode, group);
 
 	if (!nilfs_clear_bit_atomic(lock, group_offset, bitmap))
-		nilfs_warning(inode->i_sb, __func__,
-			      "entry number %llu already freed: ino=%lu",
-			      (unsigned long long)req->pr_entry_nr,
-			      (unsigned long)inode->i_ino);
+		nilfs_msg(inode->i_sb, KERN_WARNING,
+			  "%s (ino=%lu): entry number %llu already freed",
+			  __func__, inode->i_ino,
+			  (unsigned long long)req->pr_entry_nr);
 	else
 		nilfs_palloc_group_desc_add_entries(desc, lock, 1);
 
@@ -772,10 +772,10 @@ int nilfs_palloc_freev(struct inode *ino
 		do {
 			if (!nilfs_clear_bit_atomic(lock, group_offset,
 						    bitmap)) {
-				nilfs_warning(inode->i_sb, __func__,
-					      "entry number %llu already freed: ino=%lu",
-					      (unsigned long long)entry_nrs[j],
-					      (unsigned long)inode->i_ino);
+				nilfs_msg(inode->i_sb, KERN_WARNING,
+					  "%s (ino=%lu): entry number %llu already freed",
+					  __func__, inode->i_ino,
+					  (unsigned long long)entry_nrs[j]);
 			} else {
 				n++;
 			}
@@ -816,12 +816,11 @@ int nilfs_palloc_freev(struct inode *ino
 		for (k = 0; k < nempties; k++) {
 			ret = nilfs_palloc_delete_entry_block(inode,
 							      last_nrs[k]);
-			if (ret && ret != -ENOENT) {
-				nilfs_warning(inode->i_sb, __func__,
-					      "failed to delete block of entry %llu: ino=%lu, err=%d",
-					      (unsigned long long)last_nrs[k],
-					      (unsigned long)inode->i_ino, ret);
-			}
+			if (ret && ret != -ENOENT)
+				nilfs_msg(inode->i_sb, KERN_WARNING,
+					  "error %d deleting block that object (entry=%llu, ino=%lu) belongs to",
+					  ret, (unsigned long long)last_nrs[k],
+					  inode->i_ino);
 		}
 
 		desc_kaddr = kmap_atomic(desc_bh->b_page);
@@ -835,12 +834,10 @@ int nilfs_palloc_freev(struct inode *ino
 
 		if (nfree == nilfs_palloc_entries_per_group(inode)) {
 			ret = nilfs_palloc_delete_bitmap_block(inode, group);
-			if (ret && ret != -ENOENT) {
-				nilfs_warning(inode->i_sb, __func__,
-					      "failed to delete bitmap block of group %lu: ino=%lu, err=%d",
-					      group,
-					      (unsigned long)inode->i_ino, ret);
-			}
+			if (ret && ret != -ENOENT)
+				nilfs_msg(inode->i_sb, KERN_WARNING,
+					  "error %d deleting bitmap block of group=%lu, ino=%lu",
+					  ret, group, inode->i_ino);
 		}
 	}
 	return 0;
diff -puN fs/nilfs2/ifile.c~nilfs2-replace-nilfs_warning-with-nilfs_msg fs/nilfs2/ifile.c
--- a/fs/nilfs2/ifile.c~nilfs2-replace-nilfs_warning-with-nilfs_msg
+++ a/fs/nilfs2/ifile.c
@@ -151,8 +151,8 @@ int nilfs_ifile_get_inode_block(struct i
 
 	err = nilfs_palloc_get_entry_block(ifile, ino, 0, out_bh);
 	if (unlikely(err))
-		nilfs_warning(sb, __func__, "unable to read inode: %lu",
-			      (unsigned long) ino);
+		nilfs_msg(sb, KERN_WARNING, "error %d reading inode: ino=%lu",
+			  err, (unsigned long)ino);
 	return err;
 }
 
diff -puN fs/nilfs2/inode.c~nilfs2-replace-nilfs_warning-with-nilfs_msg fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-replace-nilfs_warning-with-nilfs_msg
+++ a/fs/nilfs2/inode.c
@@ -723,9 +723,9 @@ repeat:
 		goto repeat;
 
 failed:
-	nilfs_warning(ii->vfs_inode.i_sb, __func__,
-		      "failed to truncate bmap (ino=%lu, err=%d)",
-		      ii->vfs_inode.i_ino, ret);
+	nilfs_msg(ii->vfs_inode.i_sb, KERN_WARNING,
+		  "error %d truncating bmap (ino=%lu)", ret,
+		  ii->vfs_inode.i_ino);
 }
 
 void nilfs_truncate(struct inode *inode)
@@ -936,9 +936,9 @@ int nilfs_set_file_dirty(struct inode *i
 			 * This will happen when somebody is freeing
 			 * this inode.
 			 */
-			nilfs_warning(inode->i_sb, __func__,
-				      "cannot get inode (ino=%lu)",
-				      inode->i_ino);
+			nilfs_msg(inode->i_sb, KERN_WARNING,
+				  "cannot set file dirty (ino=%lu): the file is being freed",
+				  inode->i_ino);
 			spin_unlock(&nilfs->ns_inode_lock);
 			return -EINVAL; /*
 					 * NILFS_I_DIRTY may remain for
@@ -959,8 +959,9 @@ int __nilfs_mark_inode_dirty(struct inod
 
 	err = nilfs_load_inode_block(inode, &ibh);
 	if (unlikely(err)) {
-		nilfs_warning(inode->i_sb, __func__,
-			      "failed to reget inode block.");
+		nilfs_msg(inode->i_sb, KERN_WARNING,
+			  "cannot mark inode dirty (ino=%lu): error %d loading inode block",
+			  inode->i_ino, err);
 		return err;
 	}
 	nilfs_update_inode(inode, ibh, flags);
@@ -986,8 +987,8 @@ void nilfs_dirty_inode(struct inode *ino
 	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
 
 	if (is_bad_inode(inode)) {
-		nilfs_warning(inode->i_sb, __func__,
-			      "tried to mark bad_inode dirty. ignored.");
+		nilfs_msg(inode->i_sb, KERN_WARNING,
+			  "tried to mark bad_inode dirty. ignored.");
 		dump_stack();
 		return;
 	}
diff -puN fs/nilfs2/namei.c~nilfs2-replace-nilfs_warning-with-nilfs_msg fs/nilfs2/namei.c
--- a/fs/nilfs2/namei.c~nilfs2-replace-nilfs_warning-with-nilfs_msg
+++ a/fs/nilfs2/namei.c
@@ -283,9 +283,9 @@ static int nilfs_do_unlink(struct inode
 		goto out;
 
 	if (!inode->i_nlink) {
-		nilfs_warning(inode->i_sb, __func__,
-			      "deleting nonexistent file (%lu), %d",
-			      inode->i_ino, inode->i_nlink);
+		nilfs_msg(inode->i_sb, KERN_WARNING,
+			  "deleting nonexistent file (ino=%lu), %d",
+			  inode->i_ino, inode->i_nlink);
 		set_nlink(inode, 1);
 	}
 	err = nilfs_delete_entry(de, page);
diff -puN fs/nilfs2/nilfs.h~nilfs2-replace-nilfs_warning-with-nilfs_msg fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-replace-nilfs_warning-with-nilfs_msg
+++ a/fs/nilfs2/nilfs.h
@@ -306,8 +306,6 @@ void __nilfs_msg(struct super_block *sb,
 extern __printf(3, 4)
 void __nilfs_error(struct super_block *sb, const char *function,
 		   const char *fmt, ...);
-extern __printf(3, 4)
-void nilfs_warning(struct super_block *, const char *, const char *, ...);
 
 #ifdef CONFIG_PRINTK
 
diff -puN fs/nilfs2/page.c~nilfs2-replace-nilfs_warning-with-nilfs_msg fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~nilfs2-replace-nilfs_warning-with-nilfs_msg
+++ a/fs/nilfs2/page.c
@@ -403,11 +403,10 @@ void nilfs_clear_dirty_page(struct page
 
 	BUG_ON(!PageLocked(page));
 
-	if (!silent) {
-		nilfs_warning(sb, __func__,
-				"discard page: offset %lld, ino %lu",
-				page_offset(page), inode->i_ino);
-	}
+	if (!silent)
+		nilfs_msg(sb, KERN_WARNING,
+			  "discard dirty page: offset=%lld, ino=%lu",
+			  page_offset(page), inode->i_ino);
 
 	ClearPageUptodate(page);
 	ClearPageMappedToDisk(page);
@@ -422,11 +421,11 @@ void nilfs_clear_dirty_page(struct page
 		bh = head = page_buffers(page);
 		do {
 			lock_buffer(bh);
-			if (!silent) {
-				nilfs_warning(sb, __func__,
-					"discard block %llu, size %zu",
-					(u64)bh->b_blocknr, bh->b_size);
-			}
+			if (!silent)
+				nilfs_msg(sb, KERN_WARNING,
+					  "discard dirty block: blocknr=%llu, size=%zu",
+					  (u64)bh->b_blocknr, bh->b_size);
+
 			set_mask_bits(&bh->b_state, clear_bits, 0);
 			unlock_buffer(bh);
 		} while (bh = bh->b_this_page, bh != head);
diff -puN fs/nilfs2/segment.c~nilfs2-replace-nilfs_warning-with-nilfs_msg fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-replace-nilfs_warning-with-nilfs_msg
+++ a/fs/nilfs2/segment.c
@@ -1951,8 +1951,9 @@ static int nilfs_segctor_collect_dirty_f
 			err = nilfs_ifile_get_inode_block(
 				ifile, ii->vfs_inode.i_ino, &ibh);
 			if (unlikely(err)) {
-				nilfs_warning(sci->sc_super, __func__,
-					      "failed to get inode block.");
+				nilfs_msg(sci->sc_super, KERN_WARNING,
+					  "log writer: error %d getting inode block (ino=%lu)",
+					  err, ii->vfs_inode.i_ino);
 				return err;
 			}
 			mark_buffer_dirty(ibh);
@@ -2458,8 +2459,7 @@ int nilfs_clean_segments(struct super_bl
 		if (likely(!err))
 			break;
 
-		nilfs_warning(sb, __func__,
-			      "segment construction failed. (err=%d)", err);
+		nilfs_msg(sb, KERN_WARNING, "error %d cleaning segments", err);
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(sci->sc_interval);
 	}
@@ -2738,14 +2738,14 @@ static void nilfs_segctor_destroy(struct
 		nilfs_segctor_write_out(sci);
 
 	if (!list_empty(&sci->sc_dirty_files)) {
-		nilfs_warning(sci->sc_super, __func__,
-			      "dirty file(s) after the final construction");
+		nilfs_msg(sci->sc_super, KERN_WARNING,
+			  "disposed unprocessed dirty file(s) when stopping log writer");
 		nilfs_dispose_list(nilfs, &sci->sc_dirty_files, 1);
 	}
 
 	if (!list_empty(&sci->sc_iput_queue)) {
-		nilfs_warning(sci->sc_super, __func__,
-			      "iput queue is not empty");
+		nilfs_msg(sci->sc_super, KERN_WARNING,
+			  "disposed unprocessed inode(s) in iput queue when stopping log writer");
 		nilfs_dispose_list(nilfs, &sci->sc_iput_queue, 1);
 	}
 
@@ -2821,8 +2821,8 @@ void nilfs_detach_log_writer(struct supe
 	spin_lock(&nilfs->ns_inode_lock);
 	if (!list_empty(&nilfs->ns_dirty_files)) {
 		list_splice_init(&nilfs->ns_dirty_files, &garbage_list);
-		nilfs_warning(sb, __func__,
-			      "Hit dirty file after stopped log writer");
+		nilfs_msg(sb, KERN_WARNING,
+			  "disposed unprocessed dirty file(s) when detaching log writer");
 	}
 	spin_unlock(&nilfs->ns_inode_lock);
 	up_write(&nilfs->ns_segctor_sem);
diff -puN fs/nilfs2/super.c~nilfs2-replace-nilfs_warning-with-nilfs_msg fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-replace-nilfs_warning-with-nilfs_msg
+++ a/fs/nilfs2/super.c
@@ -115,8 +115,7 @@ static void nilfs_set_error(struct super
  *
  * This implements the body of nilfs_error() macro.  Normally,
  * nilfs_error() should be used.  As for sustainable errors such as a
- * single-shot I/O error, nilfs_warning() or printk() should be used
- * instead.
+ * single-shot I/O error, nilfs_msg() should be used instead.
  *
  * Callers should not add a trailing newline since this will do it.
  */
@@ -151,24 +150,6 @@ void __nilfs_error(struct super_block *s
 		      sb->s_id);
 }
 
-void nilfs_warning(struct super_block *sb, const char *function,
-		   const char *fmt, ...)
-{
-	struct va_format vaf;
-	va_list args;
-
-	va_start(args, fmt);
-
-	vaf.fmt = fmt;
-	vaf.va = &args;
-
-	printk(KERN_WARNING "NILFS warning (device %s): %s: %pV\n",
-	       sb->s_id, function, &vaf);
-
-	va_end(args);
-}
-
