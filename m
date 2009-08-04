From: akpm@linux-foundation.org
Subject: + lzo-arm-add-support-for-lzo-compressed-kernels.patch added to -mm tree
Date: Tue, 04 Aug 2009 16:02:42 -0700
Message-ID: <200908042302.n74N2hW2019540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933363AbZHDXDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 19:03:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albin.tonnerre@free-electrons.com, hpa@zytor.com, mingo@elte.hu, phillip@lougher.demon.co.uk, rmk@arm.linux.org.uk, sam@ravnborg.org, tglx@linutronix.de


The patch titled
     lzo: arm: add support for LZO-compressed kernels
has been added to the -mm tree.  Its filename is
     lzo-arm-add-support-for-lzo-compressed-kernels.patch

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
Subject: lzo: arm: add support for LZO-compressed kernels
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>

This is the second part of patch. This part includes:
 - changes to ach/arch/boot/Makefile to make it easier to add new
   compression types
 - new piggy.lzo.S necessary for lzo compression
 - changes in arch/arm/boot/compressed/misc.c to allow the use of lzo or
   gzip, depending on the config
 - Kconfig support

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                      |    2 
 arch/arm/boot/compressed/Makefile     |   16 ++-
 arch/arm/boot/compressed/misc.c       |  110 ++++++------------------
 arch/arm/boot/compressed/piggy.S      |    6 -
 arch/arm/boot/compressed/piggy.gzip.S |    6 +
 arch/arm/boot/compressed/piggy.lzo.S  |    6 +
 6 files changed, 52 insertions(+), 94 deletions(-)

diff -puN arch/arm/Kconfig~lzo-arm-add-support-for-lzo-compressed-kernels arch/arm/Kconfig
--- a/arch/arm/Kconfig~lzo-arm-add-support-for-lzo-compressed-kernels
+++ a/arch/arm/Kconfig
@@ -18,6 +18,8 @@ config ARM
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
 	select HAVE_GENERIC_DMA_COHERENT
+	select HAVE_KERNEL_GZIP
+	select HAVE_KERNEL_LZO
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff -puN arch/arm/boot/compressed/Makefile~lzo-arm-add-support-for-lzo-compressed-kernels arch/arm/boot/compressed/Makefile
--- a/arch/arm/boot/compressed/Makefile~lzo-arm-add-support-for-lzo-compressed-kernels
+++ a/arch/arm/boot/compressed/Makefile
@@ -63,8 +63,12 @@ endif
 
 SEDFLAGS	= s/TEXT_START/$(ZTEXTADDR)/;s/BSS_START/$(ZBSSADDR)/
 
-targets       := vmlinux vmlinux.lds piggy.gz piggy.o font.o font.c \
-		 head.o misc.o $(OBJS)
+suffix_$(CONFIG_KERNEL_GZIP) = gzip
+suffix_$(CONFIG_KERNEL_LZO)  = lzo
+
+targets       := vmlinux vmlinux.lds \
+		 piggy.$(suffix_y) piggy.$(suffix_y).o \
+		 font.o font.c head.o misc.o $(OBJS)
 
 ifeq ($(CONFIG_FUNCTION_TRACER),y)
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
@@ -94,15 +98,15 @@ LDFLAGS_vmlinux += -p --no-undefined -X 
 # would otherwise mess up our GOT table
 CFLAGS_misc.o := -Dstatic=
 
-$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.o \
+$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.$(suffix_y).o \
 	 	$(addprefix $(obj)/, $(OBJS)) FORCE
 	$(call if_changed,ld)
 	@:
 
-$(obj)/piggy.gz: $(obj)/../Image FORCE
-	$(call if_changed,gzip)
+$(obj)/piggy.$(suffix_y): $(obj)/../Image FORCE
+	$(call if_changed,$(suffix_y))
 
-$(obj)/piggy.o:  $(obj)/piggy.gz FORCE
+$(obj)/piggy.$(suffix_y).o:  $(obj)/piggy.$(suffix_y) FORCE
 
 CFLAGS_font.o := -Dstatic=
 
diff -puN arch/arm/boot/compressed/misc.c~lzo-arm-add-support-for-lzo-compressed-kernels arch/arm/boot/compressed/misc.c
--- a/arch/arm/boot/compressed/misc.c~lzo-arm-add-support-for-lzo-compressed-kernels
+++ a/arch/arm/boot/compressed/misc.c
@@ -18,11 +18,15 @@
 
 unsigned int __machine_arch_type;
 
+#define _LINUX_STRING_H_
+
 #include <linux/compiler.h>	/* for inline */
 #include <linux/types.h>	/* for size_t */
 #include <linux/stddef.h>	/* for NULL */
 #include <asm/string.h>
 
+#include <asm/unaligned.h>
+
 #ifdef STANDALONE_DEBUG
 #define putstr printf
 #else
@@ -188,34 +192,8 @@ static inline __ptr_t memcpy(__ptr_t __d
 /*
  * gzip delarations
  */
-#define OF(args)  args
 #define STATIC static
 
-typedef unsigned char  uch;
-typedef unsigned short ush;
-typedef unsigned long  ulg;
-
-#define WSIZE 0x8000		/* Window size must be at least 32k, */
-				/* and a power of two */
-
-static uch *inbuf;		/* input buffer */
-static uch window[WSIZE];	/* Sliding window buffer */
-
-static unsigned insize;		/* valid bytes in inbuf */
-static unsigned inptr;		/* index of next byte to be processed in inbuf */
-static unsigned outcnt;		/* bytes in output buffer */
-
-/* gzip flag byte */
-#define ASCII_FLAG   0x01 /* bit 0 set: file probably ascii text */
-#define CONTINUATION 0x02 /* bit 1 set: continuation of multi-part gzip file */
-#define EXTRA_FIELD  0x04 /* bit 2 set: extra field present */
-#define ORIG_NAME    0x08 /* bit 3 set: original file name present */
-#define COMMENT      0x10 /* bit 4 set: file comment present */
-#define ENCRYPTED    0x20 /* bit 5 set: file is encrypted */
-#define RESERVED     0xC0 /* bit 6,7:   reserved */
-
-#define get_byte()  (inptr < insize ? inbuf[inptr++] : fill_inbuf())
-
 /* Diagnostic functions */
 #ifdef DEBUG
 #  define Assert(cond,msg) {if(!(cond)) error(msg);}
@@ -233,24 +211,20 @@ static unsigned outcnt;		/* bytes in out
 #  define Tracecv(c,x)
 #endif
 
-static int  fill_inbuf(void);
-static void flush_window(void);
 static void error(char *m);
 
 extern char input_data[];
 extern char input_data_end[];
 
-static uch *output_data;
-static ulg output_ptr;
-static ulg bytes_out;
+static unsigned char *output_data;
+static unsigned long output_ptr;
 
 static void error(char *m);
 
 static void putstr(const char *);
 
-extern int end;
-static ulg free_mem_ptr;
-static ulg free_mem_end_ptr;
+static unsigned long free_mem_ptr;
+static unsigned long free_mem_end_ptr;
 
 #ifdef STANDALONE_DEBUG
 #define NO_INFLATE_MALLOC
@@ -258,46 +232,13 @@ static ulg free_mem_end_ptr;
 
 #define ARCH_HAS_DECOMP_WDOG
 
-#include "../../../../lib/inflate.c"
-
-/* ===========================================================================
- * Fill the input buffer. This is called only when the buffer is empty
- * and at least one byte is really needed.
- */
-int fill_inbuf(void)
-{
-	if (insize != 0)
-		error("ran out of input data");
-
-	inbuf = input_data;
-	insize = &input_data_end[0] - &input_data[0];
-
-	inptr = 1;
-	return inbuf[0];
-}
+#ifdef CONFIG_KERNEL_GZIP
+#include "../../../../lib/decompress_inflate.c"
+#endif
 
-/* ===========================================================================
- * Write the output window window[0..outcnt-1] and update crc and bytes_out.
- * (Used for the decompressed data only.)
- */
-void flush_window(void)
-{
-	ulg c = crc;
-	unsigned n;
-	uch *in, *out, ch;
-
-	in = window;
-	out = &output_data[output_ptr];
-	for (n = 0; n < outcnt; n++) {
-		ch = *out++ = *in++;
-		c = crc_32_tab[((int)c ^ ch) & 0xff] ^ (c >> 8);
-	}
-	crc = c;
-	bytes_out += (ulg)outcnt;
-	output_ptr += (ulg)outcnt;
-	outcnt = 0;
-	putstr(".");
-}
+#ifdef CONFIG_KERNEL_LZO
+#include "../../../../lib/decompress_unlzo.c"
+#endif
 
 #ifndef arch_error
 #define arch_error(x)
@@ -316,20 +257,26 @@ static void error(char *x)
 
 #ifndef STANDALONE_DEBUG
 
-ulg
-decompress_kernel(ulg output_start, ulg free_mem_ptr_p, ulg free_mem_ptr_end_p,
-		  int arch_id)
+unsigned long
+decompress_kernel(unsigned long output_start, unsigned long free_mem_ptr_p,
+                  unsigned long free_mem_ptr_end_p,
+                  int arch_id)
 {
-	output_data		= (uch *)output_start;	/* Points to kernel start */
+	unsigned char *tmp;
+
+	output_data		= (unsigned char *)output_start;
 	free_mem_ptr		= free_mem_ptr_p;
 	free_mem_end_ptr	= free_mem_ptr_end_p;
 	__machine_arch_type	= arch_id;
 
 	arch_decomp_setup();
 
-	makecrc();
+	tmp = (unsigned char *) (((unsigned long)input_data_end) - 4);
+	output_ptr = get_unaligned_le32(tmp);
+
 	putstr("Uncompressing Linux...");
-	gunzip();
+	decompress(input_data, input_data_end - input_data,
+	           NULL, NULL, output_data, NULL, error);
 	putstr(" done, booting the kernel.\n");
 	return output_ptr;
 }
@@ -341,11 +288,10 @@ int main()
 {
 	output_data = output_buffer;
 
-	makecrc();
 	putstr("Uncompressing Linux...");
-	gunzip();
+	decompress(input_data, input_data_end - input_data,
+	           NULL, NULL, output_data, NULL, error);
 	putstr("done.\n");
 	return 0;
 }
 #endif
-	
diff -puN arch/arm/boot/compressed/piggy.S~lzo-arm-add-support-for-lzo-compressed-kernels /dev/null
--- a/arch/arm/boot/compressed/piggy.S
+++ /dev/null
@@ -1,6 +0,0 @@
-	.section .piggydata,#alloc
-	.globl	input_data
-input_data:
-	.incbin	"arch/arm/boot/compressed/piggy.gz"
-	.globl	input_data_end
-input_data_end:
diff -puN /dev/null arch/arm/boot/compressed/piggy.gzip.S
--- /dev/null
+++ a/arch/arm/boot/compressed/piggy.gzip.S
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.gzip"
+	.globl	input_data_end
+input_data_end:
diff -puN /dev/null arch/arm/boot/compressed/piggy.lzo.S
--- /dev/null
+++ a/arch/arm/boot/compressed/piggy.lzo.S
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.lzo"
+	.globl	input_data_end
+input_data_end:
_

Patches currently in -mm which might be from albin.tonnerre@free-electrons.com are

lib-decompress_-only-include-linux-slabh-if-static-is-not-defined.patch
include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels.patch
lzo-add-support-for-lzo-compressed-kernels.patch
lzo-arm-add-support-for-lzo-compressed-kernels.patch
lzo-x86-add-support-for-lzo-compressed-kernels.patch
lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch

