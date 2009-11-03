From: akpm@linux-foundation.org
Subject: + ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch added to -mm tree
Date: Tue, 03 Nov 2009 14:03:17 -0800
Message-ID: <200911032203.nA3M3Hlv030175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbZKCWEB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 17:04:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tytso@mit.edu


The patch titled
     ext2: avoid WARN() messages when failing to write to the superblock
has been added to the -mm tree.  Its filename is
     ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch

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
Subject: ext2: avoid WARN() messages when failing to write to the superblock
From: "Theodore Ts'o" <tytso@mit.edu>

This fixes a common warning reported by kerneloops.org

[Kernel summit hacking hour]
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/ext2/super.c~ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock
+++ a/fs/ext2/super.c
@@ -1089,9 +1089,30 @@ failed_sbi:
 	return ret;
 }
 
+static void ext2_clear_super_error(struct super_block * sb)
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
@@ -1099,6 +1120,7 @@ static void ext2_commit_super (struct su
 
 static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
 {
+	ext2_clear_super_error(sb);
 	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
 	es->s_wtime = cpu_to_le32(get_seconds());
_

Patches currently in -mm which might be from tytso@mit.edu are

origin.patch
__generic_block_fiemap-fix-for-files-bigger-than-4gb.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch

