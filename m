From: akpm@linux-foundation.org
Subject: + ufs-e_add_cpu-conversion.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:42:40 -0800
Message-ID: <200802140042.m1E0geEW022845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44994 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758781AbYBNAsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 19:48:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, dushistov@mail.ru


The patch titled
     ufs: [bl]e*_add_cpu conversion
has been added to the -mm tree.  Its filename is
     ufs-e_add_cpu-conversion.patch

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
Subject: ufs: [bl]e*_add_cpu conversion
From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
big/little_endian_variable = cpu_to_[bl]eX([bl]eX_to_cpu(big/little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	[bl]eX_add_cpu(&big/little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/swab.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/ufs/swab.h~ufs-e_add_cpu-conversion fs/ufs/swab.h
--- a/fs/ufs/swab.h~ufs-e_add_cpu-conversion
+++ a/fs/ufs/swab.h
@@ -80,18 +80,18 @@ static inline void
 fs32_add(struct super_block *sbp, __fs32 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		*(__le32 *)n = cpu_to_le32(le32_to_cpu(*(__le32 *)n)+d);
+		le32_add_cpu((__le32 *)n, d);
 	else
-		*(__be32 *)n = cpu_to_be32(be32_to_cpu(*(__be32 *)n)+d);
+		be32_add_cpu((__be32 *)n, d);
 }
 
 static inline void
 fs32_sub(struct super_block *sbp, __fs32 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		*(__le32 *)n = cpu_to_le32(le32_to_cpu(*(__le32 *)n)-d);
+		le32_add_cpu((__le32 *)n, -d);
 	else
-		*(__be32 *)n = cpu_to_be32(be32_to_cpu(*(__be32 *)n)-d);
+		be32_add_cpu((__be32 *)n, -d);
 }
 
 static inline u16
@@ -116,18 +116,18 @@ static inline void
 fs16_add(struct super_block *sbp, __fs16 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		*(__le16 *)n = cpu_to_le16(le16_to_cpu(*(__le16 *)n)+d);
+		le16_add_cpu((__le16 *)n, d);
 	else
-		*(__be16 *)n = cpu_to_be16(be16_to_cpu(*(__be16 *)n)+d);
+		be16_add_cpu((__be16 *)n, d);
 }
 
 static inline void
 fs16_sub(struct super_block *sbp, __fs16 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		*(__le16 *)n = cpu_to_le16(le16_to_cpu(*(__le16 *)n)-d);
+		le16_add_cpu((__le16 *)n, -d);
 	else
-		*(__be16 *)n = cpu_to_be16(be16_to_cpu(*(__be16 *)n)-d);
+		be16_add_cpu((__be16 *)n, -d);
 }
 
 #endif /* _UFS_SWAB_H */
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
udf-fix-directory-offset-handling.patch
udf-fix-udf_add_free_space.patch
git-gfs2-nmw.patch
jfs-le_add_cpu-conversion.patch
ntfs-le_add_cpu-conversion.patch
ocfs2-le_add_cpu-conversion.patch
scsi-le_add_cpu-conversion.patch
ipw2200-le_add_cpu-conversion.patch
ext2-le_add_cpu-conversion.patch
ufs-e_add_cpu-conversion.patch
ufs-e_add_cpu-conversion-in-return.patch
reiserfs-le_add_cpu-conversion.patch
ext4-le_add_cpu-conversion.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch
