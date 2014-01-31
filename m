From: akpm@linux-foundation.org
Subject: [merged] net-phy-call-put_device-on-device_register-failure.patch removed from -mm tree
Date: Fri, 31 Jan 2014 11:16:01 -0800
Message-ID: <52ebf671.A5bsQD3zA8I7hTr7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbaAaTQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gregkh@linuxfoundation.org, grant.likely@secretlab.ca, david.daney@cavium.com, davem@davemloft.net, levex@linux.com

Subject: [merged] net-phy-call-put_device-on-device_register-failure.patch removed from -mm tree
To: levex@linux.com,davem@davemloft.net,david.daney@cavium.com,grant.likely@secretlab.ca,gregkh@linuxfoundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:01 -0800


The patch titled
     Subject: drivers/net/phy/mdio_bus.c: call put_device on device_register() failure
has been removed from the -mm tree.  Its filename was
     net-phy-call-put_device-on-device_register-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -150,6 +150,7 @@ int mdiobus_register(struct mii_bus *bus
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
+		put_device(&bus->dev);
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from levex@linux.com are

origin.patch
w1-call-put_device-if-device_register-fails.patch

