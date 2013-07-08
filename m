From: akpm@linux-foundation.org
Subject: [folded-merged] x86-add-support-for-lz4-compressed-kernel.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 15:34:26 -0700
Message-ID: <51db3e72.mZOO9gV4fUs+WyYO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab3GHWe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yann.collet.73@gmail.com, tglx@linutronix.de, rmk@arm.linux.org.uk, mingo@elte.hu, hpa@zytor.com, florian@openwrt.org, bp@alien8.de, kyungsik.lee@lge.com

Subject: [folded-merged] x86-add-support-for-lz4-compressed-kernel.patch removed from -mm tree
To: kyungsik.lee@lge.com,bp@alien8.de,florian@openwrt.org,hpa@zytor.com,mingo@elte.hu,rmk@arm.linux.org.uk,tglx@linutronix.de,yann.collet.73@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:34:26 -0700


The patch titled
     Subject: x86: add support for LZ4-compressed kernel
has been removed from the -mm tree.  Its filename was
     x86-add-support-for-lz4-compressed-kernel.patch

This patch was dropped because it was folded into arm-add-support-for-lz4-compressed-kernel.patch

------------------------------------------------------
From: Kyungsik Lee <kyungsik.lee@lge.com>
Subject: x86: add support for LZ4-compressed kernel

Integrate the LZ4 decompression code to the x86 pre-boot code.

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Yann Collet <yann.collet.73@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                  |    1 +
 arch/x86/boot/compressed/Makefile |    6 +++++-
 arch/x86/boot/compressed/misc.c   |    4 ++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff -puN arch/x86/Kconfig~x86-add-support-for-lz4-compressed-kernel arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-add-support-for-lz4-compressed-kernel
+++ a/arch/x86/Kconfig
@@ -65,6 +65,7 @@ config X86
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_XZ
 	select HAVE_KERNEL_LZO
+	select HAVE_KERNEL_LZ4
 	select HAVE_HW_BREAKPOINT
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select PERF_EVENTS
diff -puN arch/x86/boot/compressed/Makefile~x86-add-support-for-lz4-compressed-kernel arch/x86/boot/compressed/Makefile
--- a/arch/x86/boot/compressed/Makefile~x86-add-support-for-lz4-compressed-kernel
+++ a/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,8 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo
+targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma \
+	vmlinux.bin.xz vmlinux.bin.lzo vmlinux.bin.lz4
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -63,12 +64,15 @@ $(obj)/vmlinux.bin.xz: $(vmlinux.bin.all
 	$(call if_changed,xzkern)
 $(obj)/vmlinux.bin.lzo: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,lzo)
+$(obj)/vmlinux.bin.lz4: $(vmlinux.bin.all-y) FORCE
+	$(call if_changed,lz4)
 
 suffix-$(CONFIG_KERNEL_GZIP)	:= gz
 suffix-$(CONFIG_KERNEL_BZIP2)	:= bz2
 suffix-$(CONFIG_KERNEL_LZMA)	:= lzma
 suffix-$(CONFIG_KERNEL_XZ)	:= xz
 suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
+suffix-$(CONFIG_KERNEL_LZ4) 	:= lz4
 
 quiet_cmd_mkpiggy = MKPIGGY $@
       cmd_mkpiggy = $(obj)/mkpiggy $< > $@ || ( rm -f $@ ; false )
diff -puN arch/x86/boot/compressed/misc.c~x86-add-support-for-lz4-compressed-kernel arch/x86/boot/compressed/misc.c
--- a/arch/x86/boot/compressed/misc.c~x86-add-support-for-lz4-compressed-kernel
+++ a/arch/x86/boot/compressed/misc.c
@@ -145,6 +145,10 @@ static int lines, cols;
 #include "../../../../lib/decompress_unlzo.c"
 #endif
 
+#ifdef CONFIG_KERNEL_LZ4
+#include "../../../../lib/decompress_unlz4.c"
+#endif
+
 static void scroll(void)
 {
 	int i;
_

Patches currently in -mm which might be from kyungsik.lee@lge.com are

lib-add-weak-clz-ctz-functions.patch
decompressor-add-lz4-decompressor-module.patch
lib-add-support-for-lz4-compressed-kernel.patch
lib-add-support-for-lz4-compressed-kernel-kbuild-fix-for-updated-lz4-tool-with-the-new-streaming-format.patch
arm-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel-doc-add-lz4-magic-number-for-the-new-compression.patch
lib-add-lz4-compressor-module.patch
crypto-add-lz4-cryptographic-api.patch
crypto-add-lz4-cryptographic-api-fix.patch

