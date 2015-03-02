From: akpm@linux-foundation.org
Subject: + include-linux-remove-empty-conditionals.patch added to -mm tree
Date: Mon, 02 Mar 2015 13:58:53 -0800
Message-ID: <54f4dd1d.ojgzzwyeIeay+grs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbbCBV6y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 16:58:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, dhowells@redhat.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux: remove empty conditionals
has been added to the -mm tree.  Its filename is
     include-linux-remove-empty-conditionals.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-remove-empty-conditionals.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-remove-empty-conditionals.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: include/linux: remove empty conditionals

Commit 607ca46e97a1 ("UAPI: (Scripted) Disintegrate include/linux") left
behind some empty conditional blocks.  Since they are useless and may
cause a reader to wonder whether something is missing, remove them.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/a.out.h |   67 ----------------------------------------
 include/linux/types.h |    6 ---
 2 files changed, 73 deletions(-)

diff -puN include/linux/a.out.h~include-linux-remove-empty-conditionals include/linux/a.out.h
--- a/include/linux/a.out.h~include-linux-remove-empty-conditionals
+++ a/include/linux/a.out.h
@@ -4,44 +4,6 @@
 #include <uapi/linux/a.out.h>
 
 #ifndef __ASSEMBLY__
-#if defined (M_OLDSUN2)
-#else
-#endif
-#if defined (M_68010)
-#else
-#endif
-#if defined (M_68020)
-#else
-#endif
-#if defined (M_SPARC)
-#else
-#endif
-#if !defined (N_MAGIC)
-#endif
-#if !defined (N_BADMAG)
-#endif
-#if !defined (N_TXTOFF)
-#endif
-#if !defined (N_DATOFF)
-#endif
-#if !defined (N_TRELOFF)
-#endif
-#if !defined (N_DRELOFF)
-#endif
-#if !defined (N_SYMOFF)
-#endif
-#if !defined (N_STROFF)
-#endif
-#if !defined (N_TXTADDR)
-#endif
-#if defined(vax) || defined(hp300) || defined(pyr)
-#endif
-#ifdef	sony
-#endif	/* Sony.  */
-#ifdef is68k
-#endif
-#if defined(m68k) && defined(PORTAR)
-#endif
 #ifdef linux
 #include <asm/page.h>
 #if defined(__i386__) || defined(__mc68000__)
@@ -51,34 +13,5 @@
 #endif
 #endif
 #endif
-#ifndef N_DATADDR
-#endif
-#if !defined (N_BSSADDR)
-#endif
-#if !defined (N_NLIST_DECLARED)
-#endif /* no N_NLIST_DECLARED.  */
-#if !defined (N_UNDF)
-#endif
-#if !defined (N_ABS)
-#endif
-#if !defined (N_TEXT)
-#endif
-#if !defined (N_DATA)
-#endif
-#if !defined (N_BSS)
-#endif
-#if !defined (N_FN)
-#endif
-#if !defined (N_EXT)
-#endif
-#if !defined (N_TYPE)
-#endif
-#if !defined (N_STAB)
-#endif
-#if !defined (N_RELOCATION_INFO_DECLARED)
-#ifdef NS32K
-#else
-#endif
-#endif /* no N_RELOCATION_INFO_DECLARED.  */
 #endif /*__ASSEMBLY__ */
 #endif /* __A_OUT_GNU_H__ */
diff -puN include/linux/types.h~include-linux-remove-empty-conditionals include/linux/types.h
--- a/include/linux/types.h~include-linux-remove-empty-conditionals
+++ a/include/linux/types.h
@@ -146,12 +146,6 @@ typedef u64 dma_addr_t;
 typedef u32 dma_addr_t;
 #endif /* dma_addr_t */
 
-#ifdef __CHECKER__
-#else
-#endif
-#ifdef __CHECK_ENDIAN__
-#else
-#endif
 typedef unsigned __bitwise__ gfp_t;
 typedef unsigned __bitwise__ fmode_t;
 typedef unsigned __bitwise__ oom_flags_t;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

include-linux-remove-empty-conditionals.patch
lib-vsprintfc-eliminate-some-branches.patch
lib-vsprintfc-reduce-stack-use-in-number.patch
lib-vsprintfc-eliminate-duplicate-hex-string-array.patch
lib-vsprintfc-another-small-hack.patch
linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
lib-find__bit-reimplementation.patch
lib-find__bit-reimplementation-fix.patch
lib-move-find_last_bit-to-lib-find_next_bitc.patch
lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch
binfmt_misc-simplify-entry_status.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch
lib-lz4-pull-out-constant-tables.patch
linux-next.patch

