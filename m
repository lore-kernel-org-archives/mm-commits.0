From: akpm@linux-foundation.org
Subject: + x86-acpi-use-cpu_physical_id.patch added to -mm tree
Date: Mon, 27 Aug 2007 14:43:35 -0700
Message-ID: <200708272143.l7RLhZhV029925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933199AbXH0Vnw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 17:43:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, ak@suse.de, clameter@sgi.com, lenb@kernel.org, suresh.b.siddha@intel.com


The patch titled
     x86: acpi: use cpu_physical_id()
has been added to the -mm tree.  Its filename is
     x86-acpi-use-cpu_physical_id.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: acpi: use cpu_physical_id()
From: Mike Travis <travis@sgi.com>

This is from an earlier message from Christoph Lameter:

    processor_core.c currently tries to determine the apicid by special casing
    for IA64 and x86. The desired information is readily available via

	    cpu_physical_id()

    on IA64, i386 and x86_64.

    Signed-off-by: Christoph Lameter <clameter@sgi.com>

Additionally, boot_cpu_id needed to be exported to fix compile errors in
dma code when !CONFIG_SMP.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/mpparse.c  |    2 ++
 drivers/acpi/processor_core.c |    8 +-------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/kernel/mpparse.c~x86-acpi-use-cpu_physical_id arch/x86_64/kernel/mpparse.c
--- a/arch/x86_64/kernel/mpparse.c~x86-acpi-use-cpu_physical_id
+++ a/arch/x86_64/kernel/mpparse.c
@@ -57,6 +57,8 @@ unsigned long mp_lapic_addr = 0;
 
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_id = -1U;
+EXPORT_SYMBOL(boot_cpu_id);
+
 /* Internal processor count */
 unsigned int num_processors __cpuinitdata = 0;
 
diff -puN drivers/acpi/processor_core.c~x86-acpi-use-cpu_physical_id drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~x86-acpi-use-cpu_physical_id
+++ a/drivers/acpi/processor_core.c
@@ -420,12 +420,6 @@ static int map_lsapic_id(struct acpi_sub
 	return 0;
 }
 
-#ifdef CONFIG_IA64
-#define arch_cpu_to_apicid 	ia64_cpu_to_sapicid
-#else
-#define arch_cpu_to_apicid 	x86_cpu_to_apicid
-#endif
-
 static int map_madt_entry(u32 acpi_id)
 {
 	unsigned long madt_end, entry;
@@ -499,7 +493,7 @@ static int get_cpu_id(acpi_handle handle
 		return apic_id;
 
 	for (i = 0; i < NR_CPUS; ++i) {
-		if (arch_cpu_to_apicid[i] == apic_id)
+		if (cpu_physical_id(i) == apic_id)
 			return i;
 	}
 	return -1;
_

Patches currently in -mm which might be from travis@sgi.com are

x86-fix-cpu_to_node-references.patch
x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
x86-convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
