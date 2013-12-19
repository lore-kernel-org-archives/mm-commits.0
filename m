From: akpm@linux-foundation.org
Subject: [merged] eisa-call-put_device-if-device_register-fails.patch
 removed from -mm tree
Date: Thu, 19 Dec 2013 11:54:13 -0800
Message-ID: <52b34ee5.Zz6z7gQM+Ujgvj8J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab3LSTyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 14:54:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, bhelgaas@google.com, levex@linux.com

Subject: [merged] eisa-call-put_device-if-device_register-fails.patch removed from -mm tree
To: levex@linux.com,bhelgaas@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 11:54:13 -0800


The patch titled
     Subject: drivers/eisa/eisa-bus.c: call put_device if device_register fails
has been removed from the -mm tree.  Its filename was
     eisa-call-put_device-if-device_register-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Levente Kurusa <levex@linux.com>
Subject: drivers/eisa/eisa-bus.c: call put_device if device_register fails

We need to give up the last reference to edev->dev, so we need to call
put_device().

Signed-off-by: Levente Kurusa <levex@linux.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/eisa/eisa-bus.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/eisa/eisa-bus.c~eisa-call-put_device-if-device_register-fails drivers/eisa/eisa-bus.c
--- a/drivers/eisa/eisa-bus.c~eisa-call-put_device-if-device_register-fails
+++ a/drivers/eisa/eisa-bus.c
@@ -232,8 +232,10 @@ static int __init eisa_init_device(struc
 static int __init eisa_register_device(struct eisa_device *edev)
 {
 	int rc = device_register(&edev->dev);
-	if (rc)
+	if (rc) {
+		put_device(&edev->dev);
 		return rc;
+	}
 
 	rc = device_create_file(&edev->dev, &dev_attr_signature);
 	if (rc)
_

Patches currently in -mm which might be from levex@linux.com are

kstrtox-remove-redundant-cleanup.patch
lib-cmdlinec-declare-exported-symbols-immediately.patch
linux-next.patch
w1-call-put_device-if-device_register-fails.patch
backlight-lcd-call-put_device-if-device_register-fails.patch
net-phy-call-put_device-on-device_register-failure.patch

