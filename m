From: akpm@linux-foundation.org
Subject: + sd-async-shutdown.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:02:38 -0800
Message-ID: <200901132202.n0DM2cGt009150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754407AbZAMWCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:02:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, James.Bottomley@HansenPartnership.com, arjan@infradead.org


The patch titled
     sd: async shutdown
has been added to the -mm tree.  Its filename is
     sd-async-shutdown.patch

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
Subject: sd: async shutdown
From: Shaohua Li <shaohua.li@intel.com>

sd shutdown is quite slow. It sometimes will take about 1s for shutdown.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/sd.c~sd-async-shutdown drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~sd-async-shutdown
+++ a/drivers/scsi/sd.c
@@ -98,6 +98,7 @@ static int  sd_revalidate_disk(struct ge
 static int  sd_probe(struct device *);
 static int  sd_remove(struct device *);
 static void sd_shutdown(struct device *);
+static void sd_sync_shutdown(struct device *);
 static int sd_suspend(struct device *, pm_message_t state);
 static int sd_resume(struct device *);
 static void sd_rescan(struct device *);
@@ -1962,7 +1963,7 @@ static int sd_remove(struct device *dev)
 
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
-	sd_shutdown(dev);
+	sd_sync_shutdown(dev);
 
 	mutex_lock(&sd_ref_mutex);
 	dev_set_drvdata(dev, NULL);
@@ -2028,8 +2029,9 @@ static int sd_start_stop_device(struct s
  * the normal SCSI command structure.  Wait for the command to
  * complete.
  */
-static void sd_shutdown(struct device *dev)
+static void sd_async_shutdown(void *data, async_cookie_t cookie)
 {
+	struct device *dev = data;
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 
 	if (!sdkp)
@@ -2048,6 +2050,17 @@ static void sd_shutdown(struct device *d
 	scsi_disk_put(sdkp);
 }
 
+static void sd_shutdown(struct device *dev)
+{
+	async_schedule(sd_async_shutdown, dev);
+}
+
+static void sd_sync_shutdown(struct device *dev)
+{
+	async_cookie_t cookie = async_schedule(sd_async_shutdown, dev);
+	async_synchronize_cookie(cookie);
+}
+
 static int sd_suspend(struct device *dev, pm_message_t mesg)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
_

Patches currently in -mm which might be from shaohua.li@intel.com are

linux-next.patch
synchronize-device-shutdown.patch
serios-async-shutdown.patch
sd-async-shutdown.patch

