From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-simplify-error-flow-in-setup_swap_map_and_extents.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:50 -0700
Message-ID: <201103232041.p2NKfQCZ028644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933522Ab1CWUzd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: simplify error flow in setup_swap_map_and_extents()
has been removed from the -mm tree.  Its filename was
     sys_swapon-simplify-error-flow-in-setup_swap_map_and_extents.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: simplify error flow in setup_swap_map_and_extents()
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Since there is no cleanup to do, there is no reason to jump to a label.
Return directly instead.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-simplify-error-flow-in-setup_swap_map_and_extents mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-simplify-error-flow-in-setup_swap_map_and_extents
+++ a/mm/swapfile.c
@@ -1998,7 +1998,6 @@ static int setup_swap_map_and_extents(st
 					sector_t *span)
 {
 	int i;
-	int error;
 	unsigned int nr_good_pages;
 	int nr_extents;
 
@@ -2006,10 +2005,8 @@ static int setup_swap_map_and_extents(st
 
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
-		if (page_nr == 0 || page_nr > swap_header->info.last_page) {
-			error = -EINVAL;
-			goto bad_swap;
-		}
+		if (page_nr == 0 || page_nr > swap_header->info.last_page)
+			return -EINVAL;
 		if (page_nr < maxpages) {
 			swap_map[page_nr] = SWAP_MAP_BAD;
 			nr_good_pages--;
@@ -2021,22 +2018,16 @@ static int setup_swap_map_and_extents(st
 		p->max = maxpages;
 		p->pages = nr_good_pages;
 		nr_extents = setup_swap_extents(p, span);
-		if (nr_extents < 0) {
-			error = nr_extents;
-			goto bad_swap;
-		}
+		if (nr_extents < 0)
+			return nr_extents;
 		nr_good_pages = p->pages;
 	}
 	if (!nr_good_pages) {
 		printk(KERN_WARNING "Empty swap-file\n");
-		error = -EINVAL;
-		goto bad_swap;
+		return -EINVAL;
 	}
 
 	return nr_extents;
