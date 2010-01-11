From: akpm@linux-foundation.org
Subject: [merged] x86-add-support-for-lzo-compressed-kernels.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:18:06 -0800
Message-ID: <201001112018.o0BKI6oG025458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276Ab0AKUig (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:38:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: albin.tonnerre@free-electrons.com, hpa@zytor.com, mingo@elte.hu, ralf@linux-mips.org, rmk@arm.linux.org.uk, tglx@linutronix.de, wuzhangjin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     x86: add support for LZO-compressed kernels
has been removed from the -mm tree.  Its filename was
     x86-add-support-for-lzo-compressed-kernels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: add support for LZO-compressed kernels
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>

The necessary changes to the x86 Kconfig and boot/compressed to allow the
use of this new compression method

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Tested-by: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Russell King <rmk@arm.linux.org.uk>
Acked-by: Russell King <rmk@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                  |    1 +
 arch/x86/boot/compressed/Makefile |    5 ++++-
 arch/x86/boot/compressed/misc.c   |    4 ++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff -puN arch/x86/Kconfig~x86-add-support-for-lzo-compressed-kernels arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-add-support-for-lzo-compressed-kernels
+++ a/arch/x86/Kconfig
@@ -49,6 +49,7 @@ config X86
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
+	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
 	select PERF_EVENTS
 	select ANON_INODES
diff -puN arch/x86/boot/compressed/Makefile~x86-add-support-for-lzo-compressed-kernels arch/x86/boot/compressed/Makefile
--- a/arch/x86/boot/compressed/Makefile~x86-add-support-for-lzo-compressed-kernels
+++ a/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
+targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.lzo head_$(BITS).o misc.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -49,10 +49,13 @@ $(obj)/vmlinux.bin.bz2: $(vmlinux.bin.al
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
diff -puN arch/x86/boot/compressed/misc.c~x86-add-support-for-lzo-compressed-kernels arch/x86/boot/compressed/misc.c
--- a/arch/x86/boot/compressed/misc.c~x86-add-support-for-lzo-compressed-kernels
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

origin.patch
linux-next.patch
lzo-fix-up-add-support-for-lzo-compressed-kernels-patch.patch

