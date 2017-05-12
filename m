From: akpm@linux-foundation.org
Subject: [patch 03/15] mm, vmstat: remove spurious WARN() during
 zoneinfo print
Date: Fri, 12 May 2017 15:46:32 -0700
Message-ID: <20170512224632._kHchziOI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38664 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756700AbdELWqe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 18:46:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arbab@linux.vnet.ibm.com, hannes@cmpxchg.org, khandual@linux.vnet.ibm.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Reza Arbab <arbab@linux.vnet.ibm.com>
Subject: mm, vmstat: Remove spurious WARN() during zoneinfo print

After e2ecc8a79ed49f7838 ("mm, vmstat: print non-populated zones in
zoneinfo"), /proc/zoneinfo will show unpopulated zones.

A memoryless node, having no populated zones at all, was previously
ignored, but will now trigger the WARN() in is_zone_first_populated().

Remove this warning, as its only purpose was to warn of a situation that
has since been enabled.

Aside: The "per-node stats" are still printed under the first populated
zone, but that's not necessarily the first stanza any more. I'm not sure
which criteria is more important with regard to not breaking parsers, but
it looks a little weird to the eye.

Fixes:  e2ecc8a79ed49f7838: "mm, vmstat: print node-based stats in zoneinfo file")
Link: http://lkml.kernel.org/r/1493854905-10918-1-git-send-email-arbab@linux.vnet.ibm.com
Signed-off-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/vmstat.c~mm-vmstat-remove-spurious-warn-during-zoneinfo-print mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-remove-spurious-warn-during-zoneinfo-print
+++ a/mm/vmstat.c
@@ -1359,8 +1359,6 @@ static bool is_zone_first_populated(pg_d
 			return zone == compare;
 	}
 
-	/* The zone must be somewhere! */
-	WARN_ON_ONCE(1);
 	return false;
 }
 
_
