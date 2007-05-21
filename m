From: akpm@linux-foundation.org
Subject: + i2o-eliminate-a-peculiar-constraint-on-i2o_max_drivers.patch added to -mm tree
Date: Mon, 21 May 2007 14:44:06 -0700
Message-ID: <200705212144.l4LLi6Fp020760@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36363 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756293AbXEUVqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:46:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, Markus.Lidel@shadowconnect.com


The patch titled
     i2o: eliminate a peculiar constraint on i2o_max_drivers
has been added to the -mm tree.  Its filename is
     i2o-eliminate-a-peculiar-constraint-on-i2o_max_drivers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

auth_gss-unregister-gss_domain-when-unloading-module.patch
i2o-destroy-event-queue-only-when-drv-event-is-set.patch
i2o-fix-notifiers-when-max_drivers-is-configured.patch
i2o-eliminate-a-peculiar-constraint-on-i2o_max_drivers.patch
add-kstrndup.patch
