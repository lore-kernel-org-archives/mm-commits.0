From: akpm@linux-foundation.org
Subject: + fs-sysv-stop-using-write_super-and-s_dirt.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:45:43 -0700
Message-ID: <20120713214544.AA6F420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:53253 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab2GMVpr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:45:47 -0400
Received: by eaao13 with SMTP id o13so205013eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:45:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, alan@lxorguk.ukuu.org.uk, hch@lst.de, viro@ZenIV.linux.org.uk


The patch titled
     Subject: fs/sysv: stop using write_super and s_dirt
has been added to the -mm tree.  Its filename is
     fs-sysv-stop-using-write_super-and-s_dirt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: fs/sysv: stop using write_super and s_dirt

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

origin.patch
linux-next.patch
hfs-push-lock_super-down.patch
hfs-get-rid-of-lock_super.patch
hfs-remove-extra-mdb-write-on-unmount.patch
hfs-simplify-a-bit-checking-for-r-o.patch
hfs-introduce-vfs-superblock-object-back-reference.patch
hfs-get-rid-of-hfs_sync_super.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
hfs-get-rid-of-hfs_sync_super-v2.patch
hfsplus-make-hfsplus_sync_fs-static.patch
hfsplus-amend-debugging-print.patch
hfsplus-remove-useless-check.patch
hfsplus-get-rid-of-write_super.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
hfsplus-get-rid-of-write_super-v3.patch
fs-ufs-remove-extra-superblock-write-on-unmount.patch
fs-ufs-re-arrange-the-code-a-bit.patch
fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes.patch
fs-ufs-get-rid-of-write_super.patch
fs-sysv-remove-useless-write_super-call.patch
fs-sysv-remove-another-useless-write_super-call.patch
fs-sysv-stop-using-write_super-and-s_dirt.patch

