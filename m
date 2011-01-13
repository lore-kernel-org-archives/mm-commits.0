From: akpm@linux-foundation.org
Subject: [merged] decompressors-check-for-write-errors-in-decompress_unlzoc.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:30 -0800
Message-ID: <201101132013.p0DKDBSR030367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757409Ab1AMUOM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:14:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     Decompressors: check for write errors in decompress_unlzo.c
has been removed from the -mm tree.  Its filename was
     decompressors-check-for-write-errors-in-decompress_unlzoc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Decompressors: check for write errors in decompress_unlzo.c
From: Lasse Collin <lasse.collin@tukaani.org>

The return value of flush() is not checked in unlzo().  This means that
the decompressor won't stop even if the caller doesn't want more data. 
This can happen e.g.  with a corrupt LZO-compressed initramfs image.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/decompress_unlzo.c~decompressors-check-for-write-errors-in-decompress_unlzoc lib/decompress_unlzo.c
--- a/lib/decompress_unlzo.c~decompressors-check-for-write-errors-in-decompress_unlzoc
+++ a/lib/decompress_unlzo.c
@@ -187,8 +187,8 @@ STATIC inline int INIT unlzo(u8 *input, 
 			}
 		}
 
-		if (flush)
-			flush(out_buf, dst_len);
+		if (flush && flush(out_buf, dst_len) != dst_len)
+			goto exit_2;
 		if (output)
 			out_buf += dst_len;
 		if (posp)
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

origin.patch

