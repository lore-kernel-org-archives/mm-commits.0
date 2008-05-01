From: akpm@linux-foundation.org
Subject: - hfs-hfsplus-be_add_cpu-conversion.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:23 -0700
Message-ID: <200805010932.m419WNiG030981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758033AbYEAJcd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:32:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfs/hfsplus: be*_add_cpu conversion
has been removed from the -mm tree.  Its filename was
     hfs-hfsplus-be_add_cpu-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
ntfs-le_add_cpu-conversion.patch

