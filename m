From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-apds9802alsc-put-the-device-into-runtime-suspend-after-resume-probe-is-handled.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:41 -0700
Message-ID: <201103232042.p2NKgHHN028742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600Ab1CWUzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hong.liu@intel.com, alan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/apds9802als.c: put the device into runtime suspend after resume()/probe() is handled
has been removed from the -mm tree.  Its filename was
     drivers-misc-apds9802alsc-put-the-device-into-runtime-suspend-after-resume-probe-is-handled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/apds9802als.c: put the device into runtime suspend after resume()/probe() is handled
From: Hong Liu <hong.liu@intel.com>

Put the device into runtime suspend after resume()/probe() is handled by
the PM core and the device core code.  No need to manually add them in
each single driver.  And correct the runtime state in remove().

Signed-off-by: Hong Liu <hong.liu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/apds9802als.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN drivers/misc/apds9802als.c~drivers-misc-apds9802alsc-put-the-device-into-runtime-suspend-after-resume-probe-is-handled drivers/misc/apds9802als.c
--- a/drivers/misc/apds9802als.c~drivers-misc-apds9802alsc-put-the-device-into-runtime-suspend-after-resume-probe-is-handled
+++ a/drivers/misc/apds9802als.c
@@ -245,9 +245,8 @@ static int apds9802als_probe(struct i2c_
 	als_set_default_config(client);
 	mutex_init(&data->mutex);
 
+	pm_runtime_set_active(&client->dev);
 	pm_runtime_enable(&client->dev);
-	pm_runtime_get(&client->dev);
-	pm_runtime_put(&client->dev);
 
 	return res;
 als_error1:
@@ -255,12 +254,19 @@ als_error1:
 	return res;
 }
 
-static int apds9802als_remove(struct i2c_client *client)
+static int __devexit apds9802als_remove(struct i2c_client *client)
 {
 	struct als_data *data = i2c_get_clientdata(client);
 
+	pm_runtime_get_sync(&client->dev);
+
 	als_set_power_state(client, false);
 	sysfs_remove_group(&client->dev.kobj, &m_als_gr);
+
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+	pm_runtime_put_noidle(&client->dev);
+
 	kfree(data);
 	return 0;
 }
@@ -275,9 +281,6 @@ static int apds9802als_suspend(struct i2
 static int apds9802als_resume(struct i2c_client *client)
 {
 	als_set_default_config(client);
