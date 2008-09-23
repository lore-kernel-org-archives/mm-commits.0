From: akpm@linux-foundation.org
Subject: - ia64-uv-use-led-to-indicate-cpu-is-active.patch removed from -mm tree
Date: Mon, 22 Sep 2008 18:43:21 -0700
Message-ID: <200809230143.m8N1hLmo008797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891AbYIWBnY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 21:43:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64 UV: use LED to indicate CPU is active
has been removed from the -mm tree.  Its filename was
     ia64-uv-use-led-to-indicate-cpu-is-active.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64 UV: use LED to indicate CPU is active
From: Mike Travis <travis@sgi.com>

  * Add an idle callback to turn on/off a LED indicating that
    the CPU is "active" (ON) or "idle" (OFF).

  * Introduces a callback for "post-smp_cpus_done" processing
    to setup callback.

Note that this is a RAS feature that allows external monitoring of
various cpu state indicators, not just providing "pretty blinking
lights", as the LED state is readable by the system controller.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/uv/uv_hub.h |    3 +++
 arch/ia64/uv/kernel/setup.c       |   19 +++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff -puN arch/ia64/include/asm/uv/uv_hub.h~ia64-uv-use-led-to-indicate-cpu-is-active arch/ia64/include/asm/uv/uv_hub.h
--- a/arch/ia64/include/asm/uv/uv_hub.h~ia64-uv-use-led-to-indicate-cpu-is-active
+++ a/arch/ia64/include/asm/uv/uv_hub.h
@@ -150,6 +150,9 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 #define LED_CPU_BLINK		0xffff	/* blink led */
 #define LED_CPU_HB_INTERVAL	(HZ/2)	/* blink once per second */
 
+/* idle callback */
+extern void (*ia64_mark_idle) (int);
+
 /*
  * Macros for converting between kernel virtual addresses, socket local physical
  * addresses, and UV global physical addresses.
diff -puN arch/ia64/uv/kernel/setup.c~ia64-uv-use-led-to-indicate-cpu-is-active arch/ia64/uv/kernel/setup.c
--- a/arch/ia64/uv/kernel/setup.c~ia64-uv-use-led-to-indicate-cpu-is-active
+++ a/arch/ia64/uv/kernel/setup.c
@@ -52,6 +52,19 @@ static __init void get_lowmem_redirect(u
 	BUG();
 }
 
+/*
+ * Illuminate "activity" LED when CPU is going "active",
+ * extinguish when going "idle".
+ */
+static void uv_idle(int state)
+{
+	if (state)
+		uv_set_led_bits(0, LED_CPU_ACTIVITY);
+
+	else
+		uv_set_led_bits(LED_CPU_ACTIVITY, LED_CPU_ACTIVITY);
+}
+
 void __init uv_setup(char **cmdline_p)
 {
 	union uvh_si_addr_map_config_u m_n_config;
@@ -104,9 +117,11 @@ void __init uv_setup(char **cmdline_p)
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
 		uv_cpu_hub_info(cpu)->coherency_domain_number = 0;/* ZZZ */
-		uv_cpu_hub_info(cpu)->led_offset = LED_LOCAL_MMR_BASE + lcpu;
+		uv_cpu_hub_info(cpu)->led_offset = LED_LOCAL_MMR_BASE + cpu;
 		uv_cpu_hub_info(cpu)->led_state = 0;
 		printk(KERN_DEBUG "UV cpu %d, nid %d\n", cpu, nid);
 	}
-}
 
+	/* enable idle callback */
+	ia64_mark_idle = &uv_idle;
+}
_

Patches currently in -mm which might be from travis@sgi.com are

linux-next.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ia64-uv-use-led-to-indicate-cpu-is-active.patch
ia64-uv-use-blinking-led-for-heartbeat-display.patch
cpuset-use-seq_cpumask-seq_nodemask.patch

