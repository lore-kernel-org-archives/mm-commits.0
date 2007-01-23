From: akpm@osdl.org
Subject: + i386-modpost-apic-related-warning-fixes.patch added to -mm tree
Date: Tue, 23 Jan 2007 12:19:31 -0800
Message-ID: <200701232019.l0NKJV7Y030142@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53235 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965447AbXAWUVQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 15:21:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgoyal@in.ibm.com, ak@suse.de, lenb@kernel.org


The patch titled
     i386: modpost apic related warning fixes
has been added to the -mm tree.  Its filename is
     i386-modpost-apic-related-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: modpost apic related warning fixes
From: Vivek Goyal <vgoyal@in.ibm.com>

o Modpost generates warnings for i386 if compiled with CONFIG_RELOCATABLE=y

WARNING: vmlinux - Section mismatch: reference to .init.text:find_unisys_acpi_oem_table from .text between 'acpi_madt_oem_check' (at offset 0xc0101eda) and 'enable_apic_mode'
WARNING: vmlinux - Section mismatch: reference to .init.text:acpi_get_table_header_early from .text between 'acpi_madt_oem_check' (at offset 0xc0101ef0) and 'enable_apic_mode'
WARNING: vmlinux - Section mismatch: reference to .init.text:parse_unisys_oem from .text between 'acpi_madt_oem_check' (at offset 0xc0101f2e) and 'enable_apic_mode'
WARNING: vmlinux - Section mismatch: reference to .init.text:setup_unisys from .text between 'acpi_madt_oem_check' (at offset 0xc0101f37) and 'enable_apic_mode'WARNING: vmlinux - Section mismatch: reference to .init.text:parse_unisys_oem from .text between 'mps_oem_check' (at offset 0xc0101ec7) and 'acpi_madt_oem_check'
WARNING: vmlinux - Section mismatch: reference to .init.text:es7000_sw_apic from .text between 'enable_apic_mode' (at offset 0xc0101f48) and 'check_apicid_present'

o Some functions which are inline (acpi_madt_oem_check) are not inlined by
  compiler as these functions are accessed using function pointer. These
  functions are put in .text section and they in-turn access __init type
  functions hence modpost generates warnings.

o Do not iniline acpi_madt_oem_check, instead make it __init.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/mach-generic/es7000.c             |   41 ++++++++++++++++++
 include/asm-i386/mach-es7000/mach_apic.h    |    7 ---
 include/asm-i386/mach-es7000/mach_mpparse.h |   32 --------------
 scripts/mod/modpost.c                       |    1 
 4 files changed, 42 insertions(+), 39 deletions(-)

diff -puN arch/i386/mach-generic/es7000.c~i386-modpost-apic-related-warning-fixes arch/i386/mach-generic/es7000.c
--- a/arch/i386/mach-generic/es7000.c~i386-modpost-apic-related-warning-fixes
+++ a/arch/i386/mach-generic/es7000.c
@@ -25,4 +25,45 @@ static int probe_es7000(void)
 	return 0;
 }
 
+extern void es7000_sw_apic(void);
+static void __init enable_apic_mode(void)
+{
+	es7000_sw_apic();
+	return;
+}
+
+static __init int mps_oem_check(struct mp_config_table *mpc, char *oem,
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
+
+#ifdef CONFIG_ACPI
+/* Hook from generic ACPI tables.c */
+static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
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
+static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	return 0;
+}
+#endif
+
 struct genapic apic_es7000 = APIC_INIT("es7000", probe_es7000);
diff -puN include/asm-i386/mach-es7000/mach_apic.h~i386-modpost-apic-related-warning-fixes include/asm-i386/mach-es7000/mach_apic.h
--- a/include/asm-i386/mach-es7000/mach_apic.h~i386-modpost-apic-related-warning-fixes
+++ a/include/asm-i386/mach-es7000/mach_apic.h
@@ -73,13 +73,6 @@ static inline void init_apic_ldr(void)
 	apic_write_around(APIC_LDR, val);
 }
 
-extern void es7000_sw_apic(void);
-static inline void enable_apic_mode(void)
-{
-	es7000_sw_apic();
-	return;
-}
-
 extern int apic_version [MAX_APICS];
 static inline void setup_apic_routing(void)
 {
diff -puN include/asm-i386/mach-es7000/mach_mpparse.h~i386-modpost-apic-related-warning-fixes include/asm-i386/mach-es7000/mach_mpparse.h
--- a/include/asm-i386/mach-es7000/mach_mpparse.h~i386-modpost-apic-related-warning-fixes
+++ a/include/asm-i386/mach-es7000/mach_mpparse.h
@@ -18,18 +18,6 @@ extern int parse_unisys_oem (char *oempt
 extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
 extern void setup_unisys(void);
 
-static inline int mps_oem_check(struct mp_config_table *mpc, char *oem,
-		char *productid)
-{
-	if (mpc->mpc_oemptr) {
-		struct mp_config_oemtable *oem_table = 
-			(struct mp_config_oemtable *)mpc->mpc_oemptr;
-		if (!strncmp(oem, "UNISYS", 6))
-			return parse_unisys_oem((char *)oem_table);
-	}
-	return 0;
-}
-
 #ifdef CONFIG_ACPI
 static inline int es7000_check_dsdt(void)
 {
@@ -40,26 +28,6 @@ static inline int es7000_check_dsdt(void
 		return 1;
 	return 0;
 }
-
-/* Hook from generic ACPI tables.c */
-static inline int acpi_madt_oem_check(char *oem_id, char *oem_table_id)
-{
-	unsigned long oem_addr; 
-	if (!find_unisys_acpi_oem_table(&oem_addr)) {
-		if (es7000_check_dsdt())
-			return parse_unisys_oem((char *)oem_addr);
-		else {
-			setup_unisys();
-			return 1;
-		}
-	}
-	return 0;
-}
-#else
-static inline int acpi_madt_oem_check(char *oem_id, char *oem_table_id)
-{
-	return 0;
-}
 #endif
 
 #endif /* __ASM_MACH_MPPARSE_H */
diff -puN scripts/mod/modpost.c~i386-modpost-apic-related-warning-fixes scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~i386-modpost-apic-related-warning-fixes
+++ a/scripts/mod/modpost.c
@@ -606,6 +606,7 @@ static int secref_whitelist(const char *
 		"_probe",
 		"_probe_one",
 		"_console",
+		"apic_es7000",
 		NULL
 	};
 
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

kdump-documentation-update-for-2620-kexec-tools-update.patch
kdump-documentation-update-for-2620-ia64-portion.patch
i386-modpost-apic-related-warning-fixes.patch
clockevents-i386-drivers.patch
