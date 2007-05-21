From: akpm@linux-foundation.org
Subject: + i2o-fix-notifiers-when-max_drivers-is-configured.patch added to -mm tree
Date: Sun, 20 May 2007 21:17:03 -0700
Message-ID: <200705210417.l4L4H2kA002158@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38607 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322AbXEUETY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:19:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, Markus.Lidel@shadowconnect.com


The patch titled
     i2o: fix notifiers when max_drivers is configured
has been added to the -mm tree.  Its filename is
     i2o-fix-notifiers-when-max_drivers-is-configured.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i2o: fix notifiers when max_drivers is configured
From: Akinobu Mita <akinobu.mita@gmail.com>

Maximum number of I2O drivers which could be registered is configurable by
max_drivers module parameter.

But the module parameter is ignored and default value (I2O_MAX_DRIVERS = 8)
is used in the loops to notify all registered drivers.

Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/driver.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/message/i2o/driver.c~i2o-fix-notifiers-when-max_drivers-is-configured drivers/message/i2o/driver.c
--- a/drivers/message/i2o/driver.c~i2o-fix-notifiers-when-max_drivers-is-configured
+++ a/drivers/message/i2o/driver.c
@@ -20,6 +20,7 @@
 #include <linux/workqueue.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/log2.h>
 #include "core.h"
 
 #define OSM_NAME	"i2o"
@@ -260,7 +261,7 @@ void i2o_driver_notify_controller_add_al
 	int i;
 	struct i2o_driver *drv;
 
-	for (i = 0; i < I2O_MAX_DRIVERS; i++) {
+	for (i = 0; i < i2o_max_drivers; i++) {
 		drv = i2o_drivers[i];
 
 		if (drv)
@@ -280,7 +281,7 @@ void i2o_driver_notify_controller_remove
 	int i;
 	struct i2o_driver *drv;
 
-	for (i = 0; i < I2O_MAX_DRIVERS; i++) {
+	for (i = 0; i < i2o_max_drivers; i++) {
 		drv = i2o_drivers[i];
 
 		if (drv)
@@ -299,7 +300,7 @@ void i2o_driver_notify_device_add_all(st
 	int i;
 	struct i2o_driver *drv;
 
-	for (i = 0; i < I2O_MAX_DRIVERS; i++) {
+	for (i = 0; i < i2o_max_drivers; i++) {
 		drv = i2o_drivers[i];
 
 		if (drv)
@@ -318,7 +319,7 @@ void i2o_driver_notify_device_remove_all
 	int i;
 	struct i2o_driver *drv;
 
-	for (i = 0; i < I2O_MAX_DRIVERS; i++) {
+	for (i = 0; i < i2o_max_drivers; i++) {
 		drv = i2o_drivers[i];
 
 		if (drv)
@@ -340,8 +341,7 @@ int __init i2o_driver_init(void)
 	spin_lock_init(&i2o_drivers_lock);
 
 	if ((i2o_max_drivers < 2) || (i2o_max_drivers > 64) ||
-	    ((i2o_max_drivers ^ (i2o_max_drivers - 1)) !=
-	     (2 * i2o_max_drivers - 1))) {
+	    !is_power_of_2(i2o_max_drivers)) {
 		osm_warn("max_drivers set to %d, but must be >=2 and <= 64 and "
 			 "a power of 2\n", i2o_max_drivers);
 		i2o_max_drivers = I2O_MAX_DRIVERS;
@@ -349,7 +349,7 @@ int __init i2o_driver_init(void)
 	osm_info("max drivers = %d\n", i2o_max_drivers);
 
 	i2o_drivers =
-	    kzalloc(i2o_max_drivers * sizeof(*i2o_drivers), GFP_KERNEL);
+	    kcalloc(i2o_max_drivers, sizeof(*i2o_drivers), GFP_KERNEL);
 	if (!i2o_drivers)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

auth_gss-unregister-gss_domain-when-unloading-module.patch
i2o-destroy-event-queue-only-when-drv-event-is-set.patch
i2o-fix-notifiers-when-max_drivers-is-configured.patch
add-kstrndup.patch
