From: akpm@linux-foundation.org
Subject: [merged] numa-cpu-hotplug-change-links-of-cpu-and-node-when-changing-node-number-by-onlining-cpu.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:15 -0700
Message-ID: <20130430185015.ACEB85A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:54132 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953Ab3D3SuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:16 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so86111yen.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isimatu.yasuaki@jp.fujitsu.com, greg@kroah.com, hpa@zytor.com, kosaki.motohiro@gmail.com, mingo@elte.hu, srivatsa.bhat@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: numa, cpu hotplug: change links of CPU and node when changing node number by onlining CPU
has been removed from the -mm tree.  Its filename was
     numa-cpu-hotplug-change-links-of-cpu-and-node-when-changing-node-number-by-onlining-cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: numa, cpu hotplug: change links of CPU and node when changing node number by onlining CPU

When booting x86 system contains memoryless node, node numbers of CPUs on
memoryless node were changed to nearest online node number by
init_cpu_to_node() because the node is not online.

In my system, node numbers of cpu#30-44 and 75-89 were changed from 2 to 0
as follows:

$ numactl --hardware
available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 30 31 32 33 34 35 36 37 38 39 40
41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 75 76 77 78 79 80 81 82
83 84 85 86 87 88 89
node 0 size: 32394 MB
node 0 free: 27898 MB
node 1 cpus: 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 60 61 62 63 64 65 66
67 68 69 70 71 72 73 74
node 1 size: 32768 MB
node 1 free: 30335 MB

If we hot add memory to memoryless node and offine/online all CPUs on
the node, node numbers of these CPUs are changed to correct node numbers
by srat_detect_node() because the node become online.

In this case, node numbers of cpu#30-44 and 75-89 were changed from 0 to 2
in my system as follows:

$ numactl --hardware
available: 3 nodes (0-2)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 45 46 47 48 49 50 51 52 53 54 55
56 57 58 59
node 0 size: 32394 MB
node 0 free: 27218 MB
node 1 cpus: 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 60 61 62 63 64 65 66
67 68 69 70 71 72 73 74
node 1 size: 32768 MB
node 1 free: 30014 MB
node 2 cpus: 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 75 76 77 78 79 80 81
82 83 84 85 86 87 88 89
node 2 size: 16384 MB
node 2 free: 16384 MB

But "cpu to node" and "node to cpu" links were not changed as follows:

$ ls /sys/devices/system/cpu/cpu30/|grep node
node0
$ ls /sys/devices/system/node/node0/|grep cpu30
cpu30

"numactl --hardware" shows that cpu30 belongs to node 2. But sysfs links
does  not change.

This patch changes "cpu to node" and "node to cpu" links when node number
changed by onlining CPU.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/cpu.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff -puN drivers/base/cpu.c~numa-cpu-hotplug-change-links-of-cpu-and-node-when-changing-node-number-by-onlining-cpu drivers/base/cpu.c
--- a/drivers/base/cpu.c~numa-cpu-hotplug-change-links-of-cpu-and-node-when-changing-node-number-by-onlining-cpu
+++ a/drivers/base/cpu.c
@@ -25,6 +25,15 @@ EXPORT_SYMBOL_GPL(cpu_subsys);
 static DEFINE_PER_CPU(struct device *, cpu_sys_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
+static void change_cpu_under_node(struct cpu *cpu,
+			unsigned int from_nid, unsigned int to_nid)
+{
+	int cpuid = cpu->dev.id;
+	unregister_cpu_under_node(cpuid, from_nid);
+	register_cpu_under_node(cpuid, to_nid);
+	cpu->node_id = to_nid;
+}
+
 static ssize_t show_online(struct device *dev,
 			   struct device_attribute *attr,
 			   char *buf)
@@ -39,17 +48,29 @@ static ssize_t __ref store_online(struct
 				  const char *buf, size_t count)
 {
 	struct cpu *cpu = container_of(dev, struct cpu, dev);
+	int cpuid = cpu->dev.id;
+	int from_nid, to_nid;
 	ssize_t ret;
 
 	cpu_hotplug_driver_lock();
 	switch (buf[0]) {
 	case '0':
-		ret = cpu_down(cpu->dev.id);
+		ret = cpu_down(cpuid);
 		if (!ret)
 			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
 		break;
 	case '1':
-		ret = cpu_up(cpu->dev.id);
+		from_nid = cpu_to_node(cpuid);
+		ret = cpu_up(cpuid);
+
+		/*
+		 * When hot adding memory to memoryless node and enabling a cpu
+		 * on the node, node number of the cpu may internally change.
+		 */
+		to_nid = cpu_to_node(cpuid);
+		if (from_nid != to_nid)
+			change_cpu_under_node(cpu, from_nid, to_nid);
+
 		if (!ret)
 			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
 		break;
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

origin.patch
linux-next.patch
x86-make-mem=-option-to-work-for-efi-platform.patch

