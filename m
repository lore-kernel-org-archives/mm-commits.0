From: akpm@linux-foundation.org
Subject: [merged] fs-sysv-stop-using-write_super-and-s_dirt.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:05:26 -0700
Message-ID: <20120717200527.2AE3820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:56542 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab2GQUF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:05:29 -0400
Received: by wgbdt11 with SMTP id dt11so38611wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:05:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, alan@lxorguk.ukuu.org.uk, hch@lst.de, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/sysv: stop using write_super and s_dirt
has been removed from the -mm tree.  Its filename was
     fs-sysv-stop-using-write_super-and-s_dirt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: fs/sysv: stop using write_super and s_dirt

It does not look like sysv FS needs 'write_super()' at all, because all it
does is a timestamp update.  I cannot test this patch, because this
file-system is so old and probably has not been used by anyone for years,
so there are no tools to create it in Linux.  But from the code I see that
marking the superblock as dirty is basically marking the superblock
buffers as drity and then setting the s_dirt flag.  And when
'write_super()' is executed to handle the s_dirt flag, we just update the
timestamp and again mark the superblock buffer as dirty.  Seems pointless.

It looks like we can update the timestamp more opprtunistically - on
unmount or remount of sync, and nothing should change.

Thus, this patch removes 'sysv_write_super()' and 's_dirt'.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/inode.c |   10 ----------
 fs/sysv/sysv.h  |    1 -
 2 files changed, 11 deletions(-)

diff -puN fs/sysv/inode.c~fs-sysv-stop-using-write_super-and-s_dirt fs/sysv/inode.c
--- a/fs/sysv/inode.c~fs-sysv-stop-using-write_super-and-s_dirt
+++ a/fs/sysv/inode.c
@@ -43,7 +43,6 @@ static int sysv_sync_fs(struct super_blo
 	 * then attach current time stamp.
 	 * But if the filesystem was marked clean, keep it clean.
 	 */
-	sb->s_dirt = 0;
 	old_time = fs32_to_cpu(sbi, *sbi->s_sb_time);
 	if (sbi->s_type == FSTYPE_SYSV4) {
 		if (*sbi->s_sb_state == cpu_to_fs32(sbi, 0x7c269d38 - old_time))
@@ -57,14 +56,6 @@ static int sysv_sync_fs(struct super_blo
 	return 0;
 }
 
-static void sysv_write_super(struct super_block *sb)
-{
-	if (!(sb->s_flags & MS_RDONLY))
-		sysv_sync_fs(sb, 1);
-	else
-		sb->s_dirt = 0;
-}
-
 static int sysv_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct sysv_sb_info *sbi = SYSV_SB(sb);
@@ -351,7 +342,6 @@ const struct super_operations sysv_sops 
 	.write_inode	= sysv_write_inode,
 	.evict_inode	= sysv_evict_inode,
 	.put_super	= sysv_put_super,
-	.write_super	= sysv_write_super,
 	.sync_fs	= sysv_sync_fs,
 	.remount_fs	= sysv_remount,
 	.statfs		= sysv_statfs,
diff -puN fs/sysv/sysv.h~fs-sysv-stop-using-write_super-and-s_dirt fs/sysv/sysv.h
--- a/fs/sysv/sysv.h~fs-sysv-stop-using-write_super-and-s_dirt
+++ a/fs/sysv/sysv.h
@@ -117,7 +117,6 @@ static inline void dirty_sb(struct super
 	mark_buffer_dirty(sbi->s_bh1);
 	if (sbi->s_bh1 != sbi->s_bh2)
 		mark_buffer_dirty(sbi->s_bh2);
-	sb->s_dirt = 1;
 }
 
 
_

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch

