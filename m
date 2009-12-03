From: akpm@linux-foundation.org
Subject: [merged] acpi-thermal-display-forced-passive-trip-points-in-proc.patch removed from -mm tree
Date: Thu, 03 Dec 2009 15:56:47 -0800
Message-ID: <200912040020.nB40Kq2P013713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755321AbZLDAVj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 19:21:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, lenb@kernel.org, mjg59@srcf.ucam.org, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: thermal: display forced passive trip points in proc
has been removed from the -mm tree.  Its filename was
     acpi-thermal-display-forced-passive-trip-points-in-proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: thermal: display forced passive trip points in proc
From: Frans Pop <elendil@planet.nl>

Users can force a passive trip point for a thermal zone that does not have
_PSV defined in ACPI by setting the passive attribute in sysfs.  It's
useful to display such trip points in /proc/acpi/thermal_zone.

.../TZ1/cooling_mode:<setting not supported>
.../TZ1/polling_frequency:polling frequency:       10 seconds
.../TZ1/state:state:                   ok
.../TZ1/temperature:temperature:             53 C
.../TZ1/trip_points:critical (S5):           110 C
.../TZ1/trip_points:passive (forced):        95 C

And if not set (passive is 0):
.../TZ1/trip_points:passive (forced):<not set>

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/thermal.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/acpi/thermal.c~acpi-thermal-display-forced-passive-trip-points-in-proc drivers/acpi/thermal.c
--- a/drivers/acpi/thermal.c~acpi-thermal-display-forced-passive-trip-points-in-proc
+++ a/drivers/acpi/thermal.c
@@ -1052,6 +1052,13 @@ static int acpi_thermal_trip_seq_show(st
 				   acpi_device_bid(device));
 		}
 		seq_puts(seq, "\n");
+	} else {
+		seq_printf(seq, "passive (forced):");
+		if (tz->thermal_zone->forced_passive)
+			seq_printf(seq, "        %i C\n",
+				   tz->thermal_zone->forced_passive / 1000);
+		else
+			seq_printf(seq, "<not set>\n");
 	}
 
 	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE; i++) {
_

Patches currently in -mm which might be from elendil@planet.nl are

linux-next.patch
acpi-thermal-display-forced-passive-trip-points-in-proc.patch
page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch

