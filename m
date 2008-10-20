From: akpm@linux-foundation.org
Subject: - bitmask-remove-bitmap_scnprintf_len.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:49 -0700
Message-ID: <200810202036.m9KKanvu011462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754448AbYJTUqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, adobriyan@gmail.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     bitmask: remove bitmap_scnprintf_len()
has been removed from the -mm tree.  Its filename was
     bitmask-remove-bitmap_scnprintf_len.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitmask: remove bitmap_scnprintf_len()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

bitmap_scnprintf_len() is not used now, so we remove it.

Otherwise we have to maintain it and make its return
value always equal to bitmap_scnprintf()'s return value.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    1 -
 lib/bitmap.c           |   11 -----------
 2 files changed, 12 deletions(-)

diff -puN include/linux/bitmap.h~bitmask-remove-bitmap_scnprintf_len include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmask-remove-bitmap_scnprintf_len
+++ a/include/linux/bitmap.h
@@ -110,7 +110,6 @@ extern int __bitmap_weight(const unsigne
 
 extern int bitmap_scnprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
-extern int bitmap_scnprintf_len(unsigned int nr_bits);
 extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
 			unsigned long *dst, int nbits);
 extern int bitmap_parse_user(const char __user *ubuf, unsigned int ulen,
diff -puN lib/bitmap.c~bitmask-remove-bitmap_scnprintf_len lib/bitmap.c
--- a/lib/bitmap.c~bitmask-remove-bitmap_scnprintf_len
+++ a/lib/bitmap.c
@@ -316,17 +316,6 @@ int bitmap_scnprintf(char *buf, unsigned
 EXPORT_SYMBOL(bitmap_scnprintf);
 
 /**
- * bitmap_scnprintf_len - return buffer length needed to convert
- * bitmap to an ASCII hex string
- * @nr_bits: number of bits to be converted
- */
-int bitmap_scnprintf_len(unsigned int nr_bits)
-{
-	unsigned int nr_nibbles = ALIGN(nr_bits, 4) / 4;
-	return nr_nibbles + ALIGN(nr_nibbles, CHUNKSZ / 4) / (CHUNKSZ / 4) - 1;
-}
