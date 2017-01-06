From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-swap-likely-to-unlikely-as-code-logic-is-different-for-next_zones_zonelist.patch added to -mm tree
Date: Thu, 05 Jan 2017 17:05:48 -0800
Message-ID: <586eed6c.2+8tacr+n/eCNlkD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38422 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754548AbdAFBEa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 20:04:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmzone.c: swap likely to unlikely as code logic is different for next_zones_zonelist()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-swap-likely-to-unlikely-as-code-logic-is-different-for-next_zones_zonelist.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-swap-likely-to-unlikely-as-code-logic-is-different-for-next_zones_zonelist.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-swap-likely-to-unlikely-as-code-logic-is-different-for-next_zones_zonelist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: mm/mmzone.c: swap likely to unlikely as code logic is different for next_zones_zonelist()

Commit 682a3385e773 "mm, page_alloc: inline the fast path of the
zonelist iterator" changed how next_zones_zonelist() is called, by
adding a static inline function to do the fast path. This function adds:

       if (likely(!nodes && zonelist_zone_idx(z) <= highest_zoneidx))
               return z;
       return __next_zones_zonelist(z, highest_zoneidx, nodes);

Where __next_zones_zonelist() is only called when nodes is not NULL or
zonelist_zone_idx(z) is less than highest_zoneidx.

The original next_zone_zonelist() was converted to
__next_zones_zonelist() but it still maintained:

	if (likely(nodes == NULL))

Which is now actually a very unlikely, as it is only called with nodes
equal to NULL when zonelist_zone_idx(z) is greater than highest_zoneidx.

Before this commit, this if had this statistic:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
  837895   446078  34 next_zones_zonelist            mmzone.c             63

After this commit, it has:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
      10   173840  99 __next_zones_zonelist          mmzone.c             63

Thus, the if statement is now much more unlikely than it ever was as a
likely.

Link: http://lkml.kernel.org/r/20170105200102.77989567@gandalf.local.home
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmzone.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmzone.c~mm-page_alloc-swap-likely-to-unlikely-as-code-logic-is-different-for-next_zones_zonelist mm/mmzone.c
--- a/mm/mmzone.c~mm-page_alloc-swap-likely-to-unlikely-as-code-logic-is-different-for-next_zones_zonelist
+++ a/mm/mmzone.c
@@ -60,7 +60,7 @@ struct zoneref *__next_zones_zonelist(st
 	 * Find the next suitable zone to use for the allocation.
 	 * Only filter based on nodemask if it's set
 	 */
-	if (likely(nodes == NULL))
+	if (unlikely(nodes == NULL))
 		while (zonelist_zone_idx(z) > highest_zoneidx)
 			z++;
 	else
_

Patches currently in -mm which might be from rostedt@goodmis.org are

mm-page_alloc-swap-likely-to-unlikely-as-code-logic-is-different-for-next_zones_zonelist.patch

