From: akpm@linux-foundation.org
Subject: - cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch removed from -mm tree
Date: Fri, 19 Oct 2007 16:13:04 -0700
Message-ID: <200710192313.l9JND5Ka025233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43759 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758242AbXJSXNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:13:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     CPU HOTPLUG: avoid hotadd when proper possible_map isn't specified
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CPU HOTPLUG: avoid hotadd when proper possible_map isn't specified
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

cpu-hot-add should be fail if cpu is not set in cpu_possible_map.  If go
ahead, the system will panic soon.

Especially, arch which requires additional_cpus= parameter should handle
this.  Tested on ia64.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN kernel/cpu.c~cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified kernel/cpu.c
--- a/kernel/cpu.c~cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified
+++ a/kernel/cpu.c
@@ -274,6 +274,15 @@ out_notify:
 int __cpuinit cpu_up(unsigned int cpu)
 {
 	int err = 0;
+	if (!cpu_isset(cpu, cpu_possible_map)) {
+		printk(KERN_ERR "can't online cpu %d because it is not "
+			"configured as may-hotadd at boot time\n", cpu);
+#if defined(CONFIG_IA64) || defined(CONFIG_X86_64) || defined(CONFIG_S390)
+		printk(KERN_ERR "please check additional_cpus= boot "
+				"parameter\n");
+#endif
+		return -EINVAL;
+	}
 
 	mutex_lock(&cpu_add_remove_lock);
 	if (cpu_hotplug_disabled)
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch
git-sh.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
