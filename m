From: akpm@google.com
Subject: + drivers-misc-vmw_balloonc-determine-page-allocation-flag-can_sleep-outside-loop.patch added to -mm tree
Date: Mon, 17 Oct 2011 12:04:53 -0700
Message-ID: <201110171904.p9HJ4sSu016023@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:52429 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1JQTE6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2011 15:04:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, dtor@vmware.com


The patch titled
     Subject: drivers/misc/vmw_balloon.c: determine page allocation flag can_sleep outside loop
has been added to the -mm tree.  Its filename is
     drivers-misc-vmw_balloonc-determine-page-allocation-flag-can_sleep-outside-loop.patch

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
From: Rakib Mullick <rakib.mullick@gmail.com>
Subject: drivers/misc/vmw_balloon.c: determine page allocation flag can_sleep outside loop

In vmballoon_reserve_page(), flags has been passed from the callee
function (vmballoon_inflate here).  So, we can determine can_sleep outside
the loop.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Acked-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Andrew Morton <akpm@google.com>
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
Subject: Subject: drivers/misc/vmw_balloon.c: determine page allocation flag can_sleep outside loop

Patches currently in -mm which might be from rakib.mullick@gmail.com are

drivers-misc-vmw_balloonc-determine-page-allocation-flag-can_sleep-outside-loop.patch

