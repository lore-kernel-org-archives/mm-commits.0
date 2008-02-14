From: akpm@linux-foundation.org
Subject: + hfs-hfsplus-be_add_cpu-conversion.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:24:33 -0800
Message-ID: <200802140024.m1E0OXg9021968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50188 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934533AbYBNAZO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 19:25:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, zippel@linux-m68k.org


The patch titled
     hfs/hfsplus: be*_add_cpu conversion
has been added to the -mm tree.  Its filename is
     hfs-hfsplus-be_add_cpu-conversion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfs/hfsplus: be*_add_cpu conversion
From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
big_endian_variable = cpu_to_beX(beX_to_cpu(big_endian_variable) +
					expression_in_cpu_byteorder);
with:
	beX_add_cpu(&big_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/mdb.c       |    2 +-
 fs/hfsplus/super.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/hfs/mdb.c~hfs-hfsplus-be_add_cpu-conversion fs/hfs/mdb.c
--- a/fs/hfs/mdb.c~hfs-hfsplus-be_add_cpu-conversion
+++ a/fs/hfs/mdb.c
@@ -215,7 +215,7 @@ int hfs_mdb_get(struct super_block *sb)
 		attrib &= cpu_to_be16(~HFS_SB_ATTRIB_UNMNT);
 		attrib |= cpu_to_be16(HFS_SB_ATTRIB_INCNSTNT);
 		mdb->drAtrb = attrib;
-		mdb->drWrCnt = cpu_to_be32(be32_to_cpu(mdb->drWrCnt) + 1);
+		be32_add_cpu(&mdb->drWrCnt, 1);
 		mdb->drLsMod = hfs_mtime();
 
 		mark_buffer_dirty(HFS_SB(sb)->mdb_bh);
diff -puN fs/hfsplus/super.c~hfs-hfsplus-be_add_cpu-conversion fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfs-hfsplus-be_add_cpu-conversion
+++ a/fs/hfsplus/super.c
@@ -423,7 +423,7 @@ static int hfsplus_fill_super(struct sup
 	 */
 	vhdr->last_mount_vers = cpu_to_be32(HFSP_MOUNT_VERSION);
 	vhdr->modify_date = hfsp_now2mt();
-	vhdr->write_count = cpu_to_be32(be32_to_cpu(vhdr->write_count) + 1);
+	be32_add_cpu(&vhdr->write_count, 1);
 	vhdr->attributes &= cpu_to_be32(~HFSPLUS_VOL_UNMNT);
 	vhdr->attributes |= cpu_to_be32(HFSPLUS_VOL_INCNSTNT);
 	mark_buffer_dirty(HFSPLUS_SB(sb).s_vhbh);
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
udf-fix-directory-offset-handling.patch
udf-fix-udf_add_free_space.patch
git-gfs2-nmw.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
ipw2200-le_add_cpu-conversion.patch
scsi-le_add_cpu-conversion.patch
ext2-le_add_cpu-conversion.patch
ext4-le_add_cpu-conversion.patch
jfs-le_add_cpu-conversion.patch
ntfs-le_add_cpu-conversion.patch
ocfs2-le_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
reiserfs-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch
ufs-e_add_cpu-conversion.patch
ufs-e_add_cpu-conversion-in-return.patch
