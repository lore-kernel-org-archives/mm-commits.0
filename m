From: akpm@linux-foundation.org
Subject: + cpu-mem-hotplug-enable-cpus-online-before-local-memory-online.patch added to -mm tree
Date: Fri, 07 May 2010 13:42:51 -0700
Message-ID: <201005072042.o47KgrqJ010723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303Ab0EGUnl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 May 2010 16:43:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chaohong_guo@linux.intel.com, andi@firstfloor.org, chaohong.guo@intel.com, cl@linux-foundation.org, minchan.kim@gmail.com, tj@kernel.org, y-goto@jp.fujitsu.com


The patch titled
     cpu/mem hotplug: enable CPUs online before local memory online
has been added to the -mm tree.  Its filename is
     cpu-mem-hotplug-enable-cpus-online-before-local-memory-online.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu/mem hotplug: enable CPUs online before local memory online
From: minskey guo <chaohong_guo@linux.intel.com>

Enable users to online CPUs even if the CPUs belongs to a numa node which
doesn't have onlined local memory.

The zonlists(pg_data_t.node_zonelists[]) of a numa node are created either
in system boot/init period, or at the time of local memory online.  For a
numa node without onlined local memory, its zonelists are not initialized
at present.  As a result, any memory allocation operations executed by
CPUs within this node will fail.  In fact, an out-of-memory error is
triggered when attempt to online CPUs before memory comes to online.

This patch tries to create zonelists for such numa nodes, so that the
memory allocation for this node can be fallback'ed to other nodes.

Signed-off-by: minskey guo<chaohong.guo@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    1 +
 kernel/cpu.c                   |   26 ++++++++++++++++++++++++++
 mm/memory_hotplug.c            |   25 +++++++++++++++++++++++++
 3 files changed, 52 insertions(+)

diff -puN include/linux/memory_hotplug.h~cpu-mem-hotplug-enable-cpus-online-before-local-memory-online include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~cpu-mem-hotplug-enable-cpus-online-before-local-memory-online
+++ a/include/linux/memory_hotplug.h
@@ -202,6 +202,7 @@ static inline int is_mem_section_removab
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
+extern int mem_online_node(int nid);
 extern int add_memory(int nid, u64 start, u64 size);
 extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int remove_memory(u64 start, u64 size);
diff -puN kernel/cpu.c~cpu-mem-hotplug-enable-cpus-online-before-local-memory-online kernel/cpu.c
--- a/kernel/cpu.c~cpu-mem-hotplug-enable-cpus-online-before-local-memory-online
+++ a/kernel/cpu.c
@@ -330,6 +330,12 @@ out_notify:
 int __cpuinit cpu_up(unsigned int cpu)
 {
 	int err = 0;
+
+#ifdef	CONFIG_MEMORY_HOTPLUG
+	int nid;
+	pg_data_t	*pgdat;
+#endif
+
 	if (!cpu_possible(cpu)) {
 		printk(KERN_ERR "can't online cpu %d because it is not "
 			"configured as may-hotadd at boot time\n", cpu);
@@ -340,6 +346,26 @@ int __cpuinit cpu_up(unsigned int cpu)
 		return -EINVAL;
 	}
 
+#ifdef	CONFIG_MEMORY_HOTPLUG
+	nid = cpu_to_node(cpu);
+	if (!node_online(nid)) {
+		err = mem_online_node(nid);
+		if (err)
+			return err;
+	}
+
+	pgdat = NODE_DATA(nid);
+	if (!pgdat) {
+		printk(KERN_ERR
+			"Can't online cpu %d due to NULL pgdat\n", cpu);
+		return -ENOMEM;
+	}
+
+	if (pgdat-&gt;node_zonelists-&gt;_zonerefs-&gt;zone == NULL) {
+		build_all_zonelists();
+	}
+#endif
+
 	cpu_maps_update_begin();
 
 	if (cpu_hotplug_disabled) {
diff -puN mm/memory_hotplug.c~cpu-mem-hotplug-enable-cpus-online-before-local-memory-online mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~cpu-mem-hotplug-enable-cpus-online-before-local-memory-online
+++ a/mm/memory_hotplug.c
@@ -482,6 +482,31 @@ static void rollback_node_hotadd(int nid
 }
 
 
+/*
+ * called by cpu_up() to online a node without onlined memory.
+ */
+int mem_online_node(int nid)
+{
+	pg_data_t	*pgdat;
+	int	ret;
+
+	lock_system_sleep();
+	pgdat = hotadd_new_pgdat(nid, 0);
+	if (pgdat) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	node_set_online(nid);
+	ret = register_one_node(nid);
+	BUG_ON(ret);
+
+out:
+	unlock_system_sleep();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mem_online_node);
+
+
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
 int __ref add_memory(int nid, u64 start, u64 size)
 {
_

Patches currently in -mm which might be from chaohong_guo@linux.intel.com are

cpu-mem-hotplug-enable-cpus-online-before-local-memory-online.patch

