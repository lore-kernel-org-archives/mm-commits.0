From: akpm@linux-foundation.org
Subject: - atl1_main-pci_module_int-returns-to-haunt-us.patch removed from -mm tree
Date: Fri, 02 Feb 2007 13:38:19 -0800
Message-ID: <200702022138.l12LcJJZ018599@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41599 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946122AbXBBVi2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 16:38:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     atl1_main: pci_module_int returns to haunt us
has been removed from the -mm tree.  Its filename was
     atl1_main-pci_module_int-returns-to-haunt-us.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atl1_main: pci_module_int returns to haunt us
From: Alan <alan@lxorguk.ukuu.org.uk>

Perhaps Adrian would care to simply delete the pci_module_init ancient
compat code so nobody else can inadvertently merge a driver that uses it.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/atl1/atl1_main.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/net/atl1/atl1_main.c~atl1_main-pci_module_int-returns-to-haunt-us drivers/net/atl1/atl1_main.c
--- a/drivers/net/atl1/atl1_main.c~atl1_main-pci_module_int-returns-to-haunt-us
+++ a/drivers/net/atl1/atl1_main.c
@@ -2461,12 +2461,9 @@ static void __exit atl1_exit_module(void
  */
 static int __init atl1_init_module(void)
 {
-	int ret;
 	printk(KERN_INFO "%s - version %s\n", atl1_driver_string, DRIVER_VERSION);
 	printk(KERN_INFO "%s\n", atl1_copyright);
-	ret = pci_module_init(&atl1_driver);
-
-	return ret;
+	return pci_register_driver(&atl1_driver);
 }
 
 module_init(atl1_init_module);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
sis-warning-fixes.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
git-mtd.patch
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
