From: akpm@linux-foundation.org
Subject: + ia64-uv-use-led-to-indicate-cpu-is-active.patch added to -mm tree
Date: Thu, 07 Aug 2008 23:08:15 -0700
Message-ID: <200808080608.m7868FUV025819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752665AbYHHGIT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 02:08:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, tony.luck@intel.com


The patch titled
     ia64 UV: use LED to indicate CPU is active
has been added to the -mm tree.  Its filename is
     ia64-uv-use-led-to-indicate-cpu-is-active.patch

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

