From: akpm@linux-foundation.org
Subject: + eisa-call-put_device-if-device_register-fails.patch added to
 -mm tree
Date: Mon, 16 Dec 2013 15:17:51 -0800
Message-ID: <52af8a1f.u32xJxlwwDCYG4Hp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3LPXRw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 18:17:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, bhelgaas@google.com, levex@linux.com

Subject: + eisa-call-put_device-if-device_register-fails.patch added to -mm tree
To: levex@linux.com,bhelgaas@google.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 15:17:51 -0800


The patch titled
     Subject: drivers/eisa/eisa-bus.c: call put_device if device_register fails
has been added to the -mm tree.  Its filename is
     eisa-call-put_device-if-device_register-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/eisa-call-put_device-if-device_register-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/eisa-call-put_device-if-device_register-fails.patch

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
backlight-lcd-call-put_device-if-device_register-fails.patch
net-phy-call-put_device-on-device_register-failure.patch
eisa-call-put_device-if-device_register-fails.patch
w1-call-put_device-if-device_register-fails.patch

