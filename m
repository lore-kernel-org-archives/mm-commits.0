From: akpm@linux-foundation.org
Subject: [alternative-merged]
 sched-numa-fix-set-cpupid-on-page-migration-twice.patch removed from -mm
 tree
Date: Fri, 17 Jan 2014 12:47:20 -0800
Message-ID: <52d996d8.pdcOQBntZMAyMG6k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaAQUrV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jan 2014 15:47:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, peterz@infradead.org, n-horiguchi@ah.jp.nec.com, mingo@redhat.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com

Subject: [alternative-merged] sched-numa-fix-set-cpupid-on-page-migration-twice.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,mgorman@suse.de,mingo@redhat.com,n-horiguchi@ah.jp.nec.com,peterz@infradead.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 17 Jan 2014 12:47:20 -0800


The patch titled
     Subject: sched/numa: fix setting of cpupid on page migration twice
has been removed from the -mm tree.  Its filename was
     sched-numa-fix-set-cpupid-on-page-migration-twice.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: sched/numa: fix setting of cpupid on page migration twice

commit 7851a45cd3 ("mm: numa: Copy cpupid on page migration") copys over
the cpupid at page migration time.  It is unnecessary to set it again in
migrate_misplaced_transhuge_page().

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/migrate.c~sched-numa-fix-set-cpupid-on-page-migration-twice mm/migrate.c
--- a/mm/migrate.c~sched-numa-fix-set-cpupid-on-page-migration-twice
+++ a/mm/migrate.c
@@ -1753,8 +1753,6 @@ int migrate_misplaced_transhuge_page(str
 	if (!new_page)
 		goto out_fail;
 
-	page_cpupid_xchg_last(new_page, page_cpupid_last(page));
-
 	isolated = numamigrate_isolate_page(pgdat, page);
 	if (!isolated) {
 		put_page(new_page);
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

mm-remove-bug_on-from-mlock_vma_page.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
mm-rmap-use-rmap_walk-in-page_referenced-fix.patch
mm-hwpoison-add-to-hwpoison_inject.patch
lib-show_memc-show-num_poisoned_pages-when-oom.patch
mm-migrate-add-comment-about-permanent-failure-path.patch
mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch
mm-migrate-remove-unused-function-fail_migrate_page.patch
mm-documentation-remove-hopelessly-out-of-date-locking-doc.patch
mm-memory-failurec-shift-page-lock-from-head-page-to-tail-page-after-thp-split.patch
mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages.patch
linux-next.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch

