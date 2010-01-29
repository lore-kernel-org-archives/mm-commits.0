From: akpm@linux-foundation.org
Subject: [to-be-updated] zlib-make-new-optimized-inflate-endian-independent.patch removed from -mm tree
Date: Fri, 29 Jan 2010 15:45:20 -0800
Message-ID: <201001292345.o0TNjKbg016951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572Ab0A2XqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 18:46:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joakim.tjernlund@transmode.se, Joakim.Tjernlund@transmode.se, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     zlib: make new optimized inflate endian independent
has been removed from the -mm tree.  Its filename was
     zlib-make-new-optimized-inflate-endian-independent.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: zlib: make new optimized inflate endian independent
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>

Commit 6846ee5ca68d81e6baccf0d56221d7a00c1be18b ("zlib: Fix build of
powerpc boot wrapper") made the new optimized inflate only available on
arch's that define CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS.  This fixes it
by defining our own endian independent versions of unaligned access.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_inflate/inffast.c |   70 +++++++++++++++--------------------
 1 file changed, 30 insertions(+), 40 deletions(-)

diff -puN lib/zlib_inflate/inffast.c~zlib-make-new-optimized-inflate-endian-independent lib/zlib_inflate/inffast.c
--- a/lib/zlib_inflate/inffast.c~zlib-make-new-optimized-inflate-endian-independent
+++ a/lib/zlib_inflate/inffast.c
@@ -8,21 +8,6 @@
 #include "inflate.h"
 #include "inffast.h"
 
-/* Only do the unaligned "Faster" variant when
- * CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is set
- *
- * On powerpc, it won't be as we don't include autoconf.h
- * automatically for the boot wrapper, which is intended as
- * we run in an environment where we may not be able to deal
- * with (even rare) alignment faults. In addition, we do not
- * define __KERNEL__ for arch/powerpc/boot unlike x86
- */
-
-#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-#include <asm/unaligned.h>
-#include <asm/byteorder.h>
-#endif
-
 #ifndef ASMINF
 
 /* Allow machine dependent optimization for post-increment or pre-increment.
@@ -36,14 +21,31 @@
    - Pentium III (Anderson)
    - M68060 (Nikl)
  */
+union uu {
+	unsigned short us;
+	unsigned char b[2];
+};
+
+/* Endian independed version */
+static inline unsigned short
+get_unaligned16(const unsigned short *p)
+{
+	union uu  mm;
+	unsigned char *b = (unsigned char *)p;
+
+	mm.b[0] = b[0];
+	mm.b[1] = b[1];
+	return mm.us;
+}
+
 #ifdef POSTINC
 #  define OFF 0
 #  define PUP(a) *(a)++
-#  define UP_UNALIGNED(a) get_unaligned((a)++)
+#  define UP_UNALIGNED(a) get_unaligned16((a)++)
 #else
 #  define OFF 1
 #  define PUP(a) *++(a)
-#  define UP_UNALIGNED(a) get_unaligned(++(a))
+#  define UP_UNALIGNED(a) get_unaligned16(++(a))
 #endif
 
 /*
@@ -256,7 +258,6 @@ void inflate_fast(z_streamp strm, unsign
                     }
                 }
                 else {
-#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 		    unsigned short *sout;
 		    unsigned long loops;
 
@@ -274,7 +275,11 @@ void inflate_fast(z_streamp strm, unsign
 			sfrom = (unsigned short *)(from - OFF);
 			loops = len >> 1;
 			do
+#ifdef  CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+			    PUP(sout) = PUP(sfrom);
+#else
 			    PUP(sout) = UP_UNALIGNED(sfrom);
+#endif
 			while (--loops);
 			out = (unsigned char *)sout + OFF;
 			from = (unsigned char *)sfrom + OFF;
@@ -282,14 +287,13 @@ void inflate_fast(z_streamp strm, unsign
 			unsigned short pat16;
 
 			pat16 = *(sout-2+2*OFF);
-			if (dist == 1)
-#if defined(__BIG_ENDIAN)
-			    pat16 = (pat16 & 0xff) | ((pat16 & 0xff) << 8);
-#elif defined(__LITTLE_ENDIAN)
-			    pat16 = (pat16 & 0xff00) | ((pat16 & 0xff00) >> 8);
-#else
-#error __BIG_ENDIAN nor __LITTLE_ENDIAN is defined
-#endif
+			if (dist == 1) {
+				union uu mm;
+				/* copy one char pattern to both bytes */
+				mm.us = pat16;
+				mm.b[0] = mm.b[1];
+				pat16 = mm.us;
+			}
 			loops = len >> 1;
 			do
 			    PUP(sout) = pat16;
@@ -298,20 +302,6 @@ void inflate_fast(z_streamp strm, unsign
 		    }
 		    if (len & 1)
 			PUP(out) = PUP(from);
-#else /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
-                    from = out - dist;          /* copy direct from output */
-                    do {                        /* minimum length is three */
-			 PUP(out) = PUP(from);
-			 PUP(out) = PUP(from);
-			 PUP(out) = PUP(from);
-			 len -= 3;
-                    } while (len > 2);
-                    if (len) {
-			 PUP(out) = PUP(from);
-			 if (len > 1)
-			     PUP(out) = PUP(from);
-                    }
-#endif /* !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
                 }
             }
             else if ((op & 64) == 0) {          /* 2nd level distance code */
_

Patches currently in -mm which might be from joakim.tjernlund@transmode.se are

powerpc-fix-build-breakage-due-to-incorrect-location-of-autoconfh.patch
zlib-make-new-optimized-inflate-endian-independent.patch
zlib-make-new-optimized-inflate-endian-independent-checkpatch-fixes.patch

