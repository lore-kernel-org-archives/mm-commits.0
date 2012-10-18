From: akpm@linux-foundation.org
Subject: + memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch added to -mm tree
Date: Thu, 18 Oct 2012 15:31:18 -0700
Message-ID: <20121018223119.C9E6A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:35264 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2JRWbX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 18:31:23 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so385941eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 15:31:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, benh@kernel.crashing.org, cl@linux.com, dave@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, len.brown@intel.com, liuj97@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, paulus@samba.org, rientjes@google.com


The patch titled
     Subject: memory-hotplug: update mce_bad_pages when removing the memory
has been added to the -mm tree.  Its filename is
     memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug: update mce_bad_pages when removing the memory

When we hotremove a memory device, we will free the memory to store struct
page.  If the page is hwpoisoned page, we should decrease mce_bad_pages.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN mm/sparse.c~memory-hotplug-update-mce_bad_pages-when-removing-the-memory mm/sparse.c
--- a/mm/sparse.c~memory-hotplug-update-mce_bad_pages-when-removing-the-memory
+++ a/mm/sparse.c
@@ -773,6 +773,23 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_MEMORY_FAILURE
+static void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
+{
+	int i;
+
+	if (!memmap)
+		return;
+
+	for (i = 0; i < PAGES_PER_SECTION; i++) {
+		if (PageHWPoison(&memmap[i])) {
+			atomic_long_sub(1, &mce_bad_pages);
+			ClearPageHWPoison(&memmap[i]);
+		}
+	}
+}
+#endif
+
 void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
 {
 	struct page *memmap = NULL;
@@ -786,6 +803,10 @@ void sparse_remove_one_section(struct zo
 		ms->pageblock_flags = NULL;
 	}
 
+#ifdef CONFIG_MEMORY_FAILURE
+	clear_hwpoisoned_pages(memmap, PAGES_PER_SECTION);
+#endif
+
 	free_section_usemap(memmap, usemap);
 }
 #endif
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch

