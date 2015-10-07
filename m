From: akpm@linux-foundation.org
Subject: [merged] w1-call-put_device-if-device_register-fails.patch
 removed from -mm tree
Date: Wed, 07 Oct 2015 13:26:08 -0700
Message-ID: <56157fe0.INDLVFbZT1HS2xI1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbbJGU0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Oct 2015 16:26:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: levex@linux.com, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/w1/w1_int.c: call put_device if device_register fails
has been removed from the -mm tree.  Its filename was
     w1-call-put_device-if-device_register-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Levente Kurusa <levex@linux.com>
Subject: drivers/w1/w1_int.c: call put_device if device_register fails

Currently, memsetting and kfreeing the device is bad behaviour.  The
device will have a reference count of 1 and hence can cause trouble
because it has kfree'd.  Proper way to handle a failed device_register is
to call put_device right after it fails.

Signed-off-by: Levente Kurusa <levex@linux.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_int.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/w1/w1_int.c~w1-call-put_device-if-device_register-fails drivers/w1/w1_int.c
--- a/drivers/w1/w1_int.c~w1-call-put_device-if-device_register-fails
+++ a/drivers/w1/w1_int.c
@@ -91,8 +91,7 @@ static struct w1_master *w1_alloc_dev(u3
 	err = device_register(&dev->dev);
 	if (err) {
 		pr_err("Failed to register master device. err=%d\n", err);
-		memset(dev, 0, sizeof(struct w1_master));
-		kfree(dev);
+		put_device(&dev->dev);
 		dev = NULL;
 	}
 
_

Patches currently in -mm which might be from levex@linux.com are


