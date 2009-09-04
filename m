From: akpm@linux-foundation.org
Subject: [to-be-updated] lzo-x86-add-support-for-lzo-compressed-kernels.patch removed from -mm tree
Date: Fri, 04 Sep 2009 16:16:28 -0700
Message-ID: <200909042316.n84NGSOg021496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934473AbZIDXRV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2009 19:17:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: albin.tonnerre@free-electrons.com, hpa@zytor.com, mingo@elte.hu, phillip@lougher.demon.co.uk, rmk@arm.linux.org.uk, sam@ravnborg.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     lzo: x86: add support for LZO-compressed kernels
has been removed from the -mm tree.  Its filename was
     lzo-x86-add-support-for-lzo-compressed-kernels.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lzo: x86: add support for LZO-compressed kernels
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>

This is the third and last part of the patch, which contains the necessary
changes to the x86 Kconfig and boot/compressed to allow the use of this
new compression method

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                  |    1 +
 arch/x86/boot/compressed/Makefile |    6 +++++-
 arch/x86/boot/compressed/misc.c   |    4 ++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff -puN arch/x86/Kconfig~lzo-x86-add-support-for-lzo-compressed-kernels arch/x86/Kconfig
--- a/arch/x86/Kconfig~lzo-x86-add-support-for-lzo-compressed-kernels
+++ a/arch/x86/Kconfig
@@ -42,6 +42,7 @@ config X86
 	select HAVE_KVM
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_KERNEL_LZO
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select USER_STACKTRACE_SUPPORT
diff -puN arch/x86/boot/compressed/Makefile~lzo-x86-add-support-for-lzo-compressed-kernels arch/x86/boot/compressed/Makefile
--- a/arch/x86/boot/compressed/Makefile~lzo-x86-add-support-for-lzo-compressed-kernels
+++ a/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,8 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
+targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 \
+		vmlinux.bin.lzma vmlinux.bin.lzo head_$(BITS).o misc.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -48,10 +49,13 @@ $(obj)/vmlinux.bin.bz2: $(vmlinux.bin.al
 	$(call if_changed,bzip2)
 $(obj)/vmlinux.bin.lzma: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,lzma)
+$(obj)/vmlinux.bin.lzo: $(vmlinux.bin.all-y) FORCE
+	$(call if_changed,lzo)
 
 suffix-$(CONFIG_KERNEL_GZIP)	:= gz
 suffix-$(CONFIG_KERNEL_BZIP2)	:= bz2
 suffix-$(CONFIG_KERNEL_LZMA)	:= lzma
+suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
 
 quiet_cmd_mkpiggy = MKPIGGY $@
       cmd_mkpiggy = $(obj)/mkpiggy $< > $@ || ( rm -f $@ ; false )
diff -puN arch/x86/boot/compressed/misc.c~lzo-x86-add-support-for-lzo-compressed-kernels arch/x86/boot/compressed/misc.c
--- a/arch/x86/boot/compressed/misc.c~lzo-x86-add-support-for-lzo-compressed-kernels
+++ a/arch/x86/boot/compressed/misc.c
@@ -162,6 +162,10 @@ static int lines, cols;
 #include "../../../../lib/decompress_unlzma.c"
 #endif
 
+#ifdef CONFIG_KERNEL_LZO
+#include "../../../../lib/decompress_unlzo.c"
+#endif
+
 static void scroll(void)
 {
 	int i;
_

Patches currently in -mm which might be from albin.tonnerre@free-electrons.com are

linux-next.patch
include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels.patch
lzo-x86-add-support-for-lzo-compressed-kernels.patch
lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch

