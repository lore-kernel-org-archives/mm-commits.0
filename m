From: akpm@linux-foundation.org
Subject: [merged] mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:58:20 -0800
Message-ID: <20121212195820.D889F82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:60703 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2LLUFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:05:32 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so116242qcq.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:05:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, dan.magenheimer@oracle.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, konrad.wilk@oracle.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor reinsert of swap_info in sys_swapoff()
has been removed from the -mm tree.  Its filename was
     mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: mm: refactor reinsert of swap_info in sys_swapoff()

The block within sys_swapoff() which re-inserts the swap_info into the
swap_list in case of failure of try_to_unuse() reads a few values outside
the swap_lock.  While this is safe at that point, it is subtle code.

Simplify the code by moving the reading of these values to a separate
function, refactoring it a bit so they are read from within the swap_lock.
 This is easier to understand, and matches better the way it worked before
I unified the insertion of the swap_info from both sys_swapon and
sys_swapoff.

This change should make no functional difference.  The only real change is
moving the read of two or three structure fields to within the lock
(frontswap_map_get() is nothing more than a read of p->frontswap_map).

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff -puN mm/swapfile.c~mm-refactor-reinsert-of-swap_info-in-sys_swapoff mm/swapfile.c
--- a/mm/swapfile.c~mm-refactor-reinsert-of-swap_info-in-sys_swapoff
+++ a/mm/swapfile.c
@@ -1443,13 +1443,12 @@ static int setup_swap_extents(struct swa
 	return generic_swapfile_activate(sis, swap_file, span);
 }
 
-static void enable_swap_info(struct swap_info_struct *p, int prio,
+static void _enable_swap_info(struct swap_info_struct *p, int prio,
 				unsigned char *swap_map,
 				unsigned long *frontswap_map)
 {
 	int i, prev;
 
-	spin_lock(&swap_lock);
 	if (prio >= 0)
 		p->prio = prio;
 	else
@@ -1473,6 +1472,21 @@ static void enable_swap_info(struct swap
 	else
 		swap_info[prev]->next = p->type;
 	frontswap_init(p->type);
+}
+
+static void enable_swap_info(struct swap_info_struct *p, int prio,
+				unsigned char *swap_map,
+				unsigned long *frontswap_map)
+{
+	spin_lock(&swap_lock);
+	_enable_swap_info(p, prio, swap_map, frontswap_map);
+	spin_unlock(&swap_lock);
+}
+
+static void reinsert_swap_info(struct swap_info_struct *p)
+{
+	spin_lock(&swap_lock);
+	_enable_swap_info(p, p->prio, p->swap_map, frontswap_map_get(p));
 	spin_unlock(&swap_lock);
 }
 
@@ -1548,14 +1562,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	compare_swap_oom_score_adj(OOM_SCORE_ADJ_MAX, oom_score_adj);
 
 	if (err) {
-		/*
-		 * reading p->prio and p->swap_map outside the lock is
-		 * safe here because only sys_swapon and sys_swapoff
-		 * change them, and there can be no other sys_swapon or
-		 * sys_swapoff for this swap_info_struct at this point.
-		 */
 		/* re-insert swap space back into swap_list */
-		enable_swap_info(p, p->prio, p->swap_map, frontswap_map_get(p));
+		reinsert_swap_info(p);
 		goto out_dput;
 	}
 
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch
maintainers-remove-include-linux-ext3.patch

