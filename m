From: akpm@linux-foundation.org
Subject: + sysv-e_add_cpu-conversion.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:24:53 -0800
Message-ID: <200802140024.m1E0Orjt022003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50615 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934818AbYBNA3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 19:29:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, hch@infradead.org


The patch titled
     sysv: [bl]e*_add_cpu conversion
has been added to the -mm tree.  Its filename is
     sysv-e_add_cpu-conversion.patch

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
Subject: sysv: [bl]e*_add_cpu conversion
From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
big/little_endian_variable = cpu_to_[bl]eX([bl]eX_to_cpu(big/little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	[bl]eX_add_cpu(&big/little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/sysv.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/sysv/sysv.h~sysv-e_add_cpu-conversion fs/sysv/sysv.h
--- a/fs/sysv/sysv.h~sysv-e_add_cpu-conversion
+++ a/fs/sysv/sysv.h
@@ -217,9 +217,9 @@ static inline __fs32 fs32_add(struct sys
 	if (sbi->s_bytesex == BYTESEX_PDP)
 		*(__u32*)n = PDP_swab(PDP_swab(*(__u32*)n)+d);
 	else if (sbi->s_bytesex == BYTESEX_LE)
-		*(__le32*)n = cpu_to_le32(le32_to_cpu(*(__le32*)n)+d);
+		le32_add_cpu((__le32 *)n, d);
 	else
-		*(__be32*)n = cpu_to_be32(be32_to_cpu(*(__be32*)n)+d);
+		be32_add_cpu((__be32 *)n, d);
 	return *n;
 }
 
@@ -242,9 +242,9 @@ static inline __fs16 cpu_to_fs16(struct 
 static inline __fs16 fs16_add(struct sysv_sb_info *sbi, __fs16 *n, int d)
 {
 	if (sbi->s_bytesex != BYTESEX_BE)
-		*(__le16*)n = cpu_to_le16(le16_to_cpu(*(__le16 *)n)+d);
+		le16_add_cpu((__le16 *)n, d);
 	else
-		*(__be16*)n = cpu_to_be16(be16_to_cpu(*(__be16 *)n)+d);
+		be16_add_cpu((__be16 *)n, d);
 	return *n;
 }
 
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
