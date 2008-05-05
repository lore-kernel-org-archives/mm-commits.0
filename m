From: akpm@linux-foundation.org
Subject: - pmu-battery-filenames-in-sysfs-with-spaces.patch removed from -mm tree
Date: Mon, 05 May 2008 12:16:51 -0700
Message-ID: <200805051916.m45JGpAh000333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439AbYEETRU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:17:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lists@nerdbynature.de, cbou@mail.ru, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     PMU battery: filenames in sysfs with spaces
has been removed from the -mm tree.  Its filename was
     pmu-battery-filenames-in-sysfs-with-spaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


