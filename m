Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CEFCC636CA
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 21:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BE4D60C41
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 21:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbhGTU3x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 16:29:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235119AbhGTUWd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 16:22:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A3A561178;
        Tue, 20 Jul 2021 21:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626814991;
        bh=YFWzELtQpUMASfxpeQh+GQHU/yCzHOKjIuy75ceCGec=;
        h=Date:From:To:Subject:From;
        b=SJ7Eanu5XVVPHfdAveyOimOw4Oe259V2Aq0H/FxxTx4w5EoFi7cv2xs40ywnfJJpH
         n61QnX+o5orpd7T7zUTpO8i57knfc8YveklEKF4J5J3ooYlNdOtYE68BGvd4A57aJc
         9p8eMiIW5bPFoHDu2rq0clInojSgiAhbQJKl9yek=
Date:   Tue, 20 Jul 2021 14:03:10 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, masahiroy@kernel.org,
        hch@infradead.org, arnd@arndb.de, adobriyan@gmail.com
Subject:  [failures] decouple-build-from-userspace-headers.patch
 removed from -mm tree
Message-ID: <20210720210310.A4pbl%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kbuild: decouple build from userspace headers
has been removed from the -mm tree.  Its filename was
     decouple-build-from-userspace-headers.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: kbuild: decouple build from userspace headers

First, userspace headers can be under incompatible license.

Second, kernel doesn't require userspace to operate and should not
require anything from userspace to be built other than compiler.
We would use -ffreestanding too if not builtin function shenanigans.

To decouple:

* ship minimal stdarg.h as <linux/stdarg.h>,
	1 type, 4 macros

GPL 2 version of <stdarg.h> can be extracted from
http://archive.debian.org/debian/pool/main/g/gcc-4.2/gcc-4.2_4.2.4.orig.tar.gz

* delete "-isystem" from command line arguments,
	this is what enables header leakage

* fixup/delete include directives where necessary.

[adobriyan@gmail.com: allow to find SIMD headers where necessary]
  Link: https://lkml.kernel.org/r/YPClYgoJOTUn4V0w@localhost.localdomain
Link: https://lkml.kernel.org/r/YO8ioz4sHwcUAkdt@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile                                                                 |    2 -
 arch/arm/kernel/process.c                                                |    2 -
 arch/arm/mach-bcm/bcm_kona_smc.c                                         |    2 -
 arch/arm64/kernel/process.c                                              |    3 --
 arch/arm64/lib/Makefile                                                  |    2 -
 arch/openrisc/kernel/process.c                                           |    2 -
 arch/parisc/kernel/firmware.c                                            |    2 -
 arch/parisc/kernel/process.c                                             |    3 --
 arch/powerpc/kernel/prom.c                                               |    1 
 arch/powerpc/kernel/prom_init.c                                          |    2 -
 arch/powerpc/kernel/rtas.c                                               |    2 -
 arch/powerpc/kernel/udbg.c                                               |    2 -
 arch/powerpc/lib/Makefile                                                |    2 -
 arch/s390/boot/pgm_check_info.c                                          |    2 -
 arch/sparc/kernel/process_32.c                                           |    3 --
 arch/sparc/kernel/process_64.c                                           |    3 --
 arch/um/include/shared/irq_user.h                                        |    1 
 arch/um/include/shared/os.h                                              |    1 
 arch/um/os-Linux/signal.c                                                |    2 -
 arch/um/os-Linux/util.c                                                  |    1 
 arch/x86/boot/boot.h                                                     |    2 -
 crypto/aegis128-neon-inner.c                                             |    2 -
 drivers/block/xen-blkback/xenbus.c                                       |    1 
 drivers/firmware/efi/libstub/efi-stub-helper.c                           |    2 -
 drivers/firmware/efi/libstub/vsprintf.c                                  |    2 -
 drivers/gpu/drm/amd/display/dc/dc_helper.c                               |    2 -
 drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h                          |    1 
 drivers/gpu/drm/drm_print.c                                              |    2 -
 drivers/gpu/drm/msm/disp/msm_disp_snapshot.h                             |    1 
 drivers/isdn/capi/capiutil.c                                             |    2 -
 drivers/macintosh/macio-adb.c                                            |    1 
 drivers/macintosh/via-cuda.c                                             |    2 -
 drivers/macintosh/via-macii.c                                            |    2 -
 drivers/macintosh/via-pmu.c                                              |    2 -
 drivers/net/wireless/intersil/orinoco/hermes.c                           |    1 
 drivers/net/wwan/iosm/iosm_ipc_imem.h                                    |    1 
 drivers/pinctrl/aspeed/pinmux-aspeed.h                                   |    1 
 drivers/scsi/elx/efct/efct_driver.h                                      |    1 
 drivers/staging/media/atomisp/pci/hive_isp_css_common/host/isp_local.h   |    2 -
 drivers/staging/media/atomisp/pci/hive_isp_css_include/print_support.h   |    2 -
 drivers/staging/media/atomisp/pci/ia_css_env.h                           |    2 -
 drivers/staging/media/atomisp/pci/runtime/debug/interface/ia_css_debug.h |    2 -
 drivers/staging/media/atomisp/pci/sh_css_internal.h                      |    2 -
 drivers/xen/xen-scsiback.c                                               |    2 -
 fs/befs/debug.c                                                          |    2 -
 fs/reiserfs/prints.c                                                     |    2 -
 fs/ufs/super.c                                                           |    2 -
 include/acpi/platform/acgcc.h                                            |    2 -
 include/linux/filter.h                                                   |    2 -
 include/linux/kernel.h                                                   |    2 -
 include/linux/mISDNif.h                                                  |    1 
 include/linux/printk.h                                                   |    2 -
 include/linux/stdarg.h                                                   |   11 ++++++++++
 include/linux/string.h                                                   |    2 -
 kernel/debug/kdb/kdb_support.c                                           |    1 
 lib/debug_info.c                                                         |    3 --
 lib/kasprintf.c                                                          |    2 -
 lib/kunit/string-stream.h                                                |    2 -
 lib/raid6/Makefile                                                       |    4 +--
 lib/vsprintf.c                                                           |    2 -
 mm/kfence/report.c                                                       |    2 -
 net/batman-adv/log.c                                                     |    2 -
 sound/aoa/codecs/onyx.h                                                  |    1 
 sound/aoa/codecs/tas.c                                                   |    1 
 sound/core/info.c                                                        |    1 
 65 files changed, 48 insertions(+), 81 deletions(-)

--- a/arch/arm64/kernel/process.c~decouple-build-from-userspace-headers
+++ a/arch/arm64/kernel/process.c
@@ -6,9 +6,6 @@
  * Copyright (C) 1996-2000 Russell King - Converted to ARM.
  * Copyright (C) 2012 ARM Ltd.
  */
-
-#include <stdarg.h>
-
 #include <linux/compat.h>
 #include <linux/efi.h>
 #include <linux/elf.h>
--- a/arch/arm/kernel/process.c~decouple-build-from-userspace-headers
+++ a/arch/arm/kernel/process.c
@@ -5,8 +5,6 @@
  *  Copyright (C) 1996-2000 Russell King - Converted to ARM.
  *  Original Copyright (C) 1995  Linus Torvalds
  */
-#include <stdarg.h>
-
 #include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
--- a/arch/arm/mach-bcm/bcm_kona_smc.c~decouple-build-from-userspace-headers
+++ a/arch/arm/mach-bcm/bcm_kona_smc.c
@@ -10,8 +10,6 @@
  * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
-
-#include <stdarg.h>
 #include <linux/smp.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
--- a/arch/openrisc/kernel/process.c~decouple-build-from-userspace-headers
+++ a/arch/openrisc/kernel/process.c
@@ -14,8 +14,6 @@
  */
 
 #define __KERNEL_SYSCALLS__
-#include <stdarg.h>
-
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
--- a/arch/parisc/kernel/firmware.c~decouple-build-from-userspace-headers
+++ a/arch/parisc/kernel/firmware.c
@@ -51,7 +51,7 @@
  *					prumpf	991016	
  */
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 
 #include <linux/delay.h>
 #include <linux/init.h>
--- a/arch/parisc/kernel/process.c~decouple-build-from-userspace-headers
+++ a/arch/parisc/kernel/process.c
@@ -17,9 +17,6 @@
  *    Copyright (C) 2001-2014 Helge Deller <deller@gmx.de>
  *    Copyright (C) 2002 Randolph Chung <tausq with parisc-linux.org>
  */
-
-#include <stdarg.h>
-
 #include <linux/elf.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
--- a/arch/powerpc/kernel/prom.c~decouple-build-from-userspace-headers
+++ a/arch/powerpc/kernel/prom.c
@@ -11,7 +11,6 @@
 
 #undef DEBUG
 
-#include <stdarg.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/init.h>
--- a/arch/powerpc/kernel/prom_init.c~decouple-build-from-userspace-headers
+++ a/arch/powerpc/kernel/prom_init.c
@@ -14,7 +14,7 @@
 /* we cannot use FORTIFY as it brings in new symbols */
 #define __NO_FORTIFY
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/init.h>
--- a/arch/powerpc/kernel/rtas.c~decouple-build-from-userspace-headers
+++ a/arch/powerpc/kernel/rtas.c
@@ -7,7 +7,7 @@
  * Copyright (C) 2001 IBM.
  */
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
--- a/arch/powerpc/kernel/udbg.c~decouple-build-from-userspace-headers
+++ a/arch/powerpc/kernel/udbg.c
@@ -5,7 +5,7 @@
  * c 2001 PPC 64 Team, IBM Corp
  */
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/console.h>
--- a/arch/s390/boot/pgm_check_info.c~decouple-build-from-userspace-headers
+++ a/arch/s390/boot/pgm_check_info.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/kernel.h>
+#include <linux/stdarg.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <asm/stacktrace.h>
@@ -8,7 +9,6 @@
 #include <asm/setup.h>
 #include <asm/sclp.h>
 #include <asm/uv.h>
-#include <stdarg.h>
 #include "boot.h"
 
 const char hex_asc[] = "0123456789abcdef";
--- a/arch/sparc/kernel/process_32.c~decouple-build-from-userspace-headers
+++ a/arch/sparc/kernel/process_32.c
@@ -8,9 +8,6 @@
 /*
  * This file handles the architecture-dependent parts of process handling..
  */
-
-#include <stdarg.h>
-
 #include <linux/elfcore.h>
 #include <linux/errno.h>
 #include <linux/module.h>
--- a/arch/sparc/kernel/process_64.c~decouple-build-from-userspace-headers
+++ a/arch/sparc/kernel/process_64.c
@@ -9,9 +9,6 @@
 /*
  * This file handles the architecture-dependent parts of process handling..
  */
-
-#include <stdarg.h>
-
 #include <linux/errno.h>
 #include <linux/export.h>
 #include <linux/sched.h>
--- a/arch/um/include/shared/irq_user.h~decouple-build-from-userspace-headers
+++ a/arch/um/include/shared/irq_user.h
@@ -7,7 +7,6 @@
 #define __IRQ_USER_H__
 
 #include <sysdep/ptrace.h>
-#include <stdbool.h>
 
 enum um_irq_type {
 	IRQ_READ,
--- a/arch/um/include/shared/os.h~decouple-build-from-userspace-headers
+++ a/arch/um/include/shared/os.h
@@ -8,7 +8,6 @@
 #ifndef __OS_H__
 #define __OS_H__
 
-#include <stdarg.h>
 #include <irq_user.h>
 #include <longjmp.h>
 #include <mm_id.h>
--- a/arch/um/os-Linux/signal.c~decouple-build-from-userspace-headers
+++ a/arch/um/os-Linux/signal.c
@@ -67,7 +67,7 @@ int signals_enabled;
 #ifdef UML_CONFIG_UML_TIME_TRAVEL_SUPPORT
 static int signals_blocked;
 #else
-#define signals_blocked false
+#define signals_blocked 0
 #endif
 static unsigned int signals_pending;
 static unsigned int signals_active = 0;
--- a/arch/um/os-Linux/util.c~decouple-build-from-userspace-headers
+++ a/arch/um/os-Linux/util.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  */
 
+#include <stdarg.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
--- a/arch/x86/boot/boot.h~decouple-build-from-userspace-headers
+++ a/arch/x86/boot/boot.h
@@ -18,7 +18,7 @@
 
 #ifndef __ASSEMBLY__
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 #include <linux/types.h>
 #include <linux/edd.h>
 #include <asm/setup.h>
--- a/crypto/aegis128-neon-inner.c~decouple-build-from-userspace-headers
+++ a/crypto/aegis128-neon-inner.c
@@ -15,8 +15,6 @@
 
 #define AEGIS_BLOCK_SIZE	16
 
-#include <stddef.h>
-
 extern int aegis128_have_aes_insn;
 
 void *memcpy(void *dest, const void *src, size_t n);
--- a/drivers/block/xen-blkback/xenbus.c~decouple-build-from-userspace-headers
+++ a/drivers/block/xen-blkback/xenbus.c
@@ -8,7 +8,6 @@
 
 #define pr_fmt(fmt) "xen-blkback: " fmt
 
-#include <stdarg.h>
 #include <linux/module.h>
 #include <linux/kthread.h>
 #include <xen/events.h>
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c~decouple-build-from-userspace-headers
+++ a/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -7,7 +7,7 @@
  * Copyright 2011 Intel Corporation; author Matt Fleming
  */
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 
 #include <linux/ctype.h>
 #include <linux/efi.h>
--- a/drivers/firmware/efi/libstub/vsprintf.c~decouple-build-from-userspace-headers
+++ a/drivers/firmware/efi/libstub/vsprintf.c
@@ -10,7 +10,7 @@
  * Oh, it's a waste of space, but oh-so-yummy for debugging.
  */
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 
 #include <linux/compiler.h>
 #include <linux/ctype.h>
--- a/drivers/gpu/drm/amd/display/dc/dc_helper.c~decouple-build-from-userspace-headers
+++ a/drivers/gpu/drm/amd/display/dc/dc_helper.c
@@ -28,9 +28,9 @@
  */
 
 #include <linux/delay.h>
+#include <linux/stdarg.h>
 
 #include "dm_services.h"
-#include <stdarg.h>
 
 #include "dc.h"
 #include "dc_dmub_srv.h"
--- a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h~decouple-build-from-userspace-headers
+++ a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
@@ -39,7 +39,6 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/delay.h>
-#include <stdarg.h>
 
 #include "atomfirmware.h"
 
--- a/drivers/gpu/drm/drm_print.c~decouple-build-from-userspace-headers
+++ a/drivers/gpu/drm/drm_print.c
@@ -25,7 +25,7 @@
 
 #define DEBUG /* for pr_debug() */
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 
 #include <linux/io.h>
 #include <linux/moduleparam.h>
--- a/drivers/gpu/drm/msm/disp/msm_disp_snapshot.h~decouple-build-from-userspace-headers
+++ a/drivers/gpu/drm/msm/disp/msm_disp_snapshot.h
@@ -25,7 +25,6 @@
 #include <linux/pm_runtime.h>
 #include <linux/kthread.h>
 #include <linux/devcoredump.h>
-#include <stdarg.h>
 #include "msm_kms.h"
 
 #define MSM_DISP_SNAPSHOT_MAX_BLKS		10
--- a/drivers/isdn/capi/capiutil.c~decouple-build-from-userspace-headers
+++ a/drivers/isdn/capi/capiutil.c
@@ -379,7 +379,7 @@ static char *pnames[] =
 	/*2f */ "Useruserdata"
 };
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 
 /*-------------------------------------------------------*/
 static _cdebbuf *bufprint(_cdebbuf *cdb, char *fmt, ...)
--- a/drivers/macintosh/macio-adb.c~decouple-build-from-userspace-headers
+++ a/drivers/macintosh/macio-adb.c
@@ -2,7 +2,6 @@
 /*
  * Driver for the ADB controller in the Mac I/O (Hydra) chip.
  */
-#include <stdarg.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
--- a/drivers/macintosh/via-cuda.c~decouple-build-from-userspace-headers
+++ a/drivers/macintosh/via-cuda.c
@@ -9,7 +9,7 @@
  *
  * Copyright (C) 1996 Paul Mackerras.
  */
-#include <stdarg.h>
+#include <linux/stdarg.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
--- a/drivers/macintosh/via-macii.c~decouple-build-from-userspace-headers
+++ a/drivers/macintosh/via-macii.c
@@ -23,8 +23,6 @@
  * Apple's "ADB Analyzer" bus sniffer is invaluable:
  *   ftp://ftp.apple.com/developer/Tool_Chest/Devices_-_Hardware/Apple_Desktop_Bus/
  */
-
-#include <stdarg.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
--- a/drivers/macintosh/via-pmu.c~decouple-build-from-userspace-headers
+++ a/drivers/macintosh/via-pmu.c
@@ -18,7 +18,7 @@
  *    a sleep or a freq. switch
  *
  */
-#include <stdarg.h>
+#include <linux/stdarg.h>
 #include <linux/mutex.h>
 #include <linux/types.h>
 #include <linux/errno.h>
--- a/drivers/net/wireless/intersil/orinoco/hermes.c~decouple-build-from-userspace-headers
+++ a/drivers/net/wireless/intersil/orinoco/hermes.c
@@ -79,7 +79,6 @@
 
 #undef HERMES_DEBUG
 #ifdef HERMES_DEBUG
-#include <stdarg.h>
 
 #define DEBUG(lvl, stuff...) if ((lvl) <= HERMES_DEBUG) DMSG(stuff)
 
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h~decouple-build-from-userspace-headers
+++ a/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -7,7 +7,6 @@
 #define IOSM_IPC_IMEM_H
 
 #include <linux/skbuff.h>
-#include <stdbool.h>
 
 #include "iosm_ipc_mmio.h"
 #include "iosm_ipc_pcie.h"
--- a/drivers/pinctrl/aspeed/pinmux-aspeed.h~decouple-build-from-userspace-headers
+++ a/drivers/pinctrl/aspeed/pinmux-aspeed.h
@@ -5,7 +5,6 @@
 #define ASPEED_PINMUX_H
 
 #include <linux/regmap.h>
-#include <stdbool.h>
 
 /*
  * The ASPEED SoCs provide typically more than 200 pins for GPIO and other
--- a/drivers/scsi/elx/efct/efct_driver.h~decouple-build-from-userspace-headers
+++ a/drivers/scsi/elx/efct/efct_driver.h
@@ -10,7 +10,6 @@
 /***************************************************************************
  * OS specific includes
  */
-#include <stdarg.h>
 #include <linux/module.h>
 #include <linux/debugfs.h>
 #include <linux/firmware.h>
--- a/drivers/staging/media/atomisp/pci/hive_isp_css_common/host/isp_local.h~decouple-build-from-userspace-headers
+++ a/drivers/staging/media/atomisp/pci/hive_isp_css_common/host/isp_local.h
@@ -16,8 +16,6 @@
 #ifndef __ISP_LOCAL_H_INCLUDED__
 #define __ISP_LOCAL_H_INCLUDED__
 
-#include <stdbool.h>
-
 #include "isp_global.h"
 
 #include <isp2400_support.h>
--- a/drivers/staging/media/atomisp/pci/hive_isp_css_include/print_support.h~decouple-build-from-userspace-headers
+++ a/drivers/staging/media/atomisp/pci/hive_isp_css_include/print_support.h
@@ -16,7 +16,7 @@
 #ifndef __PRINT_SUPPORT_H_INCLUDED__
 #define __PRINT_SUPPORT_H_INCLUDED__
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 
 extern int (*sh_css_printf)(const char *fmt, va_list args);
 /* depends on host supplied print function in ia_css_init() */
--- a/drivers/staging/media/atomisp/pci/ia_css_env.h~decouple-build-from-userspace-headers
+++ a/drivers/staging/media/atomisp/pci/ia_css_env.h
@@ -17,7 +17,7 @@
 #define __IA_CSS_ENV_H
 
 #include <type_support.h>
-#include <stdarg.h> /* va_list */
+#include <linux/stdarg.h> /* va_list */
 #include "ia_css_types.h"
 #include "ia_css_acc_types.h"
 
--- a/drivers/staging/media/atomisp/pci/runtime/debug/interface/ia_css_debug.h~decouple-build-from-userspace-headers
+++ a/drivers/staging/media/atomisp/pci/runtime/debug/interface/ia_css_debug.h
@@ -19,7 +19,7 @@
 /*! \file */
 
 #include <type_support.h>
-#include <stdarg.h>
+#include <linux/stdarg.h>
 #include "ia_css_types.h"
 #include "ia_css_binary.h"
 #include "ia_css_frame_public.h"
--- a/drivers/staging/media/atomisp/pci/sh_css_internal.h~decouple-build-from-userspace-headers
+++ a/drivers/staging/media/atomisp/pci/sh_css_internal.h
@@ -20,7 +20,7 @@
 #include <math_support.h>
 #include <type_support.h>
 #include <platform_support.h>
-#include <stdarg.h>
+#include <linux/stdarg.h>
 
 #if !defined(ISP2401)
 #include "input_formatter.h"
--- a/drivers/xen/xen-scsiback.c~decouple-build-from-userspace-headers
+++ a/drivers/xen/xen-scsiback.c
@@ -33,8 +33,6 @@
 
 #define pr_fmt(fmt) "xen-pvscsi: " fmt
 
-#include <stdarg.h>
-
 #include <linux/module.h>
 #include <linux/utsname.h>
 #include <linux/interrupt.h>
--- a/fs/befs/debug.c~decouple-build-from-userspace-headers
+++ a/fs/befs/debug.c
@@ -14,7 +14,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #ifdef __KERNEL__
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 #include <linux/string.h>
 #include <linux/spinlock.h>
 #include <linux/kernel.h>
--- a/fs/reiserfs/prints.c~decouple-build-from-userspace-headers
+++ a/fs/reiserfs/prints.c
@@ -8,7 +8,7 @@
 #include <linux/string.h>
 #include <linux/buffer_head.h>
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 
 static char error_buf[1024];
 static char fmt_buf[1024];
--- a/fs/ufs/super.c~decouple-build-from-userspace-headers
+++ a/fs/ufs/super.c
@@ -70,7 +70,7 @@
 #include <linux/module.h>
 #include <linux/bitops.h>
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 
 #include <linux/uaccess.h>
 
--- a/include/acpi/platform/acgcc.h~decouple-build-from-userspace-headers
+++ a/include/acpi/platform/acgcc.h
@@ -22,7 +22,7 @@ typedef __builtin_va_list va_list;
 #define va_arg(v, l)            __builtin_va_arg(v, l)
 #define va_copy(d, s)           __builtin_va_copy(d, s)
 #else
-#include <stdarg.h>
+#include <linux/stdarg.h>
 #endif
 #endif
 
--- a/include/linux/filter.h~decouple-build-from-userspace-headers
+++ a/include/linux/filter.h
@@ -5,8 +5,6 @@
 #ifndef __LINUX_FILTER_H__
 #define __LINUX_FILTER_H__
 
-#include <stdarg.h>
-
 #include <linux/atomic.h>
 #include <linux/refcount.h>
 #include <linux/compat.h>
--- a/include/linux/kernel.h~decouple-build-from-userspace-headers
+++ a/include/linux/kernel.h
@@ -2,7 +2,7 @@
 #ifndef _LINUX_KERNEL_H
 #define _LINUX_KERNEL_H
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 #include <linux/align.h>
 #include <linux/limits.h>
 #include <linux/linkage.h>
--- a/include/linux/mISDNif.h~decouple-build-from-userspace-headers
+++ a/include/linux/mISDNif.h
@@ -18,7 +18,6 @@
 #ifndef mISDNIF_H
 #define mISDNIF_H
 
-#include <stdarg.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/socket.h>
--- a/include/linux/printk.h~decouple-build-from-userspace-headers
+++ a/include/linux/printk.h
@@ -2,7 +2,7 @@
 #ifndef __KERNEL_PRINTK__
 #define __KERNEL_PRINTK__
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 #include <linux/init.h>
 #include <linux/kern_levels.h>
 #include <linux/linkage.h>
--- /dev/null
+++ a/include/linux/stdarg.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#ifndef _LINUX_STDARG_H
+#define _LINUX_STDARG_H
+
+typedef __builtin_va_list va_list;
+#define va_start(v, l)	__builtin_va_start(v, l)
+#define va_end(v)	__builtin_va_end(v)
+#define va_arg(v, T)	__builtin_va_arg(v, T)
+#define va_copy(d, s)	__builtin_va_copy(d, s)
+
+#endif
--- a/include/linux/string.h~decouple-build-from-userspace-headers
+++ a/include/linux/string.h
@@ -6,7 +6,7 @@
 #include <linux/types.h>	/* for size_t */
 #include <linux/stddef.h>	/* for NULL */
 #include <linux/errno.h>	/* for E2BIG */
-#include <stdarg.h>
+#include <linux/stdarg.h>
 #include <uapi/linux/string.h>
 
 extern char *strndup_user(const char __user *, long);
--- a/kernel/debug/kdb/kdb_support.c~decouple-build-from-userspace-headers
+++ a/kernel/debug/kdb/kdb_support.c
@@ -10,7 +10,6 @@
  * 03/02/13    added new 2.5 kallsyms <xavier.bru@bull.net>
  */
 
-#include <stdarg.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
--- a/lib/debug_info.c~decouple-build-from-userspace-headers
+++ a/lib/debug_info.c
@@ -5,8 +5,6 @@
  * CONFIG_DEBUG_INFO_REDUCED. Please do not add actual code. However,
  * adding appropriate #includes is fine.
  */
-#include <stdarg.h>
-
 #include <linux/cred.h>
 #include <linux/crypto.h>
 #include <linux/dcache.h>
@@ -22,6 +20,7 @@
 #include <linux/net.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/stdarg.h>
 #include <linux/types.h>
 #include <net/addrconf.h>
 #include <net/sock.h>
--- a/lib/kasprintf.c~decouple-build-from-userspace-headers
+++ a/lib/kasprintf.c
@@ -5,7 +5,7 @@
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/types.h>
--- a/lib/kunit/string-stream.h~decouple-build-from-userspace-headers
+++ a/lib/kunit/string-stream.h
@@ -11,7 +11,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/types.h>
-#include <stdarg.h>
+#include <linux/stdarg.h>
 
 struct string_stream_fragment {
 	struct kunit *test;
--- a/lib/vsprintf.c~decouple-build-from-userspace-headers
+++ a/lib/vsprintf.c
@@ -17,7 +17,7 @@
  * - scnprintf and vscnprintf
  */
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 #include <linux/build_bug.h>
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
--- a/Makefile~decouple-build-from-userspace-headers
+++ a/Makefile
@@ -979,7 +979,7 @@ KBUILD_CFLAGS += -falign-functions=64
 endif
 
 # arch Makefile may override CC so keep this after arch Makefile is included
-NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
+NOSTDINC_FLAGS += -nostdinc
 
 # warn about C99 declaration after statement
 KBUILD_CFLAGS += -Wdeclaration-after-statement
--- a/mm/kfence/report.c~decouple-build-from-userspace-headers
+++ a/mm/kfence/report.c
@@ -5,7 +5,7 @@
  * Copyright (C) 2020, Google LLC.
  */
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 
 #include <linux/kernel.h>
 #include <linux/lockdep.h>
--- a/net/batman-adv/log.c~decouple-build-from-userspace-headers
+++ a/net/batman-adv/log.c
@@ -7,7 +7,7 @@
 #include "log.h"
 #include "main.h"
 
-#include <stdarg.h>
+#include <linux/stdarg.h>
 
 #include "trace.h"
 
--- a/sound/aoa/codecs/onyx.h~decouple-build-from-userspace-headers
+++ a/sound/aoa/codecs/onyx.h
@@ -6,7 +6,6 @@
  */
 #ifndef __SND_AOA_CODEC_ONYX_H
 #define __SND_AOA_CODEC_ONYX_H
-#include <stddef.h>
 #include <linux/i2c.h>
 #include <asm/pmac_low_i2c.h>
 #include <asm/prom.h>
--- a/sound/aoa/codecs/tas.c~decouple-build-from-userspace-headers
+++ a/sound/aoa/codecs/tas.c
@@ -58,7 +58,6 @@
  *    and up to the hardware designer to not wire
  *    them up in some weird unusable way.
  */
-#include <stddef.h>
 #include <linux/i2c.h>
 #include <asm/pmac_low_i2c.h>
 #include <asm/prom.h>
--- a/sound/core/info.c~decouple-build-from-userspace-headers
+++ a/sound/core/info.c
@@ -16,7 +16,6 @@
 #include <linux/utsname.h>
 #include <linux/proc_fs.h>
 #include <linux/mutex.h>
-#include <stdarg.h>
 
 int snd_info_check_reserved_words(const char *str)
 {
--- a/arch/arm64/lib/Makefile~decouple-build-from-userspace-headers
+++ a/arch/arm64/lib/Makefile
@@ -8,7 +8,7 @@ lib-y		:= clear_user.o delay.o copy_from
 ifeq ($(CONFIG_KERNEL_MODE_NEON), y)
 obj-$(CONFIG_XOR_BLOCKS)	+= xor-neon.o
 CFLAGS_REMOVE_xor-neon.o	+= -mgeneral-regs-only
-CFLAGS_xor-neon.o		+= -ffreestanding
+CFLAGS_xor-neon.o		+= -ffreestanding -isystem $(shell $(CC) -print-file-name=include)
 endif
 
 lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
--- a/arch/powerpc/lib/Makefile~decouple-build-from-userspace-headers
+++ a/arch/powerpc/lib/Makefile
@@ -64,6 +64,6 @@ obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
 obj-$(CONFIG_FTR_FIXUP_SELFTEST) += feature-fixups-test.o
 
 obj-$(CONFIG_ALTIVEC)	+= xor_vmx.o xor_vmx_glue.o
-CFLAGS_xor_vmx.o += -maltivec $(call cc-option,-mabi=altivec)
+CFLAGS_xor_vmx.o += -maltivec $(call cc-option,-mabi=altivec) -isystem $(shell $(CC) -print-file-name=include)
 
 obj-$(CONFIG_PPC64) += $(obj64-y)
--- a/lib/raid6/Makefile~decouple-build-from-userspace-headers
+++ a/lib/raid6/Makefile
@@ -13,7 +13,7 @@ raid6_pq-$(CONFIG_S390) += s390vx8.o rec
 hostprogs	+= mktables
 
 ifeq ($(CONFIG_ALTIVEC),y)
-altivec_flags := -maltivec $(call cc-option,-mabi=altivec)
+altivec_flags := -maltivec $(call cc-option,-mabi=altivec) -isystem $(shell $(CC) -print-file-name=include)
 
 ifdef CONFIG_CC_IS_CLANG
 # clang ppc port does not yet support -maltivec when -msoft-float is
@@ -33,7 +33,7 @@ endif
 # The GCC option -ffreestanding is required in order to compile code containing
 # ARM/NEON intrinsics in a non C99-compliant environment (such as the kernel)
 ifeq ($(CONFIG_KERNEL_MODE_NEON),y)
-NEON_FLAGS := -ffreestanding
+NEON_FLAGS := -ffreestanding -isystem $(shell $(CC) -print-file-name=include)
 ifeq ($(ARCH),arm)
 NEON_FLAGS += -march=armv7-a -mfloat-abi=softfp -mfpu=neon
 endif
_

Patches currently in -mm which might be from adobriyan@gmail.com are


