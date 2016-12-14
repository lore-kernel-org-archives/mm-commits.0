From: akpm@linux-foundation.org
Subject: [patch 041/114] initramfs: select builtin initram compression
 algorithm on KConfig instead of Makefile
Date: Wed, 14 Dec 2016 15:06:01 -0800
Message-ID: <5851d059.54R8yX0N3VRe529w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754094AbcLNXGX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:06:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, klondike@klondike.es, pebolle@tiscali.nl, ppandit@redhat.com

From: Francisco Blas Izquierdo Riera (klondike) <klondike@klondike.es>
Subject: initramfs: select builtin initram compression algorithm on KConfig instead of Makefile

Move the current builtin initram compression algorithm selection from the
Makefile into the INITRAMFS_COMPRESSION variable.  This makes deciding
algorithm precedence easier and would allow for overrides if new
algorithms want to be tested.

Link: http://lkml.kernel.org/r/57EAD769.1090401@klondike.es
Signed-off-by: Francisco Blas Izquierdo Riera (klondike) <klondike@klondike.es>
Cc: P J P <ppandit@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/Kconfig  |   10 ++++++++++
 usr/Makefile |   20 +-------------------
 2 files changed, 11 insertions(+), 19 deletions(-)

diff -puN usr/Kconfig~initramfs-select-builtin-initram-compression-algorithm-on-kconfig-instead-of-makefile usr/Kconfig
--- a/usr/Kconfig~initramfs-select-builtin-initram-compression-algorithm-on-kconfig-instead-of-makefile
+++ a/usr/Kconfig
@@ -98,3 +98,13 @@ config RD_LZ4
 	help
 	  Support loading of a LZ4 encoded initial ramdisk or cpio buffer
 	  If unsure, say N.
+
+config INITRAMFS_COMPRESSION
+	string
+	default ".gz"   if RD_GZIP
+	default ".lz4"  if RD_LZ4
+	default ".lzo"  if RD_LZO
+	default ".xz"   if RD_XZ
+	default ".lzma" if RD_LZMA
+	default ".bz2"  if RD_BZIP2
+	default ""
diff -puN usr/Makefile~initramfs-select-builtin-initram-compression-algorithm-on-kconfig-instead-of-makefile usr/Makefile
--- a/usr/Makefile~initramfs-select-builtin-initram-compression-algorithm-on-kconfig-instead-of-makefile
+++ a/usr/Makefile
@@ -5,25 +5,7 @@
 klibcdirs:;
 PHONY += klibcdirs
 
-
-# Bzip2
-suffix_$(CONFIG_RD_BZIP2)  = .bz2
-
-# Lzma
-suffix_$(CONFIG_RD_LZMA)   = .lzma
-
-# XZ
-suffix_$(CONFIG_RD_XZ)     = .xz
-
-# Lzo
-suffix_$(CONFIG_RD_LZO)    = .lzo
-
-# Lz4
-suffix_$(CONFIG_RD_LZ4)    = .lz4
-
-# Gzip
-suffix_$(CONFIG_RD_GZIP)   = .gz
