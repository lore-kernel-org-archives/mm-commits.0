From: akpm@linux-foundation.org
Subject: + mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed.patch added to -mm tree
Date: Tue, 05 May 2009 13:34:50 -0700
Message-ID: <200905052034.n45KYo81017185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086AbZEEUhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 16:37:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, rientjes@google.com


The patch titled
     mm: setup_per_zone_inactive_ratio - do not call for int_sqrt if not needed
has been added to the -mm tree.  Its filename is
     mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: setup_per_zone_inactive_ratio - do not call for int_sqrt if not needed
From: Cyrill Gorcunov <gorcunov@openvz.org>

int_sqrt() returns 0 if its argument is zero so call it if only needed.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed mm/page_alloc.c
--- a/mm/page_alloc.c~mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed
+++ a/mm/page_alloc.c
@@ -4547,8 +4547,9 @@ static void setup_per_zone_inactive_rati
 
 		/* Zone size in gigabytes */
 		gb = zone->present_pages >> (30 - PAGE_SHIFT);
-		ratio = int_sqrt(10 * gb);
-		if (!ratio)
+		if (gb)
+			ratio = int_sqrt(10 * gb);
+		else
 			ratio = 1;
 
 		zone->inactive_ratio = ratio;
_

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed.patch

