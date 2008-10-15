From: akpm@linux-foundation.org
Subject: - acpi-remove-have_arch_parse_srat-in-acpih.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:14:02 -0700
Message-ID: <200810152114.m9FLE2SN005668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753407AbYJOVOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:14:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, bjorn.helgaas@hp.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: remove have_arch_parse_srat in acpi.h
has been removed from the -mm tree.  Its filename was
     acpi-remove-have_arch_parse_srat-in-acpih.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: remove have_arch_parse_srat in acpi.h
From: Yinghai Lu <yhlu.kernel@gmail.com>

This was a workaround for 32bit numa SRAT processing, and we removed those
workarounds, making 32 bit more like 64 bit.  HAVE_ARCH_PARSE_SRAT is no
longer defined anywhere.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/acpi.h |    8 --------
 1 file changed, 8 deletions(-)

diff -puN include/linux/acpi.h~acpi-remove-have_arch_parse_srat-in-acpih include/linux/acpi.h
--- a/include/linux/acpi.h~acpi-remove-have_arch_parse_srat-in-acpih
+++ a/include/linux/acpi.h
@@ -95,18 +95,10 @@ int acpi_parse_mcfg (struct acpi_table_h
 void acpi_table_print_madt_entry (struct acpi_subtable_header *madt);
 
 /* the following four functions are architecture-dependent */
-#ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
-#define NR_NODE_MEMBLKS MAX_NUMNODES
-#define acpi_numa_slit_init(slit) do {} while (0)
-#define acpi_numa_processor_affinity_init(pa) do {} while (0)
-#define acpi_numa_memory_affinity_init(ma) do {} while (0)
-#define acpi_numa_arch_fixup() do {} while (0)
-#else
 void acpi_numa_slit_init (struct acpi_table_slit *slit);
 void acpi_numa_processor_affinity_init (struct acpi_srat_cpu_affinity *pa);
 void acpi_numa_memory_affinity_init (struct acpi_srat_mem_affinity *ma);
 void acpi_numa_arch_fixup(void);
-#endif
 
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 /* Arch dependent functions for cpu hotplug support */
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

origin.patch
git-acpi.patch
mm-print-out-meminit-for-memmap.patch

