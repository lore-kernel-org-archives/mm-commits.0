From: akpm@linux-foundation.org
Subject: [merged] mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:40 -0700
Message-ID: <20120712193640.D4A68100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:43159 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934203Ab2GLTgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:36:42 -0400
Received: by vbnl22 with SMTP id l22so265538vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:36:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org, riel@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: abort compaction if migration page cannot be charged to memcg
has been removed from the -mm tree.  Its filename was
     mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: abort compaction if migration page cannot be charged to memcg

If page migration cannot charge the temporary page to the memcg,
migrate_pages() will return -ENOMEM.  This isn't considered in memory
compaction however, and the loop continues to iterate over all pageblocks
trying to isolate and migrate pages.  If a small number of very large
memcgs happen to be oom, however, these attempts will mostly be futile
leading to an enormous amout of cpu consumption due to the page migration
failures.  

This patch will short circuit and fail memory compaction if
migrate_pages() returns -ENOMEM.  COMPACT_PARTIAL is returned in case some
migrations were successful so that the page allocator will retry.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg mm/compaction.c
--- a/mm/compaction.c~mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg
+++ a/mm/compaction.c
@@ -701,8 +701,11 @@ static int compact_zone(struct zone *zon
 		if (err) {
 			putback_lru_pages(&cc->migratepages);
 			cc->nr_migratepages = 0;
+			if (err == -ENOMEM) {
+				ret = COMPACT_PARTIAL;
+				goto out;
+			}
 		}
-
 	}
 
 out:
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
slab-do-not-call-compound_head-in-page_get_cache.patch
mm-buddy-cleanup-on-should_fail_alloc_page.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup-add-huge_page_order-check-to-avoid-incorrectly-uncharge.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
mm-oom-do-not-schedule-if-current-has-been-killed.patch
mm-compaction-cleanup-on-compaction_deferred.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-oom-fix-potential-killing-of-thread-that-is-disabled-from-oom-killing.patch
mm-oom-replace-some-information-in-tasklist-dump.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
mm-setup-pageblock_order-before-its-used-by-sparsemem.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-oom-move-declaration-for-mem_cgroup_out_of_memory-to-oomh.patch
mm-oom-introduce-helper-function-to-process-threads-during-scan.patch
mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads.patch
mm-oom-reduce-dependency-on-tasklist_lock.patch
mm-memcg-move-all-oom-handling-to-memcontrolc.patch
kernel-sysc-avoid-argv_freenull.patch

