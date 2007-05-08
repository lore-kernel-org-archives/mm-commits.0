From: akpm@linux-foundation.org
Subject: - h8300-add-zimage-support.patch removed from -mm tree
Date: Mon, 07 May 2007 17:05:00 -0700
Message-ID: <200705080005.l48050Eq009057@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967371AbXEHAFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:05:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300: add zImage support
has been removed from the -mm tree.  Its filename was
     h8300-add-zimage-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: h8300: add zImage support
From: Yoshinori Sato <ysato@users.sourceforge.jp>

h8300 zImage target support.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/boot/Makefile            |   12 +
 arch/h8300/boot/compressed/Makefile |   37 ++++
 arch/h8300/boot/compressed/head.S   |   47 +++++
 arch/h8300/boot/compressed/misc.c   |  219 ++++++++++++++++++++++++++
 4 files changed, 314 insertions(+), 1 deletion(-)

diff -puN arch/h8300/boot/Makefile~h8300-add-zimage-support arch/h8300/boot/Makefile
--- a/arch/h8300/boot/Makefile~h8300-add-zimage-support
+++ a/arch/h8300/boot/Makefile
@@ -1,12 +1,22 @@
 # arch/h8300/boot/Makefile
 
-targets := vmlinux.srec vmlinux.bin
+targets := vmlinux.srec vmlinux.bin zImage
+subdir- := compressed
 
 OBJCOPYFLAGS_vmlinux.srec := -Osrec
 OBJCOPYFLAGS_vmlinux.bin  := -Obinary
+OBJCOPYFLAGS_zImage := -O binary -R .note -R .comment -R .stab -R .stabstr -S
 
 $(obj)/vmlinux.srec $(obj)/vmlinux.bin:  vmlinux FORCE
 	$(call if_changed,objcopy)
 	@echo '  Kernel: $@ is ready'
 
+$(obj)/zImage: $(obj)/compressed/vmlinux FORCE
+	$(call if_changed,objcopy)
+	@echo 'Kernel: $@ is ready'
+
+$(obj)/compressed/vmlinux: FORCE
+	$(Q)$(MAKE) $(build)=$(obj)/compressed $@
+
 CLEAN_FILES += arch/$(ARCH)/vmlinux.bin arch/$(ARCH)/vmlinux.srec
+
diff -puN /dev/null arch/h8300/boot/compressed/Makefile
--- /dev/null
+++ a/arch/h8300/boot/compressed/Makefile
@@ -0,0 +1,37 @@
+#
+# linux/arch/sh/boot/compressed/Makefile
+#
+# create a compressed vmlinux image from the original vmlinux
+#
+
+targets		:= vmlinux vmlinux.bin vmlinux.bin.gz head.o misc.o piggy.o
+EXTRA_AFLAGS	:= -traditional
+
+OBJECTS = $(obj)/head.o $(obj)/misc.o
+
+#
+# IMAGE_OFFSET is the load offset of the compression loader
+# Assign dummy values if these 2 variables are not defined,
+# in order to suppress error message.
+#
+CONFIG_MEMORY_START     ?= 0x00400000
+CONFIG_BOOT_LINK_OFFSET ?= 0x00400000
+IMAGE_OFFSET := $(shell printf "0x%08x" $$[$(CONFIG_MEMORY_START)+$(CONFIG_BOOT_LINK_OFFSET)])
+
+LDFLAGS_vmlinux := -T $(obj)/vmlinux.lds
+
+$(obj)/vmlinux: $(OBJECTS) $(obj)/piggy.o FORCE
+	$(call if_changed,ld)
+	@:
+
+$(obj)/vmlinux.bin: vmlinux FORCE
+	$(call if_changed,objcopy)
+
+$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
+	$(call if_changed,gzip)
+
+LDFLAGS_piggy.o := -r --format binary --oformat elf32-h8300 -T
+OBJCOPYFLAGS := -O binary
+
+$(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.gz FORCE
+	$(call if_changed,ld)
diff -puN /dev/null arch/h8300/boot/compressed/head.S
--- /dev/null
+++ a/arch/h8300/boot/compressed/head.S
@@ -0,0 +1,47 @@
+/*
+ *  linux/arch/h8300/boot/compressed/head.S
+ *
+ *  Copyright (C) 2006 Yoshinori Sato
+ */
+
+.h8300h
+#include <linux/linkage.h>
+
+#define SRAM_START 0xff4000
+
+	.section	.text.startup
+	.global	startup
+startup:
+	mov.l	#SRAM_START+0x8000, sp
+	mov.l	#__sbss, er0
+	mov.l	#__ebss, er1
+	sub.l	er0, er1
+	shlr	er1
+	shlr	er1
+	sub.l	er2, er2
+1:
+	mov.l	er2, @er0
+	adds	#4, er0
+	dec.l	#1, er1
+	bne	1b
+	jsr	@_decompress_kernel
+	jmp	@0x400000
+
+	.align	9
+fake_headers_as_bzImage:
+	.word	0
+	.ascii	"HdrS"		; header signature
+	.word	0x0202		; header version number (>= 0x0105)
+				; or else old loadlin-1.5 will fail)
+	.word	0		; default_switch
+	.word	0		; SETUPSEG
+	.word	0x1000
+	.word	0		; pointing to kernel version string
+	.byte	0		; = 0, old one (LILO, Loadlin,
+				; 0xTV: T=0 for LILO
+				;       V = version
+	.byte	1		; Load flags bzImage=1
+	.word	0x8000		; size to move, when setup is not
+	.long	0x100000	; 0x100000 = default for big kernel
+	.long	0		; address of loaded ramdisk image
+	.long	0		; its size in bytes
diff -puN /dev/null arch/h8300/boot/compressed/misc.c
--- /dev/null
+++ a/arch/h8300/boot/compressed/misc.c
@@ -0,0 +1,219 @@
+/*
+ * arch/h8300/boot/compressed/misc.c
+ *
+ * This is a collection of several routines from gzip-1.0.3
+ * adapted for Linux.
+ *
+ * malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
+ *
+ * Adapted for h8300 by Yoshinori Sato 2006
+ */
+
+#include <asm/uaccess.h>
+
+/*
+ * gzip declarations
+ */
+
+#define OF(args)  args
+#define STATIC static
+
+#undef memset
+#undef memcpy
+#define memzero(s, n)     memset ((s), 0, (n))
+
+typedef unsigned char  uch;
+typedef unsigned short ush;
+typedef unsigned long  ulg;
+
+#define WSIZE 0x8000		/* Window size must be at least 32k, */
+				/* and a power of two */
+
+static uch *inbuf;	     /* input buffer */
+static uch window[WSIZE];    /* Sliding window buffer */
+
+static unsigned insize = 0;  /* valid bytes in inbuf */
+static unsigned inptr = 0;   /* index of next byte to be processed in inbuf */
+static unsigned outcnt = 0;  /* bytes in output buffer */
+
+/* gzip flag byte */
+#define ASCII_FLAG   0x01 /* bit 0 set: file probably ASCII text */
+#define CONTINUATION 0x02 /* bit 1 set: continuation of multi-part gzip file */
+#define EXTRA_FIELD  0x04 /* bit 2 set: extra field present */
+#define ORIG_NAME    0x08 /* bit 3 set: original file name present */
+#define COMMENT      0x10 /* bit 4 set: file comment present */
+#define ENCRYPTED    0x20 /* bit 5 set: file is encrypted */
+#define RESERVED     0xC0 /* bit 6,7:   reserved */
+
+#define get_byte()  (inptr < insize ? inbuf[inptr++] : fill_inbuf())
+
+/* Diagnostic functions */
+#ifdef DEBUG
+#  define Assert(cond,msg) {if(!(cond)) error(msg);}
+#  define Trace(x) fprintf x
+#  define Tracev(x) {if (verbose) fprintf x ;}
+#  define Tracevv(x) {if (verbose>1) fprintf x ;}
+#  define Tracec(c,x) {if (verbose && (c)) fprintf x ;}
+#  define Tracecv(c,x) {if (verbose>1 && (c)) fprintf x ;}
+#else
+#  define Assert(cond,msg)
+#  define Trace(x)
+#  define Tracev(x)
+#  define Tracevv(x)
+#  define Tracec(c,x)
+#  define Tracecv(c,x)
+#endif
+
+static int  fill_inbuf(void);
+static void flush_window(void);
+static void error(char *m);
+static void gzip_mark(void **);
+static void gzip_release(void **);
+
+extern char input_data[];
+extern int input_len;
+
+static long bytes_out = 0;
+static uch *output_data;
+static unsigned long output_ptr = 0;
+
+static void *malloc(int size);
+static void free(void *where);
+static void error(char *m);
+static void gzip_mark(void **);
+static void gzip_release(void **);
+
+int puts(const char *);
+
+extern int _text;		/* Defined in vmlinux.lds.S */
+extern int _end;
+static unsigned long free_mem_ptr;
+static unsigned long free_mem_end_ptr;
+
+#define HEAP_SIZE             0x10000
+
+#include "../../../../lib/inflate.c"
+
+#define SCR *((volatile unsigned char *)0xffff8a)
+#define TDR *((volatile unsigned char *)0xffff8b)
+#define SSR *((volatile unsigned char *)0xffff8c)
+
+static void *malloc(int size)
+{
+	void *p;
+
+	if (size <0) error("Malloc error");
+	if (free_mem_ptr == 0) error("Memory error");
+
+	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
+
+	p = (void *)free_mem_ptr;
+	free_mem_ptr += size;
+
+	if (free_mem_ptr >= free_mem_end_ptr)
+		error("Out of memory");
+
+	return p;
+}
+
+static void free(void *where)
+{	/* Don't care */
+}
+
+static void gzip_mark(void **ptr)
+{
+	*ptr = (void *) free_mem_ptr;
+}
+
+static void gzip_release(void **ptr)
+{
+	free_mem_ptr = (long) *ptr;
+}
+
+int puts(const char *s)
+{
+	return 0;
+}
+
+void* memset(void* s, int c, size_t n)
+{
+	int i;
+	char *ss = (char*)s;
+
+	for (i=0;i<n;i++) ss[i] = c;
+	return s;
+}
+
+void* memcpy(void* __dest, __const void* __src,
+			    size_t __n)
+{
+	int i;
+	char *d = (char *)__dest, *s = (char *)__src;
+
+	for (i=0;i<__n;i++) d[i] = s[i];
+	return __dest;
+}
+
+/* ===========================================================================
+ * Fill the input buffer. This is called only when the buffer is empty
+ * and at least one byte is really needed.
+ */
+static int fill_inbuf(void)
+{
+	if (insize != 0) {
+		error("ran out of input data");
+	}
+
+	inbuf = input_data;
+	insize = input_len;
+	inptr = 1;
+	return inbuf[0];
+}
+
+/* ===========================================================================
+ * Write the output window window[0..outcnt-1] and update crc and bytes_out.
+ * (Used for the decompressed data only.)
+ */
+static void flush_window(void)
+{
+    ulg c = crc;         /* temporary variable */
+    unsigned n;
+    uch *in, *out, ch;
+
+    in = window;
+    out = &output_data[output_ptr];
+    for (n = 0; n < outcnt; n++) {
+	    ch = *out++ = *in++;
+	    c = crc_32_tab[((int)c ^ ch) & 0xff] ^ (c >> 8);
+    }
+    crc = c;
+    bytes_out += (ulg)outcnt;
+    output_ptr += (ulg)outcnt;
+    outcnt = 0;
+}
+
+static void error(char *x)
+{
+	puts("\n\n");
+	puts(x);
+	puts("\n\n -- System halted");
+
+	while(1);	/* Halt */
+}
+
+#define STACK_SIZE (4096)
+long user_stack [STACK_SIZE];
+long* stack_start = &user_stack[STACK_SIZE];
+
+void decompress_kernel(void)
+{
+	output_data = 0;
+	output_ptr = (unsigned long)0x400000;
+	free_mem_ptr = (unsigned long)&_end;
+	free_mem_end_ptr = free_mem_ptr + HEAP_SIZE;
+
+	makecrc();
+	puts("Uncompressing Linux... ");
+	gunzip();
+	puts("Ok, booting the kernel.\n");
+}
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

origin.patch
