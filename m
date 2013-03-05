From: akpm@linux-foundation.org
Subject: + arm-add-support-for-lz4-compressed-kernel.patch added to -mm tree
Date: Tue, 05 Mar 2013 15:09:06 -0800
Message-ID: <20130305230906.E0B3E31C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:51885 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3CEXJI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 18:09:08 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so799059vea.4
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 15:09:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungsik.lee@lge.com, bp@alien8.de, florian@openwrt.org, hpa@zytor.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de


The patch titled
     Subject: arm: add support for LZ4-compressed kernel
has been added to the -mm tree.  Its filename is
     arm-add-support-for-lz4-compressed-kernel.patch

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
Subject: arm: add support for LZ4-compressed kernel

Integrates the LZ4 decompression code to the arm pre-boot code.

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                      |    1 +
 arch/arm/boot/compressed/.gitignore   |    1 +
 arch/arm/boot/compressed/Makefile     |    6 +++++-
 arch/arm/boot/compressed/decompress.c |    4 ++++
 arch/arm/boot/compressed/piggy.lz4.S  |    6 ++++++
 5 files changed, 17 insertions(+), 1 deletion(-)

diff -puN arch/arm/Kconfig~arm-add-support-for-lz4-compressed-kernel arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-add-support-for-lz4-compressed-kernel
+++ a/arch/arm/Kconfig
@@ -38,6 +38,7 @@ config ARM
 	select HAVE_HW_BREAKPOINT if (PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7))
 	select HAVE_IDE if PCI || ISA || PCMCIA
 	select HAVE_KERNEL_GZIP
+	select HAVE_KERNEL_LZ4
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_XZ
diff -puN arch/arm/boot/compressed/.gitignore~arm-add-support-for-lz4-compressed-kernel arch/arm/boot/compressed/.gitignore
--- a/arch/arm/boot/compressed/.gitignore~arm-add-support-for-lz4-compressed-kernel
+++ a/arch/arm/boot/compressed/.gitignore
@@ -6,6 +6,7 @@ piggy.gzip
 piggy.lzo
 piggy.lzma
 piggy.xzkern
+piggy.lz4
 vmlinux
 vmlinux.lds
 
diff -puN arch/arm/boot/compressed/Makefile~arm-add-support-for-lz4-compressed-kernel arch/arm/boot/compressed/Makefile
--- a/arch/arm/boot/compressed/Makefile~arm-add-support-for-lz4-compressed-kernel
+++ a/arch/arm/boot/compressed/Makefile
@@ -24,6 +24,9 @@ endif
 AFLAGS_head.o += -DTEXT_OFFSET=$(TEXT_OFFSET)
 HEAD	= head.o
 OBJS	+= misc.o decompress.o
+ifeq ($(CONFIG_KERNEL_LZ4),y)
+CFLAGS_decompress.o := -Os
+endif
 FONTC	= $(srctree)/drivers/video/console/font_acorn_8x8.c
 
 # string library code (-Os is enforced to keep it much smaller)
@@ -88,6 +91,7 @@ suffix_$(CONFIG_KERNEL_GZIP) = gzip
 suffix_$(CONFIG_KERNEL_LZO)  = lzo
 suffix_$(CONFIG_KERNEL_LZMA) = lzma
 suffix_$(CONFIG_KERNEL_XZ)   = xzkern
+suffix_$(CONFIG_KERNEL_LZ4)  = lz4
 
 # Borrowed libfdt files for the ATAG compatibility mode
 
@@ -112,7 +116,7 @@ targets       := vmlinux vmlinux.lds \
 		 font.o font.c head.o misc.o $(OBJS)
 
 # Make sure files are removed during clean
-extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xzkern \
+extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xzkern piggy.lz4 \
 		 lib1funcs.S ashldi3.S $(libfdt) $(libfdt_hdrs)
 
 ifeq ($(CONFIG_FUNCTION_TRACER),y)
diff -puN arch/arm/boot/compressed/decompress.c~arm-add-support-for-lz4-compressed-kernel arch/arm/boot/compressed/decompress.c
--- a/arch/arm/boot/compressed/decompress.c~arm-add-support-for-lz4-compressed-kernel
+++ a/arch/arm/boot/compressed/decompress.c
@@ -51,6 +51,10 @@ extern char * strstr(const char * s1, co
 #include "../../../../lib/decompress_unxz.c"
 #endif
 
+#ifdef CONFIG_KERNEL_LZ4
+#include "../../../../lib/decompress_unlz4.c"
+#endif
+
 int do_decompress(u8 *input, int len, u8 *output, void (*error)(char *x))
 {
 	return decompress(input, len, NULL, NULL, output, NULL, error);
diff -puN /dev/null arch/arm/boot/compressed/piggy.lz4.S
--- /dev/null
+++ a/arch/arm/boot/compressed/piggy.lz4.S
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.lz4"
+	.globl	input_data_end
+input_data_end:
_

Patches currently in -mm which might be from kyungsik.lee@lge.com are

decompressor-add-lz4-decompressor-module.patch
lib-add-support-for-lz4-compressed-kernel.patch
arm-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel.patch

