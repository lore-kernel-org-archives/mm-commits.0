From: akpm@linux-foundation.org
Subject: + numa-hotplug-emulator-fake-cpu-socket-with-logical-cpu-on-x86.patch added to -mm tree
Date: Wed, 22 Dec 2010 16:28:01 -0800
Message-ID: <201012230028.oBN0S1D2027946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601Ab0LWA3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Dec 2010 19:29:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohui.zheng@intel.com, dave@linux.vnet.ibm.com, emunson@mgebm.net, gregkh@suse.de, haicheng.li@intel.com, hpa@zytor.com, len.brown@intel.com, lethal@linux-sh.org, mingo@elte.hu, randy.dunlap@oracle.com, rientjes@google.com, sam@ravnborg.org, tglx@linutronix.de, tj@kernel.org


The patch titled
     NUMA hotplug emulator: fake CPU socket with logical CPU on x86
has been added to the -mm tree.  Its filename is
     numa-hotplug-emulator-fake-cpu-socket-with-logical-cpu-on-x86.patch

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
Subject: NUMA hotplug emulator: fake CPU socket with logical CPU on x86
From: Shaohui Zheng <shaohui.zheng@intel.com>

When hotplug a CPU with emulator, we are using a logical CPU to emulate
the CPU hotplug process.  For the CPU supported SMT, some logical CPUs are
in the same socket, but it may located in different NUMA node after we
have emulator.  it misleads the scheduling domain to build the incorrect
hierarchy, and it causes the following call trace when rebalance the
scheduling domain:

divide error: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu8/online
CPU 0
Modules linked in: fbcon tileblit font bitblit softcursor radeon ttm drm_kms_helper e1000e usbhid via_rhine mii drm i2c_algo_bit igb dca
Pid: 0, comm: swapper Not tainted 2.6.32hpe #78 X8DTN
RIP: 0010:[<ffffffff81051da5>]  [<ffffffff81051da5>] find_busiest_group+0x6c5/0xa10
RSP: 0018:ffff880028203c30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000015ac0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff880277e8cfa0 RDI: 0000000000000000
RBP: ffff880028203dc0 R08: ffff880277e8cfa0 R09: 0000000000000040
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f16cfc85770 CR3: 0000000001001000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff81822000, task ffffffff8184a600)
Stack:
 ffff880028203d60 ffff880028203cd0 ffff8801c204ff08 ffff880028203e38
<0> 0101ffff81018c59 ffff880028203e44 00000001810806bd ffff8801c204fe00
<0> 0000000528200000 ffffffff00000000 0000000000000018 0000000000015ac0
Call Trace:
 <IRQ>
 [<ffffffff81088ee0>] ? tick_dev_program_event+0x40/0xd0
 [<ffffffff81053b2c>] rebalance_domains+0x17c/0x570
 [<ffffffff81018c89>] ? read_tsc+0x9/0x20
 [<ffffffff81088ee0>] ? tick_dev_program_event+0x40/0xd0
 [<ffffffff810569ed>] run_rebalance_domains+0xbd/0xf0
 [<ffffffff8106471f>] __do_softirq+0xaf/0x1e0
 [<ffffffff810b7d18>] ? handle_IRQ_event+0x58/0x160
 [<ffffffff810130ac>] call_softirq+0x1c/0x30
 [<ffffffff81014a85>] do_softirq+0x65/0xa0
 [<ffffffff810645cd>] irq_exit+0x7d/0x90
 [<ffffffff81013ff0>] do_IRQ+0x70/0xe0
 [<ffffffff810128d3>] ret_from_intr+0x0/0x11
 <EOI>
 [<ffffffff8133387f>] ? acpi_idle_enter_bm+0x281/0x2b5
 [<ffffffff81333878>] ? acpi_idle_enter_bm+0x27a/0x2b5
 [<ffffffff8145dc8f>] ? cpuidle_idle_call+0x9f/0x130
 [<ffffffff81010e2b>] ? cpu_idle+0xab/0x100
 [<ffffffff8158aee6>] ? rest_init+0x66/0x70
 [<ffffffff81905d90>] ? start_kernel+0x3e3/0x3ef
 [<ffffffff8190533a>] ? x86_64_start_reservations+0x125/0x129
 [<ffffffff81905438>] ? x86_64_start_kernel+0xfa/0x109
Code: 00 00 e9 4c fb ff ff 0f 1f 80 00 00 00 00 48 8b b5 d8 fe ff ff 48 8b 45 a8 4d 29 ef 8b 56 08 48 c1 e0 0a 49 89 f0 48 89 d7 31 d2 <48> f7 f7 31 d2 48 89 45 a0 8b 76 08 4c 89 f0 48 c1 e0 0a 48 f7
RIP  [<ffffffff81051da5>] find_busiest_group+0x6c5/0xa10
 RSP <ffff880028203c30>

Solution:

We put the logical CPU into a fake CPU socket, and assign it an unique
phys_proc_id.  For the fake socket, we put one logical CPU in only.  This
method fixes the above bug.

Signed-off-by: Haicheng Li <haicheng.li@intel.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/processor.h |    9 +++++++
 arch/x86/kernel/smpboot.c        |   25 ++++++++++++++++++++-
 arch/x86/kernel/topology.c       |   34 +++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/processor.h~numa-hotplug-emulator-fake-cpu-socket-with-logical-cpu-on-x86 arch/x86/include/asm/processor.h
--- a/arch/x86/include/asm/processor.h~numa-hotplug-emulator-fake-cpu-socket-with-logical-cpu-on-x86
+++ a/arch/x86/include/asm/processor.h
@@ -115,6 +115,15 @@ struct cpuinfo_x86 {
 	/* Index into per_cpu list: */
 	u16			cpu_index;
 #endif
+
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+	/*
+	 * Use a logic cpu to emulate a physical cpu's hotplug. We put the
+	 * logical cpu into a fake socket, assign a fake physical id to it,
+	 * and create a fake core.
+	 */
+	__u8		cpu_probe_on; /* A flag to enable cpu probe/release */
+#endif
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define X86_VENDOR_INTEL	0
diff -puN arch/x86/kernel/smpboot.c~numa-hotplug-emulator-fake-cpu-socket-with-logical-cpu-on-x86 arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~numa-hotplug-emulator-fake-cpu-socket-with-logical-cpu-on-x86
+++ a/arch/x86/kernel/smpboot.c
@@ -97,6 +97,7 @@ static DEFINE_PER_CPU(struct task_struct
  */
 static DEFINE_MUTEX(x86_cpu_hotplug_driver_mutex);
 
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
 void cpu_hotplug_driver_lock()
 {
         mutex_lock(&x86_cpu_hotplug_driver_mutex);
@@ -106,6 +107,7 @@ void cpu_hotplug_driver_unlock()
 {
         mutex_unlock(&x86_cpu_hotplug_driver_mutex);
 }
+#endif
 
 #else
 static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
@@ -198,6 +200,8 @@ static void __cpuinit smp_callin(void)
 {
 	int cpuid, phys_id;
 	unsigned long timeout;
+	u8 cpu_probe_on = 0;
+	struct cpuinfo_x86 *c;
 
 	/*
 	 * If waken up by an INIT in an 82489DX configuration
@@ -277,7 +281,20 @@ static void __cpuinit smp_callin(void)
 	/*
 	 * Save our processor parameters
 	 */
+	c = &cpu_data(cpuid);
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+	cpu_probe_on = c->cpu_probe_on;
+	phys_id = c->phys_proc_id;
+#endif
+
 	smp_store_cpu_info(cpuid);
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+	if (cpu_probe_on) {
+		c->phys_proc_id = phys_id; /* restore the fake phys_proc_id */
+		c->cpu_core_id = 0; /* force the logical cpu to core 0 */
+		c->cpu_probe_on = cpu_probe_on;
+	}
+#endif
 
 	/*
 	 * This must be done before setting cpu_online_mask
@@ -403,6 +420,11 @@ void __cpuinit set_cpu_sibling_map(int c
 {
 	int i;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	int cpu_probe_on = 0;
+
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+	cpu_probe_on = c->cpu_probe_on;
+#endif
 
 	cpumask_set_cpu(cpu, cpu_sibling_setup_mask);
 
@@ -433,7 +455,8 @@ void __cpuinit set_cpu_sibling_map(int c
 
 	for_each_cpu(i, cpu_sibling_setup_mask) {
 		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
-		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
+		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i) &&
+			cpu_probe_on == 0) {
 			cpumask_set_cpu(i, c->llc_shared_map);
 			cpumask_set_cpu(cpu, cpu_data(i).llc_shared_map);
 		}
diff -puN arch/x86/kernel/topology.c~numa-hotplug-emulator-fake-cpu-socket-with-logical-cpu-on-x86 arch/x86/kernel/topology.c
--- a/arch/x86/kernel/topology.c~numa-hotplug-emulator-fake-cpu-socket-with-logical-cpu-on-x86
+++ a/arch/x86/kernel/topology.c
@@ -70,6 +70,36 @@ void arch_unregister_cpu(int num)
 }
 EXPORT_SYMBOL(arch_unregister_cpu);
 
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+/*
+ * Put the logical cpu into a new sokect, and encapsule it into core 0.
+ */
+static void fake_cpu_socket_info(int cpu)
+{
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	int i, phys_id = 0;
+
+	/* calculate the max phys_id */
+	for_each_present_cpu(i) {
+		struct cpuinfo_x86 *c = &cpu_data(i);
+		if (phys_id < c->phys_proc_id)
+			phys_id = c->phys_proc_id;
+	}
+
+	c->phys_proc_id = phys_id + 1; /* pick up a unused phys_proc_id */
+	c->cpu_core_id = 0; /* always put the logical cpu to core 0 */
+	c->cpu_probe_on = 1;
+}
+
+static void clear_cpu_socket_info(int cpu)
+{
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	c->phys_proc_id = 0;
+	c->cpu_core_id = 0;
+	c->cpu_probe_on = 0;
+}
+
+
 ssize_t arch_cpu_probe(const char *buf, size_t count)
 {
 	int nid = 0;
@@ -109,6 +139,7 @@ ssize_t arch_cpu_probe(const char *buf, 
 	/* register cpu */
 	arch_register_cpu_node(selected, nid);
 	acpi_map_lsapic_emu(selected, nid);
+	fake_cpu_socket_info(selected);
 
 	return count;
 }
@@ -136,10 +167,13 @@ ssize_t arch_cpu_release(const char *buf
 
 	arch_unregister_cpu(cpu);
 	acpi_unmap_lsapic(cpu);
+	clear_cpu_socket_info(cpu);
+	set_cpu_present(cpu, true);
 
 	return count;
 }
 EXPORT_SYMBOL(arch_cpu_release);
+#endif CONFIG_ARCH_CPU_PROBE_RELEASE
 
 #else /* CONFIG_HOTPLUG_CPU */
 
_

Patches currently in -mm which might be from shaohui.zheng@intel.com are

numa-hotplug-emulator-documentation.patch
numa-hotplug-emulator-add-numa=possible-option.patch
numa-hotplug-emulator-add-node-hotplug-emulation.patch
numa-hotplug-emulator-abstract-cpu-register-functions.patch
numa-hotplug-emulator-support-cpu-probe-release-in-x86_64.patch
numa-hotplug-emulator-fake-cpu-socket-with-logical-cpu-on-x86.patch
numa-hotplug-emulator-implement-per-node-add_memory-debugfs-interface.patch

