From: akpm@linux-foundation.org
Subject: [folded-merged] rapidio-add-mport-char-device-driver-fix-2.patch
 removed from -mm tree
Date: Tue, 22 Mar 2016 13:56:25 -0700
Message-ID: <56f1b179.uK5txGTGvBIujbSU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbcCVU40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 16:56:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, alexandre.bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: mport_cdev: fix some error codes
has been removed from the -mm tree.  Its filename was
     rapidio-add-mport-char-device-driver-fix-2.patch

This patch was dropped because it was folded into rapidio-add-mport-char-device-driver.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: rapidio: mport_cdev: fix some error codes

copy_to_user() returns the number of bytes not copied but we want to
return an error code.

Fixes: a45bfc36bf0d ('rapidio: add mport char device driver')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/rapidio/devices/rio_mport_cdev.c~rapidio-add-mport-char-device-driver-fix-2 drivers/rapidio/devices/rio_mport_cdev.c
--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-add-mport-char-device-driver-fix-2
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -2140,9 +2140,10 @@ static long mport_cdev_ioctl(struct file
 		return maint_port_idx_get(data, (void __user *)arg);
 	case RIO_MPORT_GET_PROPERTIES:
 		md->properties.hdid = md->mport->host_deviceid;
-		err = copy_to_user((void __user *)arg, &(data->md->properties),
-				   sizeof(data->md->properties));
-		break;
+		if (copy_to_user((void __user *)arg, &(data->md->properties),
+				 sizeof(data->md->properties)))
+			return -EFAULT;
+		return 0;
 	case RIO_ENABLE_DOORBELL_RANGE:
 		return rio_mport_add_db_filter(data, (void __user *)arg);
 	case RIO_DISABLE_DOORBELL_RANGE:
@@ -2155,8 +2156,10 @@ static long mport_cdev_ioctl(struct file
 		data->event_mask = arg;
 		return 0;
 	case RIO_GET_EVENT_MASK:
-		return copy_to_user((void __user *)arg, &data->event_mask,
-				    sizeof(data->event_mask));
+		if (copy_to_user((void __user *)arg, &data->event_mask,
+				    sizeof(data->event_mask)))
+			return -EFAULT;
+		return 0;
 	case RIO_MAP_OUTBOUND:
 		return rio_mport_obw_map(filp, (void __user *)arg);
 	case RIO_MAP_INBOUND:
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

rapidio-add-mport-char-device-driver.patch

