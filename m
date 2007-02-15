From: akpm@linux-foundation.org
Subject: - sysctl-remove-support-for-directory-strategy-routines.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:29 -0800
Message-ID: <200702150850.l1F8oTGP025233@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40203 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965503AbXBOIua (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: remove support for directory strategy routines
has been removed from the -mm tree.  Its filename was
     sysctl-remove-support-for-directory-strategy-routines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: remove support for directory strategy routines
From: Eric W. Biederman <ebiederm@xmission.com>

parse_table has support for calling a strategy routine when descending into a
directory.  To date no one has used this functionality and the /proc/sys
interface has no analog to it.

So no one is using this functionality kill it and make the binary sysctl code
easier to follow.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN kernel/sysctl.c~sysctl-remove-support-for-directory-strategy-routines kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-remove-support-for-directory-strategy-routines
+++ a/kernel/sysctl.c
@@ -1175,14 +1175,6 @@ repeat:
 			if (table->child) {
 				if (ctl_perm(table, 001))
 					return -EPERM;
-				if (table->strategy) {
-					error = table->strategy(
-						table, name, nlen,
-						oldval, oldlenp,
-						newval, newlen);
-					if (error)
-						return error;
-				}
 				name++;
 				nlen--;
 				table = table->child;
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
