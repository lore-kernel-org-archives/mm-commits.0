From: akpm@osdl.org
Subject: + i386-move-startup_32-in-texthead-section.patch added to -mm tree
Date: Tue, 19 Dec 2006 12:14:09 -0800
Message-ID: <200612192014.kBJKE95a009119@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59734 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932901AbWLSUOS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 15:14:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgoyal@in.ibm.com


The patch titled
     i386: move startup_32() in text.head section
has been added to the -mm tree.  Its filename is
     i386-move-startup_32-in-texthead-section.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: move startup_32() in text.head section
From: Vivek Goyal <vgoyal@in.ibm.com>

o Entry startup_32 was in .text section but it was accessing some init
  data too and it prompts MODPOST to generate compilation warnings.

WARNING: vmlinux - Section mismatch: reference to .init.data:boot_params from
.text between '_text' (at offset 0xc0100029) and 'startup_32_smp'
WARNING: vmlinux - Section mismatch: reference to .init.data:boot_params from
.text between '_text' (at offset 0xc0100037) and 'startup_32_smp'
WARNING: vmlinux - Section mismatch: reference to
.init.data:init_pg_tables_end from .text between '_text' (at offset
0xc0100099) and 'startup_32_smp'

o Can't move startup_32 to .init.text as this entry point has to be at the
  start of bzImage. Hence moved startup_32 to a new section .text.head and
  instructed MODPOST to not to generate warnings if init data is being
  accessed from .text.head section. This code has been audited.

o SMP boot up code (startup_32_smp) can go into .init.text if CPU hotplug
  is not supported. Otherwise it generates more warnings

WARNING: vmlinux - Section mismatch: reference to .init.data:new_cpu_data from
.text between 'checkCPUtype' (at offset 0xc0100126) and 'is486'
WARNING: vmlinux - Section mismatch: reference to .init.data:new_cpu_data from
.text between 'checkCPUtype' (at offset 0xc0100130) and 'is486'

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/head.S        |   17 ++++++++++++++---
 arch/i386/kernel/vmlinux.lds.S |    7 ++++++-
 scripts/mod/modpost.c          |   10 +++++++++-
 3 files changed, 29 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/head.S~i386-move-startup_32-in-texthead-section arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S~i386-move-startup_32-in-texthead-section
+++ a/arch/i386/kernel/head.S
@@ -53,6 +53,7 @@
  * any particular GDT layout, because we load our own as soon as we
  * can.
  */
+.section .text.head
 ENTRY(startup_32)
 
 #ifdef CONFIG_PARAVIRT
@@ -141,16 +142,25 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	jb 10b
 	movl %edi,(init_pg_tables_end - __PAGE_OFFSET)
 
-#ifdef CONFIG_SMP
 	xorl %ebx,%ebx				/* This is the boot CPU (BSP) */
 	jmp 3f
-
 /*
  * Non-boot CPU entry point; entered from trampoline.S
  * We can't lgdt here, because lgdt itself uses a data segment, but
  * we know the trampoline has already loaded the boot_gdt_table GDT
  * for us.
+ *
+ * If cpu hotplug is not supported then this code can go in init section
+ * which will be freed later
  */
+
+#ifdef CONFIG_HOTPLUG_CPU
+.section .text
+#else
+.section .init.text
+#endif
+
+#ifdef CONFIG_SMP
 ENTRY(startup_32_smp)
 	cld
 	movl $(__BOOT_DS),%eax
@@ -208,8 +218,8 @@ ENTRY(startup_32_smp)
 	xorl %ebx,%ebx
 	incl %ebx
 
-3:
 #endif /* CONFIG_SMP */
+3:
 
 /*
  * Enable paging
@@ -492,6 +502,7 @@ ignore_int:
 #endif
 	iret
 
+.section .text
 #ifdef CONFIG_PARAVIRT
 startup_paravirt:
 	cld
diff -puN arch/i386/kernel/vmlinux.lds.S~i386-move-startup_32-in-texthead-section arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~i386-move-startup_32-in-texthead-section
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -38,9 +38,14 @@ SECTIONS
 {
   . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
   phys_startup_32 = startup_32 - LOAD_OFFSET;
+
+  .text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
+  	_text = .;			/* Text and read-only data */
+	*(.text.head)
+  } :text = 0x9090
+
   /* read-only */
   .text : AT(ADDR(.text) - LOAD_OFFSET) {
-  	_text = .;			/* Text and read-only data */
 	*(.text)
 	SCHED_TEXT
 	LOCK_TEXT
diff -puN scripts/mod/modpost.c~i386-move-startup_32-in-texthead-section scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~i386-move-startup_32-in-texthead-section
+++ a/scripts/mod/modpost.c
@@ -623,11 +623,19 @@ static int secref_whitelist(const char *
 	if (f1 && f2)
 		return 1;
 
-	/* Whitelist all references from .pci_fixup section if vmlinux */
+	/* Whitelist all references from .pci_fixup section if vmlinux
+	 * Whitelist all refereces from .text.head to .init.data if vmlinux
+	 * Whitelist all refereces from .text.head to .init.text if vmlinux
+	 */
 	if (is_vmlinux(modname)) {
 		if ((strcmp(fromsec, ".pci_fixup") == 0) &&
 		    (strcmp(tosec, ".init.text") == 0))
 		return 1;
+
+		if ((strcmp(fromsec, ".text.head") == 0) &&
+			((strcmp(tosec, ".init.data") == 0) ||
+			(strcmp(tosec, ".init.text") == 0)))
+		return 1;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

i386-cpu-hotplug-smpboot-misc-modpost-warning-fixes.patch
convert-some-functions-to-__init-to-avoid-modpost-warnings.patch
i386-move-startup_32-in-texthead-section.patch
break-init-in-two-parts-to-avoid-modpost-warnings.patch
i386-fix-memory-hotplug-related-modpost-generated-warning.patch
clockevents-i386-drivers.patch

