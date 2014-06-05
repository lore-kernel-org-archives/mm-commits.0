From: akpm@linux-foundation.org
Subject: [merged]
 mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:45 -0700
Message-ID: <5390ca8d.4yd5VYbSSL8X/s4/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaFETwq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tytso@mit.edu, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mhocko@suse.cz, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, mgorman@suse.de

Subject: [merged] mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch removed from -mm tree
To: mgorman@suse.de,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mhocko@suse.cz,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,tytso@mit.edu,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:45 -0700


The patch titled
     Subject: mm: do not use unnecessary atomic operations when adding pages to the LRU
has been removed from the -mm tree.  Its filename was
     mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: do not use unnecessary atomic operations when adding pages to the LRU

When adding pages to the LRU we clear the active bit unconditionally.  As
the page could be reachable from other paths we cannot use unlocked
operations without risk of corruption such as a parallel
mark_page_accessed.  This patch tests if is necessary to clear the active
flag before using an atomic operation.  This potentially opens a tiny race
when PageActive is checked as mark_page_accessed could be called after
PageActive was checked.  The race already exists but this patch changes it
slightly.  The consequence is that that the page may be promoted to the
active list that might have been left on the inactive list before the
patch.  It's too tiny a race and too marginal a consequence to always use
atomic operations for.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/swap.c~mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru mm/swap.c
--- a/mm/swap.c~mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru
+++ a/mm/swap.c
@@ -631,13 +631,15 @@ static void __lru_cache_add(struct page
  */
 void lru_cache_add_anon(struct page *page)
 {
-	ClearPageActive(page);
+	if (PageActive(page))
+		ClearPageActive(page);
 	__lru_cache_add(page);
 }
 
 void lru_cache_add_file(struct page *page)
 {
-	ClearPageActive(page);
+	if (PageActive(page))
+		ClearPageActive(page);
 	__lru_cache_add(page);
 }
 EXPORT_SYMBOL(lru_cache_add_file);
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

