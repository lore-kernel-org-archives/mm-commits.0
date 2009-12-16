From: akpm@linux-foundation.org
Subject: [merged] ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:36:50 -0800
Message-ID: <200912162036.nBGKaoDD013269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935452AbZLPUgy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:36:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext2: avoid WARN() messages when failing to write to the superblock
has been removed from the -mm tree.  Its filename was
     ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: avoid WARN() messages when failing to write to the superblock
From: "Theodore Ts'o" <tytso@mit.edu>

This fixes a common warning reported by kerneloops.org

[Kernel summit hacking hour]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN fs/ext2/super.c~ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock
+++ a/fs/ext2/super.c
@@ -1105,9 +1105,30 @@ failed_sbi:
 	return ret;
 }
 
+static void ext2_clear_super_error(struct super_block *sb)
+{
+	struct buffer_head *sbh = EXT2_SB(sb)->s_sbh;
+
+	if (buffer_write_io_error(sbh)) {
+		/*
+		 * Oh, dear.  A previous attempt to write the
+		 * superblock failed.  This could happen because the
+		 * USB device was yanked out.  Or it could happen to
+		 * be a transient write error and maybe the block will
+		 * be remapped.  Nothing we can do but to retry the
+		 * write and hope for the best.
+		 */
+		printk(KERN_ERR "EXT2-fs: %s previous I/O error to "
+		       "superblock detected", sb->s_id);
+		clear_buffer_write_io_error(sbh);
+		set_buffer_uptodate(sbh);
+	}
+}
+
 static void ext2_commit_super (struct super_block * sb,
 			       struct ext2_super_block * es)
 {
+	ext2_clear_super_error(sb);
 	es->s_wtime = cpu_to_le32(get_seconds());
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 	sb->s_dirt = 0;
@@ -1115,6 +1136,7 @@ static void ext2_commit_super (struct su
 
 static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
 {
+	ext2_clear_super_error(sb);
 	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
 	es->s_wtime = cpu_to_le32(get_seconds());
_

Patches currently in -mm which might be from tytso@mit.edu are

origin.patch
linux-next.patch
fs-ext4-superc-fix-printk-warning.patch

