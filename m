From: akpm@linux-foundation.org
Subject: - use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch removed from -mm tree
Date: Wed, 28 Mar 2007 13:19:28 -0700
Message-ID: <200703282019.l2SKJSmZ019189@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57980 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965763AbXC1UTm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 16:19:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, ak@suse.de, ebiederm@xmission.com, horms@verge.net.au, tony.luck@intel.com, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Use the APIC to determine the hardware processor id - x86_64
has been removed from the -mm tree.  Its filename was
     use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch

This patch was dropped because it was folded into remove-hardcoding-of-hard_smp_processor_id-on-up.patch

------------------------------------------------------
Subject: Use the APIC to determine the hardware processor id - x86_64
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Use the APIC to determine the hardware processor id in both UP and SMP
kernels.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Andi Kleen <ak@suse.de>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/smp.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/asm-x86_64/smp.h~use-the-apic-to-determine-the-hardware-processor-id-x86_64 include/asm-x86_64/smp.h
--- a/include/asm-x86_64/smp.h~use-the-apic-to-determine-the-hardware-processor-id-x86_64
+++ a/include/asm-x86_64/smp.h
@@ -57,12 +57,6 @@ static inline int num_booting_cpus(void)
 
 #define raw_smp_processor_id() read_pda(cpunumber)
 
-static inline int hard_smp_processor_id(void)
-{
-	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_ID(*(unsigned int *)(APIC_BASE+APIC_ID));
-}
-
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
 extern void prefill_possible_map(void);
@@ -71,7 +65,13 @@ extern unsigned __cpuinitdata disabled_c
 
 #define NO_PROC_ID		0xFF		/* No processor magic marker */
 
-#endif
+#endif /* CONFIG_SMP */
+
+static inline int hard_smp_processor_id(void)
+{
+	/* we don't want to mark this access volatile - bad code generation */
+	return GET_APIC_ID(*(unsigned int *)(APIC_BASE+APIC_ID));
+}
 
 /*
  * Some lowlevel functions might want to know about
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

always-ask-the-hardware-to-obtain-hardware-processor.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
