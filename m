From: akpm@linux-foundation.org
Subject: - i386-es7000-build-breakage-fix.patch removed from -mm tree
Date: Sun, 08 Jul 2007 01:11:25 -0700
Message-ID: <200707080811.l688BPrm014767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753051AbXGHILq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jul 2007 04:11:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, ak@suse.de, lenb@kernel.org, protasnb@gmail.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     i386: es7000 build breakage fix
has been removed from the -mm tree.  Its filename was
     i386-es7000-build-breakage-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: es7000 build breakage fix
From: Vivek Goyal <vgoyal@in.ibm.com>

o Commit 1833d6bc72893265f22addd79cf52e6987496e0f broke the build if
  compiled with CONFIG_ES7000=y and CONFIG_X86_GENERICARCH=n

arch/i386/kernel/built-in.o(.init.text+0x4fa9): In function `acpi_parse_madt':
: undefined reference to `acpi_madt_oem_check'
arch/i386/kernel/built-in.o(.init.text+0x7406): In function `smp_read_mpc':
: undefined reference to `mps_oem_check'
arch/i386/kernel/built-in.o(.init.text+0x8990): In function
`connect_bsp_APIC':
: undefined reference to `enable_apic_mode'
make: *** [.tmp_vmlinux1] Error 1

o Fix the build issue. Provided the definitions of missing functions.

o Don't have ES7000 machine. Only compile tested.

Cc: Len Brown <lenb@kernel.org>
Cc: Natalie Protasevich <protasnb@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mach-es7000/es7000plat.c          |   48 ++++++++++++++++++
 include/asm-i386/mach-es7000/mach_apic.h    |    4 +
 include/asm-i386/mach-es7000/mach_mpparse.h |    6 ++
 3 files changed, 58 insertions(+)

diff -puN arch/i386/mach-es7000/es7000plat.c~i386-es7000-build-breakage-fix arch/i386/mach-es7000/es7000plat.c
--- a/arch/i386/mach-es7000/es7000plat.c~i386-es7000-build-breakage-fix
+++ a/arch/i386/mach-es7000/es7000plat.c
@@ -40,6 +40,7 @@
 #include <asm/smp.h>
 #include <asm/apicdef.h>
 #include "es7000.h"
+#include <mach_mpparse.h>
 
 /*
  * ES7000 Globals
@@ -174,6 +175,53 @@ find_unisys_acpi_oem_table(unsigned long
 }
 #endif
 
+/*
+ * This file also gets compiled if CONFIG_X86_GENERICARCH is set. Generic
+ * arch already has got following function definitions (asm-generic/es7000.c)
+ * hence no need to define these for that case.
+ */
+#ifndef CONFIG_X86_GENERICARCH
+void es7000_sw_apic(void);
+void __init enable_apic_mode(void)
+{
+	es7000_sw_apic();
+	return;
+}
+
+__init int mps_oem_check(struct mp_config_table *mpc, char *oem,
+		char *productid)
+{
+	if (mpc->mpc_oemptr) {
+		struct mp_config_oemtable *oem_table =
+			(struct mp_config_oemtable *)mpc->mpc_oemptr;
+		if (!strncmp(oem, "UNISYS", 6))
+			return parse_unisys_oem((char *)oem_table);
+	}
+	return 0;
+}
+#ifdef CONFIG_ACPI
+/* Hook from generic ACPI tables.c */
+int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	unsigned long oem_addr;
+	if (!find_unisys_acpi_oem_table(&oem_addr)) {
+		if (es7000_check_dsdt())
+			return parse_unisys_oem((char *)oem_addr);
+		else {
+			setup_unisys();
+			return 1;
+		}
+	}
+	return 0;
+}
+#else
+int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	return 0;
+}
+#endif
+#endif /* COFIG_X86_GENERICARCH */
+
 static void
 es7000_spin(int n)
 {
diff -puN include/asm-i386/mach-es7000/mach_apic.h~i386-es7000-build-breakage-fix include/asm-i386/mach-es7000/mach_apic.h
--- a/include/asm-i386/mach-es7000/mach_apic.h~i386-es7000-build-breakage-fix
+++ a/include/asm-i386/mach-es7000/mach_apic.h
@@ -73,6 +73,10 @@ static inline void init_apic_ldr(void)
 	apic_write_around(APIC_LDR, val);
 }
 
+#ifndef CONFIG_X86_GENERICARCH
+extern void enable_apic_mode(void);
+#endif
+
 extern int apic_version [MAX_APICS];
 static inline void setup_apic_routing(void)
 {
diff -puN include/asm-i386/mach-es7000/mach_mpparse.h~i386-es7000-build-breakage-fix include/asm-i386/mach-es7000/mach_mpparse.h
--- a/include/asm-i386/mach-es7000/mach_mpparse.h~i386-es7000-build-breakage-fix
+++ a/include/asm-i386/mach-es7000/mach_mpparse.h
@@ -18,6 +18,12 @@ extern int parse_unisys_oem (char *oempt
 extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
 extern void setup_unisys(void);
 
+#ifndef CONFIG_X86_GENERICARCH
+extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
+extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
+				char *productid);
+#endif
+
 #ifdef CONFIG_ACPI
 
 static inline int es7000_check_dsdt(void)
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

origin.patch
fix-i-oat-for-kexec.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh-fix.patch
