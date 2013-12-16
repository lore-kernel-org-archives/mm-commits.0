From: akpm@linux-foundation.org
Subject: + w1-call-put_device-if-device_register-fails.patch added to -mm
 tree
Date: Mon, 16 Dec 2013 15:17:52 -0800
Message-ID: <52af8a20.VGkI/hhxMPCvJJ8m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3LPXRx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 18:17:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zbr@ioremap.net, levex@linux.com

Subject: + w1-call-put_device-if-device_register-fails.patch added to -mm tree
To: levex@linux.com,zbr@ioremap.net
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 15:17:52 -0800


The patch titled
     Subject: drivers/w1/w1_int.c: call put_device if device_register fails
has been added to the -mm tree.  Its filename is
     w1-call-put_device-if-device_register-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/w1-call-put_device-if-device_register-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/w1-call-put_device-if-device_register-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 drivers/w1/w1_int.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/w1/w1_int.c~w1-call-put_device-if-device_register-fails drivers/w1/w1_int.c
--- a/drivers/w1/w1_int.c~w1-call-put_device-if-device_register-fails
+++ a/drivers/w1/w1_int.c
@@ -90,9 +90,8 @@ static struct w1_master * w1_alloc_dev(u
 	err = device_register(&dev->dev);
 	if (err) {
 		printk(KERN_ERR "Failed to register master device. err=%d\n", err);
-		memset(dev, 0, sizeof(struct w1_master));
-		kfree(dev);
-		dev = NULL;
+		put_device(&dev->dev);
+		return NULL;
 	}
 
 	return dev;
_

Patches currently in -mm which might be from levex@linux.com are

kstrtox-remove-redundant-cleanup.patch
lib-cmdlinec-declare-exported-symbols-immediately.patch
linux-next.patch
backlight-lcd-call-put_device-if-device_register-fails.patch
net-phy-call-put_device-on-device_register-failure.patch
eisa-call-put_device-if-device_register-fails.patch
w1-call-put_device-if-device_register-fails.patch

