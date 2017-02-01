From: akpm@linux-foundation.org
Subject: +
 m68k-replaced-gcc-specific-macros-with-ones-from-compilerh.patch added to
 -mm tree
Date: Tue, 31 Jan 2017 16:55:30 -0800
Message-ID: <58913202./O59Tr7QaulgG/8W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40200 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751183AbdBAAzb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 19:55:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gidisrael@gmail.com, geert@linux-m68k.org, gerg@linux-m68k.org, paul.gortmaker@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: replac gcc specific macros with ones from compiler.h
has been added to the -mm tree.  Its filename is
     m68k-replaced-gcc-specific-macros-with-ones-from-compilerh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m68k-replaced-gcc-specific-macros-with-ones-from-compilerh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m68k-replaced-gcc-specific-macros-with-ones-from-compilerh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gideon Israel Dsouza <gidisrael@gmail.com>
Subject: m68k: replac gcc specific macros with ones from compiler.h

There is <linux/compiler.h> which provides macros for various gcc specific
constructs.  Eg: __weak for __attribute__((weak)).  I've cleaned all
instances of gcc specific attributes with the right macros for all files
under /arch/m68k

Link: http://lkml.kernel.org/r/1485540901-1988-3-git-send-email-gidisrael@gmail.com
Signed-off-by: Gideon Israel Dsouza <gidisrael@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/68000/bootlogo-vz.h     |    4 +++-
 arch/m68k/68000/bootlogo.h        |    4 +++-
 arch/m68k/include/asm/MC68328.h   |    3 ++-
 arch/m68k/include/asm/MC68EZ328.h |    3 ++-
 arch/m68k/include/asm/MC68VZ328.h |    2 +-
 arch/m68k/include/asm/natfeat.h   |    3 ++-
 arch/m68k/lib/ashldi3.c           |    8 ++++----
 arch/m68k/lib/ashrdi3.c           |    8 ++++----
 arch/m68k/lib/lshrdi3.c           |    8 ++++----
 arch/m68k/lib/muldi3.c            |    8 ++++----
 10 files changed, 29 insertions(+), 22 deletions(-)

diff -puN arch/m68k/68000/bootlogo-vz.h~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh arch/m68k/68000/bootlogo-vz.h
--- a/arch/m68k/68000/bootlogo-vz.h~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh
+++ a/arch/m68k/68000/bootlogo-vz.h
@@ -1,6 +1,8 @@
+#include <linux/compiler.h>
+
 #define splash_width 640
 #define splash_height 480
-unsigned char __attribute__ ((aligned(16))) bootlogo_bits[] = {
+unsigned char __aligned(16) bootlogo_bits[] = {
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
diff -puN arch/m68k/68000/bootlogo.h~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh arch/m68k/68000/bootlogo.h
--- a/arch/m68k/68000/bootlogo.h~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh
+++ a/arch/m68k/68000/bootlogo.h
@@ -1,6 +1,8 @@
+#include <linux/compiler.h>
+
 #define bootlogo_width 160
 #define bootlogo_height 160
-unsigned char __attribute__ ((aligned(16))) bootlogo_bits[] = {
+unsigned char __aligned(16) bootlogo_bits[] = {
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x55, 0x01, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x40, 0x55, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
diff -puN arch/m68k/include/asm/MC68328.h~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh arch/m68k/include/asm/MC68328.h
--- a/arch/m68k/include/asm/MC68328.h~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh
+++ a/arch/m68k/include/asm/MC68328.h
@@ -8,6 +8,7 @@
  * Copyright (C) 1998  Kenneth Albanowski <kjahds@kjahds.com>,
  *
  */
+#include <linux/compiler.h>
 
 #ifndef _MC68328_H_
 #define _MC68328_H_
@@ -993,7 +994,7 @@ typedef volatile struct {
   volatile unsigned short int pad1;
   volatile unsigned short int pad2;
   volatile unsigned short int pad3;
-} __attribute__((packed)) m68328_uart;
+} __packed m68328_uart;
 
 
 /**********
diff -puN arch/m68k/include/asm/MC68EZ328.h~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh arch/m68k/include/asm/MC68EZ328.h
--- a/arch/m68k/include/asm/MC68EZ328.h~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh
+++ a/arch/m68k/include/asm/MC68EZ328.h
@@ -9,6 +9,7 @@
  *                     The Silver Hammer Group, Ltd.
  *
  */
+#include <linux/compiler.h>
 
 #ifndef _MC68EZ328_H_
 #define _MC68EZ328_H_
@@ -815,7 +816,7 @@ typedef volatile struct {
   volatile unsigned short int nipr;
   volatile unsigned short int pad1;
   volatile unsigned short int pad2;
-} __attribute__((packed)) m68328_uart;
+} __packed m68328_uart;
 
 
 /**********
diff -puN arch/m68k/include/asm/MC68VZ328.h~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh arch/m68k/include/asm/MC68VZ328.h
--- a/arch/m68k/include/asm/MC68VZ328.h~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh
+++ a/arch/m68k/include/asm/MC68VZ328.h
@@ -909,7 +909,7 @@ typedef struct {
   volatile unsigned short int nipr;
   volatile unsigned short int hmark;
   volatile unsigned short int unused;
-} __attribute__((packed)) m68328_uart;
+} __packed m68328_uart;
 
 
 
diff -puN arch/m68k/include/asm/natfeat.h~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh arch/m68k/include/asm/natfeat.h
--- a/arch/m68k/include/asm/natfeat.h~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh
+++ a/arch/m68k/include/asm/natfeat.h
@@ -6,6 +6,7 @@
  * This software may be used and distributed according to the terms of
  * the GNU General Public License (GPL), incorporated herein by reference.
  */
+#include <linux/compiler.h>
 
 #ifndef _NATFEAT_H
 #define _NATFEAT_H
@@ -17,6 +18,6 @@ void nf_init(void);
 void nf_shutdown(void);
 
 void nfprint(const char *fmt, ...)
-	__attribute__ ((format (printf, 1, 2)));
+	__printf(1, 2);
 
 # endif /* _NATFEAT_H */
diff -puN arch/m68k/lib/ashldi3.c~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh arch/m68k/lib/ashldi3.c
--- a/arch/m68k/lib/ashldi3.c~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh
+++ a/arch/m68k/lib/ashldi3.c
@@ -18,10 +18,10 @@ GNU General Public License for more deta
 
 #define BITS_PER_UNIT 8
 
-typedef		 int SItype	__attribute__ ((mode (SI)));
-typedef unsigned int USItype	__attribute__ ((mode (SI)));
-typedef		 int DItype	__attribute__ ((mode (DI)));
-typedef int word_type __attribute__ ((mode (__word__)));
+typedef		 int SItype	__mode(SI);
+typedef unsigned int USItype	__mode(SI);
+typedef		 int DItype	__mode(DI);
+typedef int word_type           __mode(__word__);
 
 struct DIstruct {SItype high, low;};
 
diff -puN arch/m68k/lib/ashrdi3.c~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh arch/m68k/lib/ashrdi3.c
--- a/arch/m68k/lib/ashrdi3.c~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh
+++ a/arch/m68k/lib/ashrdi3.c
@@ -18,10 +18,10 @@ GNU General Public License for more deta
 
 #define BITS_PER_UNIT 8
 
-typedef		 int SItype	__attribute__ ((mode (SI)));
-typedef unsigned int USItype	__attribute__ ((mode (SI)));
-typedef		 int DItype	__attribute__ ((mode (DI)));
-typedef int word_type __attribute__ ((mode (__word__)));
+typedef		 int SItype	__mode(SI);
+typedef unsigned int USItype	__mode(SI);
+typedef		 int DItype	__mode(DI);
+typedef int word_type           __mode(__word__);
 
 struct DIstruct {SItype high, low;};
 
diff -puN arch/m68k/lib/lshrdi3.c~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh arch/m68k/lib/lshrdi3.c
--- a/arch/m68k/lib/lshrdi3.c~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh
+++ a/arch/m68k/lib/lshrdi3.c
@@ -18,10 +18,10 @@ GNU General Public License for more deta
 
 #define BITS_PER_UNIT 8
 
-typedef		 int SItype	__attribute__ ((mode (SI)));
-typedef unsigned int USItype	__attribute__ ((mode (SI)));
-typedef		 int DItype	__attribute__ ((mode (DI)));
-typedef int word_type __attribute__ ((mode (__word__)));
+typedef		 int SItype	__mode(SI);
+typedef unsigned int USItype	__mode(SI);
+typedef		 int DItype	__mode(DI);
+typedef int word_type           __mode(__word__);
 
 struct DIstruct {SItype high, low;};
 
diff -puN arch/m68k/lib/muldi3.c~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh arch/m68k/lib/muldi3.c
--- a/arch/m68k/lib/muldi3.c~m68k-replaced-gcc-specific-macros-with-ones-from-compilerh
+++ a/arch/m68k/lib/muldi3.c
@@ -65,10 +65,10 @@ GNU General Public License for more deta
     umul_ppmm (__w.s.high, __w.s.low, u, v);				\
     __w.ll; })
 
-typedef 	 int SItype	__attribute__ ((mode (SI)));
-typedef unsigned int USItype	__attribute__ ((mode (SI)));
-typedef		 int DItype	__attribute__ ((mode (DI)));
-typedef int word_type __attribute__ ((mode (__word__)));
+typedef 	 int SItype	__mode(SI);
+typedef unsigned int USItype	__mode(SI);
+typedef		 int DItype	__mode(DI);
+typedef int word_type           __mode(__word__);
 
 struct DIstruct {SItype high, low;};
 
_

Patches currently in -mm which might be from gidisrael@gmail.com are

compiler-gcch-added-a-new-macro-to-wrap-gcc-attribute.patch
m68k-replaced-gcc-specific-macros-with-ones-from-compilerh.patch

