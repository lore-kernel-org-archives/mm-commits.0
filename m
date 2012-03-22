From: akpm@linux-foundation.org
Subject: [merged] mm-forbid-lumpy-reclaim-in-shrink_active_list.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:24 -0700
Message-ID: <20120322201924.8DE4CA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:58075 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965108Ab2CVUT0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:26 -0400
Received: by mail-bk0-f74.google.com with SMTP id jm19so134271bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: forbid lumpy-reclaim in shrink_active_list()
has been removed from the -mm tree.  Its filename was
     mm-forbid-lumpy-reclaim-in-shrink_active_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: forbid lumpy-reclaim in shrink_active_list()

Reset the reclaim mode in shrink_active_list() to RECLAIM_MODE_SINGLE |
RECLAIM_MODE_ASYNC.  (sync/async sign is used only in shrink_page_list and
does not affect shrink_active_list)

Currenly shrink_active_list() sometimes works in lumpy-reclaim mode, if
RECLAIM_MODE_LUMPYRECLAIM is left over from an earlier
shrink_inactive_list().  Meanwhile, in age_active_anon() sc->reclaim_mode
is totally zero.  So the current behavior is too complex and confusing,
and this looks like bug.

In general, shrink_active_list() populates the inactive list for the next
shrink_inactive_list().  Lumpy shring_inactive_list() isolates pages
around the chosen one from both the active and inactive lists.  So, there
is no reason for lumpy isolation in shrink_active_list().

See also: https://lkml.org/lkml/2012/3/15/583

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Proposed-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmscan.c~mm-forbid-lumpy-reclaim-in-shrink_active_list mm/vmscan.c
--- a/mm/vmscan.c~mm-forbid-lumpy-reclaim-in-shrink_active_list
+++ a/mm/vmscan.c
@@ -1690,6 +1690,8 @@ static void shrink_active_list(unsigned 
 
 	lru_add_drain();
 
+	reset_reclaim_mode(sc);
+
 	if (!sc->may_unmap)
 		isolate_mode |= ISOLATE_UNMAPPED;
 	if (!sc->may_writepage)
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch

