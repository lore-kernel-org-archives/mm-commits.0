From: akpm@linux-foundation.org
Subject: - sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:48:11 -0800
Message-ID: <200702150848.l1F8mBHN025031@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40298 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965537AbXBOIv2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:51:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     sysctl: x25: remove unnecessary insert_at_head from register_sysctl_table
has been removed from the -mm tree.  Its filename was
     sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: x25: remove unnecessary insert_at_head from register_sysctl_table
From: Eric W. Biederman <ebiederm@xmission.com>

There has not been much maintenance on sysctl in years, and as a result is
there is a lot to do to allow future interesting work to happen, and being
ambitious I'm trying to do it all at once :)

The patches in this series fall into several general categories.

- Removal of useless attempts to override the standard sysctls

- Registers of sysctl numbers in sysctl.h so someone else does not use
  the magic number and conflict.

- C99 conversions so it becomes possible to change the layout of 
  struct ctl_table without breaking everything.

- Removal of useless claims of module ownership, in the proc dir entries

- Removal of sys_sysctl support where people had used conflicting sysctl
  numbers. Trying to break glibc or other applications by changing the
  ABI is not cool.  9 instances of this in the kernel seems a little
  extreme.

- General enhancements when I got the junk I could see out.



This patch:

Since x25 uses unique binary numbers inserting yourself at the head of the
search list for sysctls so you can override already registered sysctls is
pointless.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/x25/sysctl_net_x25.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/x25/sysctl_net_x25.c~sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table net/x25/sysctl_net_x25.c
--- a/net/x25/sysctl_net_x25.c~sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table
+++ a/net/x25/sysctl_net_x25.c
@@ -106,7 +106,7 @@ static struct ctl_table x25_root_table[]
 
 void __init x25_register_sysctl(void)
 {
-	x25_table_header = register_sysctl_table(x25_root_table, 1);
+	x25_table_header = register_sysctl_table(x25_root_table, 0);
 }
 
 void x25_unregister_sysctl(void)
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
