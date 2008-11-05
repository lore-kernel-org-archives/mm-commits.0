From: akpm@linux-foundation.org
Subject: + jffs2-fix-race-condition-in-jffs2_lzo_compress.patch added to -mm tree
Date: Wed, 05 Nov 2008 12:12:40 -0800
Message-ID: <200811052012.mA5KCe10031209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755802AbYKEUNR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2008 15:13:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, rpurdie@openedhand.com


The patch titled
     jffs2: fix race condition in jffs2_lzo_compress()
has been added to the -mm tree.  Its filename is
     jffs2-fix-race-condition-in-jffs2_lzo_compress.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

fbdev-fix-fb_compat_ioctl-deadlocks.patch
jffs2-fix-race-condition-in-jffs2_lzo_compress.patch

