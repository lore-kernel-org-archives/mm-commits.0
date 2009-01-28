From: akpm@linux-foundation.org
Subject: + sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch added to -mm tree
Date: Tue, 27 Jan 2009 16:24:54 -0800
Message-ID: <200901280024.n0S0OsnU004508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbZA1AZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 19:25:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     sgi-gru: add macros for using the UV hub to send interrupts
has been added to the -mm tree.  Its filename is
     sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch

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

 arch/ia64/include/asm/uv/uv_hub.h |    6 ++++++
 arch/x86/include/asm/uv/uv_hub.h  |   12 ++++++++++++
 arch/x86/kernel/genx2apic_uv_x.c  |    9 ++-------
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
@@ -16,6 +16,7 @@
 #include <linux/timer.h>
 #include <asm/types.h>
 #include <asm/percpu.h>
+#include <asm/uv/uv_mmrs.h>
 
 
 /*
@@ -401,4 +402,15 @@ static inline void uv_set_cpu_scir_bits(
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
+
 #endif /* _ASM_X86_UV_UV_HUB_H */
diff -puN arch/x86/kernel/genx2apic_uv_x.c~sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts arch/x86/kernel/genx2apic_uv_x.c
--- a/arch/x86/kernel/genx2apic_uv_x.c~sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts
+++ a/arch/x86/kernel/genx2apic_uv_x.c
@@ -114,17 +114,12 @@ int uv_wakeup_secondary(int phys_apicid,
 
 static void uv_send_IPI_one(int cpu, int vector)
 {
-	unsigned long val, apicid, lapicid;
+	unsigned long apicid;
 	int pnode;
 
 	apicid = per_cpu(x86_cpu_to_apicid, cpu);
-	lapicid = apicid & 0x3f;		/* ZZZ macro needed */
 	pnode = uv_apicid_to_pnode(apicid);
-	val =
-	    (1UL << UVH_IPI_INT_SEND_SHFT) | (lapicid <<
-					      UVH_IPI_INT_APIC_ID_SHFT) |
-	    (vector << UVH_IPI_INT_VECTOR_SHFT);
-	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
+	uv_hub_send_ipi(pnode, apicid, vector);
 }
 
 static void uv_send_IPI_mask(const struct cpumask *mask, int vector)
_

Patches currently in -mm which might be from steiner@sgi.com are

sgi-gru-add-definitions-of-x86_64-gru-mmrs.patch
sgi-gru-add-definitions-of-ia64-gru-mmrs.patch
sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch
sgi-gru-misc-gru-cleanup.patch
sgi-gru-improvements-to-gru-debug-messages-statistics.patch
sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions.patch
sgi-gru-add-statistics-to-the-gru-context-management-functions.patch
sgi-gru-add-support-for-a-user-to-explicitly-unload-a-gru-context.patch
sgi-gru-asid-context-management-bug-fixes.patch
sgi-gru-restructure-the-gru-vtop-functions.patch
sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts.patch
sgi-gru-macro-for-scanning-all-gru-chiplets.patch
sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver.patch
sgi-gru-support-multiple-pagesizes-in-gru.patch

