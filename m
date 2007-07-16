From: akpm@linux-foundation.org
Subject: - lzo1x-fix-lzo1x_worst_compress.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:12 -0700
Message-ID: <200707162048.l6GKmC5k001018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59913 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756463AbXGPUsc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 16:48:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nitingupta910@gmail.com, markus@oberhumer.com, rpurdie@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     LZO1X: fix lzo1x_worst_compress
has been removed from the -mm tree.  Its filename was
     lzo1x-fix-lzo1x_worst_compress.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: LZO1X: fix lzo1x_worst_compress
From: "Nitin Gupta" <nitingupta910@gmail.com>

This is a correction for a macro which gives worst case compressed data
size by LZO1X.

This patch was provided by the LZO author (Markus Oberhumer).

Signed-off-by: Nitin Gupta <nitingupta910@gmail.com>
Cc: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Cc: "Richard Purdie" <rpurdie@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lzo.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/lzo.h~lzo1x-fix-lzo1x_worst_compress include/linux/lzo.h
--- a/include/linux/lzo.h~lzo1x-fix-lzo1x_worst_compress
+++ a/include/linux/lzo.h
@@ -17,7 +17,7 @@
 #define LZO1X_MEM_COMPRESS	(16384 * sizeof(unsigned char *))
 #define LZO1X_1_MEM_COMPRESS	LZO1X_MEM_COMPRESS
 
-#define lzo1x_worst_compress(x) (x + (x / 64) + 16 + 3)
+#define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)
 
 /* This requires 'workmem' of size LZO1X_1_MEM_COMPRESS */
 int lzo1x_1_compress(const unsigned char *src, size_t src_len,
_

Patches currently in -mm which might be from nitingupta910@gmail.com are

origin.patch
