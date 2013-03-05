From: akpm@linux-foundation.org
Subject: + lib-add-support-for-lz4-compressed-kernel.patch added to -mm tree
Date: Tue, 05 Mar 2013 15:09:03 -0800
Message-ID: <20130305230903.ED44531C1E1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:63951 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3CEXJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 18:09:05 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so799055vea.4
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 15:09:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungsik.lee@lge.com, bp@alien8.de, florian@openwrt.org, hpa@zytor.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de


The patch titled
     Subject: lib: add support for LZ4-compressed kernel
has been added to the -mm tree.  Its filename is
     lib-add-support-for-lz4-compressed-kernel.patch

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
Subject: lib: add support for LZ4-compressed kernel

Add support for extracting LZ4-compressed kernel images, as well as
LZ4-compressed ramdisk images in the kernel boot process.

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/decompress/unlz4.h |   10 +
 init/Kconfig                     |   17 ++
 lib/Kconfig                      |    7 +
 lib/Makefile                     |    2 
 lib/decompress.c                 |    5 
 lib/decompress_unlz4.c           |  187 +++++++++++++++++++++++++++++
 lib/lz4/Makefile                 |    1 
 lib/lz4/lz4_decompress.c         |    2 
 scripts/Makefile.lib             |    5 
 usr/Kconfig                      |    9 +
 10 files changed, 243 insertions(+), 2 deletions(-)

diff -puN /dev/null include/linux/decompress/unlz4.h
--- /dev/null
+++ a/include/linux/decompress/unlz4.h
@@ -0,0 +1,10 @@
+#ifndef DECOMPRESS_UNLZ4_H
+#define DECOMPRESS_UNLZ4_H
+
+int unlz4(unsigned char *inbuf, int len,
+	int(*fill)(void*, unsigned int),
+	int(*flush)(void*, unsigned int),
+	unsigned char *output,
+	int *pos,
+	void(*error)(char *x));
+#endif
diff -puN init/Kconfig~lib-add-support-for-lz4-compressed-kernel init/Kconfig
--- a/init/Kconfig~lib-add-support-for-lz4-compressed-kernel
+++ a/init/Kconfig
@@ -102,10 +102,13 @@ config HAVE_KERNEL_XZ
 config HAVE_KERNEL_LZO
 	bool
 
+config HAVE_KERNEL_LZ4
+	bool
+
 choice
 	prompt "Kernel compression mode"
 	default KERNEL_GZIP
-	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO
+	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
 	help
 	  The linux kernel is a kind of self-extracting executable.
 	  Several compression algorithms are available, which differ
@@ -172,6 +175,18 @@ config KERNEL_LZO
 	  size is about 10% bigger than gzip; however its speed
 	  (both compression and decompression) is the fastest.
 
+config KERNEL_LZ4
+	bool "LZ4"
+	depends on HAVE_KERNEL_LZ4
+	help
+	  LZ4 is an LZ77-type compressor with a fixed, byte-oriented encoding.
+	  A preliminary version of LZ4 de/compression tool is available at
+	  <https://code.google.com/p/lz4/>.
+
+	  Its compression ratio is worse than LZO. The size of the kernel
+	  is about 8% bigger than LZO. But the decompression speed is
+	  faster than LZO.
+
 endchoice
 
 config DEFAULT_HOSTNAME
diff -puN lib/Kconfig~lib-add-support-for-lz4-compressed-kernel lib/Kconfig
--- a/lib/Kconfig~lib-add-support-for-lz4-compressed-kernel
+++ a/lib/Kconfig
@@ -189,6 +189,9 @@ config LZO_COMPRESS
 config LZO_DECOMPRESS
 	tristate
 
+config LZ4_DECOMPRESS
+	tristate
+
 source "lib/xz/Kconfig"
 
 #
@@ -213,6 +216,10 @@ config DECOMPRESS_LZO
 	select LZO_DECOMPRESS
 	tristate
 
+config DECOMPRESS_LZ4
+	select LZ4_DECOMPRESS
+	tristate
+
 #
 # Generic allocator support is selected if needed
 #
diff -puN lib/Makefile~lib-add-support-for-lz4-compressed-kernel lib/Makefile
--- a/lib/Makefile~lib-add-support-for-lz4-compressed-kernel
+++ a/lib/Makefile
@@ -73,6 +73,7 @@ obj-$(CONFIG_REED_SOLOMON) += reed_solom
 obj-$(CONFIG_BCH) += bch.o
 obj-$(CONFIG_LZO_COMPRESS) += lzo/
 obj-$(CONFIG_LZO_DECOMPRESS) += lzo/
+obj-$(CONFIG_LZ4_DECOMPRESS) += lz4/
 obj-$(CONFIG_XZ_DEC) += xz/
 obj-$(CONFIG_RAID6_PQ) += raid6/
 
@@ -81,6 +82,7 @@ lib-$(CONFIG_DECOMPRESS_BZIP2) += decomp
 lib-$(CONFIG_DECOMPRESS_LZMA) += decompress_unlzma.o
 lib-$(CONFIG_DECOMPRESS_XZ) += decompress_unxz.o
 lib-$(CONFIG_DECOMPRESS_LZO) += decompress_unlzo.o
+lib-$(CONFIG_DECOMPRESS_LZ4) += decompress_unlz4.o
 
 obj-$(CONFIG_TEXTSEARCH) += textsearch.o
 obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
diff -puN lib/decompress.c~lib-add-support-for-lz4-compressed-kernel lib/decompress.c
--- a/lib/decompress.c~lib-add-support-for-lz4-compressed-kernel
+++ a/lib/decompress.c
@@ -11,6 +11,7 @@
 #include <linux/decompress/unxz.h>
 #include <linux/decompress/inflate.h>
 #include <linux/decompress/unlzo.h>
+#include <linux/decompress/unlz4.h>
 
 #include <linux/types.h>
 #include <linux/string.h>
@@ -31,6 +32,9 @@
 #ifndef CONFIG_DECOMPRESS_LZO
 # define unlzo NULL
 #endif
+#ifndef CONFIG_DECOMPRESS_LZ4
+# define unlz4 NULL
+#endif
 
 struct compress_format {
 	unsigned char magic[2];
@@ -45,6 +49,7 @@ static const struct compress_format comp
 	{ {0x5d, 0x00}, "lzma", unlzma },
 	{ {0xfd, 0x37}, "xz", unxz },
 	{ {0x89, 0x4c}, "lzo", unlzo },
+	{ {0x02, 0x21}, "lz4", unlz4 },
 	{ {0, 0}, NULL, NULL }
 };
 
diff -puN /dev/null lib/decompress_unlz4.c
--- /dev/null
+++ a/lib/decompress_unlz4.c
@@ -0,0 +1,187 @@
+/*
+ * Wrapper for decompressing LZ4-compressed kernel, initramfs, and initrd
+ *
+ * Copyright (C) 2013, LG Electronics, Kyungsik Lee <kyungsik.lee@lge.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifdef STATIC
+#define PREBOOT
+#include "lz4/lz4_decompress.c"
+#else
+#include <linux/decompress/unlz4.h>
+#endif
+#include <linux/types.h>
+#include <linux/lz4.h>
+#include <linux/decompress/mm.h>
+#include <linux/compiler.h>
+
+#include <asm/unaligned.h>
+
+/*
+ * Note: Uncompressed chunk size is used in the compressor side
+ * (userspace side for compression).
+ * It is hardcoded because there is not proper way to extract it
+ * from the binary stream which is generated by the preliminary
+ * version of LZ4 tool so far.
+ */
+#define LZ4_DEFAULT_UNCOMPRESSED_CHUNK_SIZE (8 << 20)
+#define ARCHIVE_MAGICNUMBER 0x184C2102
+
+STATIC inline int INIT unlz4(u8 *input, int in_len,
+				int (*fill) (void *, unsigned int),
+				int (*flush) (void *, unsigned int),
+				u8 *output, int *posp,
+				void (*error) (char *x))
+{
+	int ret = -1;
+	size_t chunksize = 0;
+	size_t uncomp_chunksize = LZ4_DEFAULT_UNCOMPRESSED_CHUNK_SIZE;
+	u8 *inp;
+	u8 *inp_start;
+	u8 *outp;
+	int size = in_len;
+#ifdef PREBOOT
+	size_t out_len = get_unaligned_le32(input + in_len);
+#endif
+	size_t dest_len;
+
+
+	if (output) {
+		outp = output;
+	} else if (!flush) {
+		error("NULL output pointer and no flush function provided");
+		goto exit_0;
+	} else {
+		outp = large_malloc(uncomp_chunksize);
+		if (!outp) {
+			error("Could not allocate output buffer");
+			goto exit_0;
+		}
+	}
+
+	if (input && fill) {
+		error("Both input pointer and fill function provided,");
+		goto exit_1;
+	} else if (input) {
+		inp = input;
+	} else if (!fill) {
+		error("NULL input pointer and missing fill function");
+		goto exit_1;
+	} else {
+		inp = large_malloc(lz4_compressbound(uncomp_chunksize));
+		if (!inp) {
+			error("Could not allocate input buffer");
+			goto exit_1;
+		}
+	}
+	inp_start = inp;
+
+	if (posp)
+		*posp = 0;
+
+	if (fill)
+		fill(inp, 4);
+
+	chunksize = get_unaligned_le32(inp);
+	if (chunksize == ARCHIVE_MAGICNUMBER) {
+		inp += 4;
+		size -= 4;
+	} else {
+		error("invalid header");
+		goto exit_2;
+	}
+
+	if (posp)
+		*posp += 4;
+
+	for (;;) {
+
+		if (fill)
+			fill(inp, 4);
+
+		chunksize = get_unaligned_le32(inp);
+		if (chunksize == ARCHIVE_MAGICNUMBER) {
+			inp += 4;
+			size -= 4;
+			if (posp)
+				*posp += 4;
+			continue;
+		}
+		inp += 4;
+		size -= 4;
+
+		if (posp)
+			*posp += 4;
+
+		if (fill) {
+			if (chunksize > lz4_compressbound(uncomp_chunksize)) {
+				error("chunk length is longer than allocated");
+				goto exit_2;
+			}
+			fill(inp, chunksize);
+		}
+#ifdef PREBOOT
+		if (out_len >= uncomp_chunksize) {
+			dest_len = uncomp_chunksize;
+			out_len -= dest_len;
+		} else
+			dest_len = out_len;
+		ret = lz4_decompress(inp, &chunksize, outp, dest_len);
+#else
+		dest_len = uncomp_chunksize;
+		ret = lz4_decompress_unknownoutputsize(inp, chunksize, outp,
+				&dest_len);
+#endif
+		if (ret < 0) {
+			error("Decoding failed");
+			goto exit_2;
+		}
+
+		if (flush && flush(outp, dest_len) != dest_len)
+			goto exit_2;
+		if (output)
+			outp += dest_len;
+		if (posp)
+			*posp += chunksize;
+
+		size -= chunksize;
+
+		if (size == 0)
+			break;
+		else if (size < 0) {
+			error("data corrupted");
+			goto exit_2;
+		}
+
+		inp += chunksize;
+		if (fill)
+			inp = inp_start;
+	}
+
+	ret = 0;
+exit_2:
+	if (!input)
+		large_free(inp_start);
+exit_1:
+	if (!output)
+		large_free(outp);
+exit_0:
+	return ret;
+}
+
+#ifdef PREBOOT
+STATIC int INIT decompress(unsigned char *buf, int in_len,
+			      int(*fill)(void*, unsigned int),
+			      int(*flush)(void*, unsigned int),
+			      unsigned char *output,
+			      int *posp,
+			      void(*error)(char *x)
+	)
+{
+	return unlz4(buf, in_len - 4, fill, flush, output, posp, error);
+}
+#endif
diff -puN /dev/null lib/lz4/Makefile
--- /dev/null
+++ a/lib/lz4/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_LZ4_DECOMPRESS) += lz4_decompress.o
diff -puN lib/lz4/lz4_decompress.c~lib-add-support-for-lz4-compressed-kernel lib/lz4/lz4_decompress.c
--- a/lib/lz4/lz4_decompress.c~lib-add-support-for-lz4-compressed-kernel
+++ a/lib/lz4/lz4_decompress.c
@@ -1,7 +1,7 @@
 /*
  * LZ4 Decompressor for Linux kernel
  *
- * Copyright (C) 2013 LG Electronics Co., Ltd. (http://www.lge.com/)
+ * Copyright (C) 2013, LG Electronics, Kyungsik Lee <kyungsik.lee@lge.com>
  *
  * Based on LZ4 implementation by Yann Collet.
  *
diff -puN scripts/Makefile.lib~lib-add-support-for-lz4-compressed-kernel scripts/Makefile.lib
--- a/scripts/Makefile.lib~lib-add-support-for-lz4-compressed-kernel
+++ a/scripts/Makefile.lib
@@ -321,6 +321,11 @@ cmd_lzo = (cat $(filter-out FORCE,$^) |
 	lzop -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
 	(rm -f $@ ; false)
 
+quiet_cmd_lz4 = LZ4     $@
+cmd_lz4 = (cat $(filter-out FORCE,$^) | \
+	lz4demo -c1 stdin stdout && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
+	(rm -f $@ ; false)
+
 # U-Boot mkimage
 # ---------------------------------------------------------------------------
 
diff -puN usr/Kconfig~lib-add-support-for-lz4-compressed-kernel usr/Kconfig
--- a/usr/Kconfig~lib-add-support-for-lz4-compressed-kernel
+++ a/usr/Kconfig
@@ -90,6 +90,15 @@ config RD_LZO
 	  Support loading of a LZO encoded initial ramdisk or cpio buffer
 	  If unsure, say N.
 
+config RD_LZ4
+	bool "Support initial ramdisks compressed using LZ4" if EXPERT
+	default !EXPERT
+	depends on BLK_DEV_INITRD
+	select DECOMPRESS_LZ4
+	help
+	  Support loading of a LZ4 encoded initial ramdisk or cpio buffer
+	  If unsure, say N.
+
 choice
 	prompt "Built-in initramfs compression mode" if INITRAMFS_SOURCE!=""
 	help
_

Patches currently in -mm which might be from kyungsik.lee@lge.com are

decompressor-add-lz4-decompressor-module.patch
lib-add-support-for-lz4-compressed-kernel.patch
arm-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel.patch

