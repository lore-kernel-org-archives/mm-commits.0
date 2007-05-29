From: akpm@linux-foundation.org
Subject: - i2o-eliminate-a-peculiar-constraint-on-i2o_max_drivers.patch removed from -mm tree
Date: Tue, 29 May 2007 11:52:28 -0700
Message-ID: <200705291852.l4TIqR8U008411@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758215AbXE2SxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, Markus.Lidel@shadowconnect.com, mm-commits@vger.kernel.org


The patch titled
     i2o: eliminate a peculiar constraint on i2o_max_drivers
has been removed from the -mm tree.  Its filename was
     i2o-eliminate-a-peculiar-constraint-on-i2o_max_drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i2o: eliminate a peculiar constraint on i2o_max_drivers
From: Akinobu Mita <akinobu.mita@gmail.com>

There is no reason i2o_max_drivers must be a power of two.  This patch
eliminates such a constraint.

Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/driver.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/message/i2o/driver.c~i2o-eliminate-a-peculiar-constraint-on-i2o_max_drivers drivers/message/i2o/driver.c
--- a/drivers/message/i2o/driver.c~i2o-eliminate-a-peculiar-constraint-on-i2o_max_drivers
+++ a/drivers/message/i2o/driver.c
@@ -20,7 +20,6 @@
 #include <linux/workqueue.h>
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <linux/log2.h>
 #include "core.h"
 
 #define OSM_NAME	"i2o"
@@ -340,10 +339,9 @@ int __init i2o_driver_init(void)
 
 	spin_lock_init(&i2o_drivers_lock);
 
-	if ((i2o_max_drivers < 2) || (i2o_max_drivers > 64) ||
-	    !is_power_of_2(i2o_max_drivers)) {
-		osm_warn("max_drivers set to %d, but must be >=2 and <= 64 and "
-			 "a power of 2\n", i2o_max_drivers);
+	if ((i2o_max_drivers < 2) || (i2o_max_drivers > 64)) {
+		osm_warn("max_drivers set to %d, but must be >=2 and <= 64\n",
+			 i2o_max_drivers);
 		i2o_max_drivers = I2O_MAX_DRIVERS;
 	}
 	osm_info("max drivers = %d\n", i2o_max_drivers);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

git-dvb.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
