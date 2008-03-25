From: akpm@linux-foundation.org
Subject: - make-b43_mac_enablesuspend-static.patch removed from -mm tree
Date: Mon, 24 Mar 2008 17:19:29 -0700
Message-ID: <200803250019.m2P0JTsx032689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753917AbYCYAUV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 20:20:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     make b43_mac_{enable,suspend}() static
has been removed from the -mm tree.  Its filename was
     make-b43_mac_enablesuspend-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make b43_mac_{enable,suspend}() static
From: Adrian Bunk <bunk@kernel.org>

b43_mac_{enable,suspend}() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43/main.c |    4 ++--
 drivers/net/wireless/b43/main.h |    3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/net/wireless/b43/main.c~make-b43_mac_enablesuspend-static drivers/net/wireless/b43/main.c
--- a/drivers/net/wireless/b43/main.c~make-b43_mac_enablesuspend-static
+++ a/drivers/net/wireless/b43/main.c
@@ -2045,7 +2045,7 @@ static void b43_gpio_cleanup(struct b43_
 }
 
 /* http://bcm-specs.sipsolutions.net/EnableMac */
-void b43_mac_enable(struct b43_wldev *dev)
+static void b43_mac_enable(struct b43_wldev *dev)
 {
 	dev->mac_suspended--;
 	B43_WARN_ON(dev->mac_suspended < 0);
@@ -2069,7 +2069,7 @@ void b43_mac_enable(struct b43_wldev *de
 }
 
 /* http://bcm-specs.sipsolutions.net/SuspendMAC */
-void b43_mac_suspend(struct b43_wldev *dev)
+static void b43_mac_suspend(struct b43_wldev *dev)
 {
 	int i;
 	u32 tmp;
diff -puN drivers/net/wireless/b43/main.h~make-b43_mac_enablesuspend-static drivers/net/wireless/b43/main.h
--- a/drivers/net/wireless/b43/main.h~make-b43_mac_enablesuspend-static
+++ a/drivers/net/wireless/b43/main.h
@@ -102,9 +102,6 @@ void b43_dummy_transmission(struct b43_w
 
 void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags);
 
-void b43_mac_suspend(struct b43_wldev *dev);
-void b43_mac_enable(struct b43_wldev *dev);
-
 void b43_controller_restart(struct b43_wldev *dev, const char *reason);
 
 #define B43_PS_ENABLED	(1 << 0)	/* Force enable hardware power saving */
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-gfs2-nmw.patch
git-dlm.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-udf.patch
git-net.patch
git-nfsd.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-selinux.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
git-watchdog.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch

