From: akpm@linux-foundation.org
Subject: - cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:03 -0700
Message-ID: <200805132134.m4DLY3Vu000883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759164AbYEMVeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, adobriyan@gmail.com, bert.wesarg@googlemail.com, travis@sgi.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cpumask: remove bitmap_scnprintf_len and cpumask_scnprintf_len
has been removed from the -mm tree.  Its filename was
     cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpumask: remove bitmap_scnprintf_len and cpumask_scnprintf_len
From: Paul Jackson <pj@sgi.com>

They aren't used.  They were briefly used as part of some other patches to
provide an alternative format for displaying some /proc and /sys cpumasks. 
They probably should have been removed when those other patches were dropped,
in favor of a different solution.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: "Mike Travis" <travis@sgi.com>
Cc: "Bert Wesarg" <bert.wesarg@googlemail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h  |    1 -
 include/linux/cpumask.h |    7 -------
 lib/bitmap.c            |   16 ----------------
 3 files changed, 24 deletions(-)

diff -puN include/linux/bitmap.h~cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len include/linux/bitmap.h
--- a/include/linux/bitmap.h~cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len
+++ a/include/linux/bitmap.h
@@ -110,7 +110,6 @@ extern int __bitmap_weight(const unsigne
 
 extern int bitmap_scnprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
-extern int bitmap_scnprintf_len(unsigned int len);
 extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
 			unsigned long *dst, int nbits);
 extern int bitmap_parse_user(const char __user *ubuf, unsigned int ulen,
diff -puN include/linux/cpumask.h~cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len
+++ a/include/linux/cpumask.h
@@ -289,13 +289,6 @@ static inline int __cpumask_scnprintf(ch
 	return bitmap_scnprintf(buf, len, srcp->bits, nbits);
 }
 
-#define cpumask_scnprintf_len(len) \
-			__cpumask_scnprintf_len((len))
-static inline int __cpumask_scnprintf_len(int len)
-{
-	return bitmap_scnprintf_len(len);
-}
-
 #define cpumask_parse_user(ubuf, ulen, dst) \
 			__cpumask_parse_user((ubuf), (ulen), &(dst), NR_CPUS)
 static inline int __cpumask_parse_user(const char __user *buf, int len,
diff -puN lib/bitmap.c~cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len lib/bitmap.c
--- a/lib/bitmap.c~cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len
+++ a/lib/bitmap.c
@@ -316,22 +316,6 @@ int bitmap_scnprintf(char *buf, unsigned
 EXPORT_SYMBOL(bitmap_scnprintf);
 
 /**
- * bitmap_scnprintf_len - return buffer length needed to convert
- * bitmap to an ASCII hex string.
- * @len: number of bits to be converted
- */
-int bitmap_scnprintf_len(unsigned int len)
-{
-	/* we need 9 chars per word for 32 bit words (8 hexdigits + sep/null) */
-	int bitslen = ALIGN(len, CHUNKSZ);
-	int wordlen = CHUNKSZ / 4;
-	int buflen = (bitslen / wordlen) * (wordlen + 1) * sizeof(char);
-
-	return buflen;
-}
-EXPORT_SYMBOL(bitmap_scnprintf_len);
