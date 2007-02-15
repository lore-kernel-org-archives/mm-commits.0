From: akpm@linux-foundation.org
Subject: - sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:48:52 -0800
Message-ID: <200702150848.l1F8mqnd025084@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40044 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965405AbXBOIs4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:48:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, benh@kernel.crashing.org, minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     sysctl: ipmi: remove unnecessary insert_at_head flag
has been removed from the -mm tree.  Its filename was
     sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: ipmi: remove unnecessary insert_at_head flag
From: Eric W. Biederman <ebiederm@xmission.com>

With unique sysctl binary numbers setting insert_at_head is pointless.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Corey Minyard <minyard@acm.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_poweroff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_poweroff.c~sysctl-ipmi-remove-unnecessary-insert_at_head-flag drivers/char/ipmi/ipmi_poweroff.c
--- a/drivers/char/ipmi/ipmi_poweroff.c~sysctl-ipmi-remove-unnecessary-insert_at_head-flag
+++ a/drivers/char/ipmi/ipmi_poweroff.c
@@ -686,7 +686,7 @@ static int ipmi_poweroff_init (void)
 		printk(KERN_INFO PFX "Power cycle is enabled.\n");
 
 #ifdef CONFIG_PROC_FS
-	ipmi_table_header = register_sysctl_table(ipmi_root_table, 1);
+	ipmi_table_header = register_sysctl_table(ipmi_root_table, 0);
 	if (!ipmi_table_header) {
 		printk(KERN_ERR PFX "Unable to register powercycle sysctl\n");
 		rv = -ENOMEM;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
git-v9fs.patch
x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
i386-apic-clean-up-the-apic-code.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
