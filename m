From: akpm@linux-foundation.org
Subject: + x86-support-xz-compressed-kernel.patch added to -mm tree
Date: Thu, 09 Dec 2010 13:55:47 -0800
Message-ID: <201012092155.oB9LtmOe009241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932109Ab0LIV4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 16:56:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk


The patch titled
     x86: support XZ-compressed kernel
has been added to the -mm tree.  Its filename is
     x86-support-xz-compressed-kernel.patch

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
Subject: x86: support XZ-compressed kernel
From: Lasse Collin <lasse.collin@tukaani.org>

This integrates the XZ decompression code to the x86 pre-boot code.

mkpiggy.c is updated to reserve about 32 KiB more buffer safety margin for
kernel decompression.  It is done unconditionally for all decompressors to
keep the code simpler.

The XZ decompressor needs around 30 KiB of heap, so the heap size is
increased to 32 KiB on both x86-32 and x86-64.

Documentation/x86/boot.txt is updated to list the XZ magic number.

With the x86 BCJ filter in XZ, XZ-compressed x86 kernel tends to be a few
percent smaller than the equivalent LZMA-compressed kernel.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86/boot.txt         |    6 +++---
 arch/x86/Kconfig                   |    1 +
 arch/x86/boot/compressed/Makefile  |    5 ++++-
 arch/x86/boot/compressed/misc.c    |    4 ++++
 arch/x86/boot/compressed/mkpiggy.c |    2 +-
 arch/x86/include/asm/boot.h        |    6 +-----
 6 files changed, 14 insertions(+), 10 deletions(-)

diff -puN Documentation/x86/boot.txt~x86-support-xz-compressed-kernel Documentation/x86/boot.txt
--- a/Documentation/x86/boot.txt~x86-support-xz-compressed-kernel
+++ a/Documentation/x86/boot.txt
@@ -622,9 +622,9 @@ Protocol:	2.08+
   The payload may be compressed. The format of both the compressed and
   uncompressed data should be determined using the standard magic
   numbers.  The currently supported compression formats are gzip
-  (magic numbers 1F 8B or 1F 9E), bzip2 (magic number 42 5A) and LZMA
-  (magic number 5D 00).  The uncompressed payload is currently always ELF
-  (magic number 7F 45 4C 46).
+  (magic numbers 1F 8B or 1F 9E), bzip2 (magic number 42 5A), LZMA
+  (magic number 5D 00), and XZ (magic number FD 37).  The uncompressed
+  payload is currently always ELF (magic number 7F 45 4C 46).
   
 Field name:	payload_length
 Type:		read
diff -puN arch/x86/Kconfig~x86-support-xz-compressed-kernel arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-support-xz-compressed-kernel
+++ a/arch/x86/Kconfig
@@ -51,6 +51,7 @@ config X86
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
+	select HAVE_KERNEL_XZ
 	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
 	select HAVE_MIXED_BREAKPOINTS_REGS
diff -puN arch/x86/boot/compressed/Makefile~x86-support-xz-compressed-kernel arch/x86/boot/compressed/Makefile
--- a/arch/x86/boot/compressed/Makefile~x86-support-xz-compressed-kernel
+++ a/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.lzo head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o
+targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -49,12 +49,15 @@ $(obj)/vmlinux.bin.bz2: $(vmlinux.bin.al
 	$(call if_changed,bzip2)
 $(obj)/vmlinux.bin.lzma: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,lzma)
+$(obj)/vmlinux.bin.xz: $(vmlinux.bin.all-y) FORCE
+	$(call if_changed,xzkern)
 $(obj)/vmlinux.bin.lzo: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,lzo)
 
 suffix-$(CONFIG_KERNEL_GZIP)	:= gz
 suffix-$(CONFIG_KERNEL_BZIP2)	:= bz2
 suffix-$(CONFIG_KERNEL_LZMA)	:= lzma
+suffix-$(CONFIG_KERNEL_XZ)	:= xz
 suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
 
 quiet_cmd_mkpiggy = MKPIGGY $@
diff -puN arch/x86/boot/compressed/misc.c~x86-support-xz-compressed-kernel arch/x86/boot/compressed/misc.c
--- a/arch/x86/boot/compressed/misc.c~x86-support-xz-compressed-kernel
+++ a/arch/x86/boot/compressed/misc.c
@@ -139,6 +139,10 @@ static int lines, cols;
 #include "../../../../lib/decompress_unlzma.c"
 #endif
 
+#ifdef CONFIG_KERNEL_XZ
+#include "../../../../lib/decompress_unxz.c"
+#endif
+
 #ifdef CONFIG_KERNEL_LZO
 #include "../../../../lib/decompress_unlzo.c"
 #endif
diff -puN arch/x86/boot/compressed/mkpiggy.c~x86-support-xz-compressed-kernel arch/x86/boot/compressed/mkpiggy.c
--- a/arch/x86/boot/compressed/mkpiggy.c~x86-support-xz-compressed-kernel
+++ a/arch/x86/boot/compressed/mkpiggy.c
@@ -74,7 +74,7 @@ int main(int argc, char *argv[])
 
 	offs = (olen > ilen) ? olen - ilen : 0;
 	offs += olen >> 12;	/* Add 8 bytes for each 32K block */
-	offs += 32*1024 + 18;	/* Add 32K + 18 bytes slack */
+	offs += 64*1024 + 128;	/* Add 64K + 128 bytes slack */
 	offs = (offs+4095) & ~4095; /* Round to a 4K boundary */
 
 	printf(".section \".rodata..compressed\",\"a\",@progbits\n");
diff -puN arch/x86/include/asm/boot.h~x86-support-xz-compressed-kernel arch/x86/include/asm/boot.h
--- a/arch/x86/include/asm/boot.h~x86-support-xz-compressed-kernel
+++ a/arch/x86/include/asm/boot.h
@@ -32,11 +32,7 @@
 #define BOOT_HEAP_SIZE             0x400000
 #else /* !CONFIG_KERNEL_BZIP2 */
 
-#ifdef CONFIG_X86_64
-#define BOOT_HEAP_SIZE	0x7000
-#else
-#define BOOT_HEAP_SIZE	0x4000
-#endif
+#define BOOT_HEAP_SIZE	0x8000
 
 #endif /* !CONFIG_KERNEL_BZIP2 */
 
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

decompressors-add-missing-init-ie-__init.patch
decompressors-get-rid-of-set_error_fn-macro.patch
decompressors-include-linux-slabh-in-linux-decompress-mmh.patch
decompressors-remove-unused-function-from-lib-decompress_unlzmac.patch
decompressors-fix-header-validation-in-decompress_unlzmac.patch
decompressors-check-for-read-errors-in-decompress_unlzmac.patch
decompressors-check-for-write-errors-in-decompress_unlzmac.patch
decompressors-validate-match-distance-in-decompress_unlzmac.patch
decompressors-check-for-write-errors-in-decompress_unlzoc.patch
decompressors-check-input-size-in-decompress_unlzoc.patch
decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc.patch
decompressors-add-xz-decompressor-module.patch
decompressors-add-boot-time-xz-support.patch
x86-support-xz-compressed-kernel.patch

