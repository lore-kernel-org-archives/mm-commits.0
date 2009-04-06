From: akpm@linux-foundation.org
Subject: [merged] sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:21 -0700
Message-ID: <200904061937.n36JbLGx012882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756851AbZDFTmM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:42:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     sgi-gru: add macros for using the UV hub to send interrupts
has been removed from the -mm tree.  Its filename was
     sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-gru: add macros for using the UV hub to send interrupts
From: Jack Steiner <steiner@sgi.com>

Add macros for using the UV hub to send interrupts.  Change the IPI code
to use these macros.  These macros will also be used in additional patches
that will follow.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/uv/uv_hub.h  |    6 ++++++
 arch/x86/include/asm/uv/uv_hub.h   |   12 ++++++++++++
 arch/x86/kernel/apic/x2apic_uv_x.c |    9 ++-------
 3 files changed, 20 insertions(+), 7 deletions(-)

diff -puN arch/ia64/include/asm/uv/uv_hub.h~sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts arch/ia64/include/asm/uv/uv_hub.h
--- a/arch/ia64/include/asm/uv/uv_hub.h~sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts
+++ a/arch/ia64/include/asm/uv/uv_hub.h
@@ -305,5 +305,11 @@ static inline int uv_num_possible_blades
 	return 1;
 }
 
+static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
+{
+	/* not currently needed on ia64 */
+}
+
+
 #endif /* __ASM_IA64_UV_HUB__ */
 
diff -puN arch/x86/include/asm/uv/uv_hub.h~sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts arch/x86/include/asm/uv/uv_hub.h
--- a/arch/x86/include/asm/uv/uv_hub.h~sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts
+++ a/arch/x86/include/asm/uv/uv_hub.h
@@ -17,6 +17,7 @@
 #include <linux/timer.h>
 #include <asm/types.h>
 #include <asm/percpu.h>
+#include <asm/uv/uv_mmrs.h>
 
 
 /*
@@ -398,6 +399,7 @@ static inline void uv_set_scir_bits(unsi
 		uv_write_local_mmr8(uv_hub_info->scir.offset, value);
 	}
 }
+
 static inline void uv_set_cpu_scir_bits(int cpu, unsigned char value)
 {
 	if (uv_cpu_hub_info(cpu)->scir.state != value) {
@@ -406,5 +408,15 @@ static inline void uv_set_cpu_scir_bits(
 	}
 }
 
+static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
+{
+	unsigned long val;
+
+	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
+			((apicid & 0x3f) << UVH_IPI_INT_APIC_ID_SHFT) |
+			(vector << UVH_IPI_INT_VECTOR_SHFT);
+	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
+}
+
 #endif /* CONFIG_X86_64 */
 #endif /* _ASM_X86_UV_UV_HUB_H */
diff -puN arch/x86/kernel/apic/x2apic_uv_x.c~sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts arch/x86/kernel/apic/x2apic_uv_x.c
--- a/arch/x86/kernel/apic/x2apic_uv_x.c~sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts
+++ a/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -118,17 +118,12 @@ static int uv_wakeup_secondary(int phys_
 
 static void uv_send_IPI_one(int cpu, int vector)
 {
-	unsigned long val, apicid;
+	unsigned long apicid;
 	int pnode;
 
 	apicid = per_cpu(x86_cpu_to_apicid, cpu);
 	pnode = uv_apicid_to_pnode(apicid);
-
-	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
-	      (apicid << UVH_IPI_INT_APIC_ID_SHFT) |
-	      (vector << UVH_IPI_INT_VECTOR_SHFT);
