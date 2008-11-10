From: akpm@linux-foundation.org
Subject: - jffs2-fix-race-condition-in-jffs2_lzo_compress.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:34:30 -0800
Message-ID: <200811102034.mAAKYUV9025120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381AbYKJUiw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:38:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, rpurdie@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     jffs2: fix race condition in jffs2_lzo_compress()
has been removed from the -mm tree.  Its filename was
     jffs2-fix-race-condition-in-jffs2_lzo_compress.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jffs2: fix race condition in jffs2_lzo_compress()
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

deflate_mutex protects the globals lzo_mem and lzo_compress_buf.  However,
jffs2_lzo_compress() unlocks deflate_mutex _before_ it has copied out the
compressed data from lzo_compress_buf.  Correct this by moving the mutex
unlock after the copy.

In addition, document what deflate_mutex actually protects.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Richard Purdie <rpurdie@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/compr_lzo.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN fs/jffs2/compr_lzo.c~jffs2-fix-race-condition-in-jffs2_lzo_compress fs/jffs2/compr_lzo.c
--- a/fs/jffs2/compr_lzo.c~jffs2-fix-race-condition-in-jffs2_lzo_compress
+++ a/fs/jffs2/compr_lzo.c
@@ -19,7 +19,7 @@
 
 static void *lzo_mem;
 static void *lzo_compress_buf;
-static DEFINE_MUTEX(deflate_mutex);
+static DEFINE_MUTEX(deflate_mutex);	/* for lzo_mem and lzo_compress_buf */
 
 static void free_workspace(void)
 {
@@ -49,18 +49,21 @@ static int jffs2_lzo_compress(unsigned c
 
 	mutex_lock(&deflate_mutex);
 	ret = lzo1x_1_compress(data_in, *sourcelen, lzo_compress_buf, &compress_size, lzo_mem);
-	mutex_unlock(&deflate_mutex);
-
 	if (ret != LZO_E_OK)
-		return -1;
+		goto fail;
 
 	if (compress_size > *dstlen)
-		return -1;
+		goto fail;
 
 	memcpy(cpage_out, lzo_compress_buf, compress_size);
-	*dstlen = compress_size;
+	mutex_unlock(&deflate_mutex);
 
+	*dstlen = compress_size;
 	return 0;
+
+ fail:
+	mutex_unlock(&deflate_mutex);
+	return -1;
 }
 
 static int jffs2_lzo_decompress(unsigned char *data_in, unsigned char *cpage_out,
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are


