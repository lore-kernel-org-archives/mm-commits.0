From: akpm@linux-foundation.org
Subject: - Fabric7-VIOC-driver-fixes.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:52:32 -0800
Message-ID: <200702282352.l1SNqWdd031003@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48244 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932605AbXB1Xwf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:52:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, driver-support@fabric7.com, schidambaram@fabric7.com, mm-commits@vger.kernel.org


The patch titled
     Fabric7 VIOC driver fixes
has been removed from the -mm tree.  Its filename was
     Fabric7-VIOC-driver-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fabric7 VIOC driver fixes
From: Andrew Morton <akpm@linux-foundation.org>

drivers/net/vioc/vioc_driver.c: In function `vioc_free_resources':
drivers/net/vioc/vioc_driver.c:364: warning: implicit declaration of function `vfree'
drivers/net/vioc/vioc_driver.c: In function `vioc_alloc_resources':
drivers/net/vioc/vioc_driver.c:547: warning: implicit declaration of function `vmalloc'
drivers/net/vioc/vioc_driver.c:547: warning: assignment makes pointer from integer without a cast
drivers/net/vioc/vioc_driver.c:572: warning: cast to pointer from integer of different size

and

drivers/net/vioc/vioc_irq.c:50:22: asm/apic.h: No such file or directory

and

drivers/net/vioc/vioc_transmit.c:64:21: asm/msr.h: No such file or directory

and

drivers/net/vioc/vioc_transmit.c: In function `vnic_alloc_tx_resources':
drivers/net/vioc/vioc_transmit.c:917: warning: implicit declaration of function `vmalloc'
drivers/net/vioc/vioc_transmit.c:917: warning: assignment makes pointer from integer without a cast
drivers/net/vioc/vioc_transmit.c: In function `vnic_free_tx_resources':
drivers/net/vioc/vioc_transmit.c:951: warning: implicit declaration of function `vfree'


Cc: Sriram Chidambaram <schidambaram@fabric7.com>
Acked-by: Fabric7 Driver-Support <driver-support@fabric7.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/vioc/vioc_driver.c   |    1 +
 drivers/net/vioc/vioc_irq.c      |    1 -
 drivers/net/vioc/vioc_transmit.c |    2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/vioc/vioc_driver.c~Fabric7-VIOC-driver-fixes drivers/net/vioc/vioc_driver.c
--- a/drivers/net/vioc/vioc_driver.c~Fabric7-VIOC-driver-fixes
+++ a/drivers/net/vioc/vioc_driver.c
@@ -44,6 +44,7 @@
 #include <linux/sched.h>
 #include <linux/notifier.h>
 #include <linux/errno.h>
+#include <linux/vmalloc.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
diff -puN drivers/net/vioc/vioc_irq.c~Fabric7-VIOC-driver-fixes drivers/net/vioc/vioc_irq.c
--- a/drivers/net/vioc/vioc_irq.c~Fabric7-VIOC-driver-fixes
+++ a/drivers/net/vioc/vioc_irq.c
@@ -47,7 +47,6 @@
 #include <asm/io.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
-#include <asm/apic.h>
 
 #include "f7/vioc_hw_registers.h"
 #include "f7/vnic_defs.h"
diff -puN drivers/net/vioc/vioc_transmit.c~Fabric7-VIOC-driver-fixes drivers/net/vioc/vioc_transmit.c
--- a/drivers/net/vioc/vioc_transmit.c~Fabric7-VIOC-driver-fixes
+++ a/drivers/net/vioc/vioc_transmit.c
@@ -50,6 +50,7 @@
 #include <linux/if_vlan.h>
 #include <linux/timex.h>
 #include <linux/ethtool.h>
+#include <linux/vmalloc.h>
 
 #include <net/dst.h>
 #include <net/arp.h>
@@ -61,7 +62,6 @@
 #include <asm/checksum.h>
 #include <asm/io.h>
 #include <asm/byteorder.h>
-#include <asm/msr.h>
 
 #include "f7/vnic_defs.h"
 #include "f7/vioc_pkts_defs.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-leds-fixup.patch
git-md-accel-vs-md.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
ext-ea-block-reference-count-racing-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
