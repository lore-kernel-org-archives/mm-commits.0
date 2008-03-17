From: akpm@linux-foundation.org
Subject: + mmc-omap-check-the-get_cover_state-function-pointer-if-not-set.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:27:33 -0700
Message-ID: <200803172227.m2HMRXln001552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505AbYCQW1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:27:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, drzeus-list@drzeus.cx, tony@atomide.com


The patch titled
     mmc: omap: check the get_cover_state function pointer if not set
has been added to the -mm tree.  Its filename is
     mmc-omap-check-the-get_cover_state-function-pointer-if-not-set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: check the get_cover_state function pointer if not set
From: Kyungmin Park <kyungmin.park@samsung.com>

If the get_cover_state is not set, it occurs the oops.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-check-the-get_cover_state-function-pointer-if-not-set drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-check-the-get_cover_state-function-pointer-if-not-set
+++ a/drivers/mmc/host/omap.c
@@ -236,7 +236,10 @@ static void mmc_omap_release_slot(struct
 static inline
 int mmc_omap_cover_is_open(struct mmc_omap_slot *slot)
 {
-	return slot->pdata->get_cover_state(mmc_dev(slot->mmc), slot->id);
+	if (slot->pdata->get_cover_state)
+		return slot->pdata->get_cover_state(mmc_dev(slot->mmc),
+						    slot->id);
+	return 0;
 }
 
 static ssize_t
_

Patches currently in -mm which might be from kyungmin.park@samsung.com are

mmc-omap-check-the-get_cover_state-function-pointer-if-not-set.patch
git-mtd.patch

