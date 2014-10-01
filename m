From: akpm@linux-foundation.org
Subject: +
 fs-omfs-block-number-sanity-check-during-fill_super-operation.patch added
 to -mm tree
Date: Wed, 01 Oct 2014 14:36:07 -0700
Message-ID: <542c73c7.WQsIBEABuZLkYGl1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaJAVgH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 17:36:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, me@bobcopeland.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: FS/OMFS: block number sanity check during fill_super operation
has been added to the -mm tree.  Its filename is
     fs-omfs-block-number-sanity-check-during-fill_super-operation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-omfs-block-number-sanity-check-during-fill_super-operation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-omfs-block-number-sanity-check-during-fill_super-operation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: FS/OMFS: block number sanity check during fill_super operation

This patch defines maximum block number to 2^31.  It also converts
bitmap_size and array_size to unsigned int in omfs_get_imap

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Bob Copeland <me@bobcopeland.com>
Tested-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/inode.c   |   10 +++++++---
 fs/omfs/omfs_fs.h |    1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN fs/omfs/inode.c~fs-omfs-block-number-sanity-check-during-fill_super-operation fs/omfs/inode.c
--- a/fs/omfs/inode.c~fs-omfs-block-number-sanity-check-during-fill_super-operation
+++ a/fs/omfs/inode.c
@@ -306,9 +306,7 @@ static const struct super_operations omf
  */
 static int omfs_get_imap(struct super_block *sb)
 {
-	int bitmap_size;
-	int array_size;
-	int count;
+	unsigned int bitmap_size, count, array_size;
 	struct omfs_sb_info *sbi = OMFS_SB(sb);
 	struct buffer_head *bh;
 	unsigned long **ptr;
@@ -473,6 +471,12 @@ static int omfs_fill_super(struct super_
 	sbi->s_sys_blocksize = be32_to_cpu(omfs_sb->s_sys_blocksize);
 	mutex_init(&sbi->s_bitmap_lock);
 
+	if (sbi->s_num_blocks > OMFS_MAX_BLOCKS) {
+		printk(KERN_ERR "omfs: sysblock number (%llx) is out of range\n",
+		       (unsigned long long)sbi->s_num_blocks);
+		goto out_brelse_bh;
+	}
+
 	if (sbi->s_sys_blocksize > PAGE_SIZE) {
 		printk(KERN_ERR "omfs: sysblock size (%d) is out of range\n",
 			sbi->s_sys_blocksize);
diff -puN fs/omfs/omfs_fs.h~fs-omfs-block-number-sanity-check-during-fill_super-operation fs/omfs/omfs_fs.h
--- a/fs/omfs/omfs_fs.h~fs-omfs-block-number-sanity-check-during-fill_super-operation
+++ a/fs/omfs/omfs_fs.h
@@ -18,6 +18,7 @@
 #define OMFS_XOR_COUNT 19
 #define OMFS_MAX_BLOCK_SIZE 8192
 #define OMFS_MAX_CLUSTER_SIZE 8
+#define OMFS_MAX_BLOCKS (1ul << 31)
 
 struct omfs_super_block {
 	char s_fill1[256];
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-ufs-ballocc-remove-unused-variable.patch
fs-reiserfs-journalc-fix-sparse-context-imbalance-warning.patch
fs-affs-superc-remove-unused-variable.patch
fs-affs-inodec-remove-unused-variable.patch
fs-omfs-block-number-sanity-check-during-fill_super-operation.patch
linux-next.patch

