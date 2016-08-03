From: akpm@linux-foundation.org
Subject: [merged] mm-move-swap-in-anonymous-page-into-active-list.patch
 removed from -mm tree
Date: Wed, 03 Aug 2016 11:10:43 -0700
Message-ID: <57a233a3.r03bYxQ8tMuwhgRH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbcHCSVw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:21:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net, nadav.amit@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move swap-in anonymous page into active list
has been removed from the -mm tree.  Its filename was
     mm-move-swap-in-anonymous-page-into-active-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: move swap-in anonymous page into active list

Every swap-in anonymous page starts from inactive lru list's head.  It
should be activated unconditionally when VM decide to reclaim because page
table entry for the page always usually has marked accessed bit.  Thus,
their window size for getting a new referece is 2 * NR_inactive +
NR_active while others is NR_inactive + NR_active.

It's not fair that it has more chance to be referenced compared to other
newly allocated page which starts from active lru list's head.

Johannes:

: The page can still have a valid copy on the swap device, so prefering to
: reclaim that page over a fresh one could make sense.  But as you point
: out, having it start inactive instead of active actually ends up giving it
: *more* LRU time, and that seems to be without justification.

Rik:

: The reason newly read in swap cache pages start on the inactive list is
: that we do some amount of read-around, and do not know which pages will
: get used.
:
: However, immediately activating the ones that DO get used, like your patch
: does, is the right thing to do.

Link: http://lkml.kernel.org/r/1469762740-17860-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory.c~mm-move-swap-in-anonymous-page-into-active-list mm/memory.c
--- a/mm/memory.c~mm-move-swap-in-anonymous-page-into-active-list
+++ a/mm/memory.c
@@ -2642,6 +2642,7 @@ int do_swap_page(struct fault_env *fe, p
 	if (page == swapcache) {
 		do_page_add_anon_rmap(page, vma, fe->address, exclusive);
 		mem_cgroup_commit_charge(page, memcg, true, false);
+		activate_page(page);
 	} else { /* ksm created a completely new copy */
 		page_add_new_anon_rmap(page, vma, fe->address, false);
 		mem_cgroup_commit_charge(page, memcg, false, false);
_

Patches currently in -mm which might be from minchan@kernel.org are


