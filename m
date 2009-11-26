From: akpm@linux-foundation.org
Subject: [withdrawn] mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch removed from -mm tree
Date: Wed, 25 Nov 2009 21:11:04 -0800
Message-ID: <200911260511.nAQ5B4Yf008515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853AbZKZFMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Nov 2009 00:12:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macli@brc.ubc.ca, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm/vsmcan: check shrink_active_list() sc->isolate_pages() return value
has been removed from the -mm tree.  Its filename was
     mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/vsmcan: check shrink_active_list() sc->isolate_pages() return value
From: Vincent Li <macli@brc.ubc.ca>

If we can't isolate pages from LRU list, we don't have to account page
movement, either.  Already, in commit 5343daceec, KOSAKI did it about
shrink_inactive_list.

This patch removes unnecessary overhead of page accounting and locking in
shrink_active_list as follow-up work of commit 5343daceec.

Signed-off-by: Vincent Li <macli@brc.ubc.ca>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value mm/vmscan.c
--- a/mm/vmscan.c~mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value
+++ a/mm/vmscan.c
@@ -1333,9 +1333,12 @@ static void shrink_active_list(unsigned 
 	if (scanning_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
 	}
-	reclaim_stat->recent_scanned[file] += nr_taken;
