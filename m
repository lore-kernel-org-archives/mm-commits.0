From: akpm@linux-foundation.org
Subject: [merged] zlib-optimize-inffast-when-copying-direct-from-output.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:17:57 -0800
Message-ID: <201001112017.o0BKHvPf025442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751347Ab0AKUgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:36:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Joakim.Tjernlund@transmode.se, dwmw2@infradead.org, roel.kluin@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     zlib: optimize inffast when copying direct from output
has been removed from the -mm tree.  Its filename was
     zlib-optimize-inffast-when-copying-direct-from-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: zlib: optimize inffast when copying direct from output
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

JFFS2 uses lesser compression ratio and inflate always ends up in "copy
direct from output" case.

This patch tries to optimize the direct copy procedure.  Uses
get_unaligned() but only in one place.

The copy loop just above this one can also use this optimization, but I
havn't done so as I have not tested if it is a win there too.

On my MPC8321 this is about 17% faster on my JFFS2 root FS than the
original.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: Roel Kluin <roel.kluin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/Makefile |    4 +-
 lib/zlib_inflate/inffast.c |   55 ++++++++++++++++++++++++++++-------
 2 files changed, 47 insertions(+), 12 deletions(-)

diff -puN arch/powerpc/boot/Makefile~zlib-optimize-inffast-when-copying-direct-from-output arch/powerpc/boot/Makefile
--- a/arch/powerpc/boot/Makefile~zlib-optimize-inffast-when-copying-direct-from-output
+++ a/arch/powerpc/boot/Makefile
@@ -20,7 +20,7 @@
 all: $(obj)/zImage
 
 BOOTCFLAGS    := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
-		 -fno-strict-aliasing -Os -msoft-float -pipe \
+		 -fno-strict-aliasing -Os -msoft-float -pipe -D__KERNEL__\
 		 -fomit-frame-pointer -fno-builtin -fPIC -nostdinc \
 		 -isystem $(shell $(CROSS32CC) -print-file-name=include)
 BOOTAFLAGS	:= -D__ASSEMBLY__ $(BOOTCFLAGS) -traditional -nostdinc
@@ -34,6 +34,8 @@ BOOTCFLAGS	+= -fno-stack-protector
 endif
 
 BOOTCFLAGS	+= -I$(obj) -I$(srctree)/$(obj)
+BOOTCFLAGS	+= -include include/linux/autoconf.h -Iarch/powerpc/include
+BOOTCFLAGS	+= -Iinclude
 
 DTS_FLAGS	?= -p 1024
 
diff -puN lib/zlib_inflate/inffast.c~zlib-optimize-inffast-when-copying-direct-from-output lib/zlib_inflate/inffast.c
--- a/lib/zlib_inflate/inffast.c~zlib-optimize-inffast-when-copying-direct-from-output
+++ a/lib/zlib_inflate/inffast.c
@@ -4,6 +4,8 @@
  */
 
 #include <linux/zutil.h>
+#include <asm/unaligned.h>
+#include <asm/byteorder.h>
 #include "inftrees.h"
 #include "inflate.h"
 #include "inffast.h"
@@ -24,9 +26,11 @@
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
@@ -239,18 +243,47 @@ void inflate_fast(z_streamp strm, unsign
                     }
                 }
                 else {
+		    unsigned short *sout;
+		    unsigned long loops;
+
                     from = out - dist;          /* copy direct from output */
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
+		    /* minimum length is three */
+		    /* Align out addr */
+		    if (!((long)(out - 1 + OFF) & 1)) {
+			PUP(out) = PUP(from);
+			len--;
+		    }
+		    sout = (unsigned short *)(out - OFF);
+		    if (dist > 2) {
+			unsigned short *sfrom;
+
+			sfrom = (unsigned short *)(from - OFF);
+			loops = len >> 1;
+			do
+			    PUP(sout) = UP_UNALIGNED(sfrom);
+			while (--loops);
+			out = (unsigned char *)sout + OFF;
+			from = (unsigned char *)sfrom + OFF;
+		    } else { /* dist == 1 or dist == 2 */
+			unsigned short pat16;
+
+			pat16 = *(sout-2+2*OFF);
+			if (dist == 1)
+#if defined(__BIG_ENDIAN)
+			    pat16 = (pat16 & 0xff) | ((pat16 & 0xff) << 8);
+#elif defined(__LITTLE_ENDIAN)
+			    pat16 = (pat16 & 0xff00) | ((pat16 & 0xff00) >> 8);
+#else
+#error __BIG_ENDIAN nor __LITTLE_ENDIAN is defined
+#endif
+			loops = len >> 1;
+			do
+			    PUP(sout) = pat16;
+			while (--loops);
+			out = (unsigned char *)sout + OFF;
+		    }
+		    if (len & 1)
+			PUP(out) = PUP(from);
                 }
             }
             else if ((op & 64) == 0) {          /* 2nd level distance code */
_

Patches currently in -mm which might be from Joakim.Tjernlund@transmode.se are

origin.patch

