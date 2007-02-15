From: akpm@linux-foundation.org
Subject: - sysctl-sn-remove-sysctl-abi-breakage.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:14 -0800
Message-ID: <200702150849.l1F8nE7D025111@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40085 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965438AbXBOItQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:49:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: sn: remove sysctl ABI BREAKAGE
has been removed from the -mm tree.  Its filename was
     sysctl-sn-remove-sysctl-abi-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: sn: remove sysctl ABI BREAKAGE
From: Eric W. Biederman <ebiederm@xmission.com>

By not using the enumeration in sysctl.h (or even understanding it) the SN
platform placed their arch specific xpc directory on top of CTL_KERN and only
because they didn't have 4 entries in their xpc directory got lucky and didn't
break glibc.

This is totally irresponsible.  So this patch entirely removes sys_sysctl
support from their sysctl code.  Hopefully they don't have ascii name
conflicts as well.

And now that they have no ABI numbers add them to the end instead of the
sysctl list instead of the head so nothing else will be overridden.

Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/kernel/xpc_main.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/ia64/sn/kernel/xpc_main.c~sysctl-sn-remove-sysctl-abi-breakage arch/ia64/sn/kernel/xpc_main.c
--- a/arch/ia64/sn/kernel/xpc_main.c~sysctl-sn-remove-sysctl-abi-breakage
+++ a/arch/ia64/sn/kernel/xpc_main.c
@@ -101,7 +101,7 @@ static int xpc_disengage_request_max_tim
 
 static ctl_table xpc_sys_xpc_hb_dir[] = {
 	{
-		1,
+		CTL_UNNUMBERED,
 		"hb_interval",
 		&xpc_hb_interval,
 		sizeof(int),
@@ -114,7 +114,7 @@ static ctl_table xpc_sys_xpc_hb_dir[] = 
 		&xpc_hb_max_interval
 	},
 	{
-		2,
+		CTL_UNNUMBERED,
 		"hb_check_interval",
 		&xpc_hb_check_interval,
 		sizeof(int),
@@ -130,7 +130,7 @@ static ctl_table xpc_sys_xpc_hb_dir[] = 
 };
 static ctl_table xpc_sys_xpc_dir[] = {
 	{
-		1,
+		CTL_UNNUMBERED,
 		"hb",
 		NULL,
 		0,
@@ -138,7 +138,7 @@ static ctl_table xpc_sys_xpc_dir[] = {
 		xpc_sys_xpc_hb_dir
 	},
 	{
-		2,
+		CTL_UNNUMBERED,
 		"disengage_request_timelimit",
 		&xpc_disengage_request_timelimit,
 		sizeof(int),
@@ -154,7 +154,7 @@ static ctl_table xpc_sys_xpc_dir[] = {
 };
 static ctl_table xpc_sys_dir[] = {
 	{
-		1,
+		CTL_UNNUMBERED,
 		"xpc",
 		NULL,
 		0,
@@ -1251,7 +1251,7 @@ xpc_init(void)
 	snprintf(xpc_part->bus_id, BUS_ID_SIZE, "part");
 	snprintf(xpc_chan->bus_id, BUS_ID_SIZE, "chan");
 
-	xpc_sysctl = register_sysctl_table(xpc_sys_dir, 1);
+	xpc_sysctl = register_sysctl_table(xpc_sys_dir, 0);
 
 	/*
 	 * The first few fields of each entry of xpc_partitions[] need to
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
