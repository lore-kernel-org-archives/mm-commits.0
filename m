From: akpm@linux-foundation.org
Subject: + x86-add-support-for-lzo-compressed-kernels.patch added to -mm tree
Date: Thu, 12 Nov 2009 14:34:13 -0800
Message-ID: <200911122234.nACMYEcw025291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754801AbZKLWee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 17:34:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albin.tonnerre@free-electrons.com, hpa@zytor.com, mingo@elte.hu, ralf@linux-mips.org, rmk@arm.linux.org.uk, tglx@linutronix.de, wuzhangjin@gmail.com


The patch titled
     x86: add support for LZO-compressed kernels
has been added to the -mm tree.  Its filename is
     x86-add-support-for-lzo-compressed-kernels.patch

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
Subject: x86: add support for LZO-compressed kernels
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>

The necessary changes to the x86 Kconfig and boot/compressed to allow the
use of this new compression method

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Tested-by: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
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
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
 
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
@@ -48,10 +48,13 @@ $(obj)/vmlinux.bin.bz2: $(vmlinux.bin.al
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

linux-next.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops-fix.patch
lib-add-support-for-lzo-compressed-kernels.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
arm-add-support-for-lzo-compressed-kernels.patch
x86-add-support-for-lzo-compressed-kernels.patch
add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch

