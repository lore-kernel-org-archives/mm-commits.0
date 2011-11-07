From: akpm@linux-foundation.org
Subject: [merged] memcg-close-race-between-charge-and-putback.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:27:13 -0800
Message-ID: <201111072027.pA7KRD74013330@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47322 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1KGU2M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:28:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: close race between charge and putback
has been removed from the -mm tree.  Its filename was
     memcg-close-race-between-charge-and-putback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: memcg: close race between charge and putback

There is a potential race between a thread charging a page and another
thread putting it back to the LRU list:

charge:                         putback:
SetPageCgroupUsed               SetPageLRU
PageLRU && add to memcg LRU     PageCgroupUsed && add to memcg LRU

The order of setting one flag and checking the other is crucial, otherwise
the charge may observe !PageLRU while the putback observes !PageCgroupUsed
and the page is not linked to the memcg LRU at all.

Global memory pressure may fix this by trying to isolate and putback the
page for reclaim, where that putback would link it to the memcg LRU again.
 Without that, the memory cgroup is undeletable due to a charge whose
physical page can not be found and moved out.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Cc: Ying Han <yinghan@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-close-race-between-charge-and-putback mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-close-race-between-charge-and-putback
+++ a/mm/memcontrol.c
@@ -993,6 +993,16 @@ void mem_cgroup_add_lru_list(struct page
 		return;
 	pc = lookup_page_cgroup(page);
 	VM_BUG_ON(PageCgroupAcctLRU(pc));
+	/*
+	 * putback:				charge:
+	 * SetPageLRU				SetPageCgroupUsed
+	 * smp_mb				smp_mb
+	 * PageCgroupUsed && add to memcg LRU	PageLRU && add to memcg LRU
+	 *
+	 * Ensure that one of the two sides adds the page to the memcg
+	 * LRU during a race.
+	 */
+	smp_mb();
 	if (!PageCgroupUsed(pc))
 		return;
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
@@ -1044,7 +1054,16 @@ static void mem_cgroup_lru_add_after_com
 	unsigned long flags;
 	struct zone *zone = page_zone(page);
 	struct page_cgroup *pc = lookup_page_cgroup(page);
