From: akpm@linux-foundation.org
Subject: + blackfin-arch-fix-some-coding-style-in-include.patch added to -mm tree
Date: Fri, 06 Apr 2007 14:24:46 -0700
Message-ID: <200704062124.l36LOk05019333@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34722 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933092AbXDFVYv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 17:24:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     blackfin arch: fix some coding style in include asm-blackin header files
has been added to the -mm tree.  Its filename is
     blackfin-arch-fix-some-coding-style-in-include.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: blackfin arch: fix some coding style in include asm-blackin header files
From: "Wu, Bryan" <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-blackfin/dma-mapping.h                 |   11 ++++++-----
 include/asm-blackfin/gpio.h                        |    2 --
 include/asm-blackfin/mach-bf533/anomaly.h          |    1 -
 include/asm-blackfin/mach-bf533/blackfin.h         |    1 -
 include/asm-blackfin/mach-bf533/cdefBF532.h        |    1 -
 include/asm-blackfin/mach-bf533/defBF532.h         |    3 ---
 include/asm-blackfin/mach-bf533/dma.h              |    2 --
 include/asm-blackfin/mach-bf533/irq.h              |    1 -
 include/asm-blackfin/mach-bf537/mem_map.h          |    7 +------
 include/asm-blackfin/mach-bf561/anomaly.h          |    1 -
 include/asm-blackfin/mach-bf561/blackfin.h         |    1 -
 include/asm-blackfin/mach-bf561/cdefBF561.h        |    1 -
 include/asm-blackfin/mach-bf561/defBF561.h         |    1 -
 include/asm-blackfin/mach-bf561/dma.h              |    1 -
 include/asm-blackfin/mach-bf561/irq.h              |    1 -
 include/asm-blackfin/mach-bf561/mem_map.h          |    1 -
 include/asm-blackfin/mach-common/cdef_LPBlackfin.h |    3 ---
 include/asm-blackfin/mach-common/def_LPBlackfin.h  |    3 ---
 include/asm-blackfin/mmu_context.h                 |    2 --
 include/asm-blackfin/system.h                      |    3 ---
 include/asm-blackfin/thread_info.h                 |    1 -
 21 files changed, 7 insertions(+), 41 deletions(-)

diff -puN include/asm-blackfin/dma-mapping.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/dma-mapping.h
--- a/include/asm-blackfin/dma-mapping.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/dma-mapping.h
@@ -10,6 +10,12 @@ void dma_free_coherent(struct device *de
 		       dma_addr_t dma_handle);
 
 /*
+ * Now for the API extensions over the pci_ one
+ */
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
+/*
  * Map a single buffer of the indicated size for DMA in streaming mode.
  * The 32-bit bus address to use is returned.
  *
@@ -57,9 +63,4 @@ extern int dma_map_sg(struct device *dev
 extern void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 		      int nhwentries, enum dma_data_direction direction);
 
-/* Now for the API extensions over the pci_ one */
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
 #endif				/* _BLACKFIN_DMA_MAPPING_H */
diff -puN include/asm-blackfin/gpio.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/gpio.h
--- a/include/asm-blackfin/gpio.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/gpio.h
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: gpio.h,v 1.5 2006/12/12 12:14:56 hennerich Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN include/asm-blackfin/mach-bf533/anomaly.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-bf533/anomaly.h
--- a/include/asm-blackfin/mach-bf533/anomaly.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-bf533/anomaly.h
@@ -10,7 +10,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN include/asm-blackfin/mach-bf533/blackfin.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-bf533/blackfin.h
--- a/include/asm-blackfin/mach-bf533/blackfin.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-bf533/blackfin.h
@@ -10,7 +10,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN include/asm-blackfin/mach-bf533/cdefBF532.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-bf533/cdefBF532.h
--- a/include/asm-blackfin/mach-bf533/cdefBF532.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-bf533/cdefBF532.h
@@ -10,7 +10,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN include/asm-blackfin/mach-bf533/defBF532.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-bf533/defBF532.h
--- a/include/asm-blackfin/mach-bf533/defBF532.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-bf533/defBF532.h
@@ -1,7 +1,5 @@
 /************************************************************************
  *
- * $Id: defBF532.h 2717 2007-02-02 03:58:24Z vapier $
- *
  * This file is subject to the terms and conditions of the GNU Public
  * License. See the file "COPYING" in the main directory of this archive
  * for more details.
@@ -27,7 +25,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN include/asm-blackfin/mach-bf533/dma.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-bf533/dma.h
--- a/include/asm-blackfin/mach-bf533/dma.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-bf533/dma.h
@@ -1,5 +1,4 @@
 /*****************************************************************************
-* $Id: dma.h,v 1.4 2005/10/28 04:13:50 magicyang Exp $
 *
 *        BF-533/2/1 Specific Declarations
 *
@@ -16,7 +15,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN include/asm-blackfin/mach-bf533/irq.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-bf533/irq.h
--- a/include/asm-blackfin/mach-bf533/irq.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-bf533/irq.h
@@ -10,7 +10,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN include/asm-blackfin/mach-bf537/mem_map.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-bf537/mem_map.h
--- a/include/asm-blackfin/mach-bf537/mem_map.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-bf537/mem_map.h
@@ -1,16 +1,11 @@
 /*
- * Memory MAP
- * Common header file for blackfin BF537/6/4 of processors.
- *
- */
-/*
  * file:         include/asm-blackfin/mach-bf537/mem_map.h
  * based on:
  * author:
  *
  * created:
  * description:
- *	Memory MAP
+ *	Memory MAP Common header file for blackfin BF537/6/4 of processors.
  * rev:
  *
  * modified:
diff -puN include/asm-blackfin/mach-bf561/anomaly.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-bf561/anomaly.h
--- a/include/asm-blackfin/mach-bf561/anomaly.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-bf561/anomaly.h
@@ -11,7 +11,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN include/asm-blackfin/mach-bf561/blackfin.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-bf561/blackfin.h
--- a/include/asm-blackfin/mach-bf561/blackfin.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-bf561/blackfin.h
@@ -10,7 +10,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN include/asm-blackfin/mach-bf561/cdefBF561.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-bf561/cdefBF561.h
--- a/include/asm-blackfin/mach-bf561/cdefBF561.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-bf561/cdefBF561.h
@@ -10,7 +10,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN include/asm-blackfin/mach-bf561/defBF561.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-bf561/defBF561.h
--- a/include/asm-blackfin/mach-bf561/defBF561.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-bf561/defBF561.h
@@ -11,7 +11,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN include/asm-blackfin/mach-bf561/dma.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-bf561/dma.h
--- a/include/asm-blackfin/mach-bf561/dma.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-bf561/dma.h
@@ -1,5 +1,4 @@
 /*****************************************************************************
-* $Id: dma.h,v 1.1 2005/11/14 07:46:00 bvermeul Exp $
 *
 *        BF-533/2/1 Specific Declarations
 *
diff -puN include/asm-blackfin/mach-bf561/irq.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-bf561/irq.h
--- a/include/asm-blackfin/mach-bf561/irq.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-bf561/irq.h
@@ -11,7 +11,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN include/asm-blackfin/mach-bf561/mem_map.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-bf561/mem_map.h
--- a/include/asm-blackfin/mach-bf561/mem_map.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-bf561/mem_map.h
@@ -1,7 +1,6 @@
 /*
  * Memory MAP
  * Common header file for blackfin BF561 of processors.
- *
  */
 
 #ifndef _MEM_MAP_561_H_
diff -puN include/asm-blackfin/mach-common/cdef_LPBlackfin.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-common/cdef_LPBlackfin.h
--- a/include/asm-blackfin/mach-common/cdef_LPBlackfin.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-common/cdef_LPBlackfin.h
@@ -6,11 +6,8 @@
   * Created:     ?
   * Description:
   *
-  * Rev:        $Id: cdef_LPBlackfin.h,v 1.8 2006/06/17 20:40:47 rgetz Exp $
-  *
   * Modified:
   *
-  *
   * Bugs:         Enter bugs at http://blackfin.uclinux.org/
   *
   * This program is free software; you can redistribute it and/or modify
diff -puN include/asm-blackfin/mach-common/def_LPBlackfin.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mach-common/def_LPBlackfin.h
--- a/include/asm-blackfin/mach-common/def_LPBlackfin.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mach-common/def_LPBlackfin.h
@@ -6,11 +6,8 @@
   * Created:     ?
   * Description:
   *
-  * Rev:       $Id: def_LPBlackfin.h,v 1.12 2006/08/30 21:57:25 vapier Exp $
-  *
   * Modified:
   *
-  *
   * Bugs:         Enter bugs at http://blackfin.uclinux.org/
   *
   * This program is free software; you can redistribute it and/or modify
diff -puN include/asm-blackfin/mmu_context.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/mmu_context.h
--- a/include/asm-blackfin/mmu_context.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/mmu_context.h
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: mmu_context.h,v 1.9 2006/08/09 20:31:16 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN include/asm-blackfin/system.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/system.h
--- a/include/asm-blackfin/system.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/system.h
@@ -9,13 +9,10 @@
  * Created:     25Jan2001 - Tony Kou
  * Description: system.h include file
  *
- * Rev:       $Id: system.h,v 1.22 2006/09/22 22:20:21 rgetz Exp $
- *
  * Modified:     22Sep2006 - Robin Getz
  *                - move include blackfin.h down, so I can get access to
  *                   irq functions in other include files.
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN include/asm-blackfin/thread_info.h~blackfin-arch-fix-some-coding-style-in-include include/asm-blackfin/thread_info.h
--- a/include/asm-blackfin/thread_info.h~blackfin-arch-fix-some-coding-style-in-include
+++ a/include/asm-blackfin/thread_info.h
@@ -5,7 +5,6 @@
  *               Copyright (C) 2004-2005 Analog Devices Inc.
  * Created:      Tue Sep 21 2004
  * Description:  Blackfin low-level thread information
- * Rev:          $Id: thread_info.h,v 1.8 2005/10/28 04:13:49 magicyang Exp $
  * Modified:
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
_

Patches currently in -mm which might be from bryan.wu@analog.com are

usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
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
blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch
blackfin-arch-fix-bug-prevent-warning-in-case-bf531-is-target.patch
blackfin-arch-fix-stamp537-isp1716-irq-setting-bug.patch
blackfin-arch-fix-bug-interrupt-setup-problem-request_irq.patch
blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch
blackfin-arch-always-include-linux-kallsysms-header-file.patch
blackfin-arch-sync-with-uclibc-no-functional-changes.patch
blackfin-arch-using-asm-generic-pgtable-header-file-by.patch
blackfin-arch-add-missing-__clear_user-function-to.patch
blackfin-arch-use-boot_command_line-instead-of.patch
blackfin-arch-fix-some-coding-style-in-include.patch
blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch
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
move-die-notifier-handling-to-common-code-fix.patch
blackfin-blackfin-utrace-patch.patch
utrace-nommu-fixup-support-utrace.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
