From: akpm@linux-foundation.org
Subject: + initramfs-remove-compression-mode-choice.patch added to -mm
 tree
Date: Wed, 09 Apr 2014 14:35:41 -0700
Message-ID: <5345bd2d.Nz5pX0A3a7f2jD/p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717AbaDIVfm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 17:35:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ppandit@redhat.com, pebolle@tiscali.nl

Subject: + initramfs-remove-compression-mode-choice.patch added to -mm tree
To: pebolle@tiscali.nl,ppandit@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 14:35:41 -0700


The patch titled
     Subject: initramfs: remove "compression mode" choice
has been added to the -mm tree.  Its filename is
     initramfs-remove-compression-mode-choice.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initramfs-remove-compression-mode-choice.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initramfs-remove-compression-mode-choice.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Bolle <pebolle@tiscali.nl>
Subject: initramfs: remove "compression mode" choice

9ba4bcb64589 ("initramfs: read CONFIG_RD_ variables for initramfs
compression") removed the users of the various INITRAMFS_COMPRESSION_*
Kconfig symbols.  So since v3.13 the entire "Built-in initramfs
compression mode" choice is a set of knobs connected to nothing.  The
entire choice can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Cc: P J P <ppandit@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/Kconfig |   77 --------------------------------------------------
 1 file changed, 77 deletions(-)

diff -puN usr/Kconfig~initramfs-remove-compression-mode-choice usr/Kconfig
--- a/usr/Kconfig~initramfs-remove-compression-mode-choice
+++ a/usr/Kconfig
@@ -98,80 +98,3 @@ config RD_LZ4
 	help
 	  Support loading of a LZ4 encoded initial ramdisk or cpio buffer
 	  If unsure, say N.
-
-choice
-	prompt "Built-in initramfs compression mode" if INITRAMFS_SOURCE!=""
-	help
-	  This option decides by which algorithm the builtin initramfs
-	  will be compressed.  Several compression algorithms are
-	  available, which differ in efficiency, compression and
-	  decompression speed.  Compression speed is only relevant
-	  when building a kernel.  Decompression speed is relevant at
-	  each boot.
-
-	  If you have any problems with bzip2 or LZMA compressed
-	  initramfs, mail me (Alain Knaff) <alain@knaff.lu>.
-
-	  High compression options are mostly useful for users who are
-	  low on RAM, since it reduces the memory consumption during
-	  boot.
-
-	  If in doubt, select 'gzip'
-
-config INITRAMFS_COMPRESSION_NONE
-	bool "None"
-	help
-	  Do not compress the built-in initramfs at all. This may
-	  sound wasteful in space, but, you should be aware that the
-	  built-in initramfs will be compressed at a later stage
-	  anyways along with the rest of the kernel, on those
-	  architectures that support this.
-	  However, not compressing the initramfs may lead to slightly
-	  higher memory consumption during a short time at boot, while
-	  both the cpio image and the unpacked filesystem image will
-	  be present in memory simultaneously
-
-config INITRAMFS_COMPRESSION_GZIP
-	bool "Gzip"
-	depends on RD_GZIP
-	help
-	  The old and tried gzip compression. It provides a good balance
-	  between compression ratio and decompression speed.
-
-config INITRAMFS_COMPRESSION_BZIP2
-	bool "Bzip2"
-	depends on RD_BZIP2
-	help
-	  Its compression ratio and speed is intermediate.
-	  Decompression speed is slowest among the choices.  The initramfs
-	  size is about 10% smaller with bzip2, in comparison to gzip.
-	  Bzip2 uses a large amount of memory. For modern kernels you
-	  will need at least 8MB RAM or more for booting.
-
-config INITRAMFS_COMPRESSION_LZMA
-	bool "LZMA"
-	depends on RD_LZMA
-	help
-	  This algorithm's compression ratio is best.
-	  Decompression speed is between the other choices.
-	  Compression is slowest. The initramfs size is about 33%
-	  smaller with LZMA in comparison to gzip.
-
-config INITRAMFS_COMPRESSION_XZ
-	bool "XZ"
-	depends on RD_XZ
-	help
-	  XZ uses the LZMA2 algorithm. The initramfs size is about 30%
-	  smaller with XZ in comparison to gzip. Decompression speed
-	  is better than that of bzip2 but worse than gzip and LZO.
-	  Compression is slow.
-
-config INITRAMFS_COMPRESSION_LZO
-	bool "LZO"
-	depends on RD_LZO
-	help
-	  Its compression ratio is the poorest among the choices. The kernel
-	  size is about 10% bigger than gzip; however its speed
-	  (both compression and decompression) is the fastest.
