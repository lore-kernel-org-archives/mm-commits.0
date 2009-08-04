From: akpm@linux-foundation.org
Subject: + lzo-add-support-for-lzo-compressed-kernels.patch added to -mm tree
Date: Tue, 04 Aug 2009 16:02:39 -0700
Message-ID: <200908042302.n74N2eNa019532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933563AbZHDXEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 19:04:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albin.tonnerre@free-electrons.com, hpa@zytor.com, mingo@elte.hu, phillip@lougher.demon.co.uk, rmk@arm.linux.org.uk, sam@ravnborg.org, tglx@linutronix.de


The patch titled
     lzo: add support for LZO-compressed kernels
has been added to the -mm tree.  Its filename is
     lzo-add-support-for-lzo-compressed-kernels.patch

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
Subject: lzo: add support for LZO-compressed kernels
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>

This is the first part of the lzo patch The lzo compressor is worse than
gzip at compression, but faster at extraction.  Here are some figures for
an ARM board I'm working on:

Uncompressed size: 3.24Mo
gzip  1.61Mo 0.72s
lzo   1.75Mo 0.48s

So for a compression ratio that is still relatively close to gzip, it's
much faster to extract, at least in that case.

This version applies to kernel 2.6.31-rc3

This part contains:
 - Makefile routine to support lzo compression
 - Fixes to the existing lzo compressor so that it can be used in
   compressed kernels
 - wrapper around the existing lzo1x_decompress, as it only extracts one
   block at a time, while we need to extract a whole file here
 - config dialog for kernel compression

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/decompress/unlzo.h |   10 +
 init/Kconfig                     |   18 +-
 lib/decompress_unlzo.c           |  206 +++++++++++++++++++++++++++++
 lib/lzo/lzo1x_decompress.c       |    9 -
 scripts/Makefile.lib             |    5 
 5 files changed, 241 insertions(+), 7 deletions(-)

diff -puN /dev/null include/linux/decompress/unlzo.h
--- /dev/null
+++ a/include/linux/decompress/unlzo.h
@@ -0,0 +1,10 @@
+#ifndef DECOMPRESS_UNLZO_H
+#define DECOMPRESS_UNLZO_H
+
+int unlzo(unsigned char *inbuf, int len,
+          int(*fill)(void*, unsigned int),
+          int(*flush)(void*, unsigned int),
+          unsigned char *output,
+          int *pos,
+          void(*error)(char *x));
+#endif
diff -puN init/Kconfig~lzo-add-support-for-lzo-compressed-kernels init/Kconfig
--- a/init/Kconfig~lzo-add-support-for-lzo-compressed-kernels
+++ a/init/Kconfig
@@ -115,10 +115,13 @@ config HAVE_KERNEL_BZIP2
 config HAVE_KERNEL_LZMA
 	bool
 
+config HAVE_KERNEL_LZO
+	bool
+
 choice
 	prompt "Kernel compression mode"
 	default KERNEL_GZIP
-	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA
+	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_LZO
 	help
 	  The linux kernel is a kind of self-extracting executable.
 	  Several compression algorithms are available, which differ
@@ -141,9 +144,8 @@ config KERNEL_GZIP
 	bool "Gzip"
 	depends on HAVE_KERNEL_GZIP
 	help
-	  The old and tried gzip compression. Its compression ratio is
-	  the poorest among the 3 choices; however its speed (both
-	  compression and decompression) is the fastest.
+	  The old and tried gzip compression. It provides a good balance
+	  between compression ration and decompression speed.
 
 config KERNEL_BZIP2
 	bool "Bzip2"
@@ -164,6 +166,14 @@ config KERNEL_LZMA
 	  two. Compression is slowest.	The kernel size is about 33%
 	  smaller with LZMA in comparison to gzip.
 
+config KERNEL_LZO
+	bool "LZO"
+	depends on HAVE_KERNEL_LZO
+	help
+	  Its compression ratio is the poorest among the 4. The kernel
+	  size is about about 10% bigger than gzip; however its speed
+	  (both compression and decompression) is the fastest.
+
 endchoice
 
 config SWAP
diff -puN /dev/null lib/decompress_unlzo.c
--- /dev/null
+++ a/lib/decompress_unlzo.c
@@ -0,0 +1,206 @@
+/*
+ * LZO decompressor for the Linux kernel. Code borrowed from the lzo
+ * implementation by Markus Franz Xaver Johannes Oberhumer.
+ *
+ * Linux kernel adaptation:
+ * Copyright (C) 2009
+ * Albin Tonnerre, Free Electrons <albin.tonnerre@free-electrons.com>
+ *
+ * Original code:
+ * Copyright (C) 1996-2005 Markus Franz Xaver Johannes Oberhumer
+ * All Rights Reserved.
+ *
+ * lzop and the LZO library are free software; you can redistribute them
+ * and/or modify them under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.
+ * If not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Markus F.X.J. Oberhumer
+ * <markus@oberhumer.com>
+ * http://www.oberhumer.com/opensource/lzop/
+ */
+
+#ifdef STATIC
+#include "lzo/lzo1x_decompress.c"
+#else
+#include <linux/slab.h>
+#endif
+
+#include <linux/types.h>
+#include <linux/lzo.h>
+#include <linux/decompress/mm.h>
+#include <linux/decompress/unlzo.h>
+
+#include <linux/compiler.h>
+#include <asm/unaligned.h>
+
+static const unsigned char lzop_magic[] =
+    { 0x89, 0x4c, 0x5a, 0x4f, 0x00, 0x0d, 0x0a, 0x1a, 0x0a };
+
+#define LZO_BLOCK_SIZE        (256*1024l)
+#define HEADER_HAS_FILTER      0x00000800L
+
+STATIC inline int INIT parse_header(u8 *input, u8 *skip)
+{
+	int l;
+	u8 *parse = input;
+	u8 level = 0;
+	u16 version;
+
+	/* read magic: 9 first bits */
+	for (l = 0; l < 9; l++) {
+		if (*parse++ != lzop_magic[l])
+			return 0;
+	}
+	/* get version (2bytes), skip library version (2),
+	 * 'need to be extracted' version (2) and
+	 * method (1) */
+	version = get_unaligned_be16(parse);
+	parse += 7;
+	if (version >= 0x0940)
+		level = *parse++;
+	if (get_unaligned_be32(parse) & HEADER_HAS_FILTER)
+		parse += 8; /* flags + filter info */
+	else
+		parse += 4; /* flags */
+
+	/* skip mode and mtime_low */
+	parse += 8;
+	if (version >= 0x0940)
+		parse += 4;	/* skip mtime_high */
+
+	l = *parse++;
+	/* don't care about the file name, and skip checksum */
+	parse += l + 4;
+
+	*skip = parse - input;
+	return 1;
+}
+
+STATIC inline int INIT unlzo(u8 *input, int in_len,
+                             int (*fill) (void *, unsigned int),
+                             int (*flush) (void *, unsigned int),
+                             u8 *output, int *posp,
+                             void (*error_fn) (char *x))
+{
+	u8 skip = 0, r = 0;
+	u32 src_len, dst_len;
+	size_t tmp;
+	u8 *in_buf, *in_buf_save, *out_buf;
+	int obytes_processed = 0;
+
+	set_error_fn(error_fn);
+
+	if (output)
+		out_buf = output;
+	else if (!flush) {
+		error("NULL output pointer and no flush function provided");
+		goto exit;
+	}
+	else if (!(out_buf = malloc(LZO_BLOCK_SIZE))) {
+		error("Could not allocate output buffer");
+		goto exit;
+	}
+
+	if (input && fill) {
+		error("Both input pointer and fill function provided, don't know what to do");
+		goto exit_1;
+	}
+	else if (input)
+		in_buf = input;
+	else if (!fill || !posp) {
+		error("NULL input pointer and missing position pointer or fill function");
+		goto exit_1;
+	}
+	else if (!(in_buf = malloc(lzo1x_worst_compress(LZO_BLOCK_SIZE)))) {
+		error("Could not allocate input buffer");
+		goto exit_1;
+	}
+	in_buf_save = in_buf;
+
+	if (posp)
+		*posp = 0;
+
+	if (fill)
+		fill(in_buf, lzo1x_worst_compress(LZO_BLOCK_SIZE));
+
+	if (!parse_header(input, &skip)) {
+		error("invalid header");
+		goto exit_2;
+	}
+	in_buf += skip;
+
+	if (posp)
+		*posp = skip;
+
+	for (;;) {
+		/* read uncompressed block size */
+		dst_len = get_unaligned_be32(in_buf);
+		in_buf += 4;
+
+		/* exit if last block */
+		if (dst_len == 0) {
+			if (posp)
+				*posp += 4;
+			break;
+		}
+
+		if (dst_len > LZO_BLOCK_SIZE) {
+			error("dest len longer than block size");
+			goto exit_2;
+		}
+
+		/* read compressed block size, and skip block checksum info */
+		src_len = get_unaligned_be32(in_buf);
+		in_buf += 8;
+
+		if (src_len <= 0 || src_len > dst_len) {
+			error("file corrupted");
+			goto exit_2;
+		}
+
+		/* decompress */
+		tmp = dst_len;
+		r = lzo1x_decompress_safe((u8 *) in_buf, src_len, out_buf, &tmp);
+
+		if (r != LZO_E_OK || dst_len != tmp) {
+			error("Compressed data violation");
+			goto exit_2;
+		}
+
+		obytes_processed += dst_len;
+		if (flush)
+			flush(out_buf, dst_len);
+		if (output)
+			out_buf += dst_len;
+		if (posp)
+			*posp += src_len + 12;
+		if (fill) {
+			in_buf = in_buf_save;
+			fill(in_buf, lzo1x_worst_compress(LZO_BLOCK_SIZE));
+		}
+		else
+			in_buf += src_len;
+	}
+
+exit_2:
+	if (!input)
+		free(in_buf);
+exit_1:
+	if (!output)
+		free(out_buf);
+exit:
+	return obytes_processed;
+}
+
+#define decompress unlzo
diff -puN lib/lzo/lzo1x_decompress.c~lzo-add-support-for-lzo-compressed-kernels lib/lzo/lzo1x_decompress.c
--- a/lib/lzo/lzo1x_decompress.c~lzo-add-support-for-lzo-compressed-kernels
+++ a/lib/lzo/lzo1x_decompress.c
@@ -11,11 +11,13 @@
  *  Richard Purdie <rpurdie@openedhand.com>
  */
 
+#ifndef STATIC
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/lzo.h>
-#include <asm/byteorder.h>
+#endif
+
 #include <asm/unaligned.h>
+#include <linux/lzo.h>
 #include "lzodefs.h"
 
 #define HAVE_IP(x, ip_end, ip) ((size_t)(ip_end - ip) < (x))
@@ -244,9 +246,10 @@ lookbehind_overrun:
 	*out_len = op - out;
 	return LZO_E_LOOKBEHIND_OVERRUN;
 }
-
+#ifndef STATIC
 EXPORT_SYMBOL_GPL(lzo1x_decompress_safe);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("LZO1X Decompressor");
 
+#endif
diff -puN scripts/Makefile.lib~lzo-add-support-for-lzo-compressed-kernels scripts/Makefile.lib
--- a/scripts/Makefile.lib~lzo-add-support-for-lzo-compressed-kernels
+++ a/scripts/Makefile.lib
@@ -230,3 +230,8 @@ quiet_cmd_lzma = LZMA    $@
 cmd_lzma = (cat $(filter-out FORCE,$^) | \
 	lzma -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
 	(rm -f $@ ; false)
+
+quiet_cmd_lzo = LZO    $@
+cmd_lzo = (cat $(filter-out FORCE,$^) | \
+	lzop -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
+	(rm -f $@ ; false)
_

Patches currently in -mm which might be from albin.tonnerre@free-electrons.com are

lib-decompress_-only-include-linux-slabh-if-static-is-not-defined.patch
include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels.patch
lzo-add-support-for-lzo-compressed-kernels.patch
lzo-arm-add-support-for-lzo-compressed-kernels.patch
lzo-x86-add-support-for-lzo-compressed-kernels.patch
lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch

