From: akpm@linux-foundation.org
Subject: + memory-hotplug-x86_64-fix-section-mismatch-in-init_memory_mapping.patch added to -mm tree
Date: Thu, 15 Nov 2007 17:10:08 -0800
Message-ID: <200711160110.lAG1A8pr025222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53668 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647AbXKPBK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 20:10:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     memory hotplug x86_64: fix section mismatch in init_memory_mapping()
has been added to the -mm tree.  Its filename is
     memory-hotplug-x86_64-fix-section-mismatch-in-init_memory_mapping.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memory hotplug x86_64: fix section mismatch in init_memory_mapping()
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Changes __meminit to __init_refok.
==
WARNING: vmlinux.o(.text+0x1d07c): Section mismatch: reference to
.init.text:find_e820_area (between 'init_memory_mapping' and 'arch_add_memory')
==

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/init_64.c~memory-hotplug-x86_64-fix-section-mismatch-in-init_memory_mapping arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~memory-hotplug-x86_64-fix-section-mismatch-in-init_memory_mapping
+++ a/arch/x86/mm/init_64.c
@@ -345,7 +345,7 @@ static void __init find_early_table_spac
 /* Setup the direct mapping of the physical memory at PAGE_OFFSET.
    This runs before bootmem is initialized and gets pages directly from the 
    physical memory. To access them they are temporarily mapped. */
-void __meminit init_memory_mapping(unsigned long start, unsigned long end)
+void __init_refok init_memory_mapping(unsigned long start, unsigned long end)
 { 
 	unsigned long next; 
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memory-hotplug-fix-fix-section-mismatch-in-vmammap_allock_block.patch
memory-hotplug-x86_64-fix-section-mismatch-in-init_memory_mapping.patch
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
