From: akpm@linux-foundation.org
Subject: - make-vm-statistics-update-interval-configurable.patch removed from -mm tree
Date: Wed, 09 May 2007 14:54:08 -0700
Message-ID: <200705092154.l49Ls8qw003143@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758697AbXEIVy0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:54:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Make vm statistics update interval configurable
has been removed from the -mm tree.  Its filename was
     make-vm-statistics-update-interval-configurable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make vm statistics update interval configurable
From: Christoph Lameter <clameter@sgi.com>

Make it configurable.  Code in mm makes the vm statistics intervals
independent from the cache reaper use that opportunity to make it
configurable.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   12 ++++++++++++
 mm/vmstat.c     |    4 +++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff -puN kernel/sysctl.c~make-vm-statistics-update-interval-configurable kernel/sysctl.c
--- a/kernel/sysctl.c~make-vm-statistics-update-interval-configurable
+++ a/kernel/sysctl.c
@@ -77,6 +77,7 @@ extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int maps_protect;
+extern int sysctl_stat_interval;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -857,6 +858,17 @@ static ctl_table vm_table[] = {
 		.extra2		= &one_hundred,
 	},
 #endif
+#ifdef CONFIG_SMP
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "stat_interval",
+		.data		= &sysctl_stat_interval,
+		.maxlen		= sizeof(sysctl_stat_interval),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+		.strategy	= &sysctl_jiffies,
+	},
+#endif
 #if defined(CONFIG_X86_32) || \
    (defined(CONFIG_SUPERH) && defined(CONFIG_VSYSCALL))
 	{
diff -puN mm/vmstat.c~make-vm-statistics-update-interval-configurable mm/vmstat.c
--- a/mm/vmstat.c~make-vm-statistics-update-interval-configurable
+++ a/mm/vmstat.c
@@ -641,11 +641,13 @@ const struct seq_operations vmstat_op = 
 
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
+int sysctl_stat_interval __read_mostly = HZ;
 
 static void vmstat_update(struct work_struct *w)
 {
 	refresh_cpu_vm_stats(smp_processor_id());
-	schedule_delayed_work(&__get_cpu_var(vmstat_work), HZ);
+	schedule_delayed_work(&__get_cpu_var(vmstat_work),
+		sysctl_stat_interval);
 }
 
 static void __devinit start_cpu_timer(int cpu)
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
