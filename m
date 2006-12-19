From: akpm@osdl.org
Subject: + convert-some-functions-to-__init-to-avoid-modpost-warnings.patch added to -mm tree
Date: Tue, 19 Dec 2006 12:14:07 -0800
Message-ID: <200612192014.kBJKE7Bw009116@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59735 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940AbWLSUOV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 15:14:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgoyal@in.ibm.com


The patch titled
     Convert some functions to __init to avoid MODPOST warnings
has been added to the -mm tree.  Its filename is
     convert-some-functions-to-__init-to-avoid-modpost-warnings.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Convert some functions to __init to avoid MODPOST warnings
From: Vivek Goyal <vgoyal@in.ibm.com>

o Some functions which should have been in init sections as they are called
  only once. Put them in init sections. Otherwise MODPOST generates warning
  as these functions are placed in .text and they end up accessing something
  in init sections.

WARNING: vmlinux - Section mismatch: reference to .init.text:migration_init
from .text between 'do_pre_smp_initcalls' (at offset 0xc01000d1) and
'run_init_process'

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/acpi/boot.c |    2 +-
 arch/i386/kernel/setup.c     |    2 +-
 init/main.c                  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/acpi/boot.c~convert-some-functions-to-__init-to-avoid-modpost-warnings arch/i386/kernel/acpi/boot.c
--- a/arch/i386/kernel/acpi/boot.c~convert-some-functions-to-__init-to-avoid-modpost-warnings
+++ a/arch/i386/kernel/acpi/boot.c
@@ -333,7 +333,7 @@ acpi_parse_ioapic(acpi_table_entry_heade
 /*
  * Parse Interrupt Source Override for the ACPI SCI
  */
-static void acpi_sci_ioapic_setup(u32 gsi, u16 polarity, u16 trigger)
+static void __init acpi_sci_ioapic_setup(u32 gsi, u16 polarity, u16 trigger)
 {
 	if (trigger == 0)	/* compatible SCI trigger is level */
 		trigger = 3;
diff -puN arch/i386/kernel/setup.c~convert-some-functions-to-__init-to-avoid-modpost-warnings arch/i386/kernel/setup.c
--- a/arch/i386/kernel/setup.c~convert-some-functions-to-__init-to-avoid-modpost-warnings
+++ a/arch/i386/kernel/setup.c
@@ -496,7 +496,7 @@ static void set_mca_bus(int x) { }
 #endif
 
 /* Overridden in paravirt.c if CONFIG_PARAVIRT */
-char * __attribute__((weak)) memory_setup(void)
+char * __init __attribute__((weak)) memory_setup(void)
 {
 	return machine_specific_memory_setup();
 }
diff -puN init/main.c~convert-some-functions-to-__init-to-avoid-modpost-warnings init/main.c
--- a/init/main.c~convert-some-functions-to-__init-to-avoid-modpost-warnings
+++ a/init/main.c
@@ -698,7 +698,7 @@ static void __init do_basic_setup(void)
 	do_initcalls();
 }
 
-static void do_pre_smp_initcalls(void)
+static void __init do_pre_smp_initcalls(void)
 {
 	extern int spawn_ksoftirqd(void);
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

i386-cpu-hotplug-smpboot-misc-modpost-warning-fixes.patch
convert-some-functions-to-__init-to-avoid-modpost-warnings.patch
i386-move-startup_32-in-texthead-section.patch
break-init-in-two-parts-to-avoid-modpost-warnings.patch
i386-fix-memory-hotplug-related-modpost-generated-warning.patch
clockevents-i386-drivers.patch

