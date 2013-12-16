From: akpm@linux-foundation.org
Subject: + net-phy-call-put_device-on-device_register-failure.patch added
 to -mm tree
Date: Mon, 16 Dec 2013 15:17:50 -0800
Message-ID: <52af8a1e.EQg0UXPhl4P7EgiE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3LPXRv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 18:17:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gregkh@linuxfoundation.org, grant.likely@secretlab.ca, david.daney@cavium.com, davem@davemloft.net, levex@linux.com

Subject: + net-phy-call-put_device-on-device_register-failure.patch added to -mm tree
To: levex@linux.com,davem@davemloft.net,david.daney@cavium.com,grant.likely@secretlab.ca,gregkh@linuxfoundation.org
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 15:17:50 -0800


The patch titled
     Subject: drivers/net/phy/mdio_bus.c: call put_device on device_register() failure
has been added to the -mm tree.  Its filename is
     net-phy-call-put_device-on-device_register-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-phy-call-put_device-on-device_register-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-phy-call-put_device-on-device_register-failure.patch

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
Subject: drivers/net/phy/mdio_bus.c: call put_device on device_register() failure

It is required to call put_device() if device_register() fails, so that we
give up the last reference to the device.  Calling put_device allows for
mdiobus_release to be executed, kfreeing the bus.

Signed-off-by: Levente Kurusa <levex@linux.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: David Daney <david.daney@cavium.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/phy/mdio_bus.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/phy/mdio_bus.c~net-phy-call-put_device-on-device_register-failure drivers/net/phy/mdio_bus.c
--- a/drivers/net/phy/mdio_bus.c~net-phy-call-put_device-on-device_register-failure
+++ a/drivers/net/phy/mdio_bus.c
@@ -154,6 +154,7 @@ int mdiobus_register(struct mii_bus *bus
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
+		put_device(&bus->dev);
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from levex@linux.com are

kstrtox-remove-redundant-cleanup.patch
lib-cmdlinec-declare-exported-symbols-immediately.patch
linux-next.patch
backlight-lcd-call-put_device-if-device_register-fails.patch
net-phy-call-put_device-on-device_register-failure.patch
eisa-call-put_device-if-device_register-fails.patch
w1-call-put_device-if-device_register-fails.patch

