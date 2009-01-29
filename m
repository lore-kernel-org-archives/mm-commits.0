From: akpm@linux-foundation.org
Subject: + fs-jfs-return-f_fsid-for-statfs2-v3.patch added to -mm tree
Date: Wed, 28 Jan 2009 23:31:04 -0800
Message-ID: <200901290731.n0T7V4lv011369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755609AbZA2HbP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 02:31:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: coly.li@suse.de, shaggy@austin.ibm.com


The patch titled
     fs/jfs: return f_fsid for statfs(2), v3
has been added to the -mm tree.  Its filename is
     fs-jfs-return-f_fsid-for-statfs2-v3.patch

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
Subject: fs/jfs: return f_fsid for statfs(2), v3
From: Coly Li <coly.li@suse.de>

Make jfs return f_fsid info for statfs(2).  By Andreas' suggestion, this
patch populates a persistent f_fsid between boots/mounts with help of
on-disk uuid record.

Signed-off-by: Coly Li <coly.li@suse.de>
Acked-by: Dave Kleikamp <shaggy@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/super.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/jfs/super.c~fs-jfs-return-f_fsid-for-statfs2-v3 fs/jfs/super.c
--- a/fs/jfs/super.c~fs-jfs-return-f_fsid-for-statfs2-v3
+++ a/fs/jfs/super.c
@@ -29,6 +29,7 @@
 #include <linux/posix_acl.h>
 #include <linux/buffer_head.h>
 #include <linux/exportfs.h>
+#include <linux/crc32.h>
 #include <asm/uaccess.h>
 #include <linux/seq_file.h>
 
@@ -143,10 +144,8 @@ static void jfs_destroy_inode(struct ino
 
 static int jfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct super_block *sb = dentry->d_sb;
-	struct jfs_sb_info *sbi = JFS_SBI(sb);
+	struct jfs_sb_info *sbi = JFS_SBI(dentry->d_sb);
 	s64 maxinodes;
-	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 	struct inomap *imap = JFS_IP(sbi->ipimap)->i_imap;
 
 	jfs_info("In jfs_statfs");
@@ -170,8 +169,9 @@ static int jfs_statfs(struct dentry *den
 	buf->f_files = maxinodes;
 	buf->f_ffree = maxinodes - (atomic_read(&imap->im_numinos) -
 				    atomic_read(&imap->im_numfree));
-	buf->f_fsid.val[0] = (u32)id;
-	buf->f_fsid.val[1] = (u32)(id >> 32);
+	buf->f_fsid.val[0] = (u32)crc32_le(0, sbi->uuid, sizeof(sbi->uuid)/2);
+	buf->f_fsid.val[1] = (u32)crc32_le(0, sbi->uuid + sizeof(sbi->uuid)/2,
+					sizeof(sbi->uuid)/2);
 
 	buf->f_namelen = JFS_NAME_MAX;
 	return 0;
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
fs-jfs-return-f_fsid-for-statfs2-v3.patch
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

