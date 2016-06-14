From: akpm@linux-foundation.org
Subject: + nilfs2-use-bit-macro.patch added to -mm tree
Date: Tue, 14 Jun 2016 15:27:02 -0700
Message-ID: <576084b6.HfBvokxAFsBwLY5f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbcFNW1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 18:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: use BIT() macro
has been added to the -mm tree.  Its filename is
     nilfs2-use-bit-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-use-bit-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-use-bit-macro.patch

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
Subject: nilfs2: use BIT() macro

Replace bit shifts by BIT macro for clarity.

Link: http://lkml.kernel.org/r/1465825507-3407-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c  |    4 ++--
 fs/nilfs2/inode.c   |    4 ++--
 fs/nilfs2/nilfs.h   |   15 +++++++--------
 fs/nilfs2/page.c    |   26 +++++++++++++-------------
 fs/nilfs2/segment.c |   14 +++++++-------
 fs/nilfs2/sufile.c  |   12 ++++++------
 6 files changed, 37 insertions(+), 38 deletions(-)

diff -puN fs/nilfs2/btnode.c~nilfs2-use-bit-macro fs/nilfs2/btnode.c
--- a/fs/nilfs2/btnode.c~nilfs2-use-bit-macro
+++ a/fs/nilfs2/btnode.c
@@ -41,7 +41,7 @@ nilfs_btnode_create_block(struct address
 	struct inode *inode = NILFS_BTNC_I(btnc);
 	struct buffer_head *bh;
 
-	bh = nilfs_grab_buffer(inode, btnc, blocknr, 1 << BH_NILFS_Node);
+	bh = nilfs_grab_buffer(inode, btnc, blocknr, BIT(BH_NILFS_Node));
 	if (unlikely(!bh))
 		return NULL;
 
@@ -70,7 +70,7 @@ int nilfs_btnode_submit_block(struct add
 	struct page *page;
 	int err;
 
-	bh = nilfs_grab_buffer(inode, btnc, blocknr, 1 << BH_NILFS_Node);
+	bh = nilfs_grab_buffer(inode, btnc, blocknr, BIT(BH_NILFS_Node));
 	if (unlikely(!bh))
 		return -ENOMEM;
 
diff -puN fs/nilfs2/inode.c~nilfs2-use-bit-macro fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-use-bit-macro
+++ a/fs/nilfs2/inode.c
@@ -356,7 +356,7 @@ struct inode *nilfs_new_inode(struct ino
 
 	root = NILFS_I(dir)->i_root;
 	ii = NILFS_I(inode);
-	ii->i_state = 1 << NILFS_I_NEW;
+	ii->i_state = BIT(NILFS_I_NEW);
 	ii->i_root = root;
 
 	err = nilfs_ifile_create_inode(root->ifile, &ino, &ii->i_bh);
@@ -555,7 +555,7 @@ static int nilfs_iget_set(struct inode *
 
 	inode->i_ino = args->ino;
 	if (args->for_gc) {
-		NILFS_I(inode)->i_state = 1 << NILFS_I_GCINODE;
+		NILFS_I(inode)->i_state = BIT(NILFS_I_GCINODE);
 		NILFS_I(inode)->i_cno = args->cno;
 		NILFS_I(inode)->i_root = NULL;
 	} else {
diff -puN fs/nilfs2/nilfs.h~nilfs2-use-bit-macro fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-use-bit-macro
+++ a/fs/nilfs2/nilfs.h
@@ -119,20 +119,19 @@ enum {
 /*
  * Macros to check inode numbers
  */
-#define NILFS_MDT_INO_BITS   \
-	((unsigned int)(1 << NILFS_DAT_INO | 1 << NILFS_CPFILE_INO |	\
-			1 << NILFS_SUFILE_INO | 1 << NILFS_IFILE_INO |	\
-			1 << NILFS_ATIME_INO | 1 << NILFS_SKETCH_INO))
+#define NILFS_MDT_INO_BITS						\
+	(BIT(NILFS_DAT_INO) | BIT(NILFS_CPFILE_INO) |			\
+	 BIT(NILFS_SUFILE_INO) | BIT(NILFS_IFILE_INO) |			\
+	 BIT(NILFS_ATIME_INO) | BIT(NILFS_SKETCH_INO))
 
-#define NILFS_SYS_INO_BITS   \
-	((unsigned int)(1 << NILFS_ROOT_INO) | NILFS_MDT_INO_BITS)
+#define NILFS_SYS_INO_BITS (BIT(NILFS_ROOT_INO) | NILFS_MDT_INO_BITS)
 
 #define NILFS_FIRST_INO(sb) (((struct the_nilfs *)sb->s_fs_info)->ns_first_ino)
 
 #define NILFS_MDT_INODE(sb, ino) \
-	((ino) < NILFS_FIRST_INO(sb) && (NILFS_MDT_INO_BITS & (1 << (ino))))
+	((ino) < NILFS_FIRST_INO(sb) && (NILFS_MDT_INO_BITS & BIT(ino)))
 #define NILFS_VALID_INODE(sb, ino) \
-	((ino) >= NILFS_FIRST_INO(sb) || (NILFS_SYS_INO_BITS & (1 << (ino))))
+	((ino) >= NILFS_FIRST_INO(sb) || (NILFS_SYS_INO_BITS & BIT(ino)))
 
 /**
  * struct nilfs_transaction_info: context information for synchronization
diff -puN fs/nilfs2/page.c~nilfs2-use-bit-macro fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~nilfs2-use-bit-macro
+++ a/fs/nilfs2/page.c
@@ -30,9 +30,9 @@
 #include "mdt.h"
 
 
-#define NILFS_BUFFER_INHERENT_BITS  \
-	((1UL << BH_Uptodate) | (1UL << BH_Mapped) | (1UL << BH_NILFS_Node) | \
-	 (1UL << BH_NILFS_Volatile) | (1UL << BH_NILFS_Checked))
+#define NILFS_BUFFER_INHERENT_BITS					\
+	(BIT(BH_Uptodate) | BIT(BH_Mapped) | BIT(BH_NILFS_Node) |	\
+	 BIT(BH_NILFS_Volatile) | BIT(BH_NILFS_Checked))
 
 static struct buffer_head *
 __nilfs_get_page_block(struct page *page, unsigned long block, pgoff_t index,
@@ -85,9 +85,9 @@ void nilfs_forget_buffer(struct buffer_h
 {
 	struct page *page = bh->b_page;
 	const unsigned long clear_bits =
-		(1 << BH_Uptodate | 1 << BH_Dirty | 1 << BH_Mapped |
-		 1 << BH_Async_Write | 1 << BH_NILFS_Volatile |
-		 1 << BH_NILFS_Checked | 1 << BH_NILFS_Redirected);
+		(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
+		 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
+		 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected));
 
 	lock_buffer(bh);
 	set_mask_bits(&bh->b_state, clear_bits, 0);
@@ -124,17 +124,17 @@ void nilfs_copy_buffer(struct buffer_hea
 	dbh->b_bdev = sbh->b_bdev;
 
 	bh = dbh;
-	bits = sbh->b_state & ((1UL << BH_Uptodate) | (1UL << BH_Mapped));
+	bits = sbh->b_state & (BIT(BH_Uptodate) | BIT(BH_Mapped));
 	while ((bh = bh->b_this_page) != dbh) {
 		lock_buffer(bh);
 		bits &= bh->b_state;
 		unlock_buffer(bh);
 	}
-	if (bits & (1UL << BH_Uptodate))
+	if (bits & BIT(BH_Uptodate))
 		SetPageUptodate(dpage);
 	else
 		ClearPageUptodate(dpage);
-	if (bits & (1UL << BH_Mapped))
+	if (bits & BIT(BH_Mapped))
 		SetPageMappedToDisk(dpage);
 	else
 		ClearPageMappedToDisk(dpage);
@@ -215,7 +215,7 @@ static void nilfs_copy_page(struct page
 		create_empty_buffers(dst, sbh->b_size, 0);
 
 	if (copy_dirty)
-		mask |= (1UL << BH_Dirty);
+		mask |= BIT(BH_Dirty);
 
 	dbh = dbufs = page_buffers(dst);
 	do {
@@ -414,9 +414,9 @@ void nilfs_clear_dirty_page(struct page
 	if (page_has_buffers(page)) {
 		struct buffer_head *bh, *head;
 		const unsigned long clear_bits =
-			(1 << BH_Uptodate | 1 << BH_Dirty | 1 << BH_Mapped |
-			 1 << BH_Async_Write | 1 << BH_NILFS_Volatile |
-			 1 << BH_NILFS_Checked | 1 << BH_NILFS_Redirected);
+			(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
+			 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
+			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected));
 
 		bh = head = page_buffers(page);
 		do {
diff -puN fs/nilfs2/segment.c~nilfs2-use-bit-macro fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-use-bit-macro
+++ a/fs/nilfs2/segment.c
@@ -1858,11 +1858,11 @@ static void nilfs_segctor_complete_write
 		 */
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
-			const unsigned long set_bits = (1 << BH_Uptodate);
+			const unsigned long set_bits = BIT(BH_Uptodate);
 			const unsigned long clear_bits =
-				(1 << BH_Dirty | 1 << BH_Async_Write |
-				 1 << BH_Delay | 1 << BH_NILFS_Volatile |
-				 1 << BH_NILFS_Redirected);
+				(BIT(BH_Dirty) | BIT(BH_Async_Write) |
+				 BIT(BH_Delay) | BIT(BH_NILFS_Volatile) |
+				 BIT(BH_NILFS_Redirected));
 
 			set_mask_bits(&bh->b_state, clear_bits, set_bits);
 			if (bh == segbuf->sb_super_root) {
@@ -2132,10 +2132,10 @@ static void nilfs_segctor_start_timer(st
 static void nilfs_segctor_do_flush(struct nilfs_sc_info *sci, int bn)
 {
 	spin_lock(&sci->sc_state_lock);
-	if (!(sci->sc_flush_request & (1 << bn))) {
+	if (!(sci->sc_flush_request & BIT(bn))) {
 		unsigned long prev_req = sci->sc_flush_request;
 
-		sci->sc_flush_request |= (1 << bn);
+		sci->sc_flush_request |= BIT(bn);
 		if (!prev_req)
 			wake_up(&sci->sc_wait_daemon);
 	}
@@ -2319,7 +2319,7 @@ int nilfs_construct_dsync_segment(struct
 }
 
 #define FLUSH_FILE_BIT	(0x1) /* data file only */
-#define FLUSH_DAT_BIT	(1 << NILFS_DAT_INO) /* DAT only */
+#define FLUSH_DAT_BIT	BIT(NILFS_DAT_INO) /* DAT only */
 
 /**
  * nilfs_segctor_accept - record accepted sequence count of log-write requests
diff -puN fs/nilfs2/sufile.c~nilfs2-use-bit-macro fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-use-bit-macro
+++ a/fs/nilfs2/sufile.c
@@ -446,7 +446,7 @@ void nilfs_sufile_do_scrap(struct inode
 
 	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
-	if (su->su_flags == cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_DIRTY) &&
+	if (su->su_flags == cpu_to_le32(BIT(NILFS_SEGMENT_USAGE_DIRTY)) &&
 	    su->su_nblocks == cpu_to_le32(0)) {
 		kunmap_atomic(kaddr);
 		return;
@@ -457,7 +457,7 @@ void nilfs_sufile_do_scrap(struct inode
 	/* make the segment garbage */
 	su->su_lastmod = cpu_to_le64(0);
 	su->su_nblocks = cpu_to_le32(0);
-	su->su_flags = cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_DIRTY);
+	su->su_flags = cpu_to_le32(BIT(NILFS_SEGMENT_USAGE_DIRTY));
 	kunmap_atomic(kaddr);
 
 	nilfs_sufile_mod_counter(header_bh, clean ? (u64)-1 : 0, dirty ? 0 : 1);
@@ -695,7 +695,7 @@ static int nilfs_sufile_truncate_range(s
 		su2 = su;
 		for (j = 0; j < n; j++, su = (void *)su + susz) {
 			if ((le32_to_cpu(su->su_flags) &
-			     ~(1UL << NILFS_SEGMENT_USAGE_ERROR)) ||
+			     ~BIT(NILFS_SEGMENT_USAGE_ERROR)) ||
 			    nilfs_segment_is_active(nilfs, segnum + j)) {
 				ret = -EBUSY;
 				kunmap_atomic(kaddr);
@@ -862,10 +862,10 @@ ssize_t nilfs_sufile_get_suinfo(struct i
 			si->sui_lastmod = le64_to_cpu(su->su_lastmod);
 			si->sui_nblocks = le32_to_cpu(su->su_nblocks);
 			si->sui_flags = le32_to_cpu(su->su_flags) &
-				~(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
+				~BIT(NILFS_SEGMENT_USAGE_ACTIVE);
 			if (nilfs_segment_is_active(nilfs, segnum + j))
 				si->sui_flags |=
-					(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
+					BIT(NILFS_SEGMENT_USAGE_ACTIVE);
 		}
 		kunmap_atomic(kaddr);
 		brelse(su_bh);
@@ -953,7 +953,7 @@ ssize_t nilfs_sufile_set_suinfo(struct i
 			 * disk.
 			 */
 			sup->sup_sui.sui_flags &=
-					~(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
+					~BIT(NILFS_SEGMENT_USAGE_ACTIVE);
 
 			cleansi = nilfs_suinfo_clean(&sup->sup_sui);
 			cleansu = nilfs_segment_usage_clean(su);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-hide-function-name-argument-from-nilfs_error.patch
nilfs2-add-nilfs_msg-message-interface.patch
nilfs2-embed-a-back-pointer-to-super-block-instance-in-nilfs-object.patch
nilfs2-reduce-bare-use-of-printk-with-nilfs_msg.patch
nilfs2-replace-nilfs_warning-with-nilfs_msg.patch
nilfs2-emit-error-message-when-i-o-error-is-detected.patch
nilfs2-do-not-use-yield.patch
nilfs2-refactor-parser-of-snapshot-mount-option.patch
nilfs2-fix-misuse-of-a-semaphore-in-sysfs-code.patch
nilfs2-use-bit-macro.patch
nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately.patch

