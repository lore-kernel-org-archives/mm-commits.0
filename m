From: akpm@linux-foundation.org
Subject: + numa-hotplug-emulator-abstract-cpu-register-functions.patch added to -mm tree
Date: Wed, 22 Dec 2010 16:27:55 -0800
Message-ID: <201012230027.oBN0RtFF027934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121Ab0LWA3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Dec 2010 19:29:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohui.zheng@intel.com, dave@linux.vnet.ibm.com, emunson@mgebm.net, gregkh@suse.de, hpa@zytor.com, len.brown@intel.com, lethal@linux-sh.org, mingo@elte.hu, randy.dunlap@oracle.com, rientjes@google.com, sam@ravnborg.org, tglx@linutronix.de, tj@kernel.org


The patch titled
     NUMA hotplug emulator: abstract cpu register functions
has been added to the -mm tree.  Its filename is
     numa-hotplug-emulator-abstract-cpu-register-functions.patch

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
Subject: NUMA hotplug emulator: abstract cpu register functions
From: Shaohui Zheng <shaohui.zheng@intel.com>

Abstract cpu register functions, provide a more flexible interface
register_cpu_node, the new interface provides convenience to add cpu to a
specified node, we can use it to add a cpu to a fake node.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Len Brown <len.brown@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/cpu.h |    1 +
 arch/x86/kernel/topology.c |    9 +++++++++
 drivers/base/cpu.c         |    9 +++++----
 include/linux/cpu.h        |    8 +++++++-
 4 files changed, 22 insertions(+), 5 deletions(-)

diff -puN arch/x86/include/asm/cpu.h~numa-hotplug-emulator-abstract-cpu-register-functions arch/x86/include/asm/cpu.h
--- a/arch/x86/include/asm/cpu.h~numa-hotplug-emulator-abstract-cpu-register-functions
+++ a/arch/x86/include/asm/cpu.h
@@ -27,6 +27,7 @@ struct x86_cpu {
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern int arch_register_cpu(int num);
+extern int arch_register_cpu_node(int num, int nid);
 extern void arch_unregister_cpu(int);
 #endif
 
diff -puN arch/x86/kernel/topology.c~numa-hotplug-emulator-abstract-cpu-register-functions arch/x86/kernel/topology.c
--- a/arch/x86/kernel/topology.c~numa-hotplug-emulator-abstract-cpu-register-functions
+++ a/arch/x86/kernel/topology.c
@@ -52,6 +52,15 @@ int __ref arch_register_cpu(int num)
 }
 EXPORT_SYMBOL(arch_register_cpu);
 
+int __ref arch_register_cpu_node(int num, int nid)
+{
+	if (num)
+		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
+
+	return register_cpu_node(&per_cpu(cpu_devices, num).cpu, num, nid);
+}
+EXPORT_SYMBOL(arch_register_cpu_node);
+
 void arch_unregister_cpu(int num)
 {
 	unregister_cpu(&per_cpu(cpu_devices, num).cpu);
diff -puN drivers/base/cpu.c~numa-hotplug-emulator-abstract-cpu-register-functions drivers/base/cpu.c
--- a/drivers/base/cpu.c~numa-hotplug-emulator-abstract-cpu-register-functions
+++ a/drivers/base/cpu.c
@@ -208,17 +208,18 @@ static ssize_t print_cpus_offline(struct
 static SYSDEV_CLASS_ATTR(offline, 0444, print_cpus_offline, NULL);
 
 /*
- * register_cpu - Setup a sysfs device for a CPU.
+ * register_cpu_node - Setup a sysfs device for a CPU.
  * @cpu - cpu->hotpluggable field set to 1 will generate a control file in
  *	  sysfs for this CPU.
  * @num - CPU number to use when creating the device.
+ * @nid - Node ID to use, if any.
  *
  * Initialize and register the CPU device.
  */
-int __cpuinit register_cpu(struct cpu *cpu, int num)
+int __cpuinit register_cpu_node(struct cpu *cpu, int num, int nid)
 {
 	int error;
-	cpu->node_id = cpu_to_node(num);
+	cpu->node_id = nid;
 	cpu->sysdev.id = num;
 	cpu->sysdev.cls = &cpu_sysdev_class;
 
@@ -229,7 +230,7 @@ int __cpuinit register_cpu(struct cpu *c
 	if (!error)
 		per_cpu(cpu_sys_devices, num) = &cpu->sysdev;
 	if (!error)
-		register_cpu_under_node(num, cpu_to_node(num));
+		register_cpu_under_node(num, nid);
 
 #ifdef CONFIG_KEXEC
 	if (!error)
diff -puN include/linux/cpu.h~numa-hotplug-emulator-abstract-cpu-register-functions include/linux/cpu.h
--- a/include/linux/cpu.h~numa-hotplug-emulator-abstract-cpu-register-functions
+++ a/include/linux/cpu.h
@@ -25,7 +25,13 @@ struct cpu {
 	struct sys_device sysdev;
 };
 
-extern int register_cpu(struct cpu *cpu, int num);
+extern int register_cpu_node(struct cpu *cpu, int num, int nid);
+
+static inline int register_cpu(struct cpu *cpu, int num)
+{
+	return register_cpu_node(cpu, num, cpu_to_node(num));
+}
+
 extern struct sys_device *get_cpu_sysdev(unsigned cpu);
 
 extern int cpu_add_sysdev_attr(struct sysdev_attribute *attr);
_

Patches currently in -mm which might be from shaohui.zheng@intel.com are

numa-hotplug-emulator-documentation.patch
numa-hotplug-emulator-add-numa=possible-option.patch
numa-hotplug-emulator-add-node-hotplug-emulation.patch
numa-hotplug-emulator-abstract-cpu-register-functions.patch
numa-hotplug-emulator-support-cpu-probe-release-in-x86_64.patch
numa-hotplug-emulator-fake-cpu-socket-with-logical-cpu-on-x86.patch
numa-hotplug-emulator-implement-per-node-add_memory-debugfs-interface.patch

