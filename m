From: akpm@linux-foundation.org
Subject: - sysctl-cdrom-dont-set-de-owner.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:48:58 -0800
Message-ID: <200702150848.l1F8mw5h025090@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40061 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965418AbXBOItG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:49:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: cdrom: don't set de->owner
has been removed from the -mm tree.  Its filename was
     sysctl-cdrom-dont-set-de-owner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: cdrom: don't set de->owner
From: Eric W. Biederman <ebiederm@xmission.com>

There is no need for open files in /proc/sys/XXX to hold a reference count on
the module that provides the file to prevent module unload races.  While there
is code active in the module p->used in the sysctl_table_header is
incremented, preventing the sysctl from being unregisted.  Once the sysctl is
unregistered it cannot be found.  Open files are also not a problem as they
revalidate the sysctl information and bump p->used before accessing module
code.

So setting de->owner is unnecessary, makes for a bad example and gets in my
way of removing ctl_table->de.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Acked-by: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/cdrom.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/cdrom/cdrom.c~sysctl-cdrom-dont-set-de-owner drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~sysctl-cdrom-dont-set-de-owner
+++ a/drivers/cdrom/cdrom.c
@@ -3554,8 +3554,6 @@ static void cdrom_sysctl_register(void)
 		return;
 
 	cdrom_sysctl_header = register_sysctl_table(cdrom_root_table, 0);
-	if (cdrom_root_table->ctl_name && cdrom_root_table->child->de)
-		cdrom_root_table->child->de->owner = THIS_MODULE;
 
 	/* set the defaults */
 	cdrom_sysctl_settings.autoclose = autoclose;
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
