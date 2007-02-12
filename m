From: akpm@linux-foundation.org
Subject: - debug-shared-irqs-kconfig-fix.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:21:49 -0800
Message-ID: <200702120721.l1C7Lnrn024686@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44827 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933056AbXBLHZJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:25:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, arjan@infradead.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     DEBUG_SHIRQ should depend on DEBUG_KERNEL
has been removed from the -mm tree.  Its filename was
     debug-shared-irqs-kconfig-fix.patch

This patch was dropped because it was folded into debug-shared-irqs.patch

------------------------------------------------------
Subject: DEBUG_SHIRQ should depend on DEBUG_KERNEL
From: Adrian Bunk <bunk@stusta.de>

DEBUG_SHIRQ is clearly a debugging option.

While moving the option below DEBUG_KERNEL, I also adjusted the help text
to be completely visible in "make menuconfig" with a 80 char width.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN lib/Kconfig.debug~debug-shared-irqs-kconfig-fix lib/Kconfig.debug
--- a/lib/Kconfig.debug~debug-shared-irqs-kconfig-fix
+++ a/lib/Kconfig.debug
@@ -71,21 +71,21 @@ config HEADERS_CHECK
 	  exported to $(INSTALL_HDR_PATH) (usually 'usr/include' in
 	  your build tree), to make sure they're suitable.
 
-config DEBUG_SHIRQ
-       bool "Debug shared IRQ handlers"
-       depends on GENERIC_HARDIRQS
-       help
-         Enable this to generate a spurious interrupt as soon as a shared interrupt
-	 handler is registered, and just before one is deregistered. Drivers ought
-	 to be able to handle interrupts coming in at those points; some don't and
-	 need to be caught.
-
 config DEBUG_KERNEL
 	bool "Kernel debugging"
 	help
 	  Say Y here if you are developing drivers or trying to debug and
 	  identify kernel problems.
 
+config DEBUG_SHIRQ
+	bool "Debug shared IRQ handlers"
+	depends on DEBUG_KERNEL && GENERIC_HARDIRQS
+	help
+	  Enable this to generate a spurious interrupt as soon as a shared
+	  interrupt handler is registered, and just before one is deregistered.
+	  Drivers ought to be able to handle interrupts coming in at those
+	  points; some don't and need to be caught.
+
 config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)" if DEBUG_KERNEL
 	range 12 21
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
debug-shared-irqs.patch
debug-shared-irqs-kconfig-fix.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
drivers-isdn-sc-proper-prototypes.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
remove-the-broken-fb_s3trio-driver.patch
