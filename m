From: akpm@linux-foundation.org
Subject: + x86_64-uv-provide-a-led-driver-for-uv-systems.patch added to -mm tree
Date: Thu, 07 Aug 2008 23:08:07 -0700
Message-ID: <200808080608.m78687aE025803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679AbYHHGIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 02:08:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, hpa@zytor.com, tglx@linutronix.de


The patch titled
     x86_64 UV: provide a LED driver for UV Systems
has been added to the -mm tree.  Its filename is
     x86_64-uv-provide-a-led-driver-for-uv-systems.patch

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
Subject: x86_64 UV: provide a LED driver for UV Systems
From: Mike Travis <travis@sgi.com>

  * Add base functionality for writing to the LED's on
    the x86_64 UV architecture.

Note that this is a RAS feature that allows external monitoring of
various cpu state indicators, not just providing "pretty blinking
lights", as the LED state is readable by the system controller.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/genx2apic_uv_x.c |    2 
 include/asm-x86/uv/uv_hub.h      |   60 ++++++++++++++++++++++++++++-
 2 files changed, 61 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/genx2apic_uv_x.c~x86_64-uv-provide-a-led-driver-for-uv-systems arch/x86/kernel/genx2apic_uv_x.c
--- a/arch/x86/kernel/genx2apic_uv_x.c~x86_64-uv-provide-a-led-driver-for-uv-systems
+++ a/arch/x86/kernel/genx2apic_uv_x.c
@@ -432,6 +432,8 @@ static __init void uv_system_init(void)
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
 		uv_cpu_hub_info(cpu)->coherency_domain_number = 0;/* ZZZ */
+		uv_cpu_hub_info(cpu)->led_offset = LED_LOCAL_MMR_BASE + lcpu;
+		uv_cpu_hub_info(cpu)->led_state = 0;
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
 		max_pnode = max(pnode, max_pnode);
diff -puN include/asm-x86/uv/uv_hub.h~x86_64-uv-provide-a-led-driver-for-uv-systems include/asm-x86/uv/uv_hub.h
--- a/include/asm-x86/uv/uv_hub.h~x86_64-uv-provide-a-led-driver-for-uv-systems
+++ a/include/asm-x86/uv/uv_hub.h
@@ -123,6 +123,7 @@ struct uv_hub_info_s {
 	unsigned long	gnode_upper;
 	unsigned long	lowmem_remap_top;
 	unsigned long	lowmem_remap_base;
+	unsigned long	led_offset;
 	unsigned short	pnode;
 	unsigned short	pnode_mask;
 	unsigned short	coherency_domain_number;
@@ -130,6 +131,7 @@ struct uv_hub_info_s {
 	unsigned char	blade_processor_id;
 	unsigned char	m_val;
 	unsigned char	n_val;
+	unsigned char	led_state;
 };
 DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 #define uv_hub_info 		(&__get_cpu_var(__uv_hub_info))
@@ -161,6 +163,19 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 	((unsigned long)(p) << UV_GLOBAL_MMR64_PNODE_SHIFT)
 
 #define UV_APIC_PNODE_SHIFT	6
+/* Local Bus from cpu's perspective */
+#define LOCAL_BUS_BASE		0x1c00000
+#define LOCAL_BUS_SIZE		(4 * 1024 * 1024)
+
+/* LED windows - located at top of ACPI MMR space */
+#define LED_WINDOW_COUNT	64
+#define LED_LOCAL_MMR_BASE	(LOCAL_BUS_BASE + LOCAL_BUS_SIZE - \
+							LED_WINDOW_COUNT)
+
+#define LED_CPU_HEARTBEAT	0x01	/* timer interrupt */
+#define LED_CPU_ACTIVITY	0x02	/* not idle */
+#define LED_CPU_BLINK		0xffff	/* blink led */
+#define LED_CPU_HB_INTERVAL	(HZ/2)	/* blink once per second */
 
 /*
  * Macros for converting between kernel virtual addresses, socket local physical
@@ -276,6 +291,16 @@ static inline void uv_write_local_mmr(un
 	*uv_local_mmr_address(offset) = val;
 }
 
+static inline unsigned char uv_read_local_mmr8(unsigned long offset)
+{
+	return *((unsigned char *)uv_local_mmr_address(offset));
+}
+
+static inline void uv_write_local_mmr8(unsigned long offset, unsigned char val)
+{
+	*((unsigned char *)uv_local_mmr_address(offset)) = val;
+}
+
 /*
  * Structures and definitions for converting between cpu, node, pnode, and blade
  * numbers.
@@ -350,5 +375,38 @@ static inline int uv_num_possible_blades
 	return uv_possible_blades;
 }
 
-#endif /* __ASM_X86_UV_HUB__ */
+/* Light up the leds */
+static inline void uv_set_led_bits(unsigned short value, unsigned char mask)
+{
+	unsigned char state = uv_hub_info->led_state;
+
+	if (value == LED_CPU_BLINK)
+		state ^= mask;
+	else
+		state = (state & ~mask) | (value & mask);
 
+	if (uv_hub_info->led_state != state) {
+		uv_hub_info->led_state = state;
+		uv_write_local_mmr8(uv_hub_info->led_offset, state);
+	}
+}
+
+/* Light up the leds */
+static inline void uv_set_led_bits_on(int cpu, unsigned short value,
+					       unsigned char mask)
+
+{
+	unsigned char state = uv_cpu_hub_info(cpu)->led_state;
+
+	if (value == LED_CPU_BLINK)
+		state ^= mask;
+	else
+		state = (state & ~mask) | (value & mask);
+
+	if (uv_cpu_hub_info(cpu)->led_state != state) {
+		uv_cpu_hub_info(cpu)->led_state = state;
+		uv_write_local_mmr8(uv_cpu_hub_info(cpu)->led_offset, state);
+	}
+}
+
+#endif /* __ASM_X86_UV_HUB__ */
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

