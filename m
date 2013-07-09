From: akpm@linux-foundation.org
Subject: [merged] arm-add-support-for-lz4-compressed-kernel.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:22:25 -0700
Message-ID: <51dc9b31.jICxmfRCr1XActi2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab3GIXW0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:22:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yann.collet.73@gmail.com, tglx@linutronix.de, rmk@arm.linux.org.uk, mingo@elte.hu, hpa@zytor.com, florian@openwrt.org, bp@alien8.de, kyungsik.lee@lge.com

Subject: [merged] arm-add-support-for-lz4-compressed-kernel.patch removed from -mm tree
To: kyungsik.lee@lge.com,bp@alien8.de,florian@openwrt.org,hpa@zytor.com,mingo@elte.hu,rmk@arm.linux.org.uk,tglx@linutronix.de,yann.collet.73@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:22:25 -0700


The patch titled
     Subject: arm: add support for LZ4-compressed kernel
has been removed from the -mm tree.  Its filename was
     arm-add-support-for-lz4-compressed-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Yann Collet <yann.collet.73@gmail.com>
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

 Documentation/x86/boot.txt            |    7 ++++---
 arch/arm/Kconfig                      |    1 +
 arch/arm/boot/compressed/.gitignore   |    1 +
 arch/arm/boot/compressed/Makefile     |    3 ++-
 arch/arm/boot/compressed/decompress.c |    4 ++++
 arch/arm/boot/compressed/piggy.lz4.S  |    6 ++++++
 arch/x86/Kconfig                      |    1 +
 arch/x86/boot/compressed/Makefile     |    6 +++++-
 arch/x86/boot/compressed/misc.c       |    4 ++++
 9 files changed, 28 insertions(+), 5 deletions(-)

diff -puN Documentation/x86/boot.txt~arm-add-support-for-lz4-compressed-kernel Documentation/x86/boot.txt
--- a/Documentation/x86/boot.txt~arm-add-support-for-lz4-compressed-kernel
+++ a/Documentation/x86/boot.txt
@@ -657,9 +657,10 @@ Protocol:	2.08+
   uncompressed data should be determined using the standard magic
   numbers.  The currently supported compression formats are gzip
   (magic numbers 1F 8B or 1F 9E), bzip2 (magic number 42 5A), LZMA
-  (magic number 5D 00), and XZ (magic number FD 37).  The uncompressed
-  payload is currently always ELF (magic number 7F 45 4C 46).
-  
+  (magic number 5D 00), XZ (magic number FD 37), and LZ4 (magic number
+  02 21).  The uncompressed payload is currently always ELF (magic
+  number 7F 45 4C 46).
+
 Field name:	payload_length
 Type:		read
 Offset/size:	0x24c/4
diff -puN arch/arm/Kconfig~arm-add-support-for-lz4-compressed-kernel arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-add-support-for-lz4-compressed-kernel
+++ a/arch/arm/Kconfig
@@ -41,6 +41,7 @@ config ARM
 	select HAVE_IDE if PCI || ISA || PCMCIA
 	select HAVE_IRQ_TIME_ACCOUNTING
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
@@ -91,6 +91,7 @@ suffix_$(CONFIG_KERNEL_GZIP) = gzip
 suffix_$(CONFIG_KERNEL_LZO)  = lzo
 suffix_$(CONFIG_KERNEL_LZMA) = lzma
 suffix_$(CONFIG_KERNEL_XZ)   = xzkern
+suffix_$(CONFIG_KERNEL_LZ4)  = lz4
 
 # Borrowed libfdt files for the ATAG compatibility mode
 
@@ -115,7 +116,7 @@ targets       := vmlinux vmlinux.lds \
 		 font.o font.c head.o misc.o $(OBJS)
 
 # Make sure files are removed during clean
-extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xzkern \
+extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xzkern piggy.lz4 \
 		 lib1funcs.S ashldi3.S $(libfdt) $(libfdt_hdrs) \
 		 hyp-stub.S
 
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
diff -puN arch/x86/Kconfig~arm-add-support-for-lz4-compressed-kernel arch/x86/Kconfig
--- a/arch/x86/Kconfig~arm-add-support-for-lz4-compressed-kernel
+++ a/arch/x86/Kconfig
@@ -65,6 +65,7 @@ config X86
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_XZ
 	select HAVE_KERNEL_LZO
+	select HAVE_KERNEL_LZ4
 	select HAVE_HW_BREAKPOINT
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select PERF_EVENTS
diff -puN arch/x86/boot/compressed/Makefile~arm-add-support-for-lz4-compressed-kernel arch/x86/boot/compressed/Makefile
--- a/arch/x86/boot/compressed/Makefile~arm-add-support-for-lz4-compressed-kernel
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
diff -puN arch/x86/boot/compressed/misc.c~arm-add-support-for-lz4-compressed-kernel arch/x86/boot/compressed/misc.c
--- a/arch/x86/boot/compressed/misc.c~arm-add-support-for-lz4-compressed-kernel
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

origin.patch

