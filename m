From: akpm@linux-foundation.org
Subject: + x86-add-support-for-lz4-compressed-kernel.patch added to -mm tree
Date: Tue, 05 Mar 2013 15:09:08 -0800
Message-ID: <20130305230908.DD8E231C1E1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56022 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3CEXJK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 18:09:10 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so269015qcs.3
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 15:09:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungsik.lee@lge.com, bp@alien8.de, florian@openwrt.org, hpa@zytor.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de


The patch titled
     Subject: x86: add support for LZ4-compressed kernel
has been added to the -mm tree.  Its filename is
     x86-add-support-for-lz4-compressed-kernel.patch

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
Subject: x86: add support for LZ4-compressed kernel

Integrate the LZ4 decompression code to the x86 pre-boot code.

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                  |    1 +
 arch/x86/boot/compressed/Makefile |    5 ++++-
 arch/x86/boot/compressed/misc.c   |    4 ++++
 3 files changed, 9 insertions(+), 1 deletion(-)

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
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o
+targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo vmlinux.bin.lz4 head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -64,12 +64,15 @@ $(obj)/vmlinux.bin.xz: $(vmlinux.bin.all
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

decompressor-add-lz4-decompressor-module.patch
lib-add-support-for-lz4-compressed-kernel.patch
arm-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel.patch

