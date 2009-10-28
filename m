From: akpm@linux-foundation.org
Subject: + thermal-only-set-passive_delay-for-forced_passive-cooling.patch added to -mm tree
Date: Wed, 28 Oct 2009 15:36:12 -0700
Message-ID: <200910282236.n9SMaCwC021515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081AbZJ1WhF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 18:37:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elendil@planet.nl, lenb@kernel.org, mjg@redhat.com, rui.zhang@intel.com


The patch titled
     thermal: Only set passive_delay for forced_passive cooling
has been added to the -mm tree.  Its filename is
     thermal-only-set-passive_delay-for-forced_passive-cooling.patch

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
Subject: thermal: Only set passive_delay for forced_passive cooling
From: Frans Pop <elendil@planet.nl>

Setting polling_delay is useless as passive_delay has priority, so the
value shown in proc isn't the actual polling delay.  It also gives the
impression to the user that he can change the polling interval through
proc, while in fact he can't.

Also, unset passive_delay when the forced passive trip point is unbound to
allow polling to be disabled.

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/thermal/thermal_sys.c~thermal-only-set-passive_delay-for-forced_passive-cooling drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal-only-set-passive_delay-for-forced_passive-cooling
+++ a/drivers/thermal/thermal_sys.c
@@ -241,6 +241,8 @@ passive_store(struct device *dev, struct
 								 cdev);
 		}
 		mutex_unlock(&thermal_list_lock);
+		if (!tz->passive_delay)
+			tz->passive_delay = 1000;
 	} else if (!state && tz->forced_passive) {
 		mutex_lock(&thermal_list_lock);
 		list_for_each_entry(cdev, &thermal_cdev_list, node) {
@@ -251,17 +253,12 @@ passive_store(struct device *dev, struct
 								   cdev);
 		}
 		mutex_unlock(&thermal_list_lock);
+		tz->passive_delay = 0;
 	}
 
 	tz->tc1 = 1;
 	tz->tc2 = 1;
 
-	if (!tz->passive_delay)
-		tz->passive_delay = 1000;
-
-	if (!tz->polling_delay)
-		tz->polling_delay = 10000;
