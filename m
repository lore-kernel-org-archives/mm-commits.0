From: akpm@linux-foundation.org
Subject: + arm-add-support-for-lz4-compressed-kernel-fix.patch added to -mm tree
Date: Wed, 08 May 2013 12:32:34 -0700
Message-ID: <20130508193234.8A8C431C26F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:49233 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3EHTcf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 15:32:35 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so214270ggm.5
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 12:32:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungsik.lee@lge.com, bp@alien8.de, florian@openwrt.org, rmk@arm.linux.org.uk, tglx@linutronix.de, yann.collet.73@gmail.com


The patch titled
     Subject: arm: Remove enforced Os flag for LZ4 decompressor
has been added to the -mm tree.  Its filename is
     arm-add-support-for-lz4-compressed-kernel-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kyungsik Lee <kyungsik.lee@lge.com>
Subject: arm: Remove enforced Os flag for LZ4 decompressor

-Os is enforced here, based on the test result of decompression time
below, slightly faster than -O2.

But further tests with UA show that using -O2 will be the right choice
especially in the case of the unaligned access enabled and the gap,
few counts in the normal decompression mode is small enough to remove -Os.

Decompression Time(counts)
     Normal    UA enabled
-Os  6717      3447
-O2  6720      2728

Note: ARM v7, Kernel 3.4
      counter freq. = 32768 HZ
      UA(Unaligned Access)
      gcc version 4.6.2

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Yann Collet <yann.collet.73@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/compressed/Makefile |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/arm/boot/compressed/Makefile~arm-add-support-for-lz4-compressed-kernel-fix arch/arm/boot/compressed/Makefile
--- a/arch/arm/boot/compressed/Makefile~arm-add-support-for-lz4-compressed-kernel-fix
+++ a/arch/arm/boot/compressed/Makefile
@@ -27,9 +27,6 @@ OBJS	+= misc.o decompress.o
 ifeq ($(CONFIG_DEBUG_UNCOMPRESS),y)
 OBJS	+= debug.o
 endif
-ifeq ($(CONFIG_KERNEL_LZ4),y)
-CFLAGS_decompress.o := -Os
-endif
 FONTC	= $(srctree)/drivers/video/console/font_acorn_8x8.c
 
 # string library code (-Os is enforced to keep it much smaller)
_

Patches currently in -mm which might be from kyungsik.lee@lge.com are

lib-add-weak-clz-ctz-functions.patch
decompressor-add-lz4-decompressor-module.patch
lib-add-support-for-lz4-compressed-kernel.patch
arm-add-support-for-lz4-compressed-kernel.patch
arm-add-support-for-lz4-compressed-kernel-fix.patch
x86-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel-doc-add-lz4-magic-number-for-the-new-compression.patch
lib-add-lz4-compressor-module.patch
crypto-add-lz4-cryptographic-api.patch
crypto-add-lz4-cryptographic-api-fix.patch

