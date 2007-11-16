From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-fix-section-mismatch-in-vmammap_allock_block.patch added to -mm tree
Date: Thu, 15 Nov 2007 16:55:07 -0800
Message-ID: <200711160055.lAG0t7MK024703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34785 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758030AbXKPAzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 19:55:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, apw@shadowen.org, kamalesh@linux.vnet.ibm.com


The patch titled
     memory hotplug fix: fix section mismatch in vmammap_allock_block()
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-fix-section-mismatch-in-vmammap_allock_block.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memory hotplug fix: fix section mismatch in vmammap_allock_block()
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Fixes section mismatch below.

WARNING: vmlinux.o(.text+0x946b5): Section mismatch: reference to .init.text:'
__alloc_bootmem_node (between 'vmemmap_alloc_block' and 'vmemmap_pgd_populate')

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/sparse-vmemmap.c~memory-hotplug-fix-fix-section-mismatch-in-vmammap_allock_block mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~memory-hotplug-fix-fix-section-mismatch-in-vmammap_allock_block
+++ a/mm/sparse-vmemmap.c
@@ -34,6 +34,16 @@
  * or to back the page tables that are used to create the mapping.
  * Uses the main allocators if they are available, else bootmem.
  */
+
+static void * __init_refok __earlyonly_bootmem_alloc(int node,
+				unsigned long size,
+				unsigned long align,
+				unsigned long goal)
+{
+	return __alloc_bootmem_node(NODE_DATA(node), size, align, goal);
+}
+
+
 void * __meminit vmemmap_alloc_block(unsigned long size, int node)
 {
 	/* If the main allocator is up use that, fallback to bootmem. */
@@ -44,7 +54,7 @@ void * __meminit vmemmap_alloc_block(uns
 			return page_address(page);
 		return NULL;
 	} else
-		return __alloc_bootmem_node(NODE_DATA(node), size, size,
+		return __earlyonly_bootmem_alloc(node, size, size,
 				__pa(MAX_DMA_ADDRESS));
 }
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memory-hotplug-fix-fix-section-mismatch-in-vmammap_allock_block.patch
git-x86-memory_add_physaddr_to_nid-export-for-acpi-memhotplugko.patch
git-x86-memory_add_physaddr_to_nid-export-for-acpi-memhotplugko-checkpatch-fixes.patch
swapoff-scan-ptes-preemptibly.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
add-remove_memory-for-ppc64-2.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
