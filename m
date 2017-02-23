From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-swap-likely-to-unlikely-as-code-logic-is-different-for-next_zones_zonelist.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:15:52 -0800
Message-ID: <58af5108.C/l8XOMVv0YT5pNp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40274 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWVPx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:15:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmzone.c: swap likely to unlikely as code logic is different for next_zones_zonelist()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-swap-likely-to-unlikely-as-code-logic-is-different-for-next_zones_zonelist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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

shm-fix-unlikely-test-of-info-seals-to-test-only-for-write-and-grow.patch
mm-place-not-inside-of-unlikely-statement-in-wb_domain_writeout_inc.patch

