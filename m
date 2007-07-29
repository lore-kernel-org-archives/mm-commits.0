From: akpm@linux-foundation.org
Subject: - memory-unplug-v7-isolate_lru_page-fix.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:11:53 -0700
Message-ID: <200707290611.l6T6Brhn011013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47693 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757598AbXG2GMG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:12:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     memory unplug: isolate_lru_page fix
has been removed from the -mm tree.  Its filename was
     memory-unplug-v7-isolate_lru_page-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: memory unplug: isolate_lru_page fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

release_pages() in mm/swap.c changes page_count() to be 0 without removing
PageLRU flag...

This means isolate_lru_page() can see a page, PageLRU() &&
page_count(page)==0..  This is BUG.  (get_page() will be called against
count=0 page.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/migrate.c~memory-unplug-v7-isolate_lru_page-fix mm/migrate.c
--- a/mm/migrate.c~memory-unplug-v7-isolate_lru_page-fix
+++ a/mm/migrate.c
@@ -49,9 +49,8 @@ int isolate_lru_page(struct page *page, 
 		struct zone *zone = page_zone(page);
 
 		spin_lock_irq(&zone->lru_lock);
-		if (PageLRU(page)) {
+		if (PageLRU(page) && get_page_unless_zero(page)) {
 			ret = 0;
-			get_page(page);
 			ClearPageLRU(page);
 			if (PageActive(page))
 				del_page_from_active_list(zone, page);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
