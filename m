From: akpm@linux-foundation.org
Subject: + scsi-qlogicptic-section-fixes.patch added to -mm tree
Date: Tue, 05 Feb 2008 01:48:07 -0800
Message-ID: <200802050947.m159lmDT014677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33317 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754015AbYBEJsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 04:48:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     scsi/qlogicpti.c section fixes
has been added to the -mm tree.  Its filename is
     scsi-qlogicptic-section-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
m68knommu-remove-duplicate-exports.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
sparc64-kernel-pci_sun4vc-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
calibrate_delay-must-be-__cpuinit.patch
idle_regs-must-be-__cpuinit.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
drivers-video-pm3fbc-section-fix.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
