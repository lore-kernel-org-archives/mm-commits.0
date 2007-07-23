From: akpm@linux-foundation.org
Subject: - remove-unusued-edac_reset_delay_period-function.patch removed from -mm tree
Date: Mon, 23 Jul 2007 15:31:29 -0700
Message-ID: <200707232231.l6NMVTsa015385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34586 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756072AbXGWWcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 18:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: caglar@pardus.org.tr, dougthompson@xmission.com, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     Remove unusued edac_reset_delay_period function
has been removed from the -mm tree.  Its filename was
     remove-unusued-edac_reset_delay_period-function.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Remove unusued edac_reset_delay_period function
From: <caglar@pardus.org.tr>

drivers/edac/edac_mc.c:334: warning: 'edac_reset_delay_period' defined but not used

Signed-off-by: <caglar@pardus.org.tr>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc.c |   17 -----------------
 1 files changed, 17 deletions(-)

diff -puN drivers/edac/edac_mc.c~remove-unusued-edac_reset_delay_period-function drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~remove-unusued-edac_reset_delay_period-function
+++ a/drivers/edac/edac_mc.c
@@ -327,23 +327,6 @@ static void edac_mc_workq_teardown(struc
 	}
 }
 
-/*
- * edac_reset_delay_period
- */
-static void edac_reset_delay_period(struct mem_ctl_info *mci, unsigned long value)
-{
-	/* cancel the current workq request */
-	edac_mc_workq_teardown(mci);
-
-	/* lock the list of devices for the new setup */
-	mutex_lock(&mem_ctls_mutex);
-
-	/* restart the workq request, with new delay value */
-	edac_mc_workq_setup(mci, value);
-
-	mutex_unlock(&mem_ctls_mutex);
-}
-
 /* Return 0 on success, 1 on failure.
  * Before calling this function, caller must
  * assign a unique value to mci->mc_idx.
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

nikon-d50-is-an-unusual-device.patch
remove-unusued-edac_reset_delay_period-function.patch
drivers-char-hpetc-integer-constant-is-too-large-for-long-type.patch
