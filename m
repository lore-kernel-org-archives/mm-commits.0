From: akpm@linux-foundation.org
Subject: [merged] drivers-hwmon-hwmonc-convert-idr-to-ida-and-use-ida_simple_get.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:13:01 -0700
Message-ID: <201111012113.pA1LD1eg005950@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29638 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:13:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jic23@cam.ac.uk, James.Bottomley@HansenPartnership.com, djwong@us.ibm.com, guenter.roeck@ericsson.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/hwmon/hwmon.c: convert idr to ida and use ida_simple_get()
has been removed from the -mm tree.  Its filename was
     drivers-hwmon-hwmonc-convert-idr-to-ida-and-use-ida_simple_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: drivers/hwmon/hwmon.c: convert idr to ida and use ida_simple_get()

A straightforward looking use of idr for a device id.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Acked-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/ibmaem.c |   47 ++++++---------------------------------
 1 file changed, 8 insertions(+), 39 deletions(-)

diff -puN drivers/hwmon/ibmaem.c~drivers-hwmon-hwmonc-convert-idr-to-ida-and-use-ida_simple_get drivers/hwmon/ibmaem.c
--- a/drivers/hwmon/ibmaem.c~drivers-hwmon-hwmonc-convert-idr-to-ida-and-use-ida_simple_get
+++ a/drivers/hwmon/ibmaem.c
@@ -88,8 +88,7 @@
 #define AEM_MIN_POWER_INTERVAL	200
 #define UJ_PER_MJ		1000L
 
-static DEFINE_IDR(aem_idr);
-static DEFINE_SPINLOCK(aem_idr_lock);
+static DEFINE_IDA(aem_ida);
 
 static struct platform_driver aem_driver = {
 	.driver = {
@@ -356,38 +355,6 @@ static void aem_msg_handler(struct ipmi_
 	complete(&data->read_complete);
 }
 
-/* ID functions */
-
-/* Obtain an id */
-static int aem_idr_get(int *id)
-{
-	int i, err;
-
-again:
-	if (unlikely(!idr_pre_get(&aem_idr, GFP_KERNEL)))
-		return -ENOMEM;
-
-	spin_lock(&aem_idr_lock);
-	err = idr_get_new(&aem_idr, NULL, &i);
-	spin_unlock(&aem_idr_lock);
-
-	if (unlikely(err == -EAGAIN))
-		goto again;
-	else if (unlikely(err))
-		return err;
-
-	*id = i & MAX_ID_MASK;
-	return 0;
-}
-
-/* Release an object ID */
-static void aem_idr_put(int id)
-{
-	spin_lock(&aem_idr_lock);
-	idr_remove(&aem_idr, id);
-	spin_unlock(&aem_idr_lock);
-}
-
 /* Sensor support functions */
 
 /* Read a sensor value */
@@ -530,7 +497,7 @@ static void aem_delete(struct aem_data *
 	ipmi_destroy_user(data->ipmi.user);
 	platform_set_drvdata(data->pdev, NULL);
 	platform_device_unregister(data->pdev);
-	aem_idr_put(data->id);
+	ida_simple_remove(&aem_ida, data->id);
 	kfree(data);
 }
 
@@ -587,7 +554,8 @@ static int aem_init_aem1_inst(struct aem
 		data->power_period[i] = AEM_DEFAULT_POWER_INTERVAL;
 
 	/* Create sub-device for this fw instance */
-	if (aem_idr_get(&data->id))
+	data->id = ida_simple_get(&aem_ida, 0, 0, GFP_KERNEL);
+	if (data->id < 0)
 		goto id_err;
 
 	data->pdev = platform_device_alloc(DRVNAME, data->id);
@@ -638,7 +606,7 @@ ipmi_err:
 	platform_set_drvdata(data->pdev, NULL);
 	platform_device_unregister(data->pdev);
 dev_err:
-	aem_idr_put(data->id);
+	ida_simple_remove(&aem_ida, data->id);
 id_err:
 	kfree(data);
 
@@ -720,7 +688,8 @@ static int aem_init_aem2_inst(struct aem
 		data->power_period[i] = AEM_DEFAULT_POWER_INTERVAL;
 
 	/* Create sub-device for this fw instance */
-	if (aem_idr_get(&data->id))
+	data->id = ida_simple_get(&aem_ida, 0, 0, GFP_KERNEL);
+	if (data->id < 0)
 		goto id_err;
 
 	data->pdev = platform_device_alloc(DRVNAME, data->id);
@@ -771,7 +740,7 @@ ipmi_err:
 	platform_set_drvdata(data->pdev, NULL);
 	platform_device_unregister(data->pdev);
 dev_err:
-	aem_idr_put(data->id);
+	ida_simple_remove(&aem_ida, data->id);
 id_err:
 	kfree(data);
 
_

Patches currently in -mm which might be from jic23@cam.ac.uk are

origin.patch
linux-next.patch
drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code.patch
drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch
drivers-rtc-classc-convert-idr-to-ida-and-use-ida_simple_get.patch
w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it.patch

