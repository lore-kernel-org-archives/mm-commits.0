From: akpm@linux-foundation.org
Subject: + acpi-thermal-display-forced-passive-trip-points-in-proc.patch added to -mm tree
Date: Wed, 28 Oct 2009 15:36:08 -0700
Message-ID: <200910282236.n9SMa9Zb021283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753915AbZJ1Wgv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 18:36:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elendil@planet.nl, lenb@kernel.org, mjg59@srcf.ucam.org, rui.zhang@intel.com


The patch titled
     acpi: thermal: display forced passive trip points in proc
has been added to the -mm tree.  Its filename is
     acpi-thermal-display-forced-passive-trip-points-in-proc.patch

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
thermal-sysfs-apitxt-reformat-for-improved-readability.patch
thermal-sysfs-apitxt-document-passive-attribute-for-thermal-zones.patch
acpi-thermal-display-forced-passive-trip-points-in-proc.patch
thermal-add-sanity-check-for-the-passive-attribute.patch
thermal-only-set-passive_delay-for-forced_passive-cooling.patch
thermal-disable-polling-if-passive_delay-and-polling_delay-are-both-unset.patch

