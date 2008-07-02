From: akpm@linux-foundation.org
Subject: + inflate-refactor-inflate-malloc-code.patch added to -mm tree
Date: Tue, 01 Jul 2008 20:29:43 -0700
Message-ID: <200807020329.m623ThO4029179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbYGBDbT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 23:31:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas.petazzoni@free-electrons.com, andi@firstfloor.org, dhowells@redhat.com, hpa@zytor.com, hskinnemoen@atmel.com, ink@jurassic.park.msu.ru, jesper.nilsson@axis.com, lethal@linux-sh.org, mikael.starvik@axis.com, mingo@elte.hu, mpm@selenic.com, rth@twiddle.net, tglx@linutronix.de, ysato@users.sourceforge.jp


The patch titled
     inflate: refactor inflate malloc code
has been added to the -mm tree.  Its filename is
     inflate-refactor-inflate-malloc-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: inflate: refactor inflate malloc code
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Inflate requires some dynamic memory allocation very early in the boot
process and this is provided with a set of four functions:
malloc/free/gzip_mark/gzip_release.

The old inflate code used a mark/release strategy rather than implement
free.  This new version instead keeps a count on the number of outstanding
allocations and when it hits zero, it resets the malloc arena.

This allows removing all the mark and release implementations and unifying
all the malloc/free implementations.

The architecture-dependent code must define two addresses:
 - free_mem_ptr, the address of the beginning of the area in which
   allocations should be made
 - free_mem_end_ptr, the address of the end of the area in which
   allocations should be made. If set to 0, then no check is made on
   the number of allocations, it just grows as much as needed

The architecture-dependent code can also provide an arch_decomp_wdog()
function call.  This function will be called several times during the
decompression process, and allow to notify the watchdog that the system is
still running.  If an architecture provides such a call, then it must
define ARCH_HAS_DECOMP_WDOG so that the generic inflate code calls
arch_decomp_wdog().

Work initially done by Matt Mackall, updated to a recent version of the
kernel and improved by me.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/boot/misc.c                    |   39 -------------
 arch/arm/boot/compressed/misc.c           |   59 ++------------------
 arch/cris/arch-v10/boot/compressed/misc.c |   35 -----------
 arch/cris/arch-v32/boot/compressed/misc.c |   35 -----------
 arch/h8300/boot/compressed/misc.c         |   38 ------------
 arch/m32r/boot/compressed/misc.c          |   37 ------------
 arch/mn10300/boot/compressed/misc.c       |   37 ------------
 arch/sh/boot/compressed/misc_32.c         |   38 ------------
 arch/sh/boot/compressed/misc_64.c         |   40 -------------
 arch/x86/boot/compressed/misc.c           |   39 -------------
 init/do_mounts_rd.c                       |   25 --------
 init/initramfs.c                          |   22 -------
 lib/inflate.c                             |   52 +++++++++++++++--
 13 files changed, 60 insertions(+), 436 deletions(-)

diff -puN arch/alpha/boot/misc.c~inflate-refactor-inflate-malloc-code arch/alpha/boot/misc.c
--- a/arch/alpha/boot/misc.c~inflate-refactor-inflate-malloc-code
+++ a/arch/alpha/boot/misc.c
@@ -78,8 +78,6 @@ static unsigned outcnt;		/* bytes in out
 static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 static char *input_data;
 static int  input_data_size;
@@ -88,51 +86,18 @@ static uch *output_data;
 static ulg output_ptr;
 static ulg bytes_out;
 
-static void *malloc(int size);
-static void free(void *where);
 static void error(char *m);
 static void gzip_mark(void **);
 static void gzip_release(void **);
 
 extern int end;
 static ulg free_mem_ptr;
-static ulg free_mem_ptr_end;
+static ulg free_mem_end_ptr;
 
 #define HEAP_SIZE 0x3000
 
 #include "../../../lib/inflate.c"
 
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-	if (free_mem_ptr <= 0) error("Memory error");
-
-	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p = (void *)free_mem_ptr;
-	free_mem_ptr += size;
-
-	if (free_mem_ptr >= free_mem_ptr_end)
-		error("Out of memory");
-	return p;
-}
-
-static void free(void *where)
-{ /* gzip_mark & gzip_release do the free */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr = (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr = (long) *ptr;
-}
-
 /* ===========================================================================
  * Fill the input buffer. This is called only when the buffer is empty
  * and at least one byte is really needed.
@@ -193,7 +158,7 @@ decompress_kernel(void *output_start,
 
 	/* FIXME FIXME FIXME */
 	free_mem_ptr		= (ulg)output_start + ksize;
-	free_mem_ptr_end	= (ulg)output_start + ksize + 0x200000;
+	free_mem_end_ptr	= (ulg)output_start + ksize + 0x200000;
 	/* FIXME FIXME FIXME */
 
 	/* put in temp area to reduce initial footprint */
diff -puN arch/arm/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code arch/arm/boot/compressed/misc.c
--- a/arch/arm/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code
+++ a/arch/arm/boot/compressed/misc.c
@@ -217,8 +217,6 @@ static unsigned outcnt;		/* bytes in out
 static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 extern char input_data[];
 extern char input_data_end[];
@@ -227,64 +225,21 @@ static uch *output_data;
 static ulg output_ptr;
 static ulg bytes_out;
 
-static void *malloc(int size);
-static void free(void *where);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 static void putstr(const char *);
 
 extern int end;
 static ulg free_mem_ptr;
-static ulg free_mem_ptr_end;
+static ulg free_mem_end_ptr;
 
-#define HEAP_SIZE 0x3000
-
-#include "../../../../lib/inflate.c"
-
-#ifndef STANDALONE_DEBUG
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-	if (free_mem_ptr <= 0) error("Memory error");
-
-	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p = (void *)free_mem_ptr;
-	free_mem_ptr += size;
-
-	if (free_mem_ptr >= free_mem_ptr_end)
-		error("Out of memory");
-	return p;
-}
-
-static void free(void *where)
-{ /* gzip_mark & gzip_release do the free */
-}
-
-static void gzip_mark(void **ptr)
-{
-	arch_decomp_wdog();
-	*ptr = (void *) free_mem_ptr;
-}
+#ifdef STANDALONE_DEBUG
+#define NO_INFLATE_MALLOC
+#endif
 
-static void gzip_release(void **ptr)
-{
-	arch_decomp_wdog();
-	free_mem_ptr = (long) *ptr;
-}
-#else
-static void gzip_mark(void **ptr)
-{
-}
+#define ARCH_HAS_DECOMP_WDOG
 
-static void gzip_release(void **ptr)
-{
-}
-#endif
+#include "../../../../lib/inflate.c"
 
 /* ===========================================================================
  * Fill the input buffer. This is called only when the buffer is empty
@@ -348,7 +303,7 @@ decompress_kernel(ulg output_start, ulg 
 {
 	output_data		= (uch *)output_start;	/* Points to kernel start */
 	free_mem_ptr		= free_mem_ptr_p;
-	free_mem_ptr_end	= free_mem_ptr_end_p;
+	free_mem_end_ptr	= free_mem_ptr_end_p;
 	__machine_arch_type	= arch_id;
 
 	arch_decomp_setup();
diff -puN arch/cris/arch-v10/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code arch/cris/arch-v10/boot/compressed/misc.c
--- a/arch/cris/arch-v10/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code
+++ a/arch/cris/arch-v10/boot/compressed/misc.c
@@ -84,8 +84,6 @@ static unsigned outcnt = 0;  /* bytes in
 static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 extern char *input_data;  /* lives in head.S */
 
@@ -93,11 +91,7 @@ static long bytes_out = 0;
 static uch *output_data;
 static unsigned long output_ptr = 0;
  
-static void *malloc(int size);
-static void free(void *where);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
  
 static void puts(const char *);
 
@@ -105,37 +99,10 @@ static void puts(const char *);
   
 extern int end;
 static long free_mem_ptr = (long)&end;
+static long free_mem_end_ptr = 0;
  
 #include "../../../../../lib/inflate.c"
 
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-
-	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p = (void *)free_mem_ptr;
-	free_mem_ptr += size;
-
-	return p;
-}
-
-static void free(void *where)
-{	/* Don't care */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr = (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr = (long) *ptr;
-}
-
 /* decompressor info and error messages to serial console */
 
 static void
diff -puN arch/cris/arch-v32/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code arch/cris/arch-v32/boot/compressed/misc.c
--- a/arch/cris/arch-v32/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code
+++ a/arch/cris/arch-v32/boot/compressed/misc.c
@@ -89,8 +89,6 @@ static unsigned outcnt = 0;  /* bytes in
 
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 extern char *input_data;  /* lives in head.S */
 
@@ -98,11 +96,7 @@ static long bytes_out = 0;
 static uch *output_data;
 static unsigned long output_ptr = 0;
 
-static void *malloc(int size);
-static void free(void *where);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 static void puts(const char *);
 
@@ -110,37 +104,10 @@ static void puts(const char *);
 
 extern int _end;
 static long free_mem_ptr = (long)&_end;
+static long free_mem_end_ptr = 0;
 
 #include "../../../../../lib/inflate.c"
 
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-
-	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p = (void *)free_mem_ptr;
-	free_mem_ptr += size;
-
-	return p;
-}
-
-static void free(void *where)
-{	/* Don't care */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr = (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr = (long) *ptr;
-}
-
 /* decompressor info and error messages to serial console */
 
 static inline void
diff -puN arch/h8300/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code arch/h8300/boot/compressed/misc.c
--- a/arch/h8300/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code
+++ a/arch/h8300/boot/compressed/misc.c
@@ -67,8 +67,6 @@ static unsigned outcnt = 0;  /* bytes in
 static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 extern char input_data[];
 extern int input_len;
@@ -77,11 +75,7 @@ static long bytes_out = 0;
 static uch *output_data;
 static unsigned long output_ptr = 0;
 
-static void *malloc(int size);
-static void free(void *where);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 int puts(const char *);
 
@@ -98,38 +92,6 @@ static unsigned long free_mem_end_ptr;
 #define TDR *((volatile unsigned char *)0xffff8b)
 #define SSR *((volatile unsigned char *)0xffff8c)
 
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-	if (free_mem_ptr == 0) error("Memory error");
-
-	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p = (void *)free_mem_ptr;
-	free_mem_ptr += size;
-
-	if (free_mem_ptr >= free_mem_end_ptr)
-		error("Out of memory");
-
-	return p;
-}
-
-static void free(void *where)
-{	/* Don't care */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr = (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr = (long) *ptr;
-}
-
 int puts(const char *s)
 {
 	return 0;
diff -puN arch/m32r/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code arch/m32r/boot/compressed/misc.c
--- a/arch/m32r/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code
+++ a/arch/m32r/boot/compressed/misc.c
@@ -70,8 +70,6 @@ static unsigned outcnt = 0;  /* bytes in
 static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 static unsigned char *input_data;
 static int input_len;
@@ -82,9 +80,6 @@ static unsigned long output_ptr = 0;
 
 #include "m32r_sio.c"
 
-static void *malloc(int size);
-static void free(void *where);
-
 static unsigned long free_mem_ptr;
 static unsigned long free_mem_end_ptr;
 
@@ -92,38 +87,6 @@ static unsigned long free_mem_end_ptr;
 
 #include "../../../../lib/inflate.c"
 
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-	if (free_mem_ptr == 0) error("Memory error");
-
-	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p = (void *)free_mem_ptr;
-	free_mem_ptr += size;
-
-	if (free_mem_ptr >= free_mem_end_ptr)
-		error("Out of memory");
-
-	return p;
-}
-
-static void free(void *where)
-{	/* Don't care */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr = (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr = (long) *ptr;
-}
-
 void* memset(void* s, int c, size_t n)
 {
 	int i;
diff -puN arch/mn10300/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code arch/mn10300/boot/compressed/misc.c
--- a/arch/mn10300/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code
+++ a/arch/mn10300/boot/compressed/misc.c
@@ -153,26 +153,9 @@ static uch *output_data;
 static unsigned long output_ptr;
 
 
-static void *malloc(int size);
-
-static inline void free(void *where)
-{	/* Don't care */
-}
-
 static unsigned long free_mem_ptr = (unsigned long) &end;
 static unsigned long free_mem_end_ptr = (unsigned long) &end + 0x90000;
 
-static inline void gzip_mark(void **ptr)
-{
-	kputs(".");
-	*ptr = (void *) free_mem_ptr;
-}
-
-static inline void gzip_release(void **ptr)
-{
-	free_mem_ptr = (unsigned long) *ptr;
-}
-
 #define INPLACE_MOVE_ROUTINE	0x1000
 #define LOW_BUFFER_START	0x2000
 #define LOW_BUFFER_END		0x90000
@@ -186,26 +169,6 @@ static int lines, cols;
 
 #include "../../../../lib/inflate.c"
 
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size < 0)
-		error("Malloc error\n");
-	if (!free_mem_ptr)
-		error("Memory error\n");
-
-	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p = (void *) free_mem_ptr;
-	free_mem_ptr += size;
-
-	if (free_mem_ptr >= free_mem_end_ptr)
-		error("\nOut of memory\n");
-
-	return p;
-}
-
 static inline void scroll(void)
 {
 	int i;
diff -puN arch/sh/boot/compressed/misc_32.c~inflate-refactor-inflate-malloc-code arch/sh/boot/compressed/misc_32.c
--- a/arch/sh/boot/compressed/misc_32.c~inflate-refactor-inflate-malloc-code
+++ a/arch/sh/boot/compressed/misc_32.c
@@ -74,8 +74,6 @@ static unsigned outcnt = 0;  /* bytes in
 static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 extern char input_data[];
 extern int input_len;
@@ -84,11 +82,7 @@ static long bytes_out = 0;
 static uch *output_data;
 static unsigned long output_ptr = 0;
 
-static void *malloc(int size);
-static void free(void *where);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 int puts(const char *);
 
@@ -101,38 +95,6 @@ static unsigned long free_mem_end_ptr;
 
 #include "../../../../lib/inflate.c"
 
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size <0) error("Malloc error");
-	if (free_mem_ptr == 0) error("Memory error");
-
-	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p = (void *)free_mem_ptr;
-	free_mem_ptr += size;
-
-	if (free_mem_ptr >= free_mem_end_ptr)
-		error("Out of memory");
-
-	return p;
-}
-
-static void free(void *where)
-{	/* Don't care */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr = (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr = (long) *ptr;
-}
-
 #ifdef CONFIG_SH_STANDARD_BIOS
 size_t strlen(const char *s)
 {
diff -puN arch/sh/boot/compressed/misc_64.c~inflate-refactor-inflate-malloc-code arch/sh/boot/compressed/misc_64.c
--- a/arch/sh/boot/compressed/misc_64.c~inflate-refactor-inflate-malloc-code
+++ a/arch/sh/boot/compressed/misc_64.c
@@ -72,8 +72,6 @@ static unsigned outcnt = 0;	/* bytes in 
 static int fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 extern char input_data[];
 extern int input_len;
@@ -82,11 +80,7 @@ static long bytes_out = 0;
 static uch *output_data;
 static unsigned long output_ptr = 0;
 
-static void *malloc(int size);
-static void free(void *where);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 static void puts(const char *);
 
@@ -99,40 +93,6 @@ static unsigned long free_mem_end_ptr;
 
 #include "../../../../lib/inflate.c"
 
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size < 0)
-		error("Malloc error\n");
-	if (free_mem_ptr == 0)
-		error("Memory error\n");
-
-	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p = (void *) free_mem_ptr;
-	free_mem_ptr += size;
-
-	if (free_mem_ptr >= free_mem_end_ptr)
-		error("\nOut of memory\n");
-
-	return p;
-}
-
-static void free(void *where)
-{				/* Don't care */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr = (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr = (long) *ptr;
-}
-
 void puts(const char *s)
 {
 }
diff -puN arch/x86/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code arch/x86/boot/compressed/misc.c
--- a/arch/x86/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code
+++ a/arch/x86/boot/compressed/misc.c
@@ -182,8 +182,6 @@ static unsigned		outcnt;
 static int  fill_inbuf(void);
 static void flush_window(void);
 static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 /*
  * This is set up by the setup-routine at boot-time
@@ -196,9 +194,6 @@ extern int input_len;
 
 static long bytes_out;
 
-static void *malloc(int size);
-static void free(void *where);
-
 static void *memset(void *s, int c, unsigned n);
 static void *memcpy(void *dest, const void *src, unsigned n);
 
@@ -219,40 +214,6 @@ static int lines, cols;
 
 #include "../../../../lib/inflate.c"
 
-static void *malloc(int size)
-{
-	void *p;
-
-	if (size < 0)
-		error("Malloc error");
-	if (free_mem_ptr <= 0)
-		error("Memory error");
-
-	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
-
-	p = (void *)free_mem_ptr;
-	free_mem_ptr += size;
-
-	if (free_mem_ptr >= free_mem_end_ptr)
-		error("Out of memory");
-
-	return p;
-}
-
-static void free(void *where)
-{	/* Don't care */
-}
-
-static void gzip_mark(void **ptr)
-{
-	*ptr = (void *) free_mem_ptr;
-}
-
-static void gzip_release(void **ptr)
-{
-	free_mem_ptr = (memptr) *ptr;
-}
-
 static void scroll(void)
 {
 	int i;
diff -puN init/do_mounts_rd.c~inflate-refactor-inflate-malloc-code init/do_mounts_rd.c
--- a/init/do_mounts_rd.c~inflate-refactor-inflate-malloc-code
+++ a/init/do_mounts_rd.c
@@ -303,32 +303,11 @@ static int crd_infd, crd_outfd;
 
 static int  __init fill_inbuf(void);
 static void __init flush_window(void);
-static void __init *malloc(size_t size);
-static void __init free(void *where);
 static void __init error(char *m);
-static void __init gzip_mark(void **);
-static void __init gzip_release(void **);
 
-#include "../lib/inflate.c"
-
-static void __init *malloc(size_t size)
-{
-	return kmalloc(size, GFP_KERNEL);
-}
-
-static void __init free(void *where)
-{
-	kfree(where);
-}
-
-static void __init gzip_mark(void **ptr)
-{
-}
-
-static void __init gzip_release(void **ptr)
-{
-}
+#define NO_INFLATE_MALLOC
 
+#include "../lib/inflate.c"
 
 /* ===========================================================================
  * Fill the input buffer. This is called only when the buffer is empty
diff -puN init/initramfs.c~inflate-refactor-inflate-malloc-code init/initramfs.c
--- a/init/initramfs.c~inflate-refactor-inflate-malloc-code
+++ a/init/initramfs.c
@@ -14,16 +14,6 @@ static void __init error(char *x)
 		message = x;
 }
 
-static void __init *malloc(size_t size)
-{
-	return kmalloc(size, GFP_KERNEL);
-}
-
-static void __init free(void *where)
-{
-	kfree(where);
-}
-
 /* link hash */
 
 #define N_ALIGN(len) ((((len) + 1) & ~3) + 2)
@@ -407,18 +397,10 @@ static long bytes_out;
 
 static void __init flush_window(void);
 static void __init error(char *m);
-static void __init gzip_mark(void **);
-static void __init gzip_release(void **);
 
-#include "../lib/inflate.c"
+#define NO_INFLATE_MALLOC
 
-static void __init gzip_mark(void **ptr)
-{
-}
-
-static void __init gzip_release(void **ptr)
-{
-}
+#include "../lib/inflate.c"
 
 /* ===========================================================================
  * Write the output window window[0..outcnt-1] and update crc and bytes_out.
diff -puN lib/inflate.c~inflate-refactor-inflate-malloc-code lib/inflate.c
--- a/lib/inflate.c~inflate-refactor-inflate-malloc-code
+++ a/lib/inflate.c
@@ -230,6 +230,45 @@ STATIC const ush mask_bits[] = {
 #define NEEDBITS(n) {while(k<(n)){b|=((ulg)NEXTBYTE())<<k;k+=8;}}
 #define DUMPBITS(n) {b>>=(n);k-=(n);}
 
+#ifndef NO_INFLATE_MALLOC
+/* A trivial malloc implementation, adapted from
+ *  malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
+ */
+
+static unsigned long malloc_ptr;
+static int malloc_count;
+
+static void *malloc(int size)
+{
+       void *p;
+
+       if (size <0)
+               error("Malloc error");
+       if (!malloc_ptr)
+               malloc_ptr = free_mem_ptr;
+
+       malloc_ptr = (malloc_ptr + 3) & ~3;     /* Align */
+
+       p = (void *)malloc_ptr;
+       malloc_ptr += size;
+
+       if (free_mem_end_ptr && malloc_ptr >= free_mem_end_ptr)
+               error("Out of memory");
+
+       malloc_count++;
+       return p;
+}
+
+static void free(void *where)
+{
+       malloc_count--;
+       if (!malloc_count)
+               malloc_ptr = free_mem_ptr;
+}
+#else
+#define malloc(a) kmalloc(a, GFP_KERNEL)
+#define free(a) kfree(a)
+#endif
 
 /*
    Huffman code decoding is performed using a multi-level table lookup.
@@ -1045,7 +1084,6 @@ STATIC int INIT inflate(void)
   int e;                /* last block flag */
   int r;                /* result code */
   unsigned h;           /* maximum struct huft's malloc'ed */
-  void *ptr;
 
   /* initialize window, bit buffer */
   wp = 0;
@@ -1057,12 +1095,12 @@ STATIC int INIT inflate(void)
   h = 0;
   do {
     hufts = 0;
-    gzip_mark(&ptr);
-    if ((r = inflate_block(&e)) != 0) {
-      gzip_release(&ptr);	    
-      return r;
-    }
-    gzip_release(&ptr);
+#ifdef ARCH_HAS_DECOMP_WDOG
+    arch_decomp_wdog();
+#endif
+    r = inflate_block(&e);
+    if (r)
+	    return r;
     if (hufts > h)
       h = hufts;
   } while (!e);
_

Patches currently in -mm which might be from thomas.petazzoni@free-electrons.com are

inflate-refactor-inflate-malloc-code.patch

