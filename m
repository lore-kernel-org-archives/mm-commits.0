From: akpm@linux-foundation.org
Subject: [folded-merged]
 arm-add-support-for-lz4-compressed-kernel-fix.patch removed from -mm tree
Date: Mon, 08 Jul 2013 15:34:23 -0700
Message-ID: <51db3e6f.GoicLT9/vhmIEfHw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHWeY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:34:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yann.collet.73@gmail.com, tglx@linutronix.de, rmk@arm.linux.org.uk, florian@openwrt.org, bp@alien8.de, kyungsik.lee@lge.com

Subject: [folded-merged] arm-add-support-for-lz4-compressed-kernel-fix.patch removed from -mm tree
To: kyungsik.lee@lge.com,bp@alien8.de,florian@openwrt.org,rmk@arm.linux.org.uk,tglx@linutronix.de,yann.collet.73@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:34:23 -0700


The patch titled
     Subject: arm: Remove enforced Os flag for LZ4 decompressor
has been removed from the -mm tree.  Its filename was
     arm-add-support-for-lz4-compressed-kernel-fix.patch

This patch was dropped because it was folded into arm-add-support-for-lz4-compressed-kernel.patch

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
 FONTC	= $(srctree)/lib/fonts/font_acorn_8x8.c
 
 # string library code (-Os is enforced to keep it much smaller)
_

Patches currently in -mm which might be from kyungsik.lee@lge.com are

lib-add-weak-clz-ctz-functions.patch
decompressor-add-lz4-decompressor-module.patch
lib-add-support-for-lz4-compressed-kernel.patch
lib-add-support-for-lz4-compressed-kernel-kbuild-fix-for-updated-lz4-tool-with-the-new-streaming-format.patch
arm-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel-doc-add-lz4-magic-number-for-the-new-compression.patch
lib-add-lz4-compressor-module.patch
crypto-add-lz4-cryptographic-api.patch
crypto-add-lz4-cryptographic-api-fix.patch

