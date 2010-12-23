From: akpm@linux-foundation.org
Subject: [to-be-updated] numa-hotplug-emulator-documentation.patch removed from -mm tree
Date: Thu, 23 Dec 2010 15:17:17 -0800
Message-ID: <201012232350.oBNNoR4J018246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033Ab0LWXvX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 18:51:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohui.zheng@intel.com, dave@linux.vnet.ibm.com, emunson@mgebm.net, gregkh@suse.de, haicheng.li@intel.com, hpa@zytor.com, len.brown@intel.com, lethal@linux-sh.org, mingo@elte.hu, ran


The patch titled
     NUMA hotplug emulator: documentation
has been removed from the -mm tree.  Its filename was
     numa-hotplug-emulator-documentation.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NUMA hotplug emulator: documentation
From: Shaohui Zheng <shaohui.zheng@intel.com>

* WHAT IS HOTPLUG EMULATOR 

NUMA hotplug emulator is collectively named for the hotplug emulation it
is able to emulate NUMA Node Hotplug thru a pure software way.  It intends
to help people easily debug and test node/cpu/memory hotplug related stuff
on a none-NUMA-hotplug-support machine, even an UMA machine.

The emulator provides mechanism to emulate the process of physcial cpu/mem
hotadd, it provides possibility to debug CPU and memory hotplug on the
machines without NUMA support for kernel developers.  It offers an
interface for cpu and memory hotplug test purpose.

* WHY DO WE USE HOTPLUG EMULATOR

We are focusing on the hotplug emualation for a few months.  The emualor
helps team to reproduce all the major hotplug bugs.  It plays an important
role to the hotplug code quality assurance.  Because of the hotplug
emulator, we already move most of the debug working to virtual
environment.

* Principles & Usages 

NUMA hotplug emulator include 3 different parts: node/CPU/memory hotplug
emulation.

1) Node hotplug emulation:

Adds a numa=possible=<N> command line option to set an additional N nodes
as being possible for memory hotplug.  This set of possible nodes control
nr_node_ids and the sizes of several dynamically allocated node arrays.

This allows memory hotplug to create new nodes for newly added memory
rather than binding it to existing nodes.

For emulation on x86, it would be possible to set aside memory for
hotplugged nodes (say, anything above 2G) and to add an additional four
nodes as being possible on boot with

	mem=2G numa=possible=4

and then creating a new 128M node at runtime:

	# echo 128M@0x80000000 > /sys/kernel/debug/mem_hotplug/add_node
	On node 1 totalpages: 0
	init_memory_mapping: 0000000080000000-0000000088000000
	 0080000000 - 0088000000 page 2M

Once the new node has been added, its memory can be onlined.  If this
memory represents memory section 16, for example:

	# echo online > /sys/devices/system/memory/memory16/state
	Built 2 zonelists in Node order, mobility grouping on.  Total pages: 514846
	Policy zone: Normal
 [ The memory section(s) mapped to a particular node are visible via
   /sys/devices/system/mem_hotplug/node1, in this example. ]

2) CPU hotplug emulation:

The emulator reserve CPUs via a grub parameter, the reserved CPUs can be
hot-add/hot-remove in software method.

When hotplug a CPU with emulator, we are using a logical CPU to emulate
the CPU hotplug process.  For a CPU which supports SMT, some logical CPUs
are in the same socket, but it may located in different NUMA node after we
have emulator.  We put the logical CPU into a fake CPU socket, and assign
it an unique phys_proc_id.  For the fake socket, we put one logical CPU in
only.

 - to hide CPUs
	- Using boot option "maxcpus=N" hide CPUs
	  N is the number of initialize CPUs
	- Using boot option "cpu_hpe=on" to enable cpu hotplug emulation
      when cpu_hpe is enabled, the rest CPUs will not be initialized 

 - to hot-add CPU to node
	# echo nid > cpu/probe

 - to hot-remove CPU
	# echo nid > cpu/release

3) Memory hotplug emulation:

The emulator reserves memory before OS boots, the reserved memory region
is removed from e820 table.  Each online node has an add_memory interface,
and memory can be hot-added via the per-ndoe add_memory debugfs interface.
 

 - reserve memory thru a kernel boot paramter
 	mem=1024m

 - add a memory section to node 3
    # echo 0x40000000 > mem_hotplug/node3/add_memory

* ACKNOWLEDGMENTS

NUMA Hotplug Emulator includes a team's efforts, thanks all of them.  They
are: Andi Kleen, Haicheng Li, Shaohui Zheng, Fengguang Wu, David Rientjes
and Yongkang You



This patch:

Add a text file Documentation/x86/x86_64/numa_hotplug_emulator.txt to
explain the usage for the hotplug emulator.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Haicheng Li <haicheng.li@intel.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86/x86_64/numa_hotplug_emulator.txt |   97 +++++++++++
 1 file changed, 97 insertions(+)

diff -puN /dev/null Documentation/x86/x86_64/numa_hotplug_emulator.txt
--- /dev/null
+++ a/Documentation/x86/x86_64/numa_hotplug_emulator.txt
@@ -0,0 +1,97 @@
+NUMA Hotplug Emulator for x86_64
+---------------------------------------------------
+
+NUMA hotplug emulator is able to emulate NUMA Node Hotplug
+thru a pure software way. It intends to help people easily debug
+and test node/CPU/memory hotplug related stuff on a
+none-NUMA-hotplug-support machine, even a UMA machine and virtual
+environment.
+
+1) Node hotplug emulation:
+
+Adds a numa=possible=<N> command line option to set an additional N nodes
+as being possible for memory hotplug.  This set of possible nodes
+control nr_node_ids and the sizes of several dynamically allocated node
+arrays.
+
+This allows memory hotplug to create new nodes for newly added memory
+rather than binding it to existing nodes.
+
+For emulation on x86, it would be possible to set aside memory for hotplugged
+nodes (say, anything above 2G) and to add an additional four nodes as being
+possible on boot with
+
+	mem=2G numa=possible=4
+
+and then creating a new 128M node at runtime:
+
+	# echo 128M@0x80000000 > /sys/kernel/debug/mem_hotplug/add_node
+	On node 1 totalpages: 0
+	init_memory_mapping: 0000000080000000-0000000088000000
+	 0080000000 - 0088000000 page 2M
+
+Once the new node has been added, its memory can be onlined.  If this
+memory represents memory section 16, for example:
+
+	# echo online > /sys/devices/system/memory/memory16/state
+	Built 2 zonelists in Node order, mobility grouping on.  Total pages: 514846
+	Policy zone: Normal
+ [ The memory section(s) mapped to a particular node are visible via
+   /sys/devices/system/mem_hotplug/node1, in this example. ]
+
+2) CPU hotplug emulation:
+
+The emulator reserves CPUs thru grub parameter, the reserved CPUs can be
+hot-add/hot-remove in software method, it emulates the process of physical
+cpu hotplug.
+
+When hotplugging a CPU with emulator, we are using a logical CPU to emulate the
+CPU socket hotplug process. For the CPU supported SMT, some logical CPUs are in
+the same socket, but it may located in different NUMA node after we have
+emulator. We put the logical CPU into a fake CPU socket, and assign it a
+unique phys_proc_id. For the fake socket, we put one logical CPU in only.
+
+ - to hide CPUs
+	- Using boot option "maxcpus=N" hide CPUs
+	  N is the number of CPUs to initialize; the reset will be hidden.
+	- Using boot option "cpu_hpe=on" to enable CPU hotplug emulation
+      when cpu_hpe is enabled, the rest CPUs will not be initialized
+
+ - to hot-add CPU to node
+	# echo nid > cpu/probe
+
+ - to hot-remove CPU
+	# echo nid > cpu/release
+
+3) Memory hotplug emulation:
+
+The emulator reserves memory before OS boots, the reserved memory region is
+removed from e820 table. Each online node has an add_memory interface, and
+memory can be hot-added via the per-ndoe add_memory debugfs interface.
+
+ - reserve memory thru a kernel boot paramter
+ 	mem=1024m
+
+ - add a memory section to node 3
+    # echo 0x40000000 > mem_hotplug/node3/add_memory
+
+4) Script for hotplug testing
+
+These scripts provides convenience when we hot-add memory/cpu in batch.
+
+- Online all memory sections:
+for m in /sys/devices/system/memory/memory*;
+do
+	echo online > $m/state;
+done
+
+- CPU Online:
+for c in /sys/devices/system/cpu/cpu*;
+do
+	echo 1 > $c/online;
+done
+
+- David Rientjes <rientjes@google.com>
+- Haicheng Li <haicheng.li@intel.com>
+- Shaohui Zheng <shaohui.zheng@intel.com>
+  Nov 2010
_

Patches currently in -mm which might be from shaohui.zheng@intel.com are

numa-hotplug-emulator-add-numa=possible-option.patch
numa-hotplug-emulator-add-node-hotplug-emulation.patch
numa-hotplug-emulator-abstract-cpu-register-functions.patch
numa-hotplug-emulator-support-cpu-probe-release-in-x86_64.patch
numa-hotplug-emulator-fake-cpu-socket-with-logical-cpu-on-x86.patch
numa-hotplug-emulator-fake-cpu-socket-with-logical-cpu-on-x86-fix.patch
numa-hotplug-emulator-implement-per-node-add_memory-debugfs-interface.patch

