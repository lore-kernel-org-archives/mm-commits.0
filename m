From: akpm@linux-foundation.org
Subject: [to-be-updated] lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch removed from -mm tree
Date: Fri, 04 Sep 2009 16:16:31 -0700
Message-ID: <200909042316.n84NGVxT021600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934454AbZIDXRU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2009 19:17:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: albin.tonnerre@free-electrons.com, hpa@zytor.com, mingo@elte.hu, phillip@lougher.demon.co.uk, rmk@arm.linux.org.uk, sam@ravnborg.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     lzo: add LZO compression support for initramfs and old-style initrd
has been removed from the -mm tree.  Its filename was
     lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lzo: add LZO compression support for initramfs and old-style initrd
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig      |    4 ++++
 lib/Makefile     |    1 +
 lib/decompress.c |    5 +++++
 usr/Kconfig      |   26 +++++++++++++++++++++-----
 4 files changed, 31 insertions(+), 5 deletions(-)

diff -puN lib/Kconfig~lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd lib/Kconfig
--- a/lib/Kconfig~lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd
+++ a/lib/Kconfig
@@ -117,6 +117,10 @@ config DECOMPRESS_BZIP2
 config DECOMPRESS_LZMA
 	tristate
 
+config DECOMPRESS_LZO
+	select LZO_DECOMPRESS
+	tristate
+
 #
 # Generic allocator support is selected if needed
 #
diff -puN lib/Makefile~lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd lib/Makefile
--- a/lib/Makefile~lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd
+++ a/lib/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_LZO_DECOMPRESS) += lzo/
 lib-$(CONFIG_DECOMPRESS_GZIP) += decompress_inflate.o
 lib-$(CONFIG_DECOMPRESS_BZIP2) += decompress_bunzip2.o
 lib-$(CONFIG_DECOMPRESS_LZMA) += decompress_unlzma.o
+lib-$(CONFIG_DECOMPRESS_LZO) += decompress_unlzo.o
 
 obj-$(CONFIG_TEXTSEARCH) += textsearch.o
 obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
diff -puN lib/decompress.c~lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd lib/decompress.c
--- a/lib/decompress.c~lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd
+++ a/lib/decompress.c
@@ -9,6 +9,7 @@
 #include <linux/decompress/bunzip2.h>
 #include <linux/decompress/unlzma.h>
 #include <linux/decompress/inflate.h>
+#include <linux/decompress/unlzo.h>
 
 #include <linux/types.h>
 #include <linux/string.h>
@@ -22,6 +23,9 @@
 #ifndef CONFIG_DECOMPRESS_LZMA
 # define unlzma NULL
 #endif
+#ifndef CONFIG_DECOMPRESS_LZO
+# define unlzo NULL
+#endif
 
 static const struct compress_format {
 	unsigned char magic[2];
@@ -32,6 +36,7 @@ static const struct compress_format {
 	{ {037, 0236}, "gzip", gunzip },
 	{ {0x42, 0x5a}, "bzip2", bunzip2 },
 	{ {0x5d, 0x00}, "lzma", unlzma },
+	{ {0x89, 0x4c}, "lzo", unlzo },
 	{ {0, 0}, NULL, NULL }
 };
 
diff -puN usr/Kconfig~lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd usr/Kconfig
--- a/usr/Kconfig~lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd
+++ a/usr/Kconfig
@@ -72,6 +72,15 @@ config RD_LZMA
 	  Support loading of a LZMA encoded initial ramdisk or cpio buffer
 	  If unsure, say N.
 
+config RD_LZO
+	bool "Support initial ramdisks compressed using LZO" if EMBEDDED
+	default !EMBEDDED
+	depends on BLK_DEV_INITRD
+	select DECOMPRESS_LZO
+	help
+	  Support loading of a LZO encoded initial ramdisk or cpio buffer
+	  If unsure, say N.
+
 choice
 	prompt "Built-in initramfs compression mode" if INITRAMFS_SOURCE!=""
 	help
@@ -108,16 +117,15 @@ config INITRAMFS_COMPRESSION_GZIP
 	bool "Gzip"
 	depends on RD_GZIP
 	help
-	  The old and tried gzip compression. Its compression ratio is
-	  the poorest among the 3 choices; however its speed (both
-	  compression and decompression) is the fastest.
+	  The old and tried gzip compression. It provides a good balance
+	  between compression ration and decompression speed.
 
 config INITRAMFS_COMPRESSION_BZIP2
 	bool "Bzip2"
 	depends on RD_BZIP2
 	help
 	  Its compression ratio and speed is intermediate.
-	  Decompression speed is slowest among the three.  The initramfs
+	  Decompression speed is slowest among the four.  The initramfs
 	  size is about 10% smaller with bzip2, in comparison to gzip.
 	  Bzip2 uses a large amount of memory. For modern kernels you
 	  will need at least 8MB RAM or more for booting.
@@ -128,7 +136,15 @@ config INITRAMFS_COMPRESSION_LZMA
 	help
 	  The most recent compression algorithm.
 	  Its ratio is best, decompression speed is between the other
-	  two. Compression is slowest.	The initramfs size is about 33%
+	  three. Compression is slowest. The initramfs size is about 33%
 	  smaller with LZMA in comparison to gzip.
 
+config INITRAMFS_COMPRESSION_LZO
+	bool "LZO"
+	depends on RD_LZO
+	help
+	  Its compression ratio is the poorest among the four. The kernel
+	  size is about about 10% bigger than gzip; however its speed
+	  (both compression and decompression) is the fastest.
+
 endchoice
_

Patches currently in -mm which might be from albin.tonnerre@free-electrons.com are

linux-next.patch
include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels.patch
lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch

