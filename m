From: akpm@linux-foundation.org
Subject: - sis900-warning-fixes.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:23:12 -0800
Message-ID: <200703070423.l274NCvV019042@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47201 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431AbXCGEXN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:23:13 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l274NCq8002367
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 6 Mar 2007 20:23:12 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     sis900 warning fixes
has been removed from the -mm tree.  Its filename was
     sis900-warning-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sis900 warning fixes
From: Andrew Morton <akpm@linux-foundation.org>

drivers/net/sis900.c: In function 'sis900_reset_phy':
drivers/net/sis900.c:972: warning: 'status' may be used uninitialized in this function
drivers/net/sis900.c: In function 'sis900_check_mode':
drivers/net/sis900.c:1431: warning: 'status' may be used uninitialized in this function
drivers/net/sis900.c: In function 'sis900_timer':
drivers/net/sis900.c:1467: warning: 'status' may be used uninitialized in this function


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sis900.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/net/sis900.c~sis900-warning-fixes drivers/net/sis900.c
--- a/drivers/net/sis900.c~sis900-warning-fixes
+++ a/drivers/net/sis900.c
@@ -968,10 +968,10 @@ static void mdio_write(struct net_device
 
 static u16 sis900_reset_phy(struct net_device *net_dev, int phy_addr)
 {
-	int i = 0;
+	int i;
 	u16 status;
 
-	while (i++ < 2)
+	for (i = 0; i < 2; i++)
 		status = mdio_read(net_dev, phy_addr, MII_STATUS);
 
 	mdio_write( net_dev, phy_addr, MII_CONTROL, MII_CNTL_RESET );
@@ -1430,7 +1430,7 @@ static void sis900_auto_negotiate(struct
 	int i = 0;
 	u32 status;
 
-	while (i++ < 2)
+	for (i = 0; i < 2; i++)
 		status = mdio_read(net_dev, phy_addr, MII_STATUS);
 
 	if (!(status & MII_STAT_LINK)){
@@ -1466,9 +1466,9 @@ static void sis900_read_mode(struct net_
 	int phy_addr = sis_priv->cur_phy;
 	u32 status;
 	u16 autoadv, autorec;
-	int i = 0;
+	int i;
 
-	while (i++ < 2)
+	for (i = 0; i < 2; i++)
 		status = mdio_read(net_dev, phy_addr, MII_STATUS);
 
 	if (!(status & MII_STAT_LINK))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-md-accel-fixup.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
x86_64-irq-make-affinity-works-for-genapic_flat-mode.patch
i386-vdso_prelink-warning-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
