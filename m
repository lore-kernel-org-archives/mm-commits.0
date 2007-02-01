From: akpm@osdl.org
Subject: + sis-warning-fixes.patch added to -mm tree
Date: Thu, 01 Feb 2007 14:00:03 -0800
Message-ID: <200702012200.l11M04fT024147@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42644 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbXBAWAY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 17:00:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org


The patch titled
     SiS warning fixes
has been added to the -mm tree.  Its filename is
     sis-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SiS warning fixes
From: Alan <alan@lxorguk.ukuu.org.uk>

Somehow the sis_info133 external definition ended up in libata.h and that
was included by both drivers.  However libata.h contains libata-* specific
internals and clashing defines like DRV_NAME so this makes a mess.  Move
the extern into the C file and remove the warnings

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/libata.h   |    2 --
 drivers/ata/pata_sis.c |    1 -
 drivers/ata/sata_sis.c |    4 +++-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/ata/libata.h~sis-warning-fixes drivers/ata/libata.h
--- a/drivers/ata/libata.h~sis-warning-fixes
+++ a/drivers/ata/libata.h
@@ -150,7 +150,5 @@ extern void ata_qc_schedule_eh(struct at
 /* libata-sff.c */
 extern u8 ata_irq_on(struct ata_port *ap);
 
-/* pata_sis.c */
-extern struct ata_port_info sis_info133;
 
 #endif /* __LIBATA_H__ */
diff -puN drivers/ata/pata_sis.c~sis-warning-fixes drivers/ata/pata_sis.c
--- a/drivers/ata/pata_sis.c~sis-warning-fixes
+++ a/drivers/ata/pata_sis.c
@@ -32,7 +32,6 @@
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 #include <linux/ata.h>
-#include "libata.h"
 
 #undef DRV_NAME		/* already defined in libata.h, for libata-core */
 #define DRV_NAME	"pata_sis"
diff -puN drivers/ata/sata_sis.c~sis-warning-fixes drivers/ata/sata_sis.c
--- a/drivers/ata/sata_sis.c~sis-warning-fixes
+++ a/drivers/ata/sata_sis.c
@@ -40,12 +40,14 @@
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
-#include "libata.h"
 
 #undef DRV_NAME		/* already defined in libata.h, for libata-core */
 #define DRV_NAME	"sata_sis"
 #define DRV_VERSION	"0.7"
 
+/* pata_sis.c */
+extern struct ata_port_info sis_info133;
+
 enum {
 	sis_180			= 0,
 	SIS_SCR_PCI_BAR		= 5,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

via-quirk-fix-update.patch
git-libata-all.patch
pata_atiixp-propogate-cable-detection-hack-from.patch
pata_via-correct-missing-comments.patch
sis-warning-fixes.patch
git-mtd.patch
ubi-int-versus-size_t-printk-warnings.patch
atl1_main-pci_module_int-returns-to-haunt-us.patch
z85230-spinlock-logic.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
geode-support-classic-mediagxm.patch
cyrix-fails-to-detect-mediagx.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-tty_wakeup-cleanup.patch
proc-remove-useless-and-buggy-nlink-settings.patch
tty-improve-encode_baud_rate-logic.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
sched-avoid-div-in-rebalance_tick.patch
pm3fb-kill-pci_find_device-usage.patch
