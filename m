From: akpm@osdl.org
Subject: - remove-drivers-block-paride-jumbo.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:45 -0800
Message-ID: <200612072316.kB7NGjwZ030868@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54165 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163979AbWLGXUE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:20:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     remove drivers/block/paride/jumbo
has been removed from the -mm tree.  Its filename was
     remove-drivers-block-paride-jumbo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove drivers/block/paride/jumbo
From: Adrian Bunk <bunk@stusta.de>

Let's remove this pre-historic paride building script.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/paride/jumbo |   70 -----------------------------------
 1 file changed, 70 deletions(-)

diff -puN drivers/block/paride/jumbo~remove-drivers-block-paride-jumbo /dev/null
--- a/drivers/block/paride/jumbo
+++ /dev/null
@@ -1,70 +0,0 @@
-#!/bin/sh
-#
-# This script can be used to build "jumbo" modules that contain the
-# base PARIDE support, one protocol module and one high-level driver.
-#
-echo -n "High level driver [pcd] : "
-read X
-HLD=${X:-pcd}
-#
-echo -n "Protocol module [bpck] : "
-read X
-PROTO=${X:-bpck}
-#
-echo -n "Use MODVERSIONS [y] ? "
-read X
-UMODV=${X:-y}
-#
-echo -n "For SMP kernel [n] ? "
-read X
-USMP=${X:-n}
-#
-echo -n "Support PARPORT [n] ? "
-read X
-UPARP=${X:-n}
-#
-echo
-#
-case $USMP in
-	y* | Y* ) FSMP="-DCONFIG_SMP"
-		  ;;
-	*)	  FSMP=""
-		  ;;
-esac
-#
-MODI="-include ../../../include/linux/modversions.h"
-#
-case $UMODV in
-	y* | Y* ) FMODV="-DMODVERSIONS $MODI"
-		  ;;
-	*)	  FMODV=""
-		  ;;
-esac
-#
-case $UPARP in
-	y* | Y* ) FPARP="-DCONFIG_PARPORT"
-		  ;;
-	*)	  FPARP=""
-		  ;;
-esac
-#
-TARG=$HLD-$PROTO.o
-FPROTO=-DCONFIG_PARIDE_`echo "$PROTO" | tr [a-z] [A-Z]`
-FK="-D__KERNEL__ -I ../../../include"
-FLCH=-D_LINUX_CONFIG_H
-#
-echo cc $FK $FSMP $FLCH $FPARP $FPROTO $FMODV -Wall -O2 -o Jb.o -c paride.c
-cc $FK $FSMP $FLCH $FPARP $FPROTO $FMODV -Wall -O2 -o Jb.o -c paride.c
-#
-echo cc $FK $FSMP $FMODV -Wall -O2 -o Jp.o -c $PROTO.c
-cc $FK $FSMP $FMODV -Wall -O2 -o Jp.o -c $PROTO.c
-#
-echo cc $FK $FSMP $FMODV -DMODULE -DPARIDE_JUMBO -Wall -O2 -o Jd.o -c $HLD.c
-cc $FK $FSMP $FMODV -DMODULE -DPARIDE_JUMBO -Wall -O2 -o Jd.o -c $HLD.c
-#
-echo ld -r -o $TARG Jp.o Jb.o Jd.o
-ld -r -o $TARG Jp.o Jb.o Jd.o
-#
-#
-rm Jp.o Jb.o Jd.o
-#
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
generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch
fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
make-drivers-md-dm-snapcksnapd-static.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

