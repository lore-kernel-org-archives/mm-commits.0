From: akpm@linux-foundation.org
Subject: [merged] asm-typesh-remove-include-asm-generic-int-l64h.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 10:59:53 -0800
Message-ID: <52e2b829.4GJQ0mIDOR6E9RmW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, rdunlap@xenotime.net, arnd@arndb.de, geert@linux-m68k.org

Subject: [merged] asm-typesh-remove-include-asm-generic-int-l64h.patch removed from -mm tree
To: geert@linux-m68k.org,arnd@arndb.de,rdunlap@xenotime.net,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:53 -0800


The patch titled
     Subject: asm/types.h: Remove include/asm-generic/int-l64.h
has been removed from the -mm tree.  Its filename was
     asm-typesh-remove-include-asm-generic-int-l64h.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: asm/types.h: Remove include/asm-generic/int-l64.h

Now all 64-bit architectures have been converted to int-ll64.h, we can
remove int-l64.h in kernelspace.

For backwards compatibility, alpha, ia64, mips64, and powerpc64 still use
int-l64.h in userspace.

This is the (reworked for UAPI) non-documentation part of more than two
year old "asm/types.h: All architectures use int-ll64.h in kernelspace"
(https://lkml.org/lkml/2011/8/13/104)

Since <asm/types.h> (from include/uapi/asm-generic/types.h) is used for
both kernel and user space, include/asm-generic/int-ll64.h cannot just
become include/asm-generic/types.h, as Arnd suggested.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/int-l64.h    |   49 -----------------------------
 include/uapi/asm-generic/types.h |    3 -
 2 files changed, 1 insertion(+), 51 deletions(-)

diff -puN include/asm-generic/int-l64.h~asm-typesh-remove-include-asm-generic-int-l64h /dev/null
--- a/include/asm-generic/int-l64.h
+++ /dev/null
@@ -1,49 +0,0 @@
-/*
- * asm-generic/int-l64.h
- *
- * Integer declarations for architectures which use "long"
- * for 64-bit types.
- */
-#ifndef _ASM_GENERIC_INT_L64_H
-#define _ASM_GENERIC_INT_L64_H
-
-#include <uapi/asm-generic/int-l64.h>
-
-
-#ifndef __ASSEMBLY__
-
-typedef signed char s8;
-typedef unsigned char u8;
-
-typedef signed short s16;
-typedef unsigned short u16;
-
-typedef signed int s32;
-typedef unsigned int u32;
-
-typedef signed long s64;
-typedef unsigned long u64;
-
-#define S8_C(x)  x
-#define U8_C(x)  x ## U
-#define S16_C(x) x
-#define U16_C(x) x ## U
-#define S32_C(x) x
-#define U32_C(x) x ## U
-#define S64_C(x) x ## L
-#define U64_C(x) x ## UL
-
-#else /* __ASSEMBLY__ */
-
-#define S8_C(x)  x
-#define U8_C(x)  x
-#define S16_C(x) x
-#define U16_C(x) x
-#define S32_C(x) x
-#define U32_C(x) x
-#define S64_C(x) x
-#define U64_C(x) x
-
-#endif /* __ASSEMBLY__ */
