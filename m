From: akpm@linux-foundation.org
Subject: + fs-ufs-return-f_fsid-for-statfs2.patch added to -mm tree
Date: Tue, 27 Jan 2009 00:00:32 -0800
Message-ID: <200901270800.n0R80W2t000313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752311AbZA0IKM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 03:10:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: coly.li@suse.de, dushistov@mail.ru


The patch titled
     fs/ufs: return f_fsid for statfs(2)
has been added to the -mm tree.  Its filename is
     fs-ufs-return-f_fsid-for-statfs2.patch

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
Subject: fs/ufs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make ufs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ufs/super.c~fs-ufs-return-f_fsid-for-statfs2 fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-return-f_fsid-for-statfs2
+++ a/fs/ufs/super.c
@@ -1268,6 +1268,7 @@ static int ufs_statfs(struct dentry *den
 	struct ufs_super_block_first *usb1;
 	struct ufs_super_block_second *usb2;
 	struct ufs_super_block_third *usb3;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	lock_kernel();
 
@@ -1290,6 +1291,8 @@ static int ufs_statfs(struct dentry *den
 		? (buf->f_bfree - (((long)buf->f_blocks / 100) * uspi->s_minfree)) : 0;
 	buf->f_files = uspi->s_ncg * uspi->s_ipg;
 	buf->f_namelen = UFS_MAXNAMLEN;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 
 	unlock_kernel();
 
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
fs-romfs-return-f_fsid-for-statfs2.patch
fs-squashfs-return-f_fsid-for-statfs2.patch
fs-sysv-return-f_fsid-for-statfs2.patch
fs-udf-return-f_fsid-for-statfs2.patch
fs-ufs-return-f_fsid-for-statfs2.patch

