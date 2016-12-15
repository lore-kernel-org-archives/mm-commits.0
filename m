From: akpm@linux-foundation.org
Subject: [merged]
 initramfs-allow-again-choice-of-the-embedded-initram-compression-algorithm.patch removed from -mm tree
Date: Thu, 15 Dec 2016 10:46:32 -0800
Message-ID: <5852e508.jg6U+EEO7W0GyN92%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48822 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754238AbcLOSqw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:46:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: klondike@klondike.es, pebolle@tiscali.nl, ppandit@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: allow again choice of the embedded initram compression algorithm
has been removed from the -mm tree.  Its filename was
     initramfs-allow-again-choice-of-the-embedded-initram-compression-algorithm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Francisco Blas Izquierdo Riera (klondike) <klondike@klondike.es>
Subject: initramfs: allow again choice of the embedded initram compression algorithm

Choosing the appropriate compression option when using an embedded
initramfs can result in significant size differences in the resulting
data.

This is caused by avoiding double compression of the initramfs contents. 
For example on my tests, choosing CONFIG_INITRAMFS_COMPRESSION_NONE when
compressing the kernel using XZ) results in up to 500KiB differences (9MiB
to 8.5MiB) in the kernel size as the dictionary will not get polluted with
uncomprensible data and may reuse kernel data too.

Despite embedding an uncompressed initramfs, a user may want to allow for
a compressed extra initramfs to be passed using the rd system, for example
to boot a recovery system.  9ba4bcb645898d ("initramfs: read CONFIG_RD_
variables for initramfs compression") broke that behavior by making the
choice based on CONFIG_RD_* instead of adding
CONFIG_INITRAMFS_COMPRESSION_LZ4.  Saddly, CONFIG_RD_* is also used to
choose the supported RD compression algorithms by the kernel and a user
may want to support more than one.

This patch also reverses 3e4e0f0a875 ("initramfs: remove "compression
mode" choice") restoring back the "compression mode" choice and includes
the CONFIG_INITRAMFS_COMPRESSION_LZ4 option which was never added.

As a result the following options are added or readed affecting the embedded
initramfs compression:
INITRAMFS_COMPRESSION_NONE Do no compression
INITRAMFS_COMPRESSION_GZIP Compress using gzip
INITRAMFS_COMPRESSION_BZIP2 Compress using bzip2
INITRAMFS_COMPRESSION_LZMA Compress using lzma
INITRAMFS_COMPRESSION_XZ Compress using xz
INITRAMFS_COMPRESSION_LZO Compress using lzo
INITRAMFS_COMPRESSION_LZ4 Compress using lz4

These depend on the corresponding CONFIG_RD_* option being set (except NONE
which has no dependencies).

This patch depends on the previous one (the previous version didn't) to
simplify the way in which the algorithm is chosen and keep backwards
compatibility with the behaviour introduced by 9ba4bcb645898 ("initramfs:
read CONFIG_RD_ variables for initramfs compression").

Link: http://lkml.kernel.org/r/57EAD77B.7090607@klondike.es
Signed-off-by: Francisco Blas Izquierdo Riera (klondike) <klondike@klondike.es>
Cc: P J P <ppandit@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/Kconfig |  117 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff -puN usr/Kconfig~initramfs-allow-again-choice-of-the-embedded-initram-compression-algorithm usr/Kconfig
--- a/usr/Kconfig~initramfs-allow-again-choice-of-the-embedded-initram-compression-algorithm
+++ a/usr/Kconfig
@@ -99,8 +99,125 @@ config RD_LZ4
 	  Support loading of a LZ4 encoded initial ramdisk or cpio buffer
 	  If unsure, say N.
 
+choice
+	prompt "Built-in initramfs compression mode"
+	depends on INITRAMFS_SOURCE!=""
+	optional
+	help
+	  This option allows you to decide by which algorithm the builtin
+	  initramfs will be compressed.  Several compression algorithms are
+	  available, which differ in efficiency, compression and
+	  decompression speed.  Compression speed is only relevant
+	  when building a kernel.  Decompression speed is relevant at
+	  each boot. Also the memory usage during decompression may become
+	  relevant on memory constrained systems. This is usually based on the
+	  dictionary size of the algorithm with algorithms like XZ and LZMA
+	  featuring large dictionary sizes.
+
+	  High compression options are mostly useful for users who are
+	  low on RAM, since it reduces the memory consumption during
+	  boot.
+
+	  Keep in mind that your build system needs to provide the appropriate
+	  compression tool to compress the generated initram cpio file for
+	  embedding.
+
+	  If in doubt, select 'None'
+
+config INITRAMFS_COMPRESSION_NONE
+	bool "None"
+	help
+	  Do not compress the built-in initramfs at all. This may sound wasteful
+	  in space, but, you should be aware that the built-in initramfs will be
+	  compressed at a later stage anyways along with the rest of the kernel,
+	  on those architectures that support this. However, not compressing the
+	  initramfs may lead to slightly higher memory consumption during a
+	  short time at boot, while both the cpio image and the unpacked
+	  filesystem image will be present in memory simultaneously
+
+config INITRAMFS_COMPRESSION_GZIP
+	bool "Gzip"
+	depends on RD_GZIP
+	help
+	  Use the old and well tested gzip compression algorithm. Gzip provides
+	  a good balance between compression ratio and decompression speed and
+	  has a reasonable compression speed. It is also more likely to be
+	  supported by your build system as the gzip tool is present by default
+	  on most distros.
+
+config INITRAMFS_COMPRESSION_BZIP2
+	bool "Bzip2"
+	depends on RD_BZIP2
+	help
+	  It's compression ratio and speed is intermediate. Decompression speed
+	  is slowest among the choices. The initramfs size is about 10% smaller
+	  with bzip2, in comparison to gzip. Bzip2 uses a large amount of
+	  memory. For modern kernels you will need at least 8MB RAM or more for
+	  booting.
+
+	  If you choose this, keep in mind that you need to have the bzip2 tool
+	  available to be able to compress the initram.
+
+config INITRAMFS_COMPRESSION_LZMA
+	bool "LZMA"
+	depends on RD_LZMA
+	help
+	  This algorithm's compression ratio is best but has a large dictionary
+	  size which might cause issues in memory constrained systems.
+	  Decompression speed is between the other choices. Compression is
+	  slowest. The initramfs size is about 33% smaller with LZMA in
+	  comparison to gzip.
+
+	  If you choose this, keep in mind that you may need to install the xz
+	  or lzma tools to be able to compress the initram.
+
+config INITRAMFS_COMPRESSION_XZ
+	bool "XZ"
+	depends on RD_XZ
+	help
+	  XZ uses the LZMA2 algorithm and has a large dictionary which may cause
+	  problems on memory constrained systems. The initramfs size is about
+	  30% smaller with XZ in comparison to gzip. Decompression speed is
+	  better than that of bzip2 but worse than gzip and LZO. Compression is
+	  slow.
+
+	  If you choose this, keep in mind that you may need to install the xz
+	  tool to be able to compress the initram.
+
+config INITRAMFS_COMPRESSION_LZO
+	bool "LZO"
+	depends on RD_LZO
+	help
+	  It's compression ratio is the second poorest amongst the choices. The
+	  kernel size is about 10% bigger than gzip. Despite that, it's
+	  decompression speed is the second fastest and it's compression speed
+	  is quite fast too.
+
+	  If you choose this, keep in mind that you may need to install the lzop
+	  tool to be able to compress the initram.
+
+config INITRAMFS_COMPRESSION_LZ4
+	bool "LZ4"
+	depends on RD_LZ4
+	help
+	  It's compression ratio is the poorest amongst the choices. The kernel
+	  size is about 15% bigger than gzip; however its decompression speed
+	  is the fastest.
+
+	  If you choose this, keep in mind that most distros don't provide lz4
+	  by default which could cause a build failure.
+
+endchoice
+
 config INITRAMFS_COMPRESSION
 	string
+	default ""      if INITRAMFS_COMPRESSION_NONE
+	default ".gz"   if INITRAMFS_COMPRESSION_GZIP
+	default ".bz2"  if INITRAMFS_COMPRESSION_BZIP2
+	default ".lzma" if INITRAMFS_COMPRESSION_LZMA
+	default ".xz"   if INITRAMFS_COMPRESSION_XZ
+	default ".lzo"  if INITRAMFS_COMPRESSION_LZO
+	default ".lz4"  if INITRAMFS_COMPRESSION_LZ4
 	default ".gz"   if RD_GZIP
 	default ".lz4"  if RD_LZ4
 	default ".lzo"  if RD_LZO
_

Patches currently in -mm which might be from klondike@klondike.es are


