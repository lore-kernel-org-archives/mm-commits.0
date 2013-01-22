From: akpm@linux-foundation.org
Subject: + sched-do-not-use-cpu_to_node-to-find-an-offlined-cpus-node.patch added to -mm tree
Date: Tue, 22 Jan 2013 13:52:43 -0800
Message-ID: <20130122215244.0B91631C200@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:62499 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3AVVwp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 16:52:45 -0500
Received: by mail-yh0-f74.google.com with SMTP id z12so605831yhz.5
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 13:52:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, mingo@redhat.com, peterz@infradead.org, rientjes@google.com, tglx@linutronix.de, wency@cn.fujitsu.com


The patch titled
     Subject: sched: do not use cpu_to_node() to find an offlined cpu's node.
has been added to the -mm tree.  Its filename is
     sched-do-not-use-cpu_to_node-to-find-an-offlined-cpus-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: sched: do not use cpu_to_node() to find an offlined cpu's node.

If a cpu is offline, its nid will be set to -1, and cpu_to_node(cpu) will
return -1.  As a result, cpumask_of_node(nid) will return NULL.  In this
case, find_next_bit() in for_each_cpu will get a NULL pointer and cause
panic.

Here is a call trace:
[  609.824017] Call Trace:
[  609.824017]  <IRQ>
[  609.824017]  [<ffffffff810b0721>] select_fallback_rq+0x71/0x190
[  609.824017]  [<ffffffff810b086e>] ? try_to_wake_up+0x2e/0x2f0
[  609.824017]  [<ffffffff810b0b0b>] try_to_wake_up+0x2cb/0x2f0
[  609.824017]  [<ffffffff8109da08>] ? __run_hrtimer+0x78/0x320
[  609.824017]  [<ffffffff810b0b85>] wake_up_process+0x15/0x20
[  609.824017]  [<ffffffff8109ce62>] hrtimer_wakeup+0x22/0x30
[  609.824017]  [<ffffffff8109da13>] __run_hrtimer+0x83/0x320
[  609.824017]  [<ffffffff8109ce40>] ? update_rmtp+0x80/0x80
[  609.824017]  [<ffffffff8109df56>] hrtimer_interrupt+0x106/0x280
[  609.824017]  [<ffffffff810a72c8>] ? sd_free_ctl_entry+0x68/0x70
[  609.824017]  [<ffffffff8167cf39>] smp_apic_timer_interrupt+0x69/0x99
[  609.824017]  [<ffffffff8167be2f>] apic_timer_interrupt+0x6f/0x80

There is a hrtimer process sleeping, whose cpu has already been offlined. 
When it is waken up, it tries to find another cpu to run, and get a -1
nid.  As a result, cpumask_of_node(-1) returns NULL, and causes ernel
panic.

This patch fixes this problem by judging if the nid is -1.  If nid is not
-1, a cpu on the same node will be picked.  Else, a online cpu on another
node will be picked.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/core.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff -puN kernel/sched/core.c~sched-do-not-use-cpu_to_node-to-find-an-offlined-cpus-node kernel/sched/core.c
--- a/kernel/sched/core.c~sched-do-not-use-cpu_to_node-to-find-an-offlined-cpus-node
+++ a/kernel/sched/core.c
@@ -1132,18 +1132,28 @@ EXPORT_SYMBOL_GPL(kick_process);
  */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
-	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
+	int nid = cpu_to_node(cpu);
+	const struct cpumask *nodemask = NULL;
 	enum { cpuset, possible, fail } state = cpuset;
 	int dest_cpu;
 
-	/* Look for allowed, online CPU in same node. */
-	for_each_cpu(dest_cpu, nodemask) {
-		if (!cpu_online(dest_cpu))
-			continue;
-		if (!cpu_active(dest_cpu))
-			continue;
-		if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
-			return dest_cpu;
+	/*
+	 * If the node that the cpu is on has been offlined, cpu_to_node()
+	 * will return -1. There is no cpu on the node, and we should
+	 * select the cpu on the other node.
+	 */
+	if (nid != -1) {
+		nodemask = cpumask_of_node(nid);
+
+		/* Look for allowed, online CPU in same node. */
+		for_each_cpu(dest_cpu, nodemask) {
+			if (!cpu_online(dest_cpu))
+				continue;
+			if (!cpu_active(dest_cpu))
+				continue;
+			if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
+				return dest_cpu;
+		}
 	}
 
 	for (;;) {
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix-fix.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch
memory-hotplug-consider-compound-pages-when-free-memmap.patch
mempolicy-fix-is_valid_nodemask.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch
memory-hotplug-export-the-function-try_offline_node.patch
cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node.patch
sched-do-not-use-cpu_to_node-to-find-an-offlined-cpus-node.patch
x86-get-pg_data_ts-memory-from-other-node.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch
page_alloc-make-movablecore_map-has-higher-priority.patch
page_alloc-bootmem-limit-with-movablecore_map.patch

