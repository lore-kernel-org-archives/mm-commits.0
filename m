From: akpm@linux-foundation.org
Subject: +
 mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings-fix.patch added to
 -mm tree
Date: Mon, 28 Jul 2014 15:24:45 -0700
Message-ID: <53d6cdad.9JpssCZSTDTeylf+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:58453 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaG1WYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jul 2014 18:24:46 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so1980247pdj.4
        for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2014 15:24:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings-fix
has been added to the -mm tree.  Its filename is
     mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings-fix

change everything

Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/filemap.c~mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings-fix mm/filemap.c
--- a/mm/filemap.c~mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings-fix
+++ a/mm/filemap.c
@@ -1031,8 +1031,8 @@ EXPORT_SYMBOL(find_lock_entry);
  * @mapping: the address_space to search
  * @offset: the page index
  * @fgp_flags: PCG flags
- * @cache_gfp_mask: gfp mask to use if a page is to be allocated
- * @radix_gfp_mask: gfp mask to use for page cache LRU allocation
+ * @cache_gfp_mask: gfp mask to use for the page cache data page allocation
+ * @radix_gfp_mask: gfp mask to use for radix tree node allocation
  *
  * Looks up the page cache slot at @mapping & @offset.
  *
@@ -1042,8 +1042,10 @@ EXPORT_SYMBOL(find_lock_entry);
  * FGP_LOCK: Page is return locked
  * FGP_CREAT: If page is not present then a new page is allocated using
  *		@cache_gfp_mask and added to the page cache and the VM's LRU
- *		list. The page is returned locked and with an increased
- *		refcount. Otherwise, %NULL is returned.
+ *		list. If radix tree nodes are allocated during page cache
+ *		insertion then @radix_gfp_mask is used. The page is returned
+ * 		locked and with an increased refcount. Otherwise, %NULL is
+ * 		returned.
  *
  * If FGP_LOCK or FGP_CREAT are specified then the function may sleep even
  * if the GFP flags specified for FGP_CREAT are atomic.
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-thp-do-not-allow-thp-faults-to-avoid-cpuset-restrictions.patch
mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings.patch
mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings-fix.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map.patch
mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch
mem-hotplug-improve-zone_movable_is_highmem-logic.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim-fix.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-remove-all_unreclaimable-fix.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
mm-vmscan-clean-up-struct-scan_control-v2.patch
tracing-tell-mm_migrate_pages-event-about-numa_misplaced.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-update-the-description-for-vm_total_pages.patch
mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch
mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch
mm-move-zone-pages_scanned-into-a-vmstat-counter.patch
mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch
mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch
mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch
mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch
memory-hotplug-add-zone_for_memory-for-selecting-zone-for-new-memory.patch
memory-hotplug-x86_64-suitable-memory-should-go-to-zone_movable.patch
memory-hotplug-x86_32-suitable-memory-should-go-to-zone_movable.patch
memory-hotplug-ia64-suitable-memory-should-go-to-zone_movable.patch
memory-hotplug-ppc-suitable-memory-should-go-to-zone_movable.patch
memory-hotplug-sh-suitable-memory-should-go-to-zone_movable.patch
mm-thp-restructure-thp-avoidance-of-light-synchronous-migration.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

