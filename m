From: akpm@linux-foundation.org
Subject: + drivers-hwmon-hwmonc-convert-idr-to-ida-and-use-ida_simple_get.patch added to -mm tree
Date: Thu, 28 Jul 2011 15:48:46 -0700
Message-ID: <201107282248.p6SMmkLI013043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074Ab1G1WtH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 18:49:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jic23@cam.ac.uk, James.Bottomley@HansenPartnership.com, djwong@us.ibm.com, guenter.roeck@ericsson.com, rusty@rustcorp.com.au, tj@kernel.org


The patch titled
     drivers/hwmon/hwmon.c: convert idr to ida and use ida_simple_get()
has been added to the -mm tree.  Its filename is
     drivers-hwmon-hwmonc-convert-idr-to-ida-and-use-ida_simple_get.patch

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
Subject: drivers/hwmon/hwmon.c: convert idr to ida and use ida_simple_get()
From: Jonathan Cameron <jic23@cam.ac.uk>

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
@@ -525,7 +492,7 @@ static void aem_delete(struct aem_data *
 	ipmi_destroy_user(data->ipmi.user);
 	platform_set_drvdata(data->pdev, NULL);
 	platform_device_unregister(data->pdev);
-	aem_idr_put(data->id);
+	ida_simple_remove(&aem_ida, data->id);
 	kfree(data);
 }
 
@@ -582,7 +549,8 @@ static int aem_init_aem1_inst(struct aem
 		data->power_period[i] = AEM_DEFAULT_POWER_INTERVAL;
 
 	/* Create sub-device for this fw instance */
-	if (aem_idr_get(&data->id))
+	data->id = ida_simple_get(&aem_ida, 0, 0, GFP_KERNEL);
+	if (data->id < 0)
 		goto id_err;
 
 	data->pdev = platform_device_alloc(DRVNAME, data->id);
@@ -633,7 +601,7 @@ ipmi_err:
 	platform_set_drvdata(data->pdev, NULL);
 	platform_device_unregister(data->pdev);
 dev_err:
-	aem_idr_put(data->id);
+	ida_simple_remove(&aem_ida, data->id);
 id_err:
 	kfree(data);
 
@@ -715,7 +683,8 @@ static int aem_init_aem2_inst(struct aem
 		data->power_period[i] = AEM_DEFAULT_POWER_INTERVAL;
 
 	/* Create sub-device for this fw instance */
-	if (aem_idr_get(&data->id))
+	data->id = ida_simple_get(&aem_ida, 0, 0, GFP_KERNEL);
+	if (data->id < 0)
 		goto id_err;
 
 	data->pdev = platform_device_alloc(DRVNAME, data->id);
@@ -766,7 +735,7 @@ ipmi_err:
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
ida-simplified-functions-for-id-allocation.patch
hwmon-convert-idr-to-ida-and-use-ida_simple-interface.patch
drivers-hwmon-hwmonc-convert-idr-to-ida-and-use-ida_simple_get.patch
drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code.patch
drm-vmwgfx-use-ida_simple_get-for-id-allocation.patch
drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch
w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it.patch
drivers-rtc-classc-convert-idr-to-ida-and-use-ida_simple_get.patch
linux-next.patch

