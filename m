From: akpm@linux-foundation.org
Subject: + make-initrd-compression-algorithm-selection-not-expert.patch
 added to -mm tree
Date: Tue, 14 Oct 2014 14:29:32 -0700
Message-ID: <543d95bc.nzm7rNUYSPoNJk7z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaJNV3c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 17:29:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: usr/Kconfig: make initrd compression algorithm selection not expert
has been added to the -mm tree.  Its filename is
     make-initrd-compression-algorithm-selection-not-expert.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/make-initrd-compression-algorithm-selection-not-expert.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/make-initrd-compression-algorithm-selection-not-expert.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: usr/Kconfig: make initrd compression algorithm selection not expert

The kernel has support for (nearly) every compression algorithm known to
man, each to handle some particular microscopic niche.

Unfortunately all of these always get compiled in if you want to support
INITRDs, and can be only disabled when CONFIG_EXPERT is set.

I don't see why I need to set EXPERT just to properly configure the initrd
compression algorithms, and not always include every possible algorithm

Usually the initrd is just compressed with gzip anyways, at least that's
true on all distributions I use.

Remove the dependencies for initrd compression on CONFIG_EXPERT.

Make the various options just default y, which should be good enough to
not break any previous configuration.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/Kconfig |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN usr/Kconfig~make-initrd-compression-algorithm-selection-not-expert usr/Kconfig
--- a/usr/Kconfig~make-initrd-compression-algorithm-selection-not-expert
+++ a/usr/Kconfig
@@ -46,17 +46,17 @@ config INITRAMFS_ROOT_GID
 	  If you are not sure, leave it set to "0".
 
 config RD_GZIP
-	bool "Support initial ramdisks compressed using gzip" if EXPERT
-	default y
+	bool "Support initial ramdisks compressed using gzip"
 	depends on BLK_DEV_INITRD
+	default y
 	select DECOMPRESS_GZIP
 	help
 	  Support loading of a gzip encoded initial ramdisk or cpio buffer.
 	  If unsure, say Y.
 
 config RD_BZIP2
-	bool "Support initial ramdisks compressed using bzip2" if EXPERT
-	default !EXPERT
+	bool "Support initial ramdisks compressed using bzip2"
+	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_BZIP2
 	help
@@ -64,8 +64,8 @@ config RD_BZIP2
 	  If unsure, say N.
 
 config RD_LZMA
-	bool "Support initial ramdisks compressed using LZMA" if EXPERT
-	default !EXPERT
+	bool "Support initial ramdisks compressed using LZMA"
+	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZMA
 	help
@@ -73,17 +73,17 @@ config RD_LZMA
 	  If unsure, say N.
 
 config RD_XZ
-	bool "Support initial ramdisks compressed using XZ" if EXPERT
-	default !EXPERT
+	bool "Support initial ramdisks compressed using XZ"
 	depends on BLK_DEV_INITRD
+	default y
 	select DECOMPRESS_XZ
 	help
 	  Support loading of a XZ encoded initial ramdisk or cpio buffer.
 	  If unsure, say N.
 
 config RD_LZO
-	bool "Support initial ramdisks compressed using LZO" if EXPERT
-	default !EXPERT
+	bool "Support initial ramdisks compressed using LZO"
+	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZO
 	help
@@ -91,8 +91,8 @@ config RD_LZO
 	  If unsure, say N.
 
 config RD_LZ4
-	bool "Support initial ramdisks compressed using LZ4" if EXPERT
-	default !EXPERT
+	bool "Support initial ramdisks compressed using LZ4"
+	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZ4
 	help
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
make-initrd-compression-algorithm-selection-not-expert.patch
linux-next.patch

