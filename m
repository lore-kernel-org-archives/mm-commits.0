From: akpm@linux-foundation.org
Subject: + numa-hotplug-emulator-support-cpu-probe-release-in-x86_64.patch added to -mm tree
Date: Wed, 22 Dec 2010 16:27:58 -0800
Message-ID: <201012230027.oBN0Rw2O027937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000Ab0LWAbC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Dec 2010 19:31:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohui.zheng@intel.com, Yinghai.Lu@Sun.COM, dave@linux.vnet.ibm.com, emunson@mgebm.net, gregkh@suse.de, haicheng.li@intel.com, hpa@zytor.com, len.brown@intel.com, lethal@linux-sh.org, mingo@elte.hu, randy.dunlap@oracle.com, rientjes@google.com, sam@ravnborg.org, tglx@linutronix.de, tj@kernel.org


The patch titled
     NUMA hotplug emulator: support cpu probe/release in x86_64
has been added to the -mm tree.  Its filename is
     numa-hotplug-emulator-support-cpu-probe-release-in-x86_64.patch

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
Subject: NUMA hotplug emulator: support cpu probe/release in x86_64
From: Shaohui Zheng <shaohui.zheng@intel.com>

CPU physical hot-add/hot-remove are supported on some hardwares, and it
was already supported in current linux kernel.  NUMA Hotplug Emulator
provides a mechanism to emulate the process with software method.  It can
be used for testing or debuging purpose.

CPU physical hotplug is different with logical CPU online/offline. 
Logical online/offline is controled by interface
/sys/device/cpu/cpuX/online.  CPU hotplug emulator uses probe/release
interface.  It becomes possible to do cpu hotplug automation and stress

Add cpu interface probe/release under sysfs for x86_64.  User can use this
interface to emulate the cpu hot-add and hot-remove process.

Directive:
*) Reserve CPU thru grub parameter like:
	maxcpus=4

the rest CPUs will not be initiliazed.

*) Probe CPU
we can use the probe interface to hot-add new CPUs:
	echo nid > /sys/devices/system/cpu/probe

*) Release a CPU
	echo cpu > /sys/devices/system/cpu/release

A reserved CPU will be hot-added to the specified node.

1) nid == 0, the CPU will be added to the real node which the CPU
   should be in

2) nid != 0, add the CPU to node nid even through it is a fake node.

Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Signed-off-by: Haicheng Li <haicheng.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <len.brown@intel.com>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Tejun Heo <tj@kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric B Munson <emunson@mgebm.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86/x86_64/boot-options.txt |    5 +
 arch/x86/kernel/acpi/boot.c               |   31 +++++++
 arch/x86/kernel/smpboot.c                 |    2 
 arch/x86/kernel/topology.c                |   85 +++++++++++++++++++-
 arch/x86/mm/numa_64.c                     |   14 +++
 drivers/acpi/processor_driver.c           |    9 ++
 drivers/base/cpu.c                        |    8 +
 include/linux/acpi.h                      |    1 
 include/linux/cpu.h                       |    4 
 9 files changed, 154 insertions(+), 5 deletions(-)

diff -puN Documentation/x86/x86_64/boot-options.txt~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64 Documentation/x86/x86_64/boot-options.txt
--- a/Documentation/x86/x86_64/boot-options.txt~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64
+++ a/Documentation/x86/x86_64/boot-options.txt
@@ -320,3 +320,8 @@ Miscellaneous
 		Do not use GB pages for kernel direct mappings.
 	gbpages
 		Use GB pages for kernel direct mappings.
+	cpu_hpe=on/off
+		Enable/disable CPU hotplug emulation with software method. When cpu_hpe=on,
+		sysfs provides probe/release interface to hot add/remove CPUs dynamically.
+		We can use maxcpus=<N> to reserve CPUs.
+		This option is disabled by default.
diff -puN arch/x86/kernel/acpi/boot.c~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64 arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64
+++ a/arch/x86/kernel/acpi/boot.c
@@ -674,8 +674,39 @@ int __ref acpi_map_lsapic(acpi_handle ha
 }
 EXPORT_SYMBOL(acpi_map_lsapic);
 
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+static void acpi_map_cpu2node_emu(int cpu, int physid, int nid)
+{
+#ifdef CONFIG_ACPI_NUMA
+	set_apicid_to_node(physid, nid);
+	numa_set_node(cpu, nid);
+#endif
+}
+
+static u16 cpu_to_apicid_saved[CONFIG_NR_CPUS];
+int __ref acpi_map_lsapic_emu(int pcpu, int nid)
+{
+	/* backup cpu apicid to array cpu_to_apicid_saved */
+	if (cpu_to_apicid_saved[pcpu] == 0 &&
+		per_cpu(x86_cpu_to_apicid, pcpu) != BAD_APICID)
+		cpu_to_apicid_saved[pcpu] = per_cpu(x86_cpu_to_apicid, pcpu);
+
+	per_cpu(x86_cpu_to_apicid, pcpu) = cpu_to_apicid_saved[pcpu];
+	acpi_map_cpu2node_emu(pcpu, per_cpu(x86_cpu_to_apicid, pcpu), nid);
+
+	return pcpu;
+}
+EXPORT_SYMBOL(acpi_map_lsapic_emu);
+#endif
+
 int acpi_unmap_lsapic(int cpu)
 {
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+	/* backup cpu apicid to array cpu_to_apicid_saved */
+	if (cpu_to_apicid_saved[cpu] == 0 &&
+		per_cpu(x86_cpu_to_apicid, cpu) != BAD_APICID)
+		cpu_to_apicid_saved[cpu] = per_cpu(x86_cpu_to_apicid, cpu);
+#endif
 	per_cpu(x86_cpu_to_apicid, cpu) = -1;
 	set_cpu_present(cpu, false);
 	num_processors--;
diff -puN arch/x86/kernel/smpboot.c~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64 arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64
+++ a/arch/x86/kernel/smpboot.c
@@ -107,8 +107,6 @@ void cpu_hotplug_driver_unlock()
         mutex_unlock(&x86_cpu_hotplug_driver_mutex);
 }
 
-ssize_t arch_cpu_probe(const char *buf, size_t count) { return -1; }
-ssize_t arch_cpu_release(const char *buf, size_t count) { return -1; }
 #else
 static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
 #define get_idle_for_cpu(x)      (idle_thread_array[(x)])
diff -puN arch/x86/kernel/topology.c~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64 arch/x86/kernel/topology.c
--- a/arch/x86/kernel/topology.c~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64
+++ a/arch/x86/kernel/topology.c
@@ -30,6 +30,9 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <asm/cpu.h>
+#include <linux/cpu.h>
+#include <linux/topology.h>
+#include <linux/acpi.h>
 
 static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
 
@@ -66,6 +69,78 @@ void arch_unregister_cpu(int num)
 	unregister_cpu(&per_cpu(cpu_devices, num).cpu);
 }
 EXPORT_SYMBOL(arch_unregister_cpu);
+
+ssize_t arch_cpu_probe(const char *buf, size_t count)
+{
+	int nid = 0;
+	int num = 0, selected = 0;
+
+	/* check parameters */
+	if (!buf || count < 2)
+		return -EPERM;
+
+	nid = simple_strtoul(buf, NULL, 0);
+	printk(KERN_DEBUG "Add a cpu to node : %d\n", nid);
+
+	if (nid < 0 || nid > nr_node_ids - 1) {
+		printk(KERN_ERR "Invalid NUMA node id: %d (0 <= nid < %d).\n",
+			nid, nr_node_ids);
+		return -EPERM;
+	}
+
+	if (!node_online(nid)) {
+		printk(KERN_ERR "NUMA node %d is not online, give up.\n", nid);
+		return -EPERM;
+	}
+
+	/* find first uninitialized cpu */
+	for_each_present_cpu(num) {
+		if (per_cpu(cpu_sys_devices, num) == NULL) {
+			selected = num;
+			break;
+		}
+	}
+
+	if (selected >= num_possible_cpus()) {
+		printk(KERN_ERR "No free cpu, give up cpu probing.\n");
+		return -EPERM;
+	}
+
+	/* register cpu */
+	arch_register_cpu_node(selected, nid);
+	acpi_map_lsapic_emu(selected, nid);
+
+	return count;
+}
+EXPORT_SYMBOL(arch_cpu_probe);
+
+ssize_t arch_cpu_release(const char *buf, size_t count)
+{
+	int cpu = 0;
+
+	cpu =  simple_strtoul(buf, NULL, 0);
+	/* cpu 0 is not hotplugable */
+	if (cpu == 0) {
+		printk(KERN_ERR "can not release cpu 0.\n");
+		return -EPERM;
+	}
+
+	if (cpu_online(cpu)) {
+		printk(KERN_DEBUG "offline cpu %d.\n", cpu);
+		if (!cpu_down(cpu)) {
+			printk(KERN_ERR "fail to offline cpu %d, give up.\n", cpu);
+			return -EPERM;
+		}
+
+	}
+
+	arch_unregister_cpu(cpu);
+	acpi_unmap_lsapic(cpu);
+
+	return count;
+}
+EXPORT_SYMBOL(arch_cpu_release);
+
 #else /* CONFIG_HOTPLUG_CPU */
 
 static int __init arch_register_cpu(int num)
@@ -83,8 +158,14 @@ static int __init topology_init(void)
 		register_one_node(i);
 #endif
 
-	for_each_present_cpu(i)
-		arch_register_cpu(i);
+	/*
+	 * when cpu hotplug emulation enabled, register the online cpu only,
+	 * the rests are reserved for cpu probe.
+	 */
+	for_each_present_cpu(i) {
+		if ((cpu_hpe_on && cpu_online(i)) || !cpu_hpe_on)
+			arch_register_cpu(i);
+	}
 
 	return 0;
 }
diff -puN arch/x86/mm/numa_64.c~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64 arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64
+++ a/arch/x86/mm/numa_64.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/nodemask.h>
 #include <linux/sched.h>
+#include <linux/cpu.h>
 
 #include <asm/e820.h>
 #include <asm/proto.h>
@@ -748,6 +749,19 @@ void __init init_cpu_to_node(void)
 }
 #endif
 
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+static __init int cpu_hpe_setup(char *opt)
+{
+	if (!opt)
+		return -EINVAL;
+
+	if (!strncmp(opt, "on", 2) || !strncmp(opt, "1", 1))
+		cpu_hpe_on = 1;
+
+	return 0;
+}
+early_param("cpu_hpe", cpu_hpe_setup);
+#endif  /* CONFIG_ARCH_CPU_PROBE_RELEASE */
 
 void __cpuinit numa_set_node(int cpu, int node)
 {
diff -puN drivers/acpi/processor_driver.c~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64 drivers/acpi/processor_driver.c
--- a/drivers/acpi/processor_driver.c~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64
+++ a/drivers/acpi/processor_driver.c
@@ -487,6 +487,14 @@ static int __cpuinit acpi_processor_add(
 	per_cpu(processors, pr->id) = pr;
 
 	sysdev = get_cpu_sysdev(pr->id);
+	/*
+	 * Reserve cpu for hotplug emulation, the reserved cpu can be hot-added
+	 * throu the cpu probe interface. Return directly.
+	 */
+	if (sysdev == NULL) {
+		goto out;
+	}
+
 	if (sysfs_create_link(&device->dev.kobj, &sysdev->kobj, "sysdev")) {
 		result = -EFAULT;
 		goto err_free_cpumask;
@@ -527,6 +535,7 @@ static int __cpuinit acpi_processor_add(
 		goto err_remove_sysfs;
 	}
 
+out:
 	return 0;
 
 err_remove_sysfs:
diff -puN drivers/base/cpu.c~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64 drivers/base/cpu.c
--- a/drivers/base/cpu.c~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64
+++ a/drivers/base/cpu.c
@@ -22,9 +22,15 @@ struct sysdev_class cpu_sysdev_class = {
 };
 EXPORT_SYMBOL(cpu_sysdev_class);
 
-static DEFINE_PER_CPU(struct sys_device *, cpu_sys_devices);
+DEFINE_PER_CPU(struct sys_device *, cpu_sys_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
+/*
+ * cpu_hpe_on is a switch to enable/disable cpu hotplug emulation. it is
+ * disabled in default, we can enable it throu grub parameter cpu_hpe=on
+ */
+int cpu_hpe_on;
+
 static ssize_t show_online(struct sys_device *dev, struct sysdev_attribute *attr,
 			   char *buf)
 {
diff -puN include/linux/acpi.h~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64 include/linux/acpi.h
--- a/include/linux/acpi.h~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64
+++ a/include/linux/acpi.h
@@ -102,6 +102,7 @@ void acpi_numa_arch_fixup(void);
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 /* Arch dependent functions for cpu hotplug support */
 int acpi_map_lsapic(acpi_handle handle, int *pcpu);
+int acpi_map_lsapic_emu(int pcpu, int nid);
 int acpi_unmap_lsapic(int cpu);
 #endif /* CONFIG_ACPI_HOTPLUG_CPU */
 
diff -puN include/linux/cpu.h~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64 include/linux/cpu.h
--- a/include/linux/cpu.h~numa-hotplug-emulator-support-cpu-probe-release-in-x86_64
+++ a/include/linux/cpu.h
@@ -25,6 +25,8 @@ struct cpu {
 	struct sys_device sysdev;
 };
 
+DECLARE_PER_CPU(struct sys_device *, cpu_sys_devices);
+
 extern int register_cpu_node(struct cpu *cpu, int num, int nid);
 
 static inline int register_cpu(struct cpu *cpu, int num)
@@ -144,6 +146,7 @@ extern void put_online_cpus(void);
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
 int cpu_down(unsigned int cpu);
+extern int cpu_hpe_on;
 
 #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
 extern void cpu_hotplug_driver_lock(void);
@@ -166,6 +169,7 @@ static inline void cpu_hotplug_driver_un
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
 #define unregister_hotcpu_notifier(nb)	({ (void)(nb); })
+static int cpu_hpe_on;
 #endif		/* CONFIG_HOTPLUG_CPU */
 
 #ifdef CONFIG_PM_SLEEP_SMP
_

Patches currently in -mm which might be from shaohui.zheng@intel.com are

numa-hotplug-emulator-documentation.patch
numa-hotplug-emulator-add-numa=possible-option.patch
numa-hotplug-emulator-add-node-hotplug-emulation.patch
numa-hotplug-emulator-abstract-cpu-register-functions.patch
numa-hotplug-emulator-support-cpu-probe-release-in-x86_64.patch
numa-hotplug-emulator-fake-cpu-socket-with-logical-cpu-on-x86.patch
numa-hotplug-emulator-implement-per-node-add_memory-debugfs-interface.patch

