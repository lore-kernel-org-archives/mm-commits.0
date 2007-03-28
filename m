From: akpm@linux-foundation.org
Subject: - use-the-apic-to-determine-the-hardware-processor-id-i386.patch removed from -mm tree
Date: Wed, 28 Mar 2007 13:19:25 -0700
Message-ID: <200703282019.l2SKJP4A019186@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58009 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965764AbXC1UUE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 16:20:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, ak@suse.de, ebiederm@xmission.com, horms@verge.net.au, tony.luck@intel.com, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Use the APIC to determine the hardware processor id - i386
has been removed from the -mm tree.  Its filename was
     use-the-apic-to-determine-the-hardware-processor-id-i386.patch

This patch was dropped because it was folded into remove-hardcoding-of-hard_smp_processor_id-on-up.patch

------------------------------------------------------
Subject: Use the APIC to determine the hardware processor id - i386
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Use the APIC to determine the hardware processor id when APIC support has been
selected, independently of whether CONFIG_SMP is set or not.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Andi Kleen <ak@suse.de>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/smp.h |   37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff -puN include/asm-i386/smp.h~use-the-apic-to-determine-the-hardware-processor-id-i386 include/asm-i386/smp.h
--- a/include/asm-i386/smp.h~use-the-apic-to-determine-the-hardware-processor-id-i386
+++ a/include/asm-i386/smp.h
@@ -71,20 +71,6 @@ static inline int num_booting_cpus(void)
 	return cpus_weight(cpu_callout_map);
 }
 
-#ifdef CONFIG_X86_LOCAL_APIC
-
-#ifdef APIC_DEFINITION
-extern int hard_smp_processor_id(void);
-#else
-#include <mach_apicdef.h>
-static inline int hard_smp_processor_id(void)
-{
-	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_ID(*(unsigned long *)(APIC_BASE+APIC_ID));
-}
-#endif
-#endif
-
 extern int safe_smp_processor_id(void);
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
@@ -99,10 +85,31 @@ extern unsigned int num_processors;
 
 #define NO_PROC_ID		0xFF		/* No processor magic marker */
 
-#endif
+#endif /* CONFIG_SMP */
 
 #ifndef __ASSEMBLY__
 
+#ifdef CONFIG_X86_LOCAL_APIC
+
+#ifdef APIC_DEFINITION
+extern int hard_smp_processor_id(void);
+#else
+#include <mach_apicdef.h>
+static inline int hard_smp_processor_id(void)
+{
+	/* we don't want to mark this access volatile - bad code generation */
+	return GET_APIC_ID(*(unsigned long *)(APIC_BASE+APIC_ID));
+}
+#endif /* APIC_DEFINITION */
+
+#else /* CONFIG_X86_LOCAL_APIC */
+
+#ifndef CONFIG_SMP
+#define hard_smp_processor_id()		0
+#endif
+
+#endif /* CONFIG_X86_LOCAL_APIC */
+
 extern u8 apicid_2_node[];
 
 #ifdef CONFIG_X86_LOCAL_APIC
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

always-ask-the-hardware-to-obtain-hardware-processor.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
