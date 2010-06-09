From: akpm@linux-foundation.org
Subject: + compiler-gcch-gcc-45-needs-noclone-and-noinline-on-__naked-functions.patch added to -mm tree
Date: Wed, 09 Jun 2010 16:00:16 -0700
Message-ID: <201006092300.o59N0GXJ026762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756861Ab0FIXAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jun 2010 19:00:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikpe@it.uu.se, raj.khem@gmail.com, rmk@arm.linux.org.uk, stable@kernel.org


The patch titled
     compiler-gcc.h: gcc-4.5 needs noclone and noinline on __naked functions
has been added to the -mm tree.  Its filename is
     compiler-gcch-gcc-45-needs-noclone-and-noinline-on-__naked-functions.patch

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
Subject: compiler-gcc.h: gcc-4.5 needs noclone and noinline on __naked functions
From: Mikael Pettersson <mikpe@it.uu.se>

A __naked function is defined in C but with a body completely implemented
by asm(), including any prologue and epilogue.  These asm() bodies expect
standard calling conventions for parameter passing.  Older GCCs implement
that correctly, but 4.[56] currently do not, see GCC PR44290.  In the
Linux kernel this breaks ARM, causing most arch/arm/mm/copypage-*.c
modules to get miscompiled, resulting in kernel crashes during bootup.

Part of the kernel fix is to augment the __naked function attribute to
also imply noinline and noclone.  This patch implements that, and has been
verified to fix boot failures with gcc-4.5 compiled 2.6.34 and 2.6.35-rc1
kernels.  The patch is a no-op with older GCCs.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Khem Raj <raj.khem@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h  |   10 +++++++++-
 include/linux/compiler-gcc4.h |    4 ++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc.h~compiler-gcch-gcc-45-needs-noclone-and-noinline-on-__naked-functions include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~compiler-gcch-gcc-45-needs-noclone-and-noinline-on-__naked-functions
+++ a/include/linux/compiler-gcc.h
@@ -58,8 +58,12 @@
  * naked functions because then mcount is called without stack and frame pointer
  * being set up and there is no chance to restore the lr register to the value
  * before mcount was called.
+ *
+ * The asm() bodies of naked functions often depend on standard calling conventions,
+ * therefore they must be noinline and noclone.  GCC 4.[56] currently fail to enforce
+ * this, so we must do so ourselves.  See GCC PR44290.
  */
-#define __naked				__attribute__((naked)) notrace
+#define __naked				__attribute__((naked)) noinline __noclone notrace
 
 #define __noreturn			__attribute__((noreturn))
 
@@ -85,3 +89,7 @@
 #define _gcc_header(x) __gcc_header(linux/compiler-gcc##x.h)
 #define gcc_header(x) _gcc_header(x)
 #include gcc_header(__GNUC__)
+
+#if !defined(__noclone)
+#define __noclone	/* not needed */
+#endif
diff -puN include/linux/compiler-gcc4.h~compiler-gcch-gcc-45-needs-noclone-and-noinline-on-__naked-functions include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~compiler-gcch-gcc-45-needs-noclone-and-noinline-on-__naked-functions
+++ a/include/linux/compiler-gcc4.h
@@ -48,6 +48,10 @@
  * unreleased.  Really, we need to have autoconf for the kernel.
  */
 #define unreachable() __builtin_unreachable()
+
+/* Mark a function definition as prohibited from being cloned. */
+#define __noclone	__attribute__((__noclone__))
+
 #endif
 
 #endif
_

Patches currently in -mm which might be from mikpe@it.uu.se are

compiler-gcch-gcc-45-needs-noclone-and-noinline-on-__naked-functions.patch

