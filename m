From: akpm@linux-foundation.org
Subject: [merged] thermal-disable-polling-if-passive_delay-and-polling_delay-are-both-unset.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:33:39 -0800
Message-ID: <200911302033.nAUKXd5V021597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868AbZK3Ue4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:34:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, lenb@kernel.org, mjg@redhat.com, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     thermal: disable polling if passive_delay and polling_delay are both unset
has been removed from the -mm tree.  Its filename was
     thermal-disable-polling-if-passive_delay-and-polling_delay-are-both-unset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thermal: disable polling if passive_delay and polling_delay are both unset
From: Frans Pop <elendil@planet.nl>

Otherwise polling will continue for the thermal zone even when it is no
longer needed, for example because forced passive cooling was disabled.

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/thermal/thermal_sys.c~thermal-disable-polling-if-passive_delay-and-polling_delay-are-both-unset drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal-disable-polling-if-passive_delay-and-polling_delay-are-both-unset
+++ a/drivers/thermal/thermal_sys.c
@@ -1019,6 +1019,8 @@ void thermal_zone_device_update(struct t
 		thermal_zone_device_set_polling(tz, tz->passive_delay);
 	else if (tz->polling_delay)
 		thermal_zone_device_set_polling(tz, tz->polling_delay);
+	else
+		thermal_zone_device_set_polling(tz, 0);
 	mutex_unlock(&tz->lock);
 }
 EXPORT_SYMBOL(thermal_zone_device_update);
_

Patches currently in -mm which might be from elendil@planet.nl are

linux-next.patch
acpi-thermal-display-forced-passive-trip-points-in-proc.patch
page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch

