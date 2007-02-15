From: akpm@linux-foundation.org
Subject: - sysctl-move-ctl_frv-into-sysctlh-where-it-belongs.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:06 -0800
Message-ID: <200702150849.l1F8n6c0025099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40081 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965417AbXBOItP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:49:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: move CTL_FRV into sysctl.h where it belongs
has been removed from the -mm tree.  Its filename was
     sysctl-move-ctl_frv-into-sysctlh-where-it-belongs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: move CTL_FRV into sysctl.h where it belongs
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/sysctl.c |    1 -
 include/linux/sysctl.h   |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/frv/kernel/sysctl.c~sysctl-move-ctl_frv-into-sysctlh-where-it-belongs arch/frv/kernel/sysctl.c
--- a/arch/frv/kernel/sysctl.c~sysctl-move-ctl_frv-into-sysctlh-where-it-belongs
+++ a/arch/frv/kernel/sysctl.c
@@ -186,7 +186,6 @@ static struct ctl_table frv_table[] =
  * Use a temporary sysctl number. Horrid, but will be cleaned up in 2.6
  * when all the PM interfaces exist nicely.
  */
-#define CTL_FRV 9898
 static struct ctl_table frv_dir_table[] =
 {
 	{CTL_FRV, "frv", NULL, 0, 0555, frv_table},
diff -puN include/linux/sysctl.h~sysctl-move-ctl_frv-into-sysctlh-where-it-belongs include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-move-ctl_frv-into-sysctlh-where-it-belongs
+++ a/include/linux/sysctl.h
@@ -72,6 +72,7 @@ enum
 	CTL_CPU=10,		/* CPU stuff (speed scaling, etc) */
 	CTL_SUNRPC=7249,	/* sunrpc debug */
 	CTL_PM=9899,		/* frv power management */
+	CTL_FRV=9898,		/* frv specific sysctls */
 };
 
 /* CTL_BUS names: */
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
