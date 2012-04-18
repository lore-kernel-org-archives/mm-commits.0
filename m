From: akpm@linux-foundation.org
Subject: + kconfig-update-compression-algorithm-info.patch added to -mm tree
Date: Wed, 18 Apr 2012 15:14:45 -0700
Message-ID: <20120418221448.7DFC8A018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:35164 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2DRWOu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Apr 2012 18:14:50 -0400
Received: by ghbz15 with SMTP id z15so905081ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Apr 2012 15:14:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, lasse.collin@tukaani.org, markus@trippelsdorf.de, qasdfgtyuiop@gmail.com


The patch titled
     Subject: kconfig: update compression algorithm info
has been added to the -mm tree.  Its filename is
     kconfig-update-compression-algorithm-info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: kconfig: update compression algorithm info

There have been new compression algorithms added without updating nearby
relevant descriptive text that refers to (a) the number of compression
algorithms and (b) the most recent one.  Fix these inconsistencies.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Reported-by: <qasdfgtyuiop@gmail.com>
Cc: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   11 +++++------
 usr/Kconfig  |   10 +++++-----
 2 files changed, 10 insertions(+), 11 deletions(-)

diff -puN init/Kconfig~kconfig-update-compression-algorithm-info init/Kconfig
--- a/init/Kconfig~kconfig-update-compression-algorithm-info
+++ a/init/Kconfig
@@ -164,7 +164,7 @@ config KERNEL_BZIP2
 	depends on HAVE_KERNEL_BZIP2
 	help
 	  Its compression ratio and speed is intermediate.
-	  Decompression speed is slowest among the three.  The kernel
+	  Decompression speed is slowest among the choices.  The kernel
 	  size is about 10% smaller with bzip2, in comparison to gzip.
 	  Bzip2 uses a large amount of memory. For modern kernels you
 	  will need at least 8MB RAM or more for booting.
@@ -173,10 +173,9 @@ config KERNEL_LZMA
 	bool "LZMA"
 	depends on HAVE_KERNEL_LZMA
 	help
-	  The most recent compression algorithm.
-	  Its ratio is best, decompression speed is between the other
-	  two. Compression is slowest.	The kernel size is about 33%
-	  smaller with LZMA in comparison to gzip.
+	  This compression algorithm's ratio is best.  Decompression speed
+	  is between gzip and bzip2.  Compression is slowest.
+	  The kernel size is about 33% smaller with LZMA in comparison to gzip.
 
 config KERNEL_XZ
 	bool "XZ"
@@ -197,7 +196,7 @@ config KERNEL_LZO
 	bool "LZO"
 	depends on HAVE_KERNEL_LZO
 	help
-	  Its compression ratio is the poorest among the 4. The kernel
+	  Its compression ratio is the poorest among the choices. The kernel
 	  size is about 10% bigger than gzip; however its speed
 	  (both compression and decompression) is the fastest.
 
diff -puN usr/Kconfig~kconfig-update-compression-algorithm-info usr/Kconfig
--- a/usr/Kconfig~kconfig-update-compression-algorithm-info
+++ a/usr/Kconfig
@@ -134,7 +134,7 @@ config INITRAMFS_COMPRESSION_BZIP2
 	depends on RD_BZIP2
 	help
 	  Its compression ratio and speed is intermediate.
-	  Decompression speed is slowest among the four.  The initramfs
+	  Decompression speed is slowest among the choices.  The initramfs
 	  size is about 10% smaller with bzip2, in comparison to gzip.
 	  Bzip2 uses a large amount of memory. For modern kernels you
 	  will need at least 8MB RAM or more for booting.
@@ -143,9 +143,9 @@ config INITRAMFS_COMPRESSION_LZMA
 	bool "LZMA"
 	depends on RD_LZMA
 	help
-	  The most recent compression algorithm.
-	  Its ratio is best, decompression speed is between the other
-	  three. Compression is slowest. The initramfs size is about 33%
+	  This algorithm's compression ratio is best.
+	  Decompression speed is between the other choices.
+	  Compression is slowest. The initramfs size is about 33%
 	  smaller with LZMA in comparison to gzip.
 
 config INITRAMFS_COMPRESSION_XZ
@@ -161,7 +161,7 @@ config INITRAMFS_COMPRESSION_LZO
 	bool "LZO"
 	depends on RD_LZO
 	help
-	  Its compression ratio is the poorest among the four. The kernel
+	  Its compression ratio is the poorest among the choices. The kernel
 	  size is about 10% bigger than gzip; however its speed
 	  (both compression and decompression) is the fastest.
 
_
Subject: Subject: kconfig: update compression algorithm info

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch
kconfig-update-compression-algorithm-info.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

