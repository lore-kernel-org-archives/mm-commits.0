From: akpm@linux-foundation.org
Subject: [obsolete]
 init-kconfig-fix-option-to-disable-kernel-compression.patch removed from
 -mm tree
Date: Mon, 18 Nov 2013 11:52:46 -0800
Message-ID: <528a700e.Ldc7hZXbzHxk7pw5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab3KRTwr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 14:52:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hpa@zytor.com, christian.ruppert@abilis.com

Subject: [obsolete] init-kconfig-fix-option-to-disable-kernel-compression.patch removed from -mm tree
To: christian.ruppert@abilis.com,hpa@zytor.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 11:52:46 -0800


The patch titled
     Subject: init/Kconfig: fix option to disable kernel compression
has been removed from the -mm tree.  Its filename was
     init-kconfig-fix-option-to-disable-kernel-compression.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Christian Ruppert <christian.ruppert@abilis.com>
Subject: init/Kconfig: fix option to disable kernel compression

Some architectures with self-decompressing kernel images did not compile
with commit 69f0554ec261fd68 ("init/Kconfig: add option to disable kernel
compression") because they don't provide a non-decompression mechanism for
uncompressed kernels.

Rectify this problem by allowing uncompressed kernels only for architectures
which explicitly state they support them.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/Kconfig |    2 ++
 init/Kconfig     |    5 +++++
 2 files changed, 7 insertions(+)

diff -puN arch/arc/Kconfig~init-kconfig-fix-option-to-disable-kernel-compression arch/arc/Kconfig
--- a/arch/arc/Kconfig~init-kconfig-fix-option-to-disable-kernel-compression
+++ a/arch/arc/Kconfig
@@ -21,6 +21,8 @@ config ARC
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_IOREMAP_PROT
+	select HAVE_KERNEL_UNCOMPRESSED
+	select HAVE_KERNEL_GZIP
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_MEMBLOCK
diff -puN init/Kconfig~init-kconfig-fix-option-to-disable-kernel-compression init/Kconfig
--- a/init/Kconfig~init-kconfig-fix-option-to-disable-kernel-compression
+++ a/init/Kconfig
@@ -97,6 +97,9 @@ config LOCALVERSION_AUTO
 
 	  which is done within the script "scripts/setlocalversion".)
 
+config HAVE_KERNEL_UNCOMPRESSED
+        bool
+
 config HAVE_KERNEL_GZIP
 	bool
 
@@ -118,6 +121,7 @@ config HAVE_KERNEL_LZ4
 choice
 	prompt "Kernel compression mode"
 	default KERNEL_GZIP
+	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4 || HAVE_KERNEL_UNCOMPRESSED
 	help
 	  The linux kernel is a kind of self-extracting executable.
 	  Several compression algorithms are available, which differ
@@ -138,6 +142,7 @@ choice
 
 config KERNEL_UNCOMPRESSED
 	bool "No compression"
+	depends on HAVE_KERNEL_UNCOMPRESSED
 	help
 	  No compression at all. The kernel is huge but the compression and
 	  decompression times are zero.
_

Patches currently in -mm which might be from christian.ruppert@abilis.com are

origin.patch
linux-next.patch

