From: akpm@linux-foundation.org
Subject: + endian-define-__byte_order.patch added to -mm tree
Date: Wed, 24 Mar 2010 11:53:52 -0700
Message-ID: <201003241853.o2OIrqBr020894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932268Ab0CXSyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 14:54:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Joakim.Tjernlund@transmode.se, geert@linux-m68k.org


The patch titled
     endian: #define __BYTE_ORDER
has been added to the -mm tree.  Its filename is
     endian-define-__byte_order.patch

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
Subject: endian: #define __BYTE_ORDER
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

Linux does not define __BYTE_ORDER in its endian header files which makes
some header files bend backwards to get at the current endian.  Lets
#define __BYTE_ORDER in big_endian.h/litte_endian.h to make it easier for
header files that are used in user space too.

In userspace the convention is that

  1. _both_ __LITTLE_ENDIAN and __BIG_ENDIAN are defined,
  2. you have to test for e.g. __BYTE_ORDER == __BIG_ENDIAN.


Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/math-emu/sfp-util.h          |    5 -----
 arch/powerpc/include/asm/sfp-machine.h  |    6 ------
 arch/s390/include/asm/sfp-util.h        |    2 --
 arch/sh/math-emu/sfp-util.h             |    4 ----
 arch/sparc/math-emu/sfp-util_32.h       |    6 ------
 arch/sparc/math-emu/sfp-util_64.h       |    6 ------
 arch/x86/boot/compressed/relocs.c       |    4 ++--
 include/linux/byteorder/big_endian.h    |    3 +++
 include/linux/byteorder/little_endian.h |    3 +++
 9 files changed, 8 insertions(+), 31 deletions(-)

diff -puN arch/alpha/math-emu/sfp-util.h~endian-define-__byte_order arch/alpha/math-emu/sfp-util.h
--- a/arch/alpha/math-emu/sfp-util.h~endian-define-__byte_order
+++ a/arch/alpha/math-emu/sfp-util.h
@@ -28,8 +28,3 @@ extern unsigned long __udiv_qrnnd (unsig
 #define UDIV_NEEDS_NORMALIZATION 1  
 
 #define abort()			goto bad_insn
-
-#ifndef __LITTLE_ENDIAN
-#define __LITTLE_ENDIAN -1
-#endif
-#define __BYTE_ORDER __LITTLE_ENDIAN
diff -puN arch/powerpc/include/asm/sfp-machine.h~endian-define-__byte_order arch/powerpc/include/asm/sfp-machine.h
--- a/arch/powerpc/include/asm/sfp-machine.h~endian-define-__byte_order
+++ a/arch/powerpc/include/asm/sfp-machine.h
@@ -353,12 +353,6 @@
 #define abort()								\
 	return 0
 
-#ifdef __BIG_ENDIAN
-#define __BYTE_ORDER __BIG_ENDIAN
-#else
-#define __BYTE_ORDER __LITTLE_ENDIAN
-#endif
-
 /* Exception flags. */
 #define EFLAG_INVALID		(1 << (31 - 2))
 #define EFLAG_OVERFLOW		(1 << (31 - 3))
diff -puN arch/s390/include/asm/sfp-util.h~endian-define-__byte_order arch/s390/include/asm/sfp-util.h
--- a/arch/s390/include/asm/sfp-util.h~endian-define-__byte_order
+++ a/arch/s390/include/asm/sfp-util.h
@@ -73,5 +73,3 @@ extern unsigned long __udiv_qrnnd (unsig
 #define UDIV_NEEDS_NORMALIZATION 0
 
 #define abort() return 0
-
-#define __BYTE_ORDER __BIG_ENDIAN
diff -puN arch/sh/math-emu/sfp-util.h~endian-define-__byte_order arch/sh/math-emu/sfp-util.h
--- a/arch/sh/math-emu/sfp-util.h~endian-define-__byte_order
+++ a/arch/sh/math-emu/sfp-util.h
@@ -66,7 +66,3 @@
   } while (0)
 
 #define abort()	return 0
-
-#define __BYTE_ORDER __LITTLE_ENDIAN
-
-
diff -puN arch/sparc/math-emu/sfp-util_32.h~endian-define-__byte_order arch/sparc/math-emu/sfp-util_32.h
--- a/arch/sparc/math-emu/sfp-util_32.h~endian-define-__byte_order
+++ a/arch/sparc/math-emu/sfp-util_32.h
@@ -107,9 +107,3 @@
 
 #define abort()								\
 	return 0
-
-#ifdef __BIG_ENDIAN
-#define __BYTE_ORDER __BIG_ENDIAN
-#else
-#define __BYTE_ORDER __LITTLE_ENDIAN
-#endif
diff -puN arch/sparc/math-emu/sfp-util_64.h~endian-define-__byte_order arch/sparc/math-emu/sfp-util_64.h
--- a/arch/sparc/math-emu/sfp-util_64.h~endian-define-__byte_order
+++ a/arch/sparc/math-emu/sfp-util_64.h
@@ -112,9 +112,3 @@
 
 #define abort() \
 	return 0
-
-#ifdef __BIG_ENDIAN
-#define __BYTE_ORDER __BIG_ENDIAN
-#else
-#define __BYTE_ORDER __LITTLE_ENDIAN
-#endif
diff -puN arch/x86/boot/compressed/relocs.c~endian-define-__byte_order arch/x86/boot/compressed/relocs.c
--- a/arch/x86/boot/compressed/relocs.c~endian-define-__byte_order
+++ a/arch/x86/boot/compressed/relocs.c
@@ -195,11 +195,11 @@ static const char *sym_name(const char *
 
 
 
-#if BYTE_ORDER == LITTLE_ENDIAN
+#if __BYTE_ORDER == __LITTLE_ENDIAN
 #define le16_to_cpu(val) (val)
 #define le32_to_cpu(val) (val)
 #endif
-#if BYTE_ORDER == BIG_ENDIAN
+#if __BYTE_ORDER == __BIG_ENDIAN
 #define le16_to_cpu(val) bswap_16(val)
 #define le32_to_cpu(val) bswap_32(val)
 #endif
diff -puN include/linux/byteorder/big_endian.h~endian-define-__byte_order include/linux/byteorder/big_endian.h
--- a/include/linux/byteorder/big_endian.h~endian-define-__byte_order
+++ a/include/linux/byteorder/big_endian.h
@@ -7,6 +7,9 @@
 #ifndef __BIG_ENDIAN_BITFIELD
 #define __BIG_ENDIAN_BITFIELD
 #endif
+#ifndef __BYTE_ORDER
+#define __BYTE_ORDER __BIG_ENDIAN
+#endif
 
 #include <linux/types.h>
 #include <linux/swab.h>
diff -puN include/linux/byteorder/little_endian.h~endian-define-__byte_order include/linux/byteorder/little_endian.h
--- a/include/linux/byteorder/little_endian.h~endian-define-__byte_order
+++ a/include/linux/byteorder/little_endian.h
@@ -7,6 +7,9 @@
 #ifndef __LITTLE_ENDIAN_BITFIELD
 #define __LITTLE_ENDIAN_BITFIELD
 #endif
+#ifndef __BYTE_ORDER
+#define __BYTE_ORDER __LITTLE_ENDIAN
+#endif
 
 #include <linux/types.h>
 #include <linux/swab.h>
_

Patches currently in -mm which might be from Joakim.Tjernlund@transmode.se are

endian-define-__byte_order.patch

