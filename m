From: akpm@linux-foundation.org
Subject: + memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new.patch added to -mm tree
Date: Thu, 09 Dec 2010 12:14:25 -0800
Message-ID: <201012092014.oB9KERF8004579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757017Ab0LIUO6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 15:14:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oakad@yahoo.com


The patch titled
     memstick: avert possible race condition between idr_pre_get and idr_get_new
has been added to the -mm tree.  Its filename is
     memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new.patch

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
Subject: memstick: avert possible race condition between idr_pre_get and idr_get_new
From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c    |   18 +++++++++++-------
 drivers/memstick/core/mspro_block.c |    6 ++++--
 2 files changed, 15 insertions(+), 9 deletions(-)

diff -puN drivers/memstick/core/memstick.c~memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new
+++ a/drivers/memstick/core/memstick.c
@@ -511,14 +511,18 @@ int memstick_add_host(struct memstick_ho
 {
 	int rc;
 
-	if (!idr_pre_get(&memstick_host_idr, GFP_KERNEL))
-		return -ENOMEM;
+	while (1) {
+		if (!idr_pre_get(&memstick_host_idr, GFP_KERNEL))
+			return -ENOMEM;
 
-	spin_lock(&memstick_host_lock);
-	rc = idr_get_new(&memstick_host_idr, host, &host->id);
-	spin_unlock(&memstick_host_lock);
-	if (rc)
-		return rc;
+		spin_lock(&memstick_host_lock);
+		rc = idr_get_new(&memstick_host_idr, host, &host->id);
+		spin_unlock(&memstick_host_lock);
+		if (!rc)
+			break;
+		else if (rc != -EAGAIN)
+			return rc;
+	}
 
 	dev_set_name(&host->dev, "memstick%u", host->id);
 
diff -puN drivers/memstick/core/mspro_block.c~memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new
+++ a/drivers/memstick/core/mspro_block.c
@@ -1206,10 +1206,12 @@ static int mspro_block_init_disk(struct 
 
 	msb->page_size = be16_to_cpu(sys_info->unit_size);
 
-	if (!idr_pre_get(&mspro_block_disk_idr, GFP_KERNEL))
+	mutex_lock(&mspro_block_disk_lock);
+	if (!idr_pre_get(&mspro_block_disk_idr, GFP_KERNEL)) {
+		mutex_unlock(&mspro_block_disk_lock);
 		return -ENOMEM;
+	}
 
-	mutex_lock(&mspro_block_disk_lock);
 	rc = idr_get_new(&mspro_block_disk_idr, card, &disk_id);
 	mutex_unlock(&mspro_block_disk_lock);
 
_

Patches currently in -mm which might be from oakad@yahoo.com are

memstick-core-fix-device_register-error-handling.patch
memstick-fix-setup-for-jmicron-38x-controllers.patch
memstick-set-pmos-values-propery-for-jmicron-38x-controllers.patch
memstick-add-support-for-jmicron-jmb-385-and-390-controllers.patch
memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new.patch
memstick-remove-mspro_block_mutex.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc.patch
memstick-add-support-for-mspro-specific-data-transfer-method.patch

