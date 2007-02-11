From: akpm@linux-foundation.org
Subject: - do-not-disturb-page-referenced-state-when-unmapping-memory-range.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:56 -0800
Message-ID: <200702112246.l1BMku47015527@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59613 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642AbXBKWr3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:47:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenchen@google.com, a.p.zijlstra@chello.nl, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     do not disturb page referenced state when unmapping memory range
has been removed from the -mm tree.  Its filename was
     do-not-disturb-page-referenced-state-when-unmapping-memory-range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: do not disturb page referenced state when unmapping memory range
From: "Ken Chen" <kenchen@google.com>

When kernel unmaps an address range, it needs to transfer PTE state into
page struct.  Currently, kernel transfer access bit via
mark_page_accessed().  The call to mark_page_accessed in the unmap path
doesn't look logically correct.

At unmap time, calling mark_page_accessed will causes page LRU state to be
bumped up one step closer to more recently used state.  It is causing quite
a bit headache in a scenario when a process creates a shmem segment, touch
a whole bunch of pages, then unmaps it.  The unmapping takes a long time
because mark_page_accessed() will start moving pages from inactive to
active list.

I'm not too much concerned with moving the page from one list to another in
LRU.  Sooner or later it might be moved because of multiple mappings from
various processes.  But it just doesn't look logical that when user asks a
range to be unmapped, it's his intention that the process is no longer
interested in these pages.  Moving those pages to active list (or bumping
up a state towards more active) seems to be an over reaction.  It also
prolongs unmapping latency which is the core issue I'm trying to solve.

As suggested by Peter, we should still preserve the info on pte young
pages, but not more.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ken Chen <kenchen@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~do-not-disturb-page-referenced-state-when-unmapping-memory-range mm/memory.c
--- a/mm/memory.c~do-not-disturb-page-referenced-state-when-unmapping-memory-range
+++ a/mm/memory.c
@@ -678,7 +678,7 @@ static unsigned long zap_pte_range(struc
 				if (pte_dirty(ptent))
 					set_page_dirty(page);
 				if (pte_young(ptent))
-					mark_page_accessed(page);
+					SetPageReferenced(page);
 				file_rss--;
 			}
 			page_remove_rmap(page, vma);
_

Patches currently in -mm which might be from kenchen@google.com are

origin.patch
