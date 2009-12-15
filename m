From: akpm@linux-foundation.org
Subject: [merged] crc32-minor-optimizations-and-cleanup.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:59:06 -0800
Message-ID: <200912152159.nBFLx6rR015875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933836AbZLOWAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:00:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Joakim.Tjernlund@transmode.se, mm-commits@vger.kernel.org


The patch titled
     crc32: minor optimizations and cleanup
has been removed from the -mm tree.  Its filename was
     crc32-minor-optimizations-and-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crc32: minor optimizations and cleanup
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

Move common crc body to new function crc32_body() cleaup and micro
optimize crc32_body for speed and less size.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |  121 ++++++++++++++++++--------------------------------
 1 file changed, 44 insertions(+), 77 deletions(-)

diff -puN lib/crc32.c~crc32-minor-optimizations-and-cleanup lib/crc32.c
--- a/lib/crc32.c~crc32-minor-optimizations-and-cleanup
+++ a/lib/crc32.c
@@ -42,6 +42,48 @@ MODULE_AUTHOR("Matt Domsch <Matt_Domsch@
 MODULE_DESCRIPTION("Ethernet CRC32 calculations");
 MODULE_LICENSE("GPL");
 
+#if CRC_LE_BITS == 8 || CRC_BE_BITS == 8
+
+static inline u32
+crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 *tab)
+{
+# ifdef __LITTLE_ENDIAN
+#  define DO_CRC(x) crc = tab[(crc ^ (x)) & 255 ] ^ (crc >> 8)
+# else
+#  define DO_CRC(x) crc = tab[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
+# endif
+	const u32 *b = (const u32 *)buf;
+	size_t    rem_len;
+
+	/* Align it */
+	if (unlikely((long)b & 3 && len)) {
+		u8 *p = (u8 *)b;
+		do {
+			DO_CRC(*p++);
+		} while ((--len) && ((long)p)&3);
+		b = (u32 *)p;
+	}
+	rem_len = len & 3;
+	/* load data 32 bits wide, xor data 32 bits wide. */
+	len = len >> 2;
+	for (--b; len; --len) {
+		crc ^= *++b; /* use pre increment for speed */
+		DO_CRC(0);
+		DO_CRC(0);
+		DO_CRC(0);
+		DO_CRC(0);
+	}
+	len = rem_len;
+	/* And the last few bytes */
+	if (len) {
+		u8 *p = (u8 *)(b + 1) - 1;
+		do {
+			DO_CRC(*++p); /* use pre increment for speed */
+		} while (--len);
+	}
+	return crc;
+}
+#endif
 /**
  * crc32_le() - Calculate bitwise little-endian Ethernet AUTODIN II CRC32
  * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
@@ -72,48 +114,10 @@ u32 __pure crc32_le(u32 crc, unsigned ch
 u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
 # if CRC_LE_BITS == 8
-	const u32      *b =(u32 *)p;
 	const u32      *tab = crc32table_le;
 
-# ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[ (crc ^ (x)) & 255 ] ^ (crc>>8)
-# else
-#  define DO_CRC(x) crc = tab[ ((crc >> 24) ^ (x)) & 255] ^ (crc<<8)
-# endif
-
 	crc = __cpu_to_le32(crc);
-	/* Align it */
-	if(unlikely(((long)b)&3 && len)){
-		do {
-			u8 *p = (u8 *)b;
-			DO_CRC(*p++);
-			b = (void *)p;
-		} while ((--len) && ((long)b)&3 );
-	}
-	if(likely(len >= 4)){
-		/* load data 32 bits wide, xor data 32 bits wide. */
-		size_t save_len = len & 3;
-	        len = len >> 2;
-		--b; /* use pre increment below(*++b) for speed */
-		do {
-			crc ^= *++b;
-			DO_CRC(0);
-			DO_CRC(0);
-			DO_CRC(0);
-			DO_CRC(0);
-		} while (--len);
-		b++; /* point to next byte(s) */
-		len = save_len;
-	}
-	/* And the last few bytes */
-	if(len){
-		do {
-			u8 *p = (u8 *)b;
-			DO_CRC(*p++);
-			b = (void *)p;
-		} while (--len);
-	}
-
+	crc = crc32_body(crc, p, len, tab);
 	return __le32_to_cpu(crc);
 #undef ENDIAN_SHIFT
 #undef DO_CRC
@@ -170,47 +174,10 @@ u32 __pure crc32_be(u32 crc, unsigned ch
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 # if CRC_BE_BITS == 8
-	const u32      *b =(u32 *)p;
 	const u32      *tab = crc32table_be;
 
-# ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[ (crc ^ (x)) & 255 ] ^ (crc>>8)
-# else
-#  define DO_CRC(x) crc = tab[ ((crc >> 24) ^ (x)) & 255] ^ (crc<<8)
-# endif
-
 	crc = __cpu_to_be32(crc);
-	/* Align it */
-	if(unlikely(((long)b)&3 && len)){
-		do {
-			u8 *p = (u8 *)b;
-			DO_CRC(*p++);
-			b = (u32 *)p;
-		} while ((--len) && ((long)b)&3 );
-	}
-	if(likely(len >= 4)){
-		/* load data 32 bits wide, xor data 32 bits wide. */
-		size_t save_len = len & 3;
-	        len = len >> 2;
-		--b; /* use pre increment below(*++b) for speed */
-		do {
-			crc ^= *++b;
-			DO_CRC(0);
-			DO_CRC(0);
-			DO_CRC(0);
-			DO_CRC(0);
-		} while (--len);
-		b++; /* point to next byte(s) */
-		len = save_len;
-	}
-	/* And the last few bytes */
-	if(len){
-		do {
-			u8 *p = (u8 *)b;
-			DO_CRC(*p++);
-			b = (void *)p;
-		} while (--len);
-	}
+	crc = crc32_body(crc, p, len, tab);
 	return __be32_to_cpu(crc);
 #undef ENDIAN_SHIFT
 #undef DO_CRC
_

Patches currently in -mm which might be from Joakim.Tjernlund@transmode.se are

origin.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch

