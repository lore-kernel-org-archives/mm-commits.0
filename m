From: akpm@linux-foundation.org
Subject: + blackfin-arch-cleanup-cache-header-file.patch added to -mm tree
Date: Mon, 26 Mar 2007 14:10:33 -0700
Message-ID: <200703262110.l2QLAXvS030649@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52055 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194AbXCZVKg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 17:10:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     Blackfin arch: cleanup cache header file
has been added to the -mm tree.  Its filename is
     blackfin-arch-cleanup-cache-header-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blackfin arch: cleanup cache header file
From: "Wu, Bryan" <bryan.wu@analog.com>

According to Paul's review, this patch cleanup the
include/asm-blackfin/cache.h comments.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-blackfin/cache.h |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff -puN include/asm-blackfin/cache.h~blackfin-arch-cleanup-cache-header-file include/asm-blackfin/cache.h
--- a/include/asm-blackfin/cache.h~blackfin-arch-cleanup-cache-header-file
+++ a/include/asm-blackfin/cache.h
@@ -1,13 +1,21 @@
+/*
+ * include/asm-blackfin/cache.h
+ */
 #ifndef __ARCH_BLACKFIN_CACHE_H
 #define __ARCH_BLACKFIN_CACHE_H
 
-/* bytes per L1 cache line */
-#define        L1_CACHE_SHIFT  5	/* BlackFin loads 32 bytes for cache */
-#define        L1_CACHE_BYTES  (1 << L1_CACHE_SHIFT)
+/*
+ * Bytes per L1 cache line
+ * Blackfin loads 32 bytes for cache
+ */
+#define L1_CACHE_SHIFT	5
+#define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
 
-/* For speed we do need to align these ...MaTed---*/
-/*  But include/linux/cache.h does this for us if we DO not define ...MaTed---*/
-#define __cacheline_aligned	/***** maybe no need this   Tony *****/
+/*
+ * Don't make __cacheline_aligned and
+ * ____cacheline_aligned defined in include/linux/cache.h
+ */
+#define __cacheline_aligned
 #define ____cacheline_aligned
 
 /*
_

Patches currently in -mm which might be from bryan.wu@analog.com are

blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-balance-parenthesis-in-macros.patch
blackfin-arch-2.6.21-rc4-mm1-update.patch
blackfin-arch-fix-struct-dmasg-packing-bug.patch
blackfin-arch-cleanup-cache-header-file.patch
blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-arch-fix-compiling-error-in-flat-c-file.patch
blackfin-arch-power-management-replace-firmware-disk-mode.patch
blackfin-arch-add-kdebug-header-file.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch
blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-blackfin-utrace-patch.patch
utrace-nommu-fixup-support-utrace.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
