From: akpm@linux-foundation.org
Subject: + copy-i_flags-to-ext2-inode-flags-on-write.patch added to -mm tree
Date: Wed, 25 Apr 2007 18:48:26 -0700
Message-ID: <200704260148.l3Q1mQbY018273@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745AbXDZBse (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 21:48:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     ext3: copy i_flags to inode flags on write
has been added to the -mm tree.  Its filename is
     copy-i_flags-to-ext2-inode-flags-on-write.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3: copy i_flags to inode flags on write
From: Jan Kara <jack@suse.cz>

Propagate flags such as S_APPEND, S_IMMUTABLE, etc.  from i_flags into
ext2-specific i_flags.  Hence, when someone sets these flags via a different
interface than ioctl, they are stored correctly.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ext2.h  |    1 +
 fs/ext2/inode.c |   20 ++++++++++++++++++++
 fs/ext2/ioctl.c |    1 +
 3 files changed, 22 insertions(+)

diff -puN fs/ext2/ext2.h~copy-i_flags-to-ext2-inode-flags-on-write fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~copy-i_flags-to-ext2-inode-flags-on-write
+++ a/fs/ext2/ext2.h
@@ -133,6 +133,7 @@ extern int ext2_get_block(struct inode *
 extern void ext2_truncate (struct inode *);
 extern int ext2_setattr (struct dentry *, struct iattr *);
 extern void ext2_set_inode_flags(struct inode *inode);
+extern void ext2_get_inode_flags(struct ext2_inode_info *);
 
 /* ioctl.c */
 extern int ext2_ioctl (struct inode *, struct file *, unsigned int,
diff -puN fs/ext2/inode.c~copy-i_flags-to-ext2-inode-flags-on-write fs/ext2/inode.c
--- a/fs/ext2/inode.c~copy-i_flags-to-ext2-inode-flags-on-write
+++ a/fs/ext2/inode.c
@@ -1055,6 +1055,25 @@ void ext2_set_inode_flags(struct inode *
 		inode->i_flags |= S_DIRSYNC;
 }
 
+/* Propagate flags from i_flags to EXT2_I(inode)->i_flags */
+void ext2_get_inode_flags(struct ext2_inode_info *ei)
+{
+	unsigned int flags = ei->vfs_inode.i_flags;
+
+	ei->i_flags &= ~(EXT2_SYNC_FL|EXT2_APPEND_FL|
+			EXT2_IMMUTABLE_FL|EXT2_NOATIME_FL|EXT2_DIRSYNC_FL);
+	if (flags & S_SYNC)
+		ei->i_flags |= EXT2_SYNC_FL;
+	if (flags & S_APPEND)
+		ei->i_flags |= EXT2_APPEND_FL;
+	if (flags & S_IMMUTABLE)
+		ei->i_flags |= EXT2_IMMUTABLE_FL;
+	if (flags & S_NOATIME)
+		ei->i_flags |= EXT2_NOATIME_FL;
+	if (flags & S_DIRSYNC)
+		ei->i_flags |= EXT2_DIRSYNC_FL;
+}
+
 void ext2_read_inode (struct inode * inode)
 {
 	struct ext2_inode_info *ei = EXT2_I(inode);
@@ -1188,6 +1207,7 @@ static int ext2_update_inode(struct inod
 	if (ei->i_state & EXT2_STATE_NEW)
 		memset(raw_inode, 0, EXT2_SB(sb)->s_inode_size);
 
+	ext2_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
 	if (!(test_opt(sb, NO_UID32))) {
 		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(uid));
diff -puN fs/ext2/ioctl.c~copy-i_flags-to-ext2-inode-flags-on-write fs/ext2/ioctl.c
--- a/fs/ext2/ioctl.c~copy-i_flags-to-ext2-inode-flags-on-write
+++ a/fs/ext2/ioctl.c
@@ -27,6 +27,7 @@ int ext2_ioctl (struct inode * inode, st
 
 	switch (cmd) {
 	case EXT2_IOC_GETFLAGS:
+		ext2_get_inode_flags(ei);
 		flags = ei->i_flags & EXT2_FL_USER_VISIBLE;
 		return put_user(flags, (int __user *) arg);
 	case EXT2_IOC_SETFLAGS: {
_

Patches currently in -mm which might be from jack@suse.cz are

readahead-improve-heuristic-detecting-sequential-reads.patch
readahead-code-cleanup.patch
readahead-code-cleanup-fix.patch
make-remove_inode_dquot_ref-static.patch
ext3-copy-i_flags-to-inode-flags-on-write.patch
copy-i_flags-to-ext2-inode-flags-on-write.patch
ext4-copy-i_flags-to-inode-flags-on-write.patch
udf-use-sector_t-and-loff_t-for-file-offsets.patch
udf-introduce-struct-extent_position.patch
udf-use-get_bh.patch
udf-add-assertions.patch
udf-support-files-larger-than-1g.patch
udf-fix-link-counts.patch
