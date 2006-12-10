From: akpm@osdl.org
Subject: - remove-mtd-jffs2-userh.patch removed from -mm tree
Date: Sun, 10 Dec 2006 04:16:37 -0800
Message-ID: <200612101216.kBACGbv4023808@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48644 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758771AbWLJMT4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 07:19:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     remove mtd/jffs2-user.h
has been removed from the -mm tree.  Its filename was
     remove-mtd-jffs2-userh.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: remove mtd/jffs2-user.h
From: Adrian Bunk <bunk@stusta.de>

- not included by any other header
- not defining any userspace <-> kernel interface
- depends on userspace providing a variable "target_endian"

mtd-utils already has a copy of this file.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/mtd/Kbuild       |    1 -
 include/mtd/jffs2-user.h |   35 -----------------------------------
 2 files changed, 36 deletions(-)

diff -puN include/mtd/Kbuild~remove-mtd-jffs2-userh include/mtd/Kbuild
--- a/include/mtd/Kbuild~remove-mtd-jffs2-userh
+++ a/include/mtd/Kbuild
@@ -1,5 +1,4 @@
 header-y += inftl-user.h
-header-y += jffs2-user.h
 header-y += mtd-abi.h
 header-y += mtd-user.h
 header-y += nftl-user.h
diff -puN include/mtd/jffs2-user.h~remove-mtd-jffs2-userh /dev/null
--- a/include/mtd/jffs2-user.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- * $Id: jffs2-user.h,v 1.1 2004/05/05 11:57:54 dwmw2 Exp $
- *
- * JFFS2 definitions for use in user space only
- */
-
-#ifndef __JFFS2_USER_H__
-#define __JFFS2_USER_H__
-
-/* This file is blessed for inclusion by userspace */
-#include <linux/jffs2.h>
-#include <endian.h>
-#include <byteswap.h>
-
-#undef cpu_to_je16
-#undef cpu_to_je32
-#undef cpu_to_jemode
-#undef je16_to_cpu
-#undef je32_to_cpu
-#undef jemode_to_cpu
-
-extern int target_endian;
-
-#define t16(x) ({ uint16_t __b = (x); (target_endian==__BYTE_ORDER)?__b:bswap_16(__b); })
-#define t32(x) ({ uint32_t __b = (x); (target_endian==__BYTE_ORDER)?__b:bswap_32(__b); })
-
-#define cpu_to_je16(x) ((jint16_t){t16(x)})
-#define cpu_to_je32(x) ((jint32_t){t32(x)})
-#define cpu_to_jemode(x) ((jmode_t){t32(x)})
-
-#define je16_to_cpu(x) (t16((x).v16))
-#define je32_to_cpu(x) (t32((x).v32))
-#define jemode_to_cpu(x) (t32((x).m))
-
-#endif /* __JFFS2_USER_H__ */
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
git-alsa.patch
git-dvb.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-mtd-jffs2-userh.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
make-ext2_get_blocks-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

