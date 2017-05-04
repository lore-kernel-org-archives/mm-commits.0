From: akpm@linux-foundation.org
Subject: + mm-vmstat-remove-spurious-warn-during-zoneinfo-print.patch
 added to -mm tree
Date: Thu, 04 May 2017 14:13:57 -0700
Message-ID: <590b9995.31zhEqWuqm+oZif1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44312 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbdEDVN7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 17:13:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, hannes@cmpxchg.org, khandual@linux.vnet.ibm.com, mgorman@techsingularity.net, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmstat: Remove spurious WARN() during zoneinfo print
has been added to the -mm tree.  Its filename is
     mm-vmstat-remove-spurious-warn-during-zoneinfo-print.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-remove-spurious-warn-during-zoneinfo-print.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-remove-spurious-warn-during-zoneinfo-print.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from arbab@linux.vnet.ibm.com are

mm-vmstat-remove-spurious-warn-during-zoneinfo-print.patch

