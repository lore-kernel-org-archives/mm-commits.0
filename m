From: akpm@linux-foundation.org
Subject: +
 mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch added to -mm tree
Date: Tue, 28 Feb 2017 15:53:28 -0800
Message-ID: <58b60d78.etkVbKLA//ZVa9/L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38106 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbdB1XzF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 18:55:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hejianet@gmail.com, mgorman@suse.de, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unnecessary reclaimability check from NUMA balancing target
has been added to the -mm tree.  Its filename is
     mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: remove unnecessary reclaimability check from NUMA balancing target

NUMA balancing already checks the watermarks of the target node to decide
whether it's a suitable balancing target.  Whether the node is reclaimable
or not is irrelevant when we don't intend to reclaim.

Link: http://lkml.kernel.org/r/20170228214007.5621-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jia He <hejianet@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/migrate.c~mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target mm/migrate.c
--- a/mm/migrate.c~mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target
+++ a/mm/migrate.c
@@ -1718,9 +1718,6 @@ static bool migrate_balanced_pgdat(struc
 {
 	int z;
 
-	if (!pgdat_reclaimable(pgdat))
-		return false;
