From: akpm@linux-foundation.org
Subject: + remove-dma64_addr_t.patch added to -mm tree
Date: Tue, 12 Oct 2010 14:42:39 -0700
Message-ID: <201010122142.o9CLgdsU020695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390Ab0JLVnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Oct 2010 17:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, ink@jurassic.park.msu.ru, mattst88@gmail.com, ralf@linux-mips.org, rth@twiddle.net


The patch titled
     remove dma64_addr_t
has been added to the -mm tree.  Its filename is
     remove-dma64_addr_t.patch

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
Subject: remove dma64_addr_t
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

There is no user now.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Miller <davem@davemloft.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/types.h   |   11 -----------
 arch/arm/include/asm/types.h     |    6 ------
 arch/cris/include/asm/types.h    |    6 ------
 arch/m32r/include/asm/types.h    |    6 ------
 arch/m68k/include/asm/types.h    |    6 ------
 arch/mips/include/asm/types.h    |    2 --
 arch/parisc/include/asm/types.h  |   13 -------------
 arch/powerpc/include/asm/types.h |    2 --
 arch/s390/include/asm/types.h    |    2 --
 arch/sparc/include/asm/types.h   |   18 ------------------
 arch/x86/include/asm/types.h     |    8 --------
 11 files changed, 80 deletions(-)

diff -puN arch/alpha/include/asm/types.h~remove-dma64_addr_t arch/alpha/include/asm/types.h
--- a/arch/alpha/include/asm/types.h~remove-dma64_addr_t
+++ a/arch/alpha/include/asm/types.h
@@ -20,15 +20,4 @@
 typedef unsigned int umode_t;
 
 #endif /* __ASSEMBLY__ */
-
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-
-typedef u64 dma64_addr_t;
-
-#endif /* __ASSEMBLY__ */
-#endif /* __KERNEL__ */
 #endif /* _ALPHA_TYPES_H */
diff -puN arch/arm/include/asm/types.h~remove-dma64_addr_t arch/arm/include/asm/types.h
--- a/arch/arm/include/asm/types.h~remove-dma64_addr_t
+++ a/arch/arm/include/asm/types.h
@@ -16,12 +16,6 @@ typedef unsigned short umode_t;
 
 #define BITS_PER_LONG 32
 
-#ifndef __ASSEMBLY__
-
-typedef u32 dma64_addr_t;
-
-#endif /* __ASSEMBLY__ */
-
 #endif /* __KERNEL__ */
 
 #endif
diff -puN arch/cris/include/asm/types.h~remove-dma64_addr_t arch/cris/include/asm/types.h
--- a/arch/cris/include/asm/types.h~remove-dma64_addr_t
+++ a/arch/cris/include/asm/types.h
@@ -16,12 +16,6 @@ typedef unsigned short umode_t;
 
 #define BITS_PER_LONG 32
 
-#ifndef __ASSEMBLY__
-
-typedef u32 dma64_addr_t;
-
-#endif /* __ASSEMBLY__ */
-
 #endif /* __KERNEL__ */
 
 #endif
diff -puN arch/m32r/include/asm/types.h~remove-dma64_addr_t arch/m32r/include/asm/types.h
--- a/arch/m32r/include/asm/types.h~remove-dma64_addr_t
+++ a/arch/m32r/include/asm/types.h
@@ -16,12 +16,6 @@ typedef unsigned short umode_t;
 
 #define BITS_PER_LONG 32
 
-#ifndef __ASSEMBLY__
-
-typedef u64 dma64_addr_t;
-
-#endif /* __ASSEMBLY__ */
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_M32R_TYPES_H */
diff -puN arch/m68k/include/asm/types.h~remove-dma64_addr_t arch/m68k/include/asm/types.h
--- a/arch/m68k/include/asm/types.h~remove-dma64_addr_t
+++ a/arch/m68k/include/asm/types.h
@@ -23,12 +23,6 @@ typedef unsigned short umode_t;
 
 #define BITS_PER_LONG 32
 
-#ifndef __ASSEMBLY__
-
-typedef u32 dma64_addr_t;
-
-#endif /* __ASSEMBLY__ */
-
 #endif /* __KERNEL__ */
 
 #endif /* _M68K_TYPES_H */
diff -puN arch/mips/include/asm/types.h~remove-dma64_addr_t arch/mips/include/asm/types.h
--- a/arch/mips/include/asm/types.h~remove-dma64_addr_t
+++ a/arch/mips/include/asm/types.h
@@ -33,8 +33,6 @@ typedef unsigned short umode_t;
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
-typedef u64 dma64_addr_t;
-
 /*
  * Don't use phys_t.  You've been warned.
  */
diff -puN arch/parisc/include/asm/types.h~remove-dma64_addr_t arch/parisc/include/asm/types.h
--- a/arch/parisc/include/asm/types.h~remove-dma64_addr_t
+++ a/arch/parisc/include/asm/types.h
@@ -9,17 +9,4 @@ typedef unsigned short umode_t;
 
 #endif /* __ASSEMBLY__ */
 
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-#ifdef __KERNEL__
-
-#ifndef __ASSEMBLY__
-
-typedef u64 dma64_addr_t;
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* __KERNEL__ */
-
 #endif
diff -puN arch/powerpc/include/asm/types.h~remove-dma64_addr_t arch/powerpc/include/asm/types.h
--- a/arch/powerpc/include/asm/types.h~remove-dma64_addr_t
+++ a/arch/powerpc/include/asm/types.h
@@ -44,8 +44,6 @@ typedef struct {
 
 typedef __vector128 vector128;
 
-typedef u64 dma64_addr_t;
-
 typedef struct {
 	unsigned long entry;
 	unsigned long toc;
diff -puN arch/s390/include/asm/types.h~remove-dma64_addr_t arch/s390/include/asm/types.h
--- a/arch/s390/include/asm/types.h~remove-dma64_addr_t
+++ a/arch/s390/include/asm/types.h
@@ -30,8 +30,6 @@ typedef __signed__ long saddr_t;
 
 #ifndef __ASSEMBLY__
 
-typedef u64 dma64_addr_t;
-
 #ifndef __s390x__
 typedef union {
 	unsigned long long pair;
diff -puN arch/sparc/include/asm/types.h~remove-dma64_addr_t arch/sparc/include/asm/types.h
--- a/arch/sparc/include/asm/types.h~remove-dma64_addr_t
+++ a/arch/sparc/include/asm/types.h
@@ -18,24 +18,6 @@ typedef unsigned short umode_t;
 
 #endif /* __ASSEMBLY__ */
 
-#ifdef __KERNEL__
-
-#ifndef __ASSEMBLY__
-
-#if defined(__arch64__)
-
-/*** SPARC 64 bit ***/
-typedef u64 dma64_addr_t;
-#else
-/*** SPARC 32 bit ***/
-typedef u32 dma64_addr_t;
-
-#endif /* defined(__arch64__) */
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* __KERNEL__ */
-
 #endif /* defined(__sparc__) */
 
 #endif /* defined(_SPARC_TYPES_H) */
diff -puN arch/x86/include/asm/types.h~remove-dma64_addr_t arch/x86/include/asm/types.h
--- a/arch/x86/include/asm/types.h~remove-dma64_addr_t
+++ a/arch/x86/include/asm/types.h
@@ -3,12 +3,4 @@
 
 #include <asm-generic/types.h>
 
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-
-typedef u64 dma64_addr_t;
-
-#endif /* __ASSEMBLY__ */
-#endif /* __KERNEL__ */
