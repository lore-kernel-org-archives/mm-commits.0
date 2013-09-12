From: akpm@linux-foundation.org
Subject: [merged] mm-munlock-batch-nr_mlock-zone-state-updates.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:44:53 -0700
Message-ID: <523219b5.t2k7gmyOoVk/NyOj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab3ILToy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, joern@logfs.org, hughd@google.com, hannes@cmpxchg.org, vbabka@suse.cz

Subject: [merged] mm-munlock-batch-nr_mlock-zone-state-updates.patch removed from -mm tree
To: vbabka@suse.cz,hannes@cmpxchg.org,hughd@google.com,joern@logfs.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:53 -0700


The patch titled
     Subject: mm: munlock: batch NR_MLOCK zone state updates
has been removed from the -mm tree.  Its filename was
     mm-munlock-batch-nr_mlock-zone-state-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: munlock: batch NR_MLOCK zone state updates

Depending on previous batch which introduced batched isolation in
munlock_vma_range(), we can batch also the updates of NR_MLOCK page stats.
 After the whole pagevec is processed for page isolation, the stats are
updated only once with the number of successful isolations.  There were
however no measurable perfomance gains.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Jörn Engel <joern@logfs.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/mlock.c~mm-munlock-batch-nr_mlock-zone-state-updates mm/mlock.c
--- a/mm/mlock.c~mm-munlock-batch-nr_mlock-zone-state-updates
+++ a/mm/mlock.c
@@ -241,6 +241,7 @@ static void __munlock_pagevec(struct pag
 {
 	int i;
 	int nr = pagevec_count(pvec);
+	int delta_munlocked = -nr;
 
 	/* Phase 1: page isolation */
 	spin_lock_irq(&zone->lru_lock);
@@ -251,9 +252,6 @@ static void __munlock_pagevec(struct pag
 			struct lruvec *lruvec;
 			int lru;
 
-			/* we have disabled interrupts */
-			__mod_zone_page_state(zone, NR_MLOCK, -1);
