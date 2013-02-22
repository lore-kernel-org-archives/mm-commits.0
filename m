From: akpm@linux-foundation.org
Subject: [folded-merged] memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:35:56 -0800
Message-ID: <20130222233556.EEF5731C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:38978 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab3BVXf6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:35:58 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so120230qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:35:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com, linfeng@cn.fujitsu.com, mhocko@suse.cz, tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix-fix.patch

This patch was dropped because it was folded into memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix-fix

Fixes

mm/memory_hotplug.c:133:13: warning: 'register_page_bootmem_info_section' defined but not used [-Wunused-function]

by defining the function only in configurations where it is used.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix-fix
+++ a/mm/memory_hotplug.c
@@ -127,6 +127,7 @@ void __ref put_page_bootmem(struct page 
 
 }
 
+#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
 static void register_page_bootmem_info_section(unsigned long start_pfn)
 {
@@ -161,7 +162,7 @@ static void register_page_bootmem_info_s
 		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
 
 }
-#else
+#else /* CONFIG_SPARSEMEM_VMEMMAP */
 static void register_page_bootmem_info_section(unsigned long start_pfn)
 {
 	unsigned long *usemap, mapsize, section_nr, i;
@@ -186,9 +187,8 @@ static void register_page_bootmem_info_s
 	for (i = 0; i < mapsize; i++, page++)
 		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
 }
-#endif
+#endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
-#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 void register_page_bootmem_info_node(struct pglist_data *pgdat)
 {
 	unsigned long i, pfn, end_pfn, nr_pages;
@@ -230,7 +230,7 @@ void register_page_bootmem_info_node(str
 			register_page_bootmem_info_section(pfn);
 	}
 }
-#endif
+#endif /* CONFIG_HAVE_BOOTMEM_INFO_NODE */
 
 static void grow_zone_span(struct zone *zone, unsigned long start_pfn,
 			   unsigned long end_pfn)
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
memcg-oom-provide-more-precise-dump-info-while-memcg-oom-happening.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-huge_memory-use-new-hashtable-implementation.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
memory-hotplug-export-the-function-try_offline_node.patch
memory-hotplug-export-the-function-try_offline_node-fix.patch
cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
sched-do-not-use-cpu_to_node-to-find-an-offlined-cpus-node.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
mm-use-numa_no_node.patch

