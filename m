From: akpm@linux-foundation.org
Subject: [withdrawn]
 linux-consth-move-ul-macro-to-include-linux-consth.patch removed from -mm
 tree
Date: Mon, 09 Jan 2017 13:40:15 -0800
Message-ID: <5874033f.ccB0345Qbgn2gy+5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33832 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937035AbdAIVis (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2017 16:38:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, catalin.marinas@arm.com, gxt@mprc.pku.edu.cn, rmk+kernel@armlinux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/const.h: move UL() macro to include/linux/const.h
has been removed from the -mm tree.  Its filename was
     linux-consth-move-ul-macro-to-include-linux-consth.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: linux/const.h: move UL() macro to include/linux/const.h

ARM, ARM64 and UniCore32 duplicate the definition of UL():

  #define UL(x) _AC(x, UL)

This is not actually arch-specific, so it will be useful to move it
to a common header.  Currently, we only have the uapi variant for
linux/const.h, so I am creating include/linux/const.h.

I am also adding _UL(), _ULL() and ULL() because _AC() is mostly
used in the form either _AC(..., UL) or _AC(..., ULL).  I expect
they will be replaced in later cleanups.  The underscore-prefixed
ones should be used for exported headers.

Link: http://lkml.kernel.org/r/1483582810-7046-3-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	(arm64)
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>	(arm)
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/memory.h       |    6 ------
 arch/arm64/include/asm/memory.h     |    6 ------
 arch/unicore32/include/asm/memory.h |    6 ------
 include/linux/const.h               |    9 +++++++++
 include/uapi/linux/const.h          |    9 ++++++---
 5 files changed, 15 insertions(+), 21 deletions(-)

diff -puN arch/arm/include/asm/memory.h~linux-consth-move-ul-macro-to-include-linux-consth arch/arm/include/asm/memory.h
--- a/arch/arm/include/asm/memory.h~linux-consth-move-ul-macro-to-include-linux-consth
+++ a/arch/arm/include/asm/memory.h
@@ -22,12 +22,6 @@
 #include <mach/memory.h>
 #endif
 
-/*
- * Allow for constants defined here to be used from assembly code
- * by prepending the UL suffix only with actual C code compilation.
- */
-#define UL(x) _AC(x, UL)
-
 /* PAGE_OFFSET - the virtual address of the start of the kernel image */
 #define PAGE_OFFSET		UL(CONFIG_PAGE_OFFSET)
 
diff -puN arch/arm64/include/asm/memory.h~linux-consth-move-ul-macro-to-include-linux-consth arch/arm64/include/asm/memory.h
--- a/arch/arm64/include/asm/memory.h~linux-consth-move-ul-macro-to-include-linux-consth
+++ a/arch/arm64/include/asm/memory.h
@@ -28,12 +28,6 @@
 #include <asm/sizes.h>
 
 /*
- * Allow for constants defined here to be used from assembly code
- * by prepending the UL suffix only with actual C code compilation.
- */
-#define UL(x) _AC(x, UL)
-
-/*
  * Size of the PCI I/O space. This must remain a power of two so that
  * IO_SPACE_LIMIT acts as a mask for the low bits of I/O addresses.
  */
diff -puN arch/unicore32/include/asm/memory.h~linux-consth-move-ul-macro-to-include-linux-consth arch/unicore32/include/asm/memory.h
--- a/arch/unicore32/include/asm/memory.h~linux-consth-move-ul-macro-to-include-linux-consth
+++ a/arch/unicore32/include/asm/memory.h
@@ -20,12 +20,6 @@
 #include <mach/memory.h>
 
 /*
- * Allow for constants defined here to be used from assembly code
- * by prepending the UL suffix only with actual C code compilation.
- */
-#define UL(x) _AC(x, UL)
-
-/*
  * PAGE_OFFSET - the virtual address of the start of the kernel image
  * TASK_SIZE - the maximum size of a user space task.
  * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area
diff -puN /dev/null include/linux/const.h
--- /dev/null
+++ a/include/linux/const.h
@@ -0,0 +1,9 @@
+#ifndef _LINUX_CONST_H
+#define _LINUX_CONST_H
+
+#include <uapi/linux/const.h>
+
+#define UL(x)		(_UL(x))
+#define ULL(x)		(_ULL(x))
+
+#endif /* _LINUX_CONST_H */
diff -puN include/uapi/linux/const.h~linux-consth-move-ul-macro-to-include-linux-consth include/uapi/linux/const.h
--- a/include/uapi/linux/const.h~linux-consth-move-ul-macro-to-include-linux-consth
+++ a/include/uapi/linux/const.h
@@ -1,7 +1,7 @@
 /* const.h: Macros for dealing with constants.  */
 
-#ifndef _LINUX_CONST_H
-#define _LINUX_CONST_H
+#ifndef _UAPI_LINUX_CONST_H
+#define _UAPI_LINUX_CONST_H
 
 /* Some constant macros are used in both assembler and
  * C code.  Therefore we cannot annotate them always with
@@ -21,7 +21,10 @@
 #define _AT(T,X)	((T)(X))
 #endif
 
+#define _UL(x)		(_AC(x, UL))
+#define _ULL(x)		(_AC(x, ULL))
+
 #define _BITUL(x)	(_AC(1,UL) << (x))
 #define _BITULL(x)	(_AC(1,ULL) << (x))
 
-#endif /* !(_LINUX_CONST_H) */
+#endif /* _UAPI_LINUX_CONST_H */
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

linux-consth-refactor-_bitul-and-_bitull-a-bit.patch
linux-consth-move-bit_ull-to-linux-consth-for-use-in-assembly.patch
scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch

