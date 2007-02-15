From: akpm@linux-foundation.org
Subject: - sysctl-remove-sys_sysctl-support-from-the-hpet-timer-driver.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:52 -0800
Message-ID: <200702150849.l1F8nqsj025165@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40163 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965489AbXBOIuB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, clemens@ladisch.de, mm-commits@vger.kernel.org


The patch titled
     sysctl: remove sys_sysctl support from the hpet timer driver
has been removed from the -mm tree.  Its filename was
     sysctl-remove-sys_sysctl-support-from-the-hpet-timer-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: remove sys_sysctl support from the hpet timer driver
From: Eric W. Biederman <ebiederm@xmission.com>

In the binary sysctl interface the hpet driver was claiming to be the cdrom
driver.  This is a no-no so remove support for the binary interface.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/hpet.c~sysctl-remove-sys_sysctl-support-from-the-hpet-timer-driver drivers/char/hpet.c
--- a/drivers/char/hpet.c~sysctl-remove-sys_sysctl-support-from-the-hpet-timer-driver
+++ a/drivers/char/hpet.c
@@ -703,7 +703,7 @@ int hpet_control(struct hpet_task *tp, u
 
 static ctl_table hpet_table[] = {
 	{
-	 .ctl_name = 1,
+	 .ctl_name = CTL_UNNUMBERED,
 	 .procname = "max-user-freq",
 	 .data = &hpet_max_freq,
 	 .maxlen = sizeof(int),
@@ -715,7 +715,7 @@ static ctl_table hpet_table[] = {
 
 static ctl_table hpet_root[] = {
 	{
-	 .ctl_name = 1,
+	 .ctl_name = CTL_UNNUMBERED,
 	 .procname = "hpet",
 	 .maxlen = 0,
 	 .mode = 0555,
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
