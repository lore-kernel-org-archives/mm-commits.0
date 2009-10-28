From: akpm@linux-foundation.org
Subject: + thermal-disable-polling-if-passive_delay-and-polling_delay-are-both-unset.patch added to -mm tree
Date: Wed, 28 Oct 2009 15:36:14 -0700
Message-ID: <200910282236.n9SMaEa6021559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920AbZJ1WhF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 18:37:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elendil@planet.nl, lenb@kernel.org, mjg@redhat.com, rui.zhang@intel.com


The patch titled
     thermal: disable polling if passive_delay and polling_delay are both unset
has been added to the -mm tree.  Its filename is
     thermal-disable-polling-if-passive_delay-and-polling_delay-are-both-unset.patch

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
thermal-sysfs-apitxt-reformat-for-improved-readability.patch
thermal-sysfs-apitxt-document-passive-attribute-for-thermal-zones.patch
acpi-thermal-display-forced-passive-trip-points-in-proc.patch
thermal-add-sanity-check-for-the-passive-attribute.patch
thermal-only-set-passive_delay-for-forced_passive-cooling.patch
thermal-disable-polling-if-passive_delay-and-polling_delay-are-both-unset.patch

