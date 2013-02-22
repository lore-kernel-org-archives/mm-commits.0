From: akpm@linux-foundation.org
Subject: [folded-merged] memory-hotplug-export-the-function-try_offline_node-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:42:54 -0800
Message-ID: <20130222234254.6834231C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:57794 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab3BVXmz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:42:55 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so120712ggn.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:42:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: export the function try_offline_node() fix
has been removed from the -mm tree.  Its filename was
     memory-hotplug-export-the-function-try_offline_node-fix.patch

This patch was dropped because it was folded into memory-hotplug-export-the-function-try_offline_node.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: memory-hotplug: export the function try_offline_node() fix

"memory-hotplug: export the function try_offline_node()" declares
try_offline_node() for CONFIG_MEMORY_HOTPLUG, but this function is only
defined for CONFIG_MEMORY_HOTREMOVE:

ERROR: "try_offline_node" [drivers/acpi/processor.ko] undefined!

Fix the build by definining it appropriately.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/memory_hotplug.h~memory-hotplug-export-the-function-try_offline_node-fix include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-export-the-function-try_offline_node-fix
+++ a/include/linux/memory_hotplug.h
@@ -193,7 +193,6 @@ extern void get_page_bootmem(unsigned lo
 
 void lock_memory_hotplug(void);
 void unlock_memory_hotplug(void);
-extern void try_offline_node(int nid);
 
 #else /* ! CONFIG_MEMORY_HOTPLUG */
 /*
@@ -228,13 +227,13 @@ static inline void register_page_bootmem
 
 static inline void lock_memory_hotplug(void) {}
 static inline void unlock_memory_hotplug(void) {}
-static inline void try_offline_node(int nid) {}
 
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
 extern int is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
+extern void try_offline_node(int nid);
 
 #else
 static inline int is_mem_section_removable(unsigned long pfn,
@@ -242,6 +241,8 @@ static inline int is_mem_section_removab
 {
 	return 0;
 }
+
+static inline void try_offline_node(int nid) {}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 extern int mem_online_node(int nid);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
memcg-oom-provide-more-precise-dump-info-while-memcg-oom-happening.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-huge_memory-use-new-hashtable-implementation.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch
memory-hotplug-export-the-function-try_offline_node.patch
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

