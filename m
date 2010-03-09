From: akpm@linux-foundation.org
Subject: [merged] crc32-some-minor-cleanups.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:09:21 -0800
Message-ID: <201003091909.o29J9L0r031515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755848Ab0CITWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Joakim.Tjernlund@transmode.se, mm-commits@vger.kernel.org


The patch titled
     crc32: some minor cleanups
has been removed from the -mm tree.  Its filename was
     crc32-some-minor-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crc32: some minor cleanups
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff -puN lib/crc32.c~crc32-some-minor-cleanups lib/crc32.c
--- a/lib/crc32.c~crc32-some-minor-cleanups
+++ a/lib/crc32.c
@@ -30,11 +30,15 @@
 #include <asm/atomic.h>
 #include "crc32defs.h"
 #if CRC_LE_BITS == 8
-#define tole(x) __constant_cpu_to_le32(x)
-#define tobe(x) __constant_cpu_to_be32(x)
+# define tole(x) __constant_cpu_to_le32(x)
 #else
-#define tole(x) (x)
-#define tobe(x) (x)
+# define tole(x) (x)
+#endif
+
+#if CRC_BE_BITS == 8
+# define tobe(x) __constant_cpu_to_be32(x)
+#else
+# define tobe(x) (x)
 #endif
 #include "crc32table.h"
 
@@ -52,20 +56,19 @@ crc32_body(u32 crc, unsigned char const 
 # else
 #  define DO_CRC(x) crc = tab[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
 # endif
-	const u32 *b = (const u32 *)buf;
+	const u32 *b;
 	size_t    rem_len;
 
 	/* Align it */
-	if (unlikely((long)b & 3 && len)) {
-		u8 *p = (u8 *)b;
+	if (unlikely((long)buf & 3 && len)) {
 		do {
-			DO_CRC(*p++);
-		} while ((--len) && ((long)p)&3);
-		b = (u32 *)p;
+			DO_CRC(*buf++);
+		} while ((--len) && ((long)buf)&3);
 	}
 	rem_len = len & 3;
 	/* load data 32 bits wide, xor data 32 bits wide. */
 	len = len >> 2;
+	b = (const u32 *)buf;
 	for (--b; len; --len) {
 		crc ^= *++b; /* use pre increment for speed */
 		DO_CRC(0);
@@ -82,6 +85,7 @@ crc32_body(u32 crc, unsigned char const 
 		} while (--len);
 	}
 	return crc;
+#undef DO_CRC
 }
 #endif
 /**
@@ -119,9 +123,6 @@ u32 __pure crc32_le(u32 crc, unsigned ch
 	crc = __cpu_to_le32(crc);
 	crc = crc32_body(crc, p, len, tab);
 	return __le32_to_cpu(crc);
-#undef ENDIAN_SHIFT
-#undef DO_CRC
-
 # elif CRC_LE_BITS == 4
 	while (len--) {
 		crc ^= *p++;
@@ -179,9 +180,6 @@ u32 __pure crc32_be(u32 crc, unsigned ch
 	crc = __cpu_to_be32(crc);
 	crc = crc32_body(crc, p, len, tab);
 	return __be32_to_cpu(crc);
-#undef ENDIAN_SHIFT
-#undef DO_CRC
