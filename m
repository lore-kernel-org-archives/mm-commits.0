From: akpm@linux-foundation.org
Subject: [merged] fs-adfs-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:06 -0700
Message-ID: <200904061938.n36Jc6IE013256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbZDFTuS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:50:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, adilger@sun.com, al@alarsen.net, dushistov@mail.ru, hch@infradead.org, hirofumi@mail.parknet.co.jp, jack@suse.cz, jamie@shareable.org, me@bobcopeland.com, mikulas@art


The patch titled
     fs/adfs: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-adfs-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/adfs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Currently many file systems in Linux kernel do not return f_fsid in statfs
info, the value is set as 0 in vfs layer.  Anyway, in some conditions,
f_fsid from statfs(2) is useful, especially being used as (f_fsid, ino)
pair to uniquely identify a file.

Basic idea of the patches is generating a unique fs ID by
huge_encode_dev(sb->s_bdev->bd_dev) during file system mounting life time
(no endian consistent issue).  sb is a point of struct super_block of
current mounted file system being accessed by statfs(2).


This patch:

Make adfs return f_fsid info for statfs(2), and do a little variable
renaming in adfs_statfs().

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: "Sergey S. Kostyliov" <rathamahata@php4.ru>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Bob Copeland <me@bobcopeland.com>
Cc: Anders Larsen <al@alarsen.net>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Jan Kara <jack@suse.cz>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Jamie Lokier <jamie@shareable.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/super.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN fs/adfs/super.c~fs-adfs-return-f_fsid-for-statfs2 fs/adfs/super.c
--- a/fs/adfs/super.c~fs-adfs-return-f_fsid-for-statfs2
+++ a/fs/adfs/super.c
@@ -219,16 +219,20 @@ static int adfs_remount(struct super_blo
 
 static int adfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct adfs_sb_info *asb = ADFS_SB(dentry->d_sb);
+	struct super_block *sb = dentry->d_sb;
+	struct adfs_sb_info *sbi = ADFS_SB(sb);
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	buf->f_type    = ADFS_SUPER_MAGIC;
-	buf->f_namelen = asb->s_namelen;
-	buf->f_bsize   = dentry->d_sb->s_blocksize;
-	buf->f_blocks  = asb->s_size;
-	buf->f_files   = asb->s_ids_per_zone * asb->s_map_size;
+	buf->f_namelen = sbi->s_namelen;
+	buf->f_bsize   = sb->s_blocksize;
+	buf->f_blocks  = sbi->s_size;
+	buf->f_files   = sbi->s_ids_per_zone * sbi->s_map_size;
 	buf->f_bavail  =
-	buf->f_bfree   = adfs_map_free(dentry->d_sb);
+	buf->f_bfree   = adfs_map_free(sb);
 	buf->f_ffree   = (long)(buf->f_bfree * buf->f_files) / (long)buf->f_blocks;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 
 	return 0;
 }
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

