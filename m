From: akpm@linux-foundation.org
Subject: + memory-hotplug-export-the-function-try_offline_node-fix.patch added to -mm tree
Date: Thu, 24 Jan 2013 15:09:03 -0800
Message-ID: <20130124230903.A6CC65A4352@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:49660 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab3AXXJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jan 2013 18:09:05 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so163528qea.5
        for <mm-commits@vger.kernel.org>; Thu, 24 Jan 2013 15:09:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com, wency@cn.fujitsu.com


The patch titled
     Subject: memory-hotplug: export the function try_offline_node() fix
has been added to the -mm tree.  Its filename is
     memory-hotplug-export-the-function-try_offline_node-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
compiler-gcc4h-reorder-macros-based-upon-gcc-ver.patch
compiler-gcch-add-gcc-recommended-gcc_version-macro.patch
compiler-gcc34h-use-gcc_version-macro.patch
compiler-gcc4h-bugh-remove-duplicate-macros.patch
bugh-fix-build_bug_on-macro-in-__checker__.patch
bugh-prevent-double-evaulation-of-in-build_bug_on.patch
bugh-make-build_bug_on-generate-compile-time-error.patch
compilerh-bugh-prevent-double-error-messages-with-build_bug_on.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
memcg-oom-provide-more-precise-dump-info-while-memcg-oom-happening.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-huge_memory-use-new-hashtable-implementation.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch
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
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

