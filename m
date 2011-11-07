From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-vmw_balloonc-determine-page-allocation-flag-can_sleep-outside-loop.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:29:50 -0800
Message-ID: <201111072029.pA7KToma013953@wpaz37.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47743 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab1KGU3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:29:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, dtor@vmware.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/vmw_balloon.c: determine page allocation flag can_sleep outside loop
has been removed from the -mm tree.  Its filename was
     drivers-misc-vmw_balloonc-determine-page-allocation-flag-can_sleep-outside-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Rakib Mullick <rakib.mullick@gmail.com>
Subject: drivers/misc/vmw_balloon.c: determine page allocation flag can_sleep outside loop

In vmballoon_reserve_page(), flags has been passed from the callee
function (vmballoon_inflate here).  So, we can determine can_sleep outside
the loop.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Acked-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/vmw_balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/vmw_balloon.c~drivers-misc-vmw_balloonc-determine-page-allocation-flag-can_sleep-outside-loop drivers/misc/vmw_balloon.c
--- a/drivers/misc/vmw_balloon.c~drivers-misc-vmw_balloonc-determine-page-allocation-flag-can_sleep-outside-loop
+++ a/drivers/misc/vmw_balloon.c
@@ -412,6 +412,7 @@ static int vmballoon_reserve_page(struct
 	gfp_t flags;
 	unsigned int hv_status;
 	bool locked = false;
+	flags = can_sleep ? VMW_PAGE_ALLOC_CANSLEEP : VMW_PAGE_ALLOC_NOSLEEP;
 
 	do {
 		if (!can_sleep)
@@ -419,7 +420,6 @@ static int vmballoon_reserve_page(struct
 		else
 			STATS_INC(b->stats.sleep_alloc);
 
-		flags = can_sleep ? VMW_PAGE_ALLOC_CANSLEEP : VMW_PAGE_ALLOC_NOSLEEP;
 		page = alloc_page(flags);
 		if (!page) {
 			if (!can_sleep)
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

origin.patch

