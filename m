From: akpm@linux-foundation.org
Subject: + pmu-battery-filenames-in-sysfs-with-spaces.patch added to -mm tree
Date: Wed, 30 Apr 2008 13:25:39 -0700
Message-ID: <200804302025.m3UKPdNQ001148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758772AbYD3U0X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 16:26:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lists@nerdbynature.de, cbou@mail.ru, dwmw2@infradead.org


The patch titled
     PMU battery: filenames in sysfs with spaces
has been added to the -mm tree.  Its filename is
     pmu-battery-filenames-in-sysfs-with-spaces.patch

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
Subject: PMU battery: filenames in sysfs with spaces
From: Christian Kujau <lists@nerdbynature.de>

By changing drivers/power/pmu_battery.c I now have '_' instead of
' ' (spaces) in /sys:

/sys/devices/platform/pmu-battery.0/power_supply/PMU_battery_0
/sys/class/power_supply/PMU_battery_0

I'm still not sure if some userspace tool out there uses the old paths and
will break now.

Signed-off-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Cc: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/pmu_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/power/pmu_battery.c~pmu-battery-filenames-in-sysfs-with-spaces drivers/power/pmu_battery.c
--- a/drivers/power/pmu_battery.c~pmu-battery-filenames-in-sysfs-with-spaces
+++ a/drivers/power/pmu_battery.c
@@ -159,7 +159,7 @@ static int __init pmu_bat_init(void)
 		if (!pbat)
 			break;
 
-		sprintf(pbat->name, "PMU battery %d", i);
+		sprintf(pbat->name, "PMU_battery_%d", i);
 		pbat->bat.name = pbat->name;
 		pbat->bat.properties = pmu_bat_props;
 		pbat->bat.num_properties = ARRAY_SIZE(pmu_bat_props);
_

Patches currently in -mm which might be from lists@nerdbynature.de are

pmu-battery-filenames-in-sysfs-with-spaces.patch

