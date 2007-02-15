From: akpm@linux-foundation.org
Subject: - sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:55 -0800
Message-ID: <200702150849.l1F8ntPC025168@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40456 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965606AbXBOIyV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:54:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, a.zummo@towertech.it, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     sysctl: remove sys_sysctl support from drivers/char/rtc.c
has been removed from the -mm tree.  Its filename was
     sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: remove sys_sysctl support from drivers/char/rtc.c
From: Eric W. Biederman <ebiederm@xmission.com>

The real time clock driver was using the binary number reserved for cdroms in
the sysctl binary number interface, which is a no-no.  So since the sysctl
binary interface is wrong remove it.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/char/rtc.c~sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc drivers/char/rtc.c
--- a/drivers/char/rtc.c~sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc
+++ a/drivers/char/rtc.c
@@ -282,7 +282,7 @@ irqreturn_t rtc_interrupt(int irq, void 
  */
 static ctl_table rtc_table[] = {
 	{
-		.ctl_name	= 1,
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "max-user-freq",
 		.data		= &rtc_max_user_freq,
 		.maxlen		= sizeof(int),
@@ -294,9 +294,8 @@ static ctl_table rtc_table[] = {
 
 static ctl_table rtc_root[] = {
 	{
-		.ctl_name	= 1,
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "rtc",
-		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= rtc_table,
 	},
@@ -307,7 +306,6 @@ static ctl_table dev_root[] = {
 	{
 		.ctl_name	= CTL_DEV,
 		.procname	= "dev",
-		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= rtc_root,
 	},
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
