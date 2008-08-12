From: akpm@linux-foundation.org
Subject: - x86_64-uv-use-blinking-led-for-heartbeat-display.patch removed from -mm tree
Date: Mon, 11 Aug 2008 17:37:37 -0700
Message-ID: <200808120037.m7C0bbq9030560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753590AbYHLAhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 20:37:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, hpa@zytor.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64 UV: use blinking LED for heartbeat display
has been removed from the -mm tree.  Its filename was
     x86_64-uv-use-blinking-led-for-heartbeat-display.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86_64 UV: use blinking LED for heartbeat display
From: Mike Travis <travis@sgi.com>

  * Add a function to blink the "heartbeat" LED indicating
    that the CPU is responding to timer interrupts.

  * Introduces a callback for "heartbeat" display in the
    clocksource_watchdog function, which in turn requires
    CONFIG_CLOCKSOURCE_WATCHDOG to be set.

Note that this is a RAS feature that allows external monitoring of
various cpu state indicators, not just providing "pretty blinking
lights", as the LED state is readable by the system controller.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/genx2apic_uv_x.c |   29 +++++++++++++++++++++++++++++
 include/asm-x86/uv/uv_hub.h      |    1 +
 include/linux/clocksource.h      |    5 +++++
 kernel/time/clocksource.c        |   10 +++++++++-
 4 files changed, 44 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/genx2apic_uv_x.c~x86_64-uv-use-blinking-led-for-heartbeat-display arch/x86/kernel/genx2apic_uv_x.c
--- a/arch/x86/kernel/genx2apic_uv_x.c~x86_64-uv-use-blinking-led-for-heartbeat-display
+++ a/arch/x86/kernel/genx2apic_uv_x.c
@@ -10,6 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/threads.h>
+#include <linux/clocksource.h>
 #include <linux/cpumask.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
@@ -359,6 +360,25 @@ static __init void uv_rtc_init(void)
 		sn_rtc_cycles_per_second = ticks_per_sec;
 }
 
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+static void uv_display_heartbeat(void)
+{
+	int cpu;
+
+	uv_hub_info->led_heartbeat_count = nr_cpu_ids;
+
+	for_each_online_cpu(cpu) {
+		struct uv_hub_info_s *hub = uv_cpu_hub_info(cpu);
+
+		if (hub->led_heartbeat_count > 0) {
+			uv_set_led_bits_on(cpu, LED_CPU_BLINK,
+						LED_CPU_HEARTBEAT);
+			--hub->led_heartbeat_count;
+		}
+	}
+}
+#endif
+
 static __init void uv_system_init(void)
 {
 	union uvh_si_addr_map_config_u m_n_config;
@@ -437,6 +457,7 @@ static __init void uv_system_init(void)
 		uv_cpu_hub_info(cpu)->coherency_domain_number = 0;/* ZZZ */
 		uv_cpu_hub_info(cpu)->led_offset = LED_LOCAL_MMR_BASE + lcpu;
 		uv_cpu_hub_info(cpu)->led_state = 0;
+		uv_cpu_hub_info(cpu)->led_heartbeat_count = nr_cpu_ids;
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
 		max_pnode = max(pnode, max_pnode);
@@ -454,6 +475,14 @@ static __init void uv_system_init(void)
 
 	/* enable post-smp_cpus_done processing */
 	smp_cpus_done_system = uv_start_system;
+
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+	/* enable heartbeat display callback */
+	display_heartbeat = uv_display_heartbeat;
+#else
+	printk(KERN_NOTICE "UV: CLOCKSOURCE_WATCHDOG not configured, "
+			   "LED Heartbeat NOT enabled\n");
+#endif
 }
 
 /*
diff -puN include/asm-x86/uv/uv_hub.h~x86_64-uv-use-blinking-led-for-heartbeat-display include/asm-x86/uv/uv_hub.h
--- a/include/asm-x86/uv/uv_hub.h~x86_64-uv-use-blinking-led-for-heartbeat-display
+++ a/include/asm-x86/uv/uv_hub.h
@@ -124,6 +124,7 @@ struct uv_hub_info_s {
 	unsigned long	lowmem_remap_top;
 	unsigned long	lowmem_remap_base;
 	unsigned long	led_offset;
+	unsigned int	led_heartbeat_count;
 	unsigned short	pnode;
 	unsigned short	pnode_mask;
 	unsigned short	coherency_domain_number;
diff -puN include/linux/clocksource.h~x86_64-uv-use-blinking-led-for-heartbeat-display include/linux/clocksource.h
--- a/include/linux/clocksource.h~x86_64-uv-use-blinking-led-for-heartbeat-display
+++ a/include/linux/clocksource.h
@@ -242,4 +242,9 @@ static inline void update_vsyscall_tz(vo
 }
 #endif
 
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+/* typically blinks "heartbeat" LED */
+extern void (*display_heartbeat)(void);
+#endif
+
 #endif /* _LINUX_CLOCKSOURCE_H */
diff -puN kernel/time/clocksource.c~x86_64-uv-use-blinking-led-for-heartbeat-display kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~x86_64-uv-use-blinking-led-for-heartbeat-display
+++ a/kernel/time/clocksource.c
@@ -76,6 +76,9 @@ static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
 static unsigned long watchdog_resumed;
 
+/* arch specific heartbeat display */
+void (*display_heartbeat)(void);
+
 /*
  * Interval: 0.5sec Threshold: 0.0625s
  */
@@ -140,12 +143,17 @@ static void clocksource_watchdog(unsigne
 		}
 	}
 
+	/* If arch has a heartbeat display, then poke it */
+	if (display_heartbeat)
+		display_heartbeat();
+
 	if (!list_empty(&watchdog_list)) {
 		/*
 		 * Cycle through CPUs to check if the CPUs stay
 		 * synchronized to each other.
 		 */
-		int next_cpu = next_cpu_nr(raw_smp_processor_id(), cpu_online_map);
+		int next_cpu = next_cpu_nr(raw_smp_processor_id(),
+					   cpu_online_map);
 
 		if (next_cpu >= nr_cpu_ids)
 			next_cpu = first_cpu(cpu_online_map);
_

Patches currently in -mm which might be from travis@sgi.com are

linux-next.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86_64-uv-use-blinking-led-for-heartbeat-display.patch
ia64-uv-provide-a-led-driver-for-uv-systems.patch
ia64-uv-use-led-to-indicate-cpu-is-active.patch
ia64-uv-use-blinking-led-for-heartbeat-display.patch
ia64-uv-use-blinking-led-for-heartbeat-display-fix.patch
seq_file-add-seq_cpumask-seq_nodemask.patch
switch-proc-irq-smp_affinity-et-al-to-seqfiles.patch
cpuset-use-seq_cpumask-seq_nodemask.patch

