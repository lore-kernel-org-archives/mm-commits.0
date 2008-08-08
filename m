From: akpm@linux-foundation.org
Subject: + ia64-uv-use-blinking-led-for-heartbeat-display.patch added to -mm tree
Date: Thu, 07 Aug 2008 23:08:17 -0700
Message-ID: <200808080608.m7868HY7025822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbYHHGIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 02:08:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, tony.luck@intel.com


The patch titled
     ia64 UV: use blinking LED for heartbeat display
has been added to the -mm tree.  Its filename is
     ia64-uv-use-blinking-led-for-heartbeat-display.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64 UV: use blinking LED for heartbeat display
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
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/uv/uv_hub.h |    4 ++++
 arch/ia64/uv/kernel/setup.c       |   28 ++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff -puN arch/ia64/include/asm/uv/uv_hub.h~ia64-uv-use-blinking-led-for-heartbeat-display arch/ia64/include/asm/uv/uv_hub.h
--- a/arch/ia64/include/asm/uv/uv_hub.h~ia64-uv-use-blinking-led-for-heartbeat-display
+++ a/arch/ia64/include/asm/uv/uv_hub.h
@@ -100,6 +100,7 @@ struct uv_hub_info_s {
 	unsigned long	lowmem_remap_top;
 	unsigned long	lowmem_remap_base;
 	unsigned long	led_offset;
+	unsigned int	led_heartbeat_count;
 	unsigned short	pnode;
 	unsigned short	pnode_mask;
 	unsigned short	coherency_domain_number;
@@ -153,6 +154,9 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 /* idle callback */
 extern void (*ia64_mark_idle) (int);
 
+/* idle callback */
+extern void (*ia64_mark_idle) (int);
+
 /*
  * Macros for converting between kernel virtual addresses, socket local physical
  * addresses, and UV global physical addresses.
diff -puN arch/ia64/uv/kernel/setup.c~ia64-uv-use-blinking-led-for-heartbeat-display arch/ia64/uv/kernel/setup.c
--- a/arch/ia64/uv/kernel/setup.c~ia64-uv-use-blinking-led-for-heartbeat-display
+++ a/arch/ia64/uv/kernel/setup.c
@@ -8,6 +8,7 @@
  * Copyright (C) 2008 Silicon Graphics, Inc. All rights reserved.
  */
 
+#include <linux/clocksource.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <asm/sn/simulator.h>
@@ -65,6 +66,25 @@ static void uv_idle(int state)
 		uv_set_led_bits(LED_CPU_ACTIVITY, LED_CPU_ACTIVITY);
 }
 
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+static void uv_display_heartbeat(void)
+{
+	int cpu;
+
+	uv_hub_info->uv_heartbeat = nr_cpu_ids;
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
 void __init uv_setup(char **cmdline_p)
 {
 	union uvh_si_addr_map_config_u m_n_config;
@@ -124,4 +144,12 @@ void __init uv_setup(char **cmdline_p)
 
 	/* enable idle callback */
 	ia64_mark_idle = &uv_idle;
+
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+	/* enable heartbeat display callback */
+	display_heartbeat = uv_display_heartbeat;
+#else
+	printk(KERN_NOTICE "UV: CLOCKSOURCE_WATCHDOG not configured, "
+			   "LED Heartbeat NOT enabled\n");
+#endif
 }
_

Patches currently in -mm which might be from travis@sgi.com are

linux-next.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
seq_file-add-seq_cpumask-seq_nodemask.patch
switch-proc-irq-smp_affinity-et-al-to-seqfiles.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
x86_64-uv-provide-a-led-driver-for-uv-systems.patch
x86_64-uv-use-led-to-indicate-cpu-is-active.patch
x86_64-uv-use-blinking-led-for-heartbeat-display.patch
ia64-uv-provide-a-led-driver-for-uv-systems.patch
ia64-uv-use-led-to-indicate-cpu-is-active.patch
ia64-uv-use-blinking-led-for-heartbeat-display.patch
ia64-uv-use-blinking-led-for-heartbeat-display-fix.patch

