From: akpm@linux-foundation.org
Subject: + remove-unusued-edac_reset_delay_period-function.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:55:46 -0700
Message-ID: <200707232155.l6NLtkAC013940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757550AbXGWV4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:56:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: caglar@pardus.org.tr, dougthompson@xmission.com, norsk5@yahoo.com


The patch titled
     Remove unusued edac_reset_delay_period function
has been added to the -mm tree.  Its filename is
     remove-unusued-edac_reset_delay_period-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
