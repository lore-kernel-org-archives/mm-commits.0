From: akpm@linux-foundation.org
Subject: - sysctl-remove-support-for-ctl_any.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:27 -0800
Message-ID: <200702150850.l1F8oRU1025230@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40198 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965501AbXBOIu2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: remove support for CTL_ANY
has been removed from the -mm tree.  Its filename was
     sysctl-remove-support-for-ctl_any.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: remove support for CTL_ANY
From: Eric W. Biederman <ebiederm@xmission.com>

There are currently no users in the kernel for CTL_ANY and it only has effect
on the binary interface which is practically unused.

So this complicates sysctl lookups for no good reason so just remove it.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    1 -
 kernel/sysctl.c        |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-remove-support-for-ctl_any include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-remove-support-for-ctl_any
+++ a/include/linux/sysctl.h
@@ -53,7 +53,6 @@ struct __sysctl_args {
 
 /* For internal pattern-matching use only: */
 #ifdef __KERNEL__
-#define CTL_ANY		-1	/* Matches any name */
 #define CTL_NONE	0
 #define CTL_UNNUMBERED	CTL_NONE	/* sysctl without a binary number */
 #endif
diff -puN kernel/sysctl.c~sysctl-remove-support-for-ctl_any kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-remove-support-for-ctl_any
+++ a/kernel/sysctl.c
@@ -1170,7 +1170,7 @@ repeat:
 	for ( ; table->ctl_name || table->procname; table++) {
 		if (!table->ctl_name)
 			continue;
-		if (n == table->ctl_name || table->ctl_name == CTL_ANY) {
+		if (n == table->ctl_name) {
 			int error;
 			if (table->child) {
 				if (ctl_perm(table, 001))
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
