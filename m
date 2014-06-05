From: akpm@linux-foundation.org
Subject: [merged]
 mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:50:24 -0700
Message-ID: <5390ca00.wudCRiMqv7Fu//XN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaFETuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, hughd@google.com, mgorman@suse.de

Subject: [merged] mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch removed from -mm tree
To: mgorman@suse.de,hughd@google.com,riel@redhat.com,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:24 -0700


The patch titled
     Subject: mm: numa: add migrated transhuge pages to LRU the same way as base pages
has been removed from the -mm tree.  Its filename was
     mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: add migrated transhuge pages to LRU the same way as base pages

Migration of misplaced transhuge pages uses page_add_new_anon_rmap() when
putting the page back as it avoided an atomic operations and added the new
page to the correct LRU.  A side-effect is that the page gets marked
activated as part of the migration meaning that transhuge and base pages
are treated differently from an aging perspective than base page
migration.

This patch uses page_add_anon_rmap() and putback_lru_page() on completion
of a transhuge migration similar to base page migration.  It would require
fewer atomic operations to use lru_cache_add without taking an additional
reference to the page.  The downside would be that it's still different to
base page migration and unevictable pages may be added to the wrong LRU
for cleaning up later.  Testing of the usual workloads did not show any
adverse impact to the change.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages mm/migrate.c
--- a/mm/migrate.c~mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages
+++ a/mm/migrate.c
@@ -1852,7 +1852,7 @@ fail_putback:
 	 * guarantee the copy is visible before the pagetable update.
 	 */
 	flush_cache_range(vma, mmun_start, mmun_end);
-	page_add_new_anon_rmap(new_page, vma, mmun_start);
+	page_add_anon_rmap(new_page, vma, mmun_start);
 	pmdp_clear_flush(vma, mmun_start, pmd);
 	set_pmd_at(mm, mmun_start, pmd, entry);
 	flush_tlb_range(vma, mmun_start, mmun_end);
@@ -1877,6 +1877,10 @@ fail_putback:
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
+	/* Take an "isolate" reference and put new page on the LRU. */
+	get_page(new_page);
+	putback_lru_page(new_page);
+
 	unlock_page(new_page);
 	unlock_page(page);
 	put_page(page);			/* Drop the rmap reference */
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

