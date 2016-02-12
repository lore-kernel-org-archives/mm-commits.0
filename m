From: akpm@linux-foundation.org
Subject: + rapidio-add-mport-char-device-driver-fix-2.patch added to -mm
 tree
Date: Fri, 12 Feb 2016 11:39:56 -0800
Message-ID: <56be350c.iEJ+iqouCP8FM3mD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbcBLTj5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Feb 2016 14:39:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, alexandre.bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: mport_cdev: fix some error codes
has been added to the -mm tree.  Its filename is
     rapidio-add-mport-char-device-driver-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-add-mport-char-device-driver-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-add-mport-char-device-driver-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rapidio-add-mport-char-device-driver-fix-2.patch

