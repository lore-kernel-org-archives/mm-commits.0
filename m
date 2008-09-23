From: akpm@linux-foundation.org
Subject: - ia64-uv-provide-a-led-driver-for-uv-systems.patch removed from -mm tree
Date: Mon, 22 Sep 2008 18:43:19 -0700
Message-ID: <200809230143.m8N1hJkc008794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469AbYIWBnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 21:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64 UV: provide a LED driver for UV Systems
has been removed from the -mm tree.  Its filename was
     ia64-uv-provide-a-led-driver-for-uv-systems.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64 UV: provide a LED driver for UV Systems
From: Mike Travis <travis@sgi.com>

  * Add base functionality for writing to the LED's on
    the ia64 UV architecture.

Note that this is a RAS feature that allows external monitoring of
various cpu state indicators, not just providing "pretty blinking
lights", as the LED state is readable by the system controller.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/uv/uv_hub.h |   61 +++++++++++++++++++++++++++-
 arch/ia64/uv/kernel/setup.c       |    2 
 2 files changed, 62 insertions(+), 1 deletion(-)

diff -puN arch/ia64/include/asm/uv/uv_hub.h~ia64-uv-provide-a-led-driver-for-uv-systems arch/ia64/include/asm/uv/uv_hub.h
--- a/arch/ia64/include/asm/uv/uv_hub.h~ia64-uv-provide-a-led-driver-for-uv-systems
+++ a/arch/ia64/include/asm/uv/uv_hub.h
@@ -99,6 +99,7 @@ struct uv_hub_info_s {
 	unsigned long	gnode_upper;
 	unsigned long	lowmem_remap_top;
 	unsigned long	lowmem_remap_base;
+	unsigned long	led_offset;
 	unsigned short	pnode;
 	unsigned short	pnode_mask;
 	unsigned short	coherency_domain_number;
@@ -106,6 +107,7 @@ struct uv_hub_info_s {
 	unsigned char	blade_processor_id;
 	unsigned char	m_val;
 	unsigned char	n_val;
+	unsigned char	led_state;
 };
 DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 #define uv_hub_info 		(&__get_cpu_var(__uv_hub_info))
@@ -134,6 +136,20 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 #define UV_GLOBAL_MMR64_PNODE_BITS(p)					\
 	((unsigned long)(p) << UV_GLOBAL_MMR64_PNODE_SHIFT)
 
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
+
 /*
  * Macros for converting between kernel virtual addresses, socket local physical
  * addresses, and UV global physical addresses.
@@ -240,6 +256,16 @@ static inline void uv_write_local_mmr(un
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
@@ -305,5 +331,38 @@ static inline int uv_num_possible_blades
 	return 1;
 }
 
-#endif /* __ASM_IA64_UV_HUB__ */
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
+#endif /* __ASM_IA64_UV_HUB__ */
diff -puN arch/ia64/uv/kernel/setup.c~ia64-uv-provide-a-led-driver-for-uv-systems arch/ia64/uv/kernel/setup.c
--- a/arch/ia64/uv/kernel/setup.c~ia64-uv-provide-a-led-driver-for-uv-systems
+++ a/arch/ia64/uv/kernel/setup.c
@@ -104,6 +104,8 @@ void __init uv_setup(char **cmdline_p)
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
 		uv_cpu_hub_info(cpu)->coherency_domain_number = 0;/* ZZZ */
+		uv_cpu_hub_info(cpu)->led_offset = LED_LOCAL_MMR_BASE + lcpu;
+		uv_cpu_hub_info(cpu)->led_state = 0;
 		printk(KERN_DEBUG "UV cpu %d, nid %d\n", cpu, nid);
 	}
 }
_

Patches currently in -mm which might be from travis@sgi.com are

linux-next.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ia64-uv-provide-a-led-driver-for-uv-systems.patch
ia64-uv-use-led-to-indicate-cpu-is-active.patch
ia64-uv-use-blinking-led-for-heartbeat-display.patch
cpuset-use-seq_cpumask-seq_nodemask.patch

