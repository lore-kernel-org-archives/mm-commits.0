From: akpm@linux-foundation.org
Subject: + memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch added to -mm tree
Date: Fri, 05 Oct 2012 14:09:45 -0700
Message-ID: <20121005210946.A7E4F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:48989 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810Ab2JEVJv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 17:09:51 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so99987lah.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 14:09:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: isimatu.yasuaki@jp.fujitsu.com, akpm@linux-foundation.org, benh@kernel.crashing.org, cl@linux.com, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, len.brown@intel.com, liuj97@gmail.com, minchan.kim@gmail.com, nfont@austin.ibm.com, paulus@samba.org, pbadari@us.ibm.com, rientjes@google.com, wency@cn.fujitsu.com, y-goto@jp.fujitsu.com


The patch titled
     Subject: memory-hotplug: suppress "Trying to free nonexistent resource <XXXXXXXXXXXXXXXX-YYYYYYYYYYYYYYYY>" warning
has been added to the -mm tree.  Its filename is
     memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: memory-hotplug: suppress "Trying to free nonexistent resource <XXXXXXXXXXXXXXXX-YYYYYYYYYYYYYYYY>" warning

When our x86 box calls __remove_pages(), release_mem_region() shows many
warnings.  And x86 box cannot unregister iomem_resource.

"Trying to free nonexistent resource <XXXXXXXXXXXXXXXX-YYYYYYYYYYYYYYYY>"

release_mem_region() has been changed to be called in each
PAGES_PER_SECTION by de7f0cba96786c ("memory hotplug: release memory
regions in PAGES_PER_SECTION chunks").  Because powerpc registers
iomem_resource in each PAGES_PER_SECTION chunk.  But when I hot add memory
on x86 box, iomem_resource is register in each _CRS not PAGES_PER_SECTION
chunk.  So x86 box unregisters iomem_resource.

The patch fixes the problem.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/hotplug-memory.c |   13 +++++++++----
 mm/memory_hotplug.c                             |    4 ++--
 2 files changed, 11 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/platforms/pseries/hotplug-memory.c~memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning arch/powerpc/platforms/pseries/hotplug-memory.c
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c~memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning
+++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -77,7 +77,8 @@ static int pseries_remove_memblock(unsig
 {
 	unsigned long start, start_pfn;
 	struct zone *zone;
-	int ret;
+	int i, ret;
+	int sections_to_remove;
 
 	start_pfn = base >> PAGE_SHIFT;
 
@@ -97,9 +98,13 @@ static int pseries_remove_memblock(unsig
 	 * to sysfs "state" file and we can't remove sysfs entries
 	 * while writing to it. So we have to defer it to here.
 	 */
-	ret = __remove_pages(zone, start_pfn, memblock_size >> PAGE_SHIFT);
-	if (ret)
-		return ret;
+	sections_to_remove = (memblock_size >> PAGE_SHIFT) / PAGES_PER_SECTION;
+	for (i = 0; i < sections_to_remove; i++) {
+		unsigned long pfn = start_pfn + i * PAGES_PER_SECTION;
+		ret = __remove_pages(zone, start_pfn,  PAGES_PER_SECTION);
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * Update memory regions for memory remove
diff -puN mm/memory_hotplug.c~memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning
+++ a/mm/memory_hotplug.c
@@ -369,11 +369,11 @@ int __remove_pages(struct zone *zone, un
 	BUG_ON(phys_start_pfn & ~PAGE_SECTION_MASK);
 	BUG_ON(nr_pages % PAGES_PER_SECTION);
 
+	release_mem_region(phys_start_pfn << PAGE_SHIFT, nr_pages * PAGE_SIZE);
+
 	sections_to_remove = nr_pages / PAGES_PER_SECTION;
 	for (i = 0; i < sections_to_remove; i++) {
 		unsigned long pfn = phys_start_pfn + i*PAGES_PER_SECTION;
-		release_mem_region(pfn << PAGE_SHIFT,
-				   PAGES_PER_SECTION << PAGE_SHIFT);
 		ret = __remove_section(zone, __pfn_to_section(pfn));
 		if (ret)
 			break;
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

origin.patch
linux-next.patch
cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
memory-hotplug-build-zonelists-when-offlining-pages.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch
memory-hotplug-fix-zone-stat-mismatch.patch
memory-hotplug-preparation-to-notify-memory-blocks-state-at-memory-hot-remove.patch
memory-hotplug-update-memory-blocks-state-and-notfy-theinformation-to-userspace.patch
memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch

