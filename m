From: akpm@linux-foundation.org
Subject: - sysctl-c99-convert-arch-frv-kernel-sysctlc.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:12 -0800
Message-ID: <200702150849.l1F8nCpX025108@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40093 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965446AbXBOItU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:49:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: C99 convert arch/frv/kernel/sysctl.c
has been removed from the -mm tree.  Its filename was
     sysctl-c99-convert-arch-frv-kernel-sysctlc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: C99 convert arch/frv/kernel/sysctl.c
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/sysctl.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff -puN arch/frv/kernel/sysctl.c~sysctl-c99-convert-arch-frv-kernel-sysctlc arch/frv/kernel/sysctl.c
--- a/arch/frv/kernel/sysctl.c~sysctl-c99-convert-arch-frv-kernel-sysctlc
+++ a/arch/frv/kernel/sysctl.c
@@ -175,11 +175,25 @@ static int procctl_frv_pin_cxnr(ctl_tabl
  */
 static struct ctl_table frv_table[] =
 {
-	{ 1, "cache-mode",	NULL, 0, 0644, NULL, &procctl_frv_cachemode },
+	{
+		.ctl_name 	= 1,
+		.procname 	= "cache-mode",
+		.data		= NULL,
+		.maxlen		= 0,
+		.mode		= 0644,
+		.proc_handler	= &procctl_frv_cachemode,
+	},
 #ifdef CONFIG_MMU
-	{ 2, "pin-cxnr",	NULL, 0, 0644, NULL, &procctl_frv_pin_cxnr },
+	{
+		.ctl_name	= 2,
+		.procname	= "pin-cxnr",
+		.data		= NULL,
+		.maxlen		= 0,
+		.mode		= 0644,
+		.proc_handler	= &procctl_frv_pin_cxnr
+	},
 #endif
-	{ 0 }
+	{}
 };
 
 /*
@@ -188,8 +202,13 @@ static struct ctl_table frv_table[] =
  */
 static struct ctl_table frv_dir_table[] =
 {
-	{CTL_FRV, "frv", NULL, 0, 0555, frv_table},
-	{0}
+	{
+		.ctl_name	= CTL_FRV,
+		.procname	= "frv",
+		.mode 		= 0555,
+		.child		= frv_table
+	},
+	{}
 };
 
 /*
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
