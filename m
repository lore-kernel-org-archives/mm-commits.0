From: akpm@linux-foundation.org
Subject: + fs-reiserfs-return-f_fsid-for-statfs2-v2.patch added to -mm tree
Date: Wed, 28 Jan 2009 23:29:17 -0800
Message-ID: <200901290729.n0T7THc6009228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305AbZA2H3X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 02:29:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: coly.li@suse.de


The patch titled
     fs/reiserfs: return f_fsid for statfs(2), v2
has been added to the -mm tree.  Its filename is
     fs-reiserfs-return-f_fsid-for-statfs2-v2.patch

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
Subject: fs/reiserfs: return f_fsid for statfs(2), v2
From: Coly Li <coly.li@suse.de>

This patch makes reiserfs3 return f_fsid info for statfs(2).  By Andreas'
suggestion, this patch populates a persistent f_fsid between boots/mounts
with help of on-disk uuid record.

Signed-off-by: Coly Li <coly.li@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/reiserfs/super.c~fs-reiserfs-return-f_fsid-for-statfs2-v2 fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~fs-reiserfs-return-f_fsid-for-statfs2-v2
+++ a/fs/reiserfs/super.c
@@ -27,6 +27,7 @@
 #include <linux/mnt_namespace.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
+#include <linux/crc32.h>
 
 struct file_system_type reiserfs_fs_type;
 
@@ -1881,9 +1882,7 @@ error:
 
 static int reiserfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct super_block *sb = dentry->d_sb;
-	struct reiserfs_super_block *rs = SB_DISK_SUPER_BLOCK(sb);
-	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
+	struct reiserfs_super_block *rs = SB_DISK_SUPER_BLOCK(dentry->d_sb);
 
 	buf->f_namelen = (REISERFS_MAX_NAME(s->s_blocksize));
 	buf->f_bfree = sb_free_blocks(rs);
@@ -1892,8 +1891,9 @@ static int reiserfs_statfs(struct dentry
 	buf->f_bsize = dentry->d_sb->s_blocksize;
 	/* changed to accommodate gcc folks. */
 	buf->f_type = REISERFS_SUPER_MAGIC;
-	buf->f_fsid.val[0] = (u32)id;
-	buf->f_fsid.val[1] = (u32)(id >> 32);
+	buf->f_fsid.val[0] = (u32)crc32_le(0, rs->s_uuid, sizeof(rs->s_uuid)/2);
+	buf->f_fsid.val[1] = (u32)crc32_le(0, rs->s_uuid + sizeof(rs->s_uuid)/2,
+				sizeof(rs->s_uuid)/2);
 
 	return 0;
 }
_

Patches currently in -mm which might be from coly.li@suse.de are

fs-adfs-return-f_fsid-for-statfs2.patch
fs-affs-return-f_fsid-for-statfs2.patch
fs-befs-return-f_fsid-for-statfs2.patch
fs-cramfs-return-f_fsid-for-statfs2.patch
fs-efs-return-f_fsid-for-statfs2.patch
fs-fat-return-f_fsid-for-statfs2.patch
fs-hfs-return-f_fsid-for-statfs2.patch
fs-hfsplus-return-f_fsid-for-statfs2.patch
fs-hpfs-return-f_fsid-for-statfs2.patch
fs-isofs-return-f_fsid-for-statfs2.patch
fs-jfs-return-f_fsid-for-statfs2.patch
fs-minix-return-f_fsid-for-statfs2.patch
fs-omfs-return-f_fsid-for-statfs2.patch
fs-qnx4-return-f_fsid-for-statfs2.patch
fs-reiserfs-return-f_fsid-for-statfs2.patch
fs-reiserfs-return-f_fsid-for-statfs2-v2.patch
fs-romfs-return-f_fsid-for-statfs2.patch
fs-squashfs-return-f_fsid-for-statfs2.patch
fs-sysv-return-f_fsid-for-statfs2.patch
fs-udf-return-f_fsid-for-statfs2.patch
fs-ufs-return-f_fsid-for-statfs2.patch

