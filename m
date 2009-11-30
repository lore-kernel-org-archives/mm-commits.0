From: akpm@linux-foundation.org
Subject: [merged] thermal-only-set-passive_delay-for-forced_passive-cooling.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:33:36 -0800
Message-ID: <200911302033.nAUKXapt021427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752772AbZK3Uew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:34:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, lenb@kernel.org, mjg@redhat.com, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     thermal: Only set passive_delay for forced_passive cooling
has been removed from the -mm tree.  Its filename was
     thermal-only-set-passive_delay-for-forced_passive-cooling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 drivers/thermal/thermal_sys.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

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
