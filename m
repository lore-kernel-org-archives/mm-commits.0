From: akpm@linux-foundation.org
Subject: - scsi-qlogicptic-section-fixes.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:41 -0800
Message-ID: <200802232022.m1NKMfIJ013443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761829AbYBWU2q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     scsi/qlogicpti.c section fixes
has been removed from the -mm tree.  Its filename was
     scsi-qlogicptic-section-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi/qlogicpti.c section fixes
From: Adrian Bunk <bunk@kernel.org>

WARNING: drivers/scsi/qlogicpti.o(.devexit.text+0x8): Section mismatch in reference from the function qpti_sbus_remove() to the function .init.text:qpti_chain_del()
WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x56c): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_map_regs()
WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x580): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_register_irq()
WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x594): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_get_scsi_id()
WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x5b8): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_map_queues()
WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x780): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_chain_add()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qlogicpti.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/qlogicpti.c~scsi-qlogicptic-section-fixes drivers/scsi/qlogicpti.c
--- a/drivers/scsi/qlogicpti.c~scsi-qlogicptic-section-fixes
+++ a/drivers/scsi/qlogicpti.c
@@ -651,7 +651,7 @@ static int qlogicpti_verify_tmon(struct 
 
 static irqreturn_t qpti_intr(int irq, void *dev_id);
 
-static void __init qpti_chain_add(struct qlogicpti *qpti)
+static void __devinit qpti_chain_add(struct qlogicpti *qpti)
 {
 	spin_lock_irq(&qptichain_lock);
 	if (qptichain != NULL) {
@@ -667,7 +667,7 @@ static void __init qpti_chain_add(struct
 	spin_unlock_irq(&qptichain_lock);
 }
 
-static void __init qpti_chain_del(struct qlogicpti *qpti)
+static void __devexit qpti_chain_del(struct qlogicpti *qpti)
 {
 	spin_lock_irq(&qptichain_lock);
 	if (qptichain == qpti) {
@@ -682,7 +682,7 @@ static void __init qpti_chain_del(struct
 	spin_unlock_irq(&qptichain_lock);
 }
 
-static int __init qpti_map_regs(struct qlogicpti *qpti)
+static int __devinit qpti_map_regs(struct qlogicpti *qpti)
 {
 	struct sbus_dev *sdev = qpti->sdev;
 
@@ -705,7 +705,7 @@ static int __init qpti_map_regs(struct q
 	return 0;
 }
 
-static int __init qpti_register_irq(struct qlogicpti *qpti)
+static int __devinit qpti_register_irq(struct qlogicpti *qpti)
 {
 	struct sbus_dev *sdev = qpti->sdev;
 
@@ -730,7 +730,7 @@ fail:
 	return -1;
 }
 
-static void __init qpti_get_scsi_id(struct qlogicpti *qpti)
+static void __devinit qpti_get_scsi_id(struct qlogicpti *qpti)
 {
 	qpti->scsi_id = prom_getintdefault(qpti->prom_node,
 					   "initiator-id",
@@ -783,7 +783,7 @@ static void qpti_get_clock(struct qlogic
 /* The request and response queues must each be aligned
  * on a page boundary.
  */
-static int __init qpti_map_queues(struct qlogicpti *qpti)
+static int __devinit qpti_map_queues(struct qlogicpti *qpti)
 {
 	struct sbus_dev *sdev = qpti->sdev;
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
sparc-fix-build.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-net.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
git-scsi-rc-fixes.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
remove-ps2esdi.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-bcm43xx-removal.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
ieee80211-fix-broken-error-handling-in-ieee80211_sta_process_addba_request.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
make-udf_error-static.patch
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
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
kernel-cpusetc-make-3-functions-static.patch
make-ext4_xattr_list-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch
