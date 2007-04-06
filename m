From: akpm@linux-foundation.org
Subject: + use-the-apic-to-determine-the-hardware-processor-id-i386.patch added to -mm tree
Date: Fri, 06 Apr 2007 14:33:29 -0700
Message-ID: <200704062133.l36LXTOA019545@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34984 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114AbXDFVdq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 17:33:46 -0400
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

hard_smp_processor_id used to be just a macro that hard-coded
hard_smp_processor_id to 0 in the non SMP case.  When booting non SMP kernels
on hardware where the boot ioapic id is not 0 this turns out to be a problem. 
This is happens frequently in the case of kdump and once in a great while in
the case of real hardware.

Use the APIC to determine the hardware processor id in both UP and SMP kernels
to fix this issue.

Notice that hard_smp_processor_id is only used by SMP code or by code that
works with apics so we do not need to handle the case when apics are not
present and hard_smp_processor_id should never be called there.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mach-generic/probe.c |    2 -
 include/asm-i386/smp.h         |   36 ++++++++++++++++++-------------
 2 files changed, 21 insertions(+), 17 deletions(-)

diff -puN arch/i386/mach-generic/probe.c~use-the-apic-to-determine-the-hardware-processor-id-i386 arch/i386/mach-generic/probe.c
--- a/arch/i386/mach-generic/probe.c~use-the-apic-to-determine-the-hardware-processor-id-i386
+++ a/arch/i386/mach-generic/probe.c
@@ -119,9 +119,7 @@ int __init acpi_madt_oem_check(char *oem
 	return 0;	
 }
 
-#ifdef CONFIG_SMP
 int hard_smp_processor_id(void)
 {
 	return genapic->get_apic_id(*(unsigned long *)(APIC_BASE+APIC_ID));
 }
-#endif
diff -puN include/asm-i386/smp.h~use-the-apic-to-determine-the-hardware-processor-id-i386 include/asm-i386/smp.h
--- a/include/asm-i386/smp.h~use-the-apic-to-determine-the-hardware-processor-id-i386
+++ a/include/asm-i386/smp.h
@@ -124,20 +124,6 @@ static inline int num_booting_cpus(void)
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
@@ -147,7 +133,6 @@ extern unsigned int num_processors;
 
 #else /* CONFIG_SMP */
 
-#define hard_smp_processor_id()		0
 #define safe_smp_processor_id()		0
 #define cpu_physical_id(cpu)		boot_cpu_physical_apicid
 
@@ -157,6 +142,27 @@ extern unsigned int num_processors;
 
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

remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch
