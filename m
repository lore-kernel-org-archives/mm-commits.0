From: akpm@linux-foundation.org
Subject: + use-the-apic-to-determine-the-hardware-processor-id-i386.patch added to -mm tree
Date: Thu, 01 Mar 2007 15:27:05 -0800
Message-ID: <200703012327.l21NR546025757@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53736 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161150AbXCAX1Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 18:27:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, ak@suse.de, ebiederm@xmission.com, tony.luck@intel.com, vgoyal@in.ibm.com


The patch titled
     Use the APIC to determine the hardware processor id - i386
has been added to the -mm tree.  Its filename is
     use-the-apic-to-determine-the-hardware-processor-id-i386.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/smp.h |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

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
@@ -99,10 +85,23 @@ extern unsigned int num_processors;
 
 #define NO_PROC_ID		0xFF		/* No processor magic marker */
 
-#endif
+#endif /* CONFIG_SMP */
 
 #ifndef __ASSEMBLY__
 
+#ifdef CONFIG_X86_LOCAL_APIC
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
+#endif /* CONFIG_X86_LOCAL_APIC */
+
 extern u8 apicid_2_node[];
 
 #ifdef CONFIG_X86_LOCAL_APIC
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

remove-hardcoding-of-hard_smp_processor_id-on-up.patch
remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor.patch
