From: akpm@linux-foundation.org
Subject: + add-ioresouce_busy-flag-for-system-ram.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:55:23 -0800
Message-ID: <200711060255.lA62tNiS032724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40899 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938AbXKFC6g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:58:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, mingo@elte.hu, pbadari@us.ibm.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     Add IORESOUCE_BUSY flag for System RAM
has been added to the -mm tree.  Its filename is
     add-ioresouce_busy-flag-for-system-ram.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add IORESOUCE_BUSY flag for System RAM
From: Yasunori Goto <y-goto@jp.fujitsu.com>

i386 and x86-64 registers System RAM as IORESOURCE_MEM | IORESOURCE_BUSY.

But ia64 registers it as IORESOURCE_MEM only.
In addition, memory hotplug code registers new memory as IORESOURCE_MEM too.

This difference causes a failure of memory unplug of x86-64.  This patch
fixes it.

This patch adds IORESOURCE_BUSY to avoid potential overlap mapping by PCI
device.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Luck, Tony" <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c |    6 ++----
 kernel/resource.c      |    2 +-
 mm/memory_hotplug.c    |    2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff -puN arch/ia64/kernel/efi.c~add-ioresouce_busy-flag-for-system-ram arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~add-ioresouce_busy-flag-for-system-ram
+++ a/arch/ia64/kernel/efi.c
@@ -1112,7 +1112,7 @@ efi_initialize_iomem_resources(struct re
 		if (md->num_pages == 0) /* should not happen */
 			continue;
 
-		flags = IORESOURCE_MEM;
+		flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 		switch (md->type) {
 
 			case EFI_MEMORY_MAPPED_IO:
@@ -1134,12 +1134,11 @@ efi_initialize_iomem_resources(struct re
 
 			case EFI_ACPI_MEMORY_NVS:
 				name = "ACPI Non-volatile Storage";
-				flags |= IORESOURCE_BUSY;
 				break;
 
 			case EFI_UNUSABLE_MEMORY:
 				name = "reserved";
-				flags |= IORESOURCE_BUSY | IORESOURCE_DISABLED;
+				flags |= IORESOURCE_DISABLED;
 				break;
 
 			case EFI_RESERVED_TYPE:
@@ -1148,7 +1147,6 @@ efi_initialize_iomem_resources(struct re
 			case EFI_ACPI_RECLAIM_MEMORY:
 			default:
 				name = "reserved";
-				flags |= IORESOURCE_BUSY;
 				break;
 		}
 
diff -puN kernel/resource.c~add-ioresouce_busy-flag-for-system-ram kernel/resource.c
--- a/kernel/resource.c~add-ioresouce_busy-flag-for-system-ram
+++ a/kernel/resource.c
@@ -277,7 +277,7 @@ walk_memory_resource(unsigned long start
 	int ret = -1;
 	res.start = (u64) start_pfn << PAGE_SHIFT;
 	res.end = ((u64)(start_pfn + nr_pages) << PAGE_SHIFT) - 1;
-	res.flags = IORESOURCE_MEM;
+	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 	orig_end = res.end;
 	while ((res.start < res.end) && (find_next_system_ram(&res) >= 0)) {
 		pfn = (unsigned long)(res.start >> PAGE_SHIFT);
diff -puN mm/memory_hotplug.c~add-ioresouce_busy-flag-for-system-ram mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~add-ioresouce_busy-flag-for-system-ram
+++ a/mm/memory_hotplug.c
@@ -39,7 +39,7 @@ static struct resource *register_memory_
 	res->name = "System RAM";
 	res->start = start;
 	res->end = start + size - 1;
-	res->flags = IORESOURCE_MEM;
+	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 	if (request_resource(&iomem_resource, res) < 0) {
 		printk("System RAM resource %llx - %llx cannot be added\n",
 		(unsigned long long)res->start, (unsigned long long)res->end);
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

add-ioresouce_busy-flag-for-system-ram.patch
