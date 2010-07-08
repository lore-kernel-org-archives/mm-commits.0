From: akpm@linux-foundation.org
Subject: + vfs-change-writeback_inodes-signature.patch added to -mm tree
Date: Thu, 08 Jul 2010 15:10:13 -0700
Message-ID: <201007082210.o68MADuU031966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757577Ab0GHWKo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 18:10:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com


The patch titled
     vfs: change ->writeback_inodes() signature
has been added to the -mm tree.  Its filename is
     vfs-change-writeback_inodes-signature.patch

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
Subject: vfs: change ->writeback_inodes() signature
From: Edward Shishkin <edward.shishkin@gmail.com>

Change signature of ->writeback_inodes() of super_operations in accordance
with the signature of writeback_sb_inodes().

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c  |    2 +-
 include/linux/fs.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/fs-writeback.c~vfs-change-writeback_inodes-signature fs/fs-writeback.c
--- a/fs/fs-writeback.c~vfs-change-writeback_inodes-signature
+++ a/fs/fs-writeback.c
@@ -570,7 +570,7 @@ static int do_writeback_sb_inodes(struct
 				bool only_this_sb)
 {
 	if (sb->s_op->writeback_inodes)
-		return sb->s_op->writeback_inodes(sb, wb, wbc);
+		return sb->s_op->writeback_inodes(sb, wb, wbc, only_this_sb);
 	return generic_writeback_sb_inodes(sb, wb, wbc, only_this_sb);
 }
 
diff -puN include/linux/fs.h~vfs-change-writeback_inodes-signature include/linux/fs.h
--- a/include/linux/fs.h~vfs-change-writeback_inodes-signature
+++ a/include/linux/fs.h
@@ -1576,8 +1576,8 @@ struct super_operations {
 	void (*umount_begin) (struct super_block *);
 	int (*writeback_inodes)(struct super_block *sb,
 				struct bdi_writeback *wb,
-				struct writeback_control *wbc);
-
+				struct writeback_control *wbc,
+				bool only_this_sb);
 	int (*show_options)(struct seq_file *, struct vfsmount *);
 	int (*show_stats)(struct seq_file *, struct vfsmount *);
 #ifdef CONFIG_QUOTA
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

vfs-add-super-operation-writeback_inodes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
vfs-take-2add-set_page_dirty_notag.patch
vfs-change-writeback_inodes-signature.patch
reiser4.patch
reiser4-writeback_inodes-implementation.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-writeback_inodes-implementation-adjust-to-writeback-changes.patch
reiser4-fixup-checkin-checkout-jnodes-for-entd.patch
reiser4-fixups.patch
reiser4-broke.patch
reiser4-rename-quota-methods.patch
reiser4-remove-inode_setattr.patch
reiser4-change-fsync-signature.patch
reiser4-enable.patch

