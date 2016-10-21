From: akpm@linux-foundation.org
Subject: +
 initramfs-select-builtin-initram-compression-algorithm-on-kconfig-instead-of-makefile.patch added to -mm tree
Date: Fri, 21 Oct 2016 14:23:12 -0700
Message-ID: <580a8740.nSKuErNf7rZVsdh3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35279 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933860AbcJUVXN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2016 17:23:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: klondike@klondike.es, pebolle@tiscali.nl, ppandit@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: select builtin initram compression algorithm on KConfig instead of Makefile
has been added to the -mm tree.  Its filename is
     initramfs-select-builtin-initram-compression-algorithm-on-kconfig-instead-of-makefile.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initramfs-select-builtin-initram-compression-algorithm-on-kconfig-instead-of-makefile.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initramfs-select-builtin-initram-compression-algorithm-on-kconfig-instead-of-makefile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
