From: akpm@linux-foundation.org
Subject: - sysv-e_add_cpu-conversion.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:27 -0700
Message-ID: <200805010932.m419WRrj030987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758036AbYEAJcc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:32:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     sysv: [bl]e*_add_cpu conversion
has been removed from the -mm tree.  Its filename was
     sysv-e_add_cpu-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
ntfs-le_add_cpu-conversion.patch

