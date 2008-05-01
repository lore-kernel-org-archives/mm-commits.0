From: akpm@linux-foundation.org
Subject: - affs-be_add_cpu-conversion.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:21 -0700
Message-ID: <200805010932.m419WLYn030977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758033AbYEAJcc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:32:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     affs: be*_add_cpu conversion
has been removed from the -mm tree.  Its filename was
     affs-be_add_cpu-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: affs: be*_add_cpu conversion
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

 fs/affs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/affs/file.c~affs-be_add_cpu-conversion fs/affs/file.c
--- a/fs/affs/file.c~affs-be_add_cpu-conversion
+++ a/fs/affs/file.c
@@ -539,7 +539,7 @@ affs_extent_file_ofs(struct inode *inode
 		tmp = min(bsize - boff, newsize - size);
 		BUG_ON(boff + tmp > bsize || tmp > bsize);
 		memset(AFFS_DATA(bh) + boff, 0, tmp);
-		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(be32_to_cpu(AFFS_DATA_HEAD(bh)->size) + tmp);
+		be32_add_cpu(&AFFS_DATA_HEAD(bh)->size, tmp);
 		affs_fix_checksum(sb, bh);
 		mark_buffer_dirty_inode(bh, inode);
 		size += tmp;
@@ -680,7 +680,7 @@ static int affs_write_end_ofs(struct fil
 		tmp = min(bsize - boff, to - from);
 		BUG_ON(boff + tmp > bsize || tmp > bsize);
 		memcpy(AFFS_DATA(bh) + boff, data + from, tmp);
-		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(be32_to_cpu(AFFS_DATA_HEAD(bh)->size) + tmp);
+		be32_add_cpu(&AFFS_DATA_HEAD(bh)->size, tmp);
 		affs_fix_checksum(sb, bh);
 		mark_buffer_dirty_inode(bh, inode);
 		written += tmp;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
ntfs-le_add_cpu-conversion.patch

