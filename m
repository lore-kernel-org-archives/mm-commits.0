From: akpm@linux-foundation.org
Subject: + kernel-shut-up-the-irq-mismatch-messages.patch added to -mm tree
Date: Tue, 06 Feb 2007 15:44:26 -0800
Message-ID: <200702062344.l16NiQiU000565@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55531 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030600AbXBFXox (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 18:44:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, arjan@infradead.org, dwmw2@infradead.org, mingo@elte.hu


The patch titled
     kernel: shut up the IRQ mismatch messages
has been added to the -mm tree.  Its filename is
     kernel-shut-up-the-irq-mismatch-messages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel: shut up the IRQ mismatch messages
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The problem is various drivers legally validly and sensibly try to claim
IRQs but the kernel insists on vomiting forth a giant irrelevant debugging
spew when the types clash.

Edit kernel/irq/manage.c go down to mismatch: in setup_irq() and ifdef out
the if clause that checks for mismatches.  It'll then just do the right
thing and work sanely.

For the current -mm kernel this will do the trick (and moves it into shared
irq debugging as in debug mode the info spew is useful).  I've had a
variant of this in my private tree for some time as I got fed up on the
mess on boxes where old legacy IRQs get reused.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN kernel/irq/manage.c~kernel-shut-up-the-irq-mismatch-messages kernel/irq/manage.c
--- a/kernel/irq/manage.c~kernel-shut-up-the-irq-mismatch-messages
+++ a/kernel/irq/manage.c
@@ -328,12 +328,14 @@ int setup_irq(unsigned int irq, struct i
 	return 0;
 
 mismatch:
+#ifdef CONFIG_DEBUG_SHIRQ
 	if (!(new->flags & IRQF_PROBE_SHARED)) {
 		printk(KERN_ERR "IRQ handler type mismatch for IRQ %d\n", irq);
 		if (old_name)
 			printk(KERN_ERR "current handler: %s\n", old_name);
 		dump_stack();
 	}
+#endif
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return -EBUSY;
 }
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
sis-warning-fixes.patch
kconfig-clarify-ata_piix-description.patch
ata-add-defines-for-the-iordy-bits.patch
libata-add-a-host-flag-to-indicate-lack-of-iordy.patch
libata-early-cfa-adapters-are-not-required-to-support-mode.patch
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
geode-configuration-fixes.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-tty_wakeup-cleanup.patch
proc-remove-useless-and-buggy-nlink-settings.patch
tty-improve-encode_baud_rate-logic.patch
kernel-shut-up-the-irq-mismatch-messages.patch
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
