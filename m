From: akpm@linux-foundation.org
Subject: - mmc-omap-check-the-get_cover_state-function-pointer-if-not-set.patch removed from -mm tree
Date: Wed, 26 Mar 2008 20:17:55 -0700
Message-ID: <200803270317.m2R3HtAZ015189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755788AbYC0DSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 23:18:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyungmin.park@samsung.com, drzeus-list@drzeus.cx, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     mmc: omap: check the get_cover_state function pointer if not set
has been removed from the -mm tree.  Its filename was
     mmc-omap-check-the-get_cover_state-function-pointer-if-not-set.patch

This patch was dropped because an updated version will be merged

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

