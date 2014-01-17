From: akpm@linux-foundation.org
Subject: + mm-nobootmem-free_all_bootmem-again-fix-fix.patch added to -mm
 tree
Date: Fri, 17 Jan 2014 13:38:48 -0800
Message-ID: <52d9a2e8.AnslcXumm1DtBNLM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaAQVit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jan 2014 16:38:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robinmholt@gmail.com, rientjes@google.com, phacht@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: + mm-nobootmem-free_all_bootmem-again-fix-fix.patch added to -mm tree
To: akpm@linux-foundation.org,phacht@linux.vnet.ibm.com,rientjes@google.com,robinmholt@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 17 Jan 2014 13:38:48 -0800


The patch titled
     Subject: mm-nobootmem-free_all_bootmem-again-fix-fix
has been added to the -mm tree.  Its filename is
     mm-nobootmem-free_all_bootmem-again-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-nobootmem-free_all_bootmem-again-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-nobootmem-free_all_bootmem-again-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-nobootmem-free_all_bootmem-again-fix-fix

cleanup

Cc: David Rientjes <rientjes@google.com>
Cc: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: Robin Holt <robinmholt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nobootmem.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN mm/nobootmem.c~mm-nobootmem-free_all_bootmem-again-fix-fix mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmem-free_all_bootmem-again-fix-fix
+++ a/mm/nobootmem.c
@@ -119,24 +119,23 @@ static unsigned long __init free_low_mem
 	phys_addr_t start, end;
 	u64 i;
 
-#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
-	phys_addr_t size;
-#endif
-
 	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
 #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+	{
+		phys_addr_t size;
 
-	/* Free memblock.reserved array if it was allocated */
-	size = get_allocated_memblock_reserved_regions_info(&start);
-	if (size)
-		count += __free_memory_core(start, start + size);
-
-	/* Free memblock.memory array if it was allocated */
-	size = get_allocated_memblock_memory_regions_info(&start);
-	if (size)
-		count += __free_memory_core(start, start + size);
+		/* Free memblock.reserved array if it was allocated */
+		size = get_allocated_memblock_reserved_regions_info(&start);
+		if (size)
+			count += __free_memory_core(start, start + size);
+
+		/* Free memblock.memory array if it was allocated */
+		size = get_allocated_memblock_memory_regions_info(&start);
+		if (size)
+			count += __free_memory_core(start, start + size);
+	}
 #endif
 
 	return count;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix-2.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
mm-print-more-details-for-bad_page-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
linux-next.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
a.patch

