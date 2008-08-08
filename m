From: akpm@linux-foundation.org
Subject: + x86_64-uv-use-led-to-indicate-cpu-is-active.patch added to -mm tree
Date: Thu, 07 Aug 2008 23:08:09 -0700
Message-ID: <200808080608.m78689J8025806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbYHHGIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 02:08:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, hpa@zytor.com, tglx@linutronix.de


The patch titled
     x86_64 UV: use LED to indicate CPU is active
has been added to the -mm tree.  Its filename is
     x86_64-uv-use-led-to-indicate-cpu-is-active.patch

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
Subject: x86_64 UV: use LED to indicate CPU is active
From: Mike Travis <travis@sgi.com>

  * Add an idle callback to turn on/off a LED indicating that
    the CPU is "active" (ON) or "idle" (OFF).

  * Introduces a callback for "post-smp_cpus_done" processing
    to setup callback.

Note that this is a RAS feature that allows external monitoring of
various cpu state indicators, not just providing "pretty blinking
lights", as the LED state is readable by the system controller.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/genx2apic_uv_x.c |   40 +++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c        |    6 ++++
 include/asm-x86/genapic_64.h     |    3 ++
 3 files changed, 49 insertions(+)

diff -puN arch/x86/kernel/genx2apic_uv_x.c~x86_64-uv-use-led-to-indicate-cpu-is-active arch/x86/kernel/genx2apic_uv_x.c
--- a/arch/x86/kernel/genx2apic_uv_x.c~x86_64-uv-use-led-to-indicate-cpu-is-active
+++ a/arch/x86/kernel/genx2apic_uv_x.c
@@ -19,6 +19,7 @@
 #include <linux/bootmem.h>
 #include <linux/module.h>
 #include <linux/hardirq.h>
+#include <asm/idle.h>
 #include <asm/smp.h>
 #include <asm/ipi.h>
 #include <asm/genapic.h>
@@ -27,6 +28,8 @@
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/bios.h>
 
+static __init void uv_start_system(void);
+
 static enum uv_system_type uv_system_type;
 
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
@@ -448,6 +451,9 @@ static __init void uv_system_init(void)
 	map_mmr_high(max_pnode);
 	map_config_high(max_pnode);
 	map_mmioh_high(max_pnode);
+
+	/* enable post-smp_cpus_done processing */
+	smp_cpus_done_system = uv_start_system;
 }
 
 /*
@@ -465,4 +471,38 @@ void __cpuinit uv_cpu_init(void)
 		set_x2apic_extra_bits(uv_hub_info->pnode);
 }
 
+/*
+ * Illuminate "activity" LED when CPU is going "active",
+ * extinguish when going "idle".
+ */
+static int uv_idle(struct notifier_block *nfb, unsigned long action, void *junk)
+{
+	if (action == IDLE_START)
+		uv_set_led_bits(0, LED_CPU_ACTIVITY);
+
+	else if (action == IDLE_END)
+		uv_set_led_bits(LED_CPU_ACTIVITY, LED_CPU_ACTIVITY);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block uv_idle_notifier = {
+	.notifier_call = uv_idle,
+};
 
+/*
+ * Initialize idle led callback function
+ */
+static __init void uv_init_led_idle_display(void)
+{
+	/* initialize timer for activity monitor */
+	idle_notifier_register(&uv_idle_notifier);
+}
+
+/*
+ * Initialize subsystems that need to start after the system is up
+ */
+static __init void uv_start_system(void)
+{
+	uv_init_led_idle_display();
+}
diff -puN arch/x86/kernel/smpboot.c~x86_64-uv-use-led-to-indicate-cpu-is-active arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~x86_64-uv-use-led-to-indicate-cpu-is-active
+++ a/arch/x86/kernel/smpboot.c
@@ -1200,6 +1200,9 @@ void __init native_smp_prepare_boot_cpu(
 	per_cpu(cpu_state, me) = CPU_ONLINE;
 }
 
+/* post-smp_cpus_done processing */
+void (*smp_cpus_done_system)(void);
+
 void __init native_smp_cpus_done(unsigned int max_cpus)
 {
 	pr_debug("Boot done.\n");
@@ -1210,6 +1213,9 @@ void __init native_smp_cpus_done(unsigne
 	setup_ioapic_dest();
 #endif
 	check_nmi_watchdog();
+
+	if (smp_cpus_done_system)
+		smp_cpus_done_system();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
diff -puN include/asm-x86/genapic_64.h~x86_64-uv-use-led-to-indicate-cpu-is-active include/asm-x86/genapic_64.h
--- a/include/asm-x86/genapic_64.h~x86_64-uv-use-led-to-indicate-cpu-is-active
+++ a/include/asm-x86/genapic_64.h
@@ -47,6 +47,9 @@ enum uv_system_type {UV_NONE, UV_LEGACY_
 extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
 
+/* system tasks to run after smp_cpus_done */
+extern void (*smp_cpus_done_system)(void);
+
 extern struct genapic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
 extern void uv_cpu_init(void);
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

