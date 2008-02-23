From: akpm@linux-foundation.org
Subject: - ocfs2-le_add_cpu-conversion.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:25 -0800
Message-ID: <200802232022.m1NKMPVS013422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761715AbYBWU26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, kurt.hackel@oracle.com, mark.fasheh@oracle.com, mm-commits@vger.kernel.org


The patch titled
     ocfs2: le*_add_cpu conversion
has been removed from the -mm tree.  Its filename was
     ocfs2-le_add_cpu-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ocfs2: le*_add_cpu conversion
From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c        |    5 ++---
 fs/ocfs2/localalloc.c |    3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/dir.c~ocfs2-le_add_cpu-conversion fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-le_add_cpu-conversion
+++ a/fs/ocfs2/dir.c
@@ -390,9 +390,8 @@ static int __ocfs2_delete_entry(handle_t
 				goto bail;
 			}
 			if (pde)
-				pde->rec_len =
-					cpu_to_le16(le16_to_cpu(pde->rec_len) +
-						    le16_to_cpu(de->rec_len));
+				le16_add_cpu(&pde->rec_len,
+						le16_to_cpu(de->rec_len));
 			else
 				de->inode = 0;
 			dir->i_version++;
diff -puN fs/ocfs2/localalloc.c~ocfs2-le_add_cpu-conversion fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c~ocfs2-le_add_cpu-conversion
+++ a/fs/ocfs2/localalloc.c
@@ -585,8 +585,7 @@ int ocfs2_claim_local_alloc_bits(struct 
 	while(bits_wanted--)
 		ocfs2_set_bit(start++, bitmap);
 
-	alloc->id1.bitmap1.i_used = cpu_to_le32(*num_bits +
-				le32_to_cpu(alloc->id1.bitmap1.i_used));
+	le32_add_cpu(&alloc->id1.bitmap1.i_used, *num_bits);
 
 	status = ocfs2_journal_dirty(handle, osb->local_alloc_bh);
 	if (status < 0) {
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-jfs.patch
qla3xxx-convert-byte-order-of-constant-instead-of-variable.patch
ntfs-le_add_cpu-conversion.patch
git-ocfs2.patch
scsi-le_add_cpu-conversion.patch
ipw2200-le_add_cpu-conversion.patch
ext2-le_add_cpu-conversion.patch
ext2-convert-byte-order-of-constant-instead-of-variable.patch
ext3-convert-byte-order-of-constant-instead-of-variable.patch
ufs-e_add_cpu-conversion.patch
reiserfs-le_add_cpu-conversion.patch
ext4-le_add_cpu-conversion.patch
ext4-convert-byte-order-of-constant-instead-of-variable.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch
