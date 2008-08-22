From: akpm@linux-foundation.org
Subject: + sgi-uv-hardcode-the-tlb-flush-interrupt-system-vector.patch added to -mm tree
Date: Fri, 22 Aug 2008 12:56:50 -0700
Message-ID: <200808221956.m7MJuofl013633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174AbYHVT5l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 15:57:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cpw@sgi.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     SGI UV: hardcode the TLB flush interrupt system vector
has been added to the -mm tree.  Its filename is
     sgi-uv-hardcode-the-tlb-flush-interrupt-system-vector.patch

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
Subject: SGI UV: hardcode the TLB flush interrupt system vector
From: Cliff Wickman <cpw@sgi.com>

The UV TLB shootdown mechanism needs a system interrupt vector.

Its vector had been hardcoded as 200, but needs to moved to the reserved
system vector range so that it does not collide with some device vector.

This is still temporary until dynamic system IRQ allocation is provided.
But it will be needed when real UV hardware becomes available and runs 2.6.27.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/tlb_uv.c      |    3 ++-
 include/asm-x86/irq_vectors.h |    1 +
 include/asm-x86/uv/uv_bau.h   |    5 -----
 3 files changed, 3 insertions(+), 6 deletions(-)

diff -puN arch/x86/kernel/tlb_uv.c~sgi-uv-hardcode-the-tlb-flush-interrupt-system-vector arch/x86/kernel/tlb_uv.c
--- a/arch/x86/kernel/tlb_uv.c~sgi-uv-hardcode-the-tlb-flush-interrupt-system-vector
+++ a/arch/x86/kernel/tlb_uv.c
@@ -17,6 +17,7 @@
 #include <asm/genapic.h>
 #include <asm/idle.h>
 #include <asm/tsc.h>
+#include <asm/irq_vectors.h>
 
 #include <mach_apic.h>
 
@@ -783,7 +784,7 @@ static int __init uv_bau_init(void)
 		uv_init_blade(blade, node, cur_cpu);
 		cur_cpu += uv_blade_nr_possible_cpus(blade);
 	}
-	set_intr_gate(UV_BAU_MESSAGE, uv_bau_message_intr1);
+	alloc_intr_gate(UV_BAU_MESSAGE, uv_bau_message_intr1);
 	uv_enable_timeouts();
 
 	return 0;
diff -puN include/asm-x86/irq_vectors.h~sgi-uv-hardcode-the-tlb-flush-interrupt-system-vector include/asm-x86/irq_vectors.h
--- a/include/asm-x86/irq_vectors.h~sgi-uv-hardcode-the-tlb-flush-interrupt-system-vector
+++ a/include/asm-x86/irq_vectors.h
@@ -76,6 +76,7 @@
 #define CALL_FUNCTION_SINGLE_VECTOR	0xfb
 #define THERMAL_APIC_VECTOR		0xfa
 #define THRESHOLD_APIC_VECTOR		0xf9
+#define UV_BAU_MESSAGE			0xf8
 #define INVALIDATE_TLB_VECTOR_END	0xf7
 #define INVALIDATE_TLB_VECTOR_START	0xf0	/* f0-f7 used for TLB flush */
 
diff -puN include/asm-x86/uv/uv_bau.h~sgi-uv-hardcode-the-tlb-flush-interrupt-system-vector include/asm-x86/uv/uv_bau.h
--- a/include/asm-x86/uv/uv_bau.h~sgi-uv-hardcode-the-tlb-flush-interrupt-system-vector
+++ a/include/asm-x86/uv/uv_bau.h
@@ -40,11 +40,6 @@
 #define UV_ACTIVATION_DESCRIPTOR_SIZE	32
 #define UV_DISTRIBUTION_SIZE		256
 #define UV_SW_ACK_NPENDING		8
-#define UV_BAU_MESSAGE			200
-/*
- * Messaging irq; see irq_64.h and include/asm-x86/hw_irq_64.h
- * To be dynamically allocated in the future
- */
 #define UV_NET_ENDPOINT_INTD		0x38
 #define UV_DESC_BASE_PNODE_SHIFT	49
 #define UV_PAYLOADQ_PNODE_SHIFT		49
_

Patches currently in -mm which might be from cpw@sgi.com are

sgi-uv-hardcode-the-tlb-flush-interrupt-system-vector.patch

