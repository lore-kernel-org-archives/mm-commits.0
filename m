From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-unlock-page-while-waiting-on-writeback.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:53:22 -0700
Message-ID: <55f08e32.wpiArPDNs5oSe/Lp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbbIITxX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: unlock page while waiting on writeback
has been removed from the -mm tree.  Its filename was
     mm-vmscan-unlock-page-while-waiting-on-writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm, vmscan: unlock page while waiting on writeback

This is merely a politeness: I've not found that shrink_page_list() leads
to deadlock with the page it holds locked across wait_on_page_writeback();
but nevertheless, why hold others off by keeping the page locked there?

And while we're at it: remove the mistaken "not " from the commentary on
this Case 3 (and a distracting blank line from Case 2, if I may).

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-unlock-page-while-waiting-on-writeback mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-unlock-page-while-waiting-on-writeback
+++ a/mm/vmscan.c
@@ -985,7 +985,7 @@ static unsigned long shrink_page_list(st
 		 *    __GFP_IO|__GFP_FS for this reason); but more thought
 		 *    would probably show more reasons.
 		 *
-		 * 3) Legacy memcg encounters a page that is not already marked
+		 * 3) Legacy memcg encounters a page that is already marked
 		 *    PageReclaim. memcg does not have any dirty pages
 		 *    throttling so we could easily OOM just because too many
 		 *    pages are in writeback and there is nothing else to
@@ -1015,12 +1015,15 @@ static unsigned long shrink_page_list(st
 				 */
 				SetPageReclaim(page);
 				nr_writeback++;
