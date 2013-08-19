From: akpm@linux-foundation.org
Subject: + mm-munlock-batch-nr_mlock-zone-state-updates.patch added to -mm tree
Date: Mon, 19 Aug 2013 15:49:08 -0700
Message-ID: <5212a0e4.rB0FptaWWpMbo9Yo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3HSWtJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Aug 2013 18:49:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, joern@logfs.org, hughd@google.com, hannes@cmpxchg.org, vbabka@suse.cz

Subject: + mm-munlock-batch-nr_mlock-zone-state-updates.patch added to -mm tree
To: vbabka@suse.cz,hannes@cmpxchg.org,hughd@google.com,joern@logfs.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,walken@google.com
From: akpm@linux-foundation.org
Date: Mon, 19 Aug 2013 15:49:08 -0700


The patch titled
     Subject: mm: munlock: batch NR_MLOCK zone state updates
has been added to the -mm tree.  Its filename is
     mm-munlock-batch-nr_mlock-zone-state-updates.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-batch-nr_mlock-zone-state-updates.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-batch-nr_mlock-zone-state-updates.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -238,6 +238,7 @@ static void __munlock_pagevec(struct pag
 {
 	int i;
 	int nr = pagevec_count(pvec);
+	int delta_munlocked = -nr;
 
 	/* Phase 1: page isolation */
 	spin_lock_irq(&zone->lru_lock);
@@ -248,9 +249,6 @@ static void __munlock_pagevec(struct pag
 			struct lruvec *lruvec;
 			int lru;
 
-			/* we have disabled interrupts */
-			__mod_zone_page_state(zone, NR_MLOCK, -1);
-
 			if (PageLRU(page)) {
 				lruvec = mem_cgroup_page_lruvec(page, zone);
 				lru = page_lru(page);
@@ -272,8 +270,10 @@ skip_munlock:
 			 */
 			pvec->pages[i] = NULL;
 			put_page(page);
+			delta_munlocked++;
 		}
 	}
+	__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
 	spin_unlock_irq(&zone->lru_lock);
 
 	/* Phase 2: page munlock and putback */
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-putback_lru_page-remove-unnecessary-call-to-page_lru_base_type.patch
mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch
mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch
mm-munlock-batch-nr_mlock-zone-state-updates.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch

