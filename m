From: akpm@linux-foundation.org
Subject: + fs-hpfs-return-f_fsid-for-statfs2.patch added to -mm tree
Date: Tue, 27 Jan 2009 00:00:15 -0800
Message-ID: <200901270800.n0R80FAO032449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbZA0IAv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 03:00:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: coly.li@suse.de, mikulas@artax.karlin.mff.cuni.cz


The patch titled
     fs/hpfs: return f_fsid for statfs(2)
has been added to the -mm tree.  Its filename is
     fs-hpfs-return-f_fsid-for-statfs2.patch

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
Subject: fs/hpfs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make hpfs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/super.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/hpfs/super.c~fs-hpfs-return-f_fsid-for-statfs2 fs/hpfs/super.c
--- a/fs/hpfs/super.c~fs-hpfs-return-f_fsid-for-statfs2
+++ a/fs/hpfs/super.c
@@ -136,6 +136,7 @@ static int hpfs_statfs(struct dentry *de
 {
 	struct super_block *s = dentry->d_sb;
 	struct hpfs_sb_info *sbi = hpfs_sb(s);
+	u64 id = huge_encode_dev(s->s_bdev->bd_dev);
 	lock_kernel();
 
 	/*if (sbi->sb_n_free == -1) {*/
@@ -149,6 +150,8 @@ static int hpfs_statfs(struct dentry *de
 	buf->f_bavail = sbi->sb_n_free;
 	buf->f_files = sbi->sb_dirband_size / 4;
 	buf->f_ffree = sbi->sb_n_free_dnodes;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = 254;
 
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

