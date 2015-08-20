From: akpm@linux-foundation.org
Subject: + mm-vmscan-unlock-page-while-waiting-on-writeback.patch added to -mm tree
Date: Thu, 20 Aug 2015 13:15:05 -0700
Message-ID: <55d63549.5qpg1Bouo0VTc6HO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbbHTUPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Aug 2015 16:15:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: unlock page while waiting on writeback
has been added to the -mm tree.  Its filename is
     mm-vmscan-unlock-page-while-waiting-on-writeback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-unlock-page-while-waiting-on-writeback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-unlock-page-while-waiting-on-writeback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm, vmscan: unlock page while waiting on writeback

This is merely a politeness: I've not found that shrink_page_list() leads
to deadlock with the page it holds locked across wait_on_page_writeback();
but nevertheless, why hold others off by keeping the page locked there?

And while we're at it: remove the mistaken "not " from the commentary on
this Case 3 (and a distracting blank line from Case 2, if I may).

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-unlock-page-while-waiting-on-writeback mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-unlock-page-while-waiting-on-writeback
+++ a/mm/vmscan.c
@@ -982,7 +982,7 @@ static unsigned long shrink_page_list(st
 		 *    __GFP_IO|__GFP_FS for this reason); but more thought
 		 *    would probably show more reasons.
 		 *
-		 * 3) Legacy memcg encounters a page that is not already marked
+		 * 3) Legacy memcg encounters a page that is already marked
 		 *    PageReclaim. memcg does not have any dirty pages
 		 *    throttling so we could easily OOM just because too many
 		 *    pages are in writeback and there is nothing else to
@@ -1012,12 +1012,15 @@ static unsigned long shrink_page_list(st
 				 */
 				SetPageReclaim(page);
 				nr_writeback++;
