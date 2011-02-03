From: akpm@linux-foundation.org
Subject: + drivers-misc-apds9802alsc-put-the-device-into-runtime-suspend-after-resume-probe-is-handled.patch added to -mm tree
Date: Thu, 03 Feb 2011 12:12:35 -0800
Message-ID: <201102032012.p13KCamm022262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754986Ab1BCUNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 15:13:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hong.liu@intel.com, alan@linux.intel.com, stable@kernel.org


The patch titled
     drivers/misc/apds9802als.c: put the device into runtime suspend after resume()/probe() is handled
has been added to the -mm tree.  Its filename is
     drivers-misc-apds9802alsc-put-the-device-into-runtime-suspend-after-resume-probe-is-handled.patch

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
Subject: drivers/misc/apds9802als.c: put the device into runtime suspend after resume()/probe() is handled
From: Hong Liu <hong.liu@intel.com>

Put the device into runtime suspend after resume()/probe() is handled by
the PM core and the device core code.  No need to manually add them in
each single driver.  And correct the runtime state in remove().

Signed-off-by: Hong Liu <hong.liu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: <stable@kernel.org>
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
