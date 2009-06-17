From: akpm@linux-foundation.org
Subject: [merged] mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:03 -0700
Message-ID: <200906171835.n5HIZ3ld001099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756832AbZFQSpz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:45:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: setup_per_zone_inactive_ratio - do not call for int_sqrt if not needed
has been removed from the -mm tree.  Its filename was
     mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4471,8 +4471,9 @@ static void setup_per_zone_inactive_rati
 
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

origin.patch
proc-vmcore-use-kzalloc-in-get_new_element.patch

