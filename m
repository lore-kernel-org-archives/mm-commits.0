From: akpm@linux-foundation.org
Subject: [to-be-updated] zlib-optimize-inffast-even-more.patch removed from -mm tree
Date: Fri, 13 Nov 2009 14:45:44 -0800
Message-ID: <200911132245.nADMji0f012269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932168AbZKMWqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 17:46:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Joakim.Tjernlund@transmode.se, alain@knaff.lu, dwmw2@infradead.org, hpa@zytor.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     zlib: optimize inffast even more
has been removed from the -mm tree.  Its filename was
     zlib-optimize-inffast-even-more.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: zlib: optimize inffast even more
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

This improves zlib: Optimize inffast when copying direct from output and
gives another 3-4% improvement for my MPC8321 target.  Does not need
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS, uses get_unaligned() but only in
one place.

The copy loop just above this one can also use this optimization, but I
havn't done so as I have not tested if it is a win there too.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: Alain Knaff <alain@knaff.lu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/Makefile |    1 
 lib/zlib_inflate/inffast.c |   54 +++++++++++++++++------------------
 2 files changed, 28 insertions(+), 27 deletions(-)

diff -puN arch/powerpc/boot/Makefile~zlib-optimize-inffast-even-more arch/powerpc/boot/Makefile
--- a/arch/powerpc/boot/Makefile~zlib-optimize-inffast-even-more
+++ a/arch/powerpc/boot/Makefile
@@ -34,6 +34,7 @@ BOOTCFLAGS	+= -fno-stack-protector
 endif
 
 BOOTCFLAGS	+= -I$(obj) -I$(srctree)/$(obj)
+BOOTCFLAGS	+= -Iarch/powerpc/include
 
 DTS_FLAGS	?= -p 1024
 
diff -puN lib/zlib_inflate/inffast.c~zlib-optimize-inffast-even-more lib/zlib_inflate/inffast.c
--- a/lib/zlib_inflate/inffast.c~zlib-optimize-inffast-even-more
+++ a/lib/zlib_inflate/inffast.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/zutil.h>
+#include <asm/unaligned.h>
 #include "inftrees.h"
 #include "inflate.h"
 #include "inffast.h"
@@ -24,9 +25,11 @@
 #ifdef POSTINC
 #  define OFF 0
 #  define PUP(a) *(a)++
+#  define UP_UNALIGNED(a) get_unaligned((a)++)
 #else
 #  define OFF 1
 #  define PUP(a) *++(a)
+#  define UP_UNALIGNED(a) get_unaligned(++(a))
 #endif
 
 /*
@@ -240,52 +243,49 @@ void inflate_fast(z_streamp strm, unsign
                 }
                 else {
                     from = out - dist;          /* copy direct from output */
-#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
                     /* minimum length is three */
 		    if (dist > 2 ) {
-			unsigned short *sout = (unsigned short *)(out - OFF);
-			unsigned short *sfrom = (unsigned short *)(from - OFF);
-			unsigned long loops = len >> 1;
+			unsigned short *sout;
+			unsigned short *sfrom;
+			unsigned long loops;
 
+			/* Align out addr, only sfrom might be unaligned */
+			if (!((long)(out - 1 + OFF)) & 1) {
+			    PUP(out) = PUP(from);
+			    len--;
+			}
+			sout = (unsigned short *)(out - OFF);
+			sfrom = (unsigned short *)(from - OFF);
+			loops = len >> 1;
 			do
-			    PUP(sout) = PUP(sfrom);
+			    PUP(sout) = UP_UNALIGNED(sfrom);
 			while (--loops);
 			out = (unsigned char *)sout + OFF;
 			from = (unsigned char *)sfrom + OFF;
 			if (len & 1)
 			    PUP(out) = PUP(from);
-		    } else if (dist == 2) {
-			unsigned short *sout = (unsigned short *)(out - OFF);
+		    } else { /* dist == 1 or dist == 2 */
+			unsigned short *sout;
 			unsigned short pat16;
-			unsigned long loops = len >> 1;
+			unsigned long loops;
 
+			/* Align out addr */
+			if (!((long)(out - 1 + OFF)) & 1) {
+			    PUP(out) = PUP(from);
+			    len--;
+			}
+			sout = (unsigned short *)(out - OFF);
 			pat16 = *(sout-2+2*OFF);
+			if (dist == 1)
+			    pat16 = (pat16 & 0xff) | ((pat16 & 0xff ) << 8);
+			loops = len >> 1;
 			do
 			    PUP(sout) = pat16;
 			while (--loops);
 			out = (unsigned char *)sout + OFF;
 			if (len & 1)
 			    PUP(out) = PUP(from);
-		    } else {
-			unsigned char pat8 = *(out - 1 + OFF);
-
-			do {
-			    PUP(out) = pat8;
-			} while (--len);
 		    }
-#else
-                    do {                        /* minimum length is three */
-                        PUP(out) = PUP(from);
-                        PUP(out) = PUP(from);
-                        PUP(out) = PUP(from);
-                        len -= 3;
-                    } while (len > 2);
-                    if (len) {
-                        PUP(out) = PUP(from);
-                        if (len > 1)
-                            PUP(out) = PUP(from);
-                    }
-#endif
                 }
             }
             else if ((op & 64) == 0) {          /* 2nd level distance code */
_

Patches currently in -mm which might be from Joakim.Tjernlund@transmode.se are

crc32-minor-optimizations-and-cleanup.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
zlib-optimize-inffast-even-more.patch

