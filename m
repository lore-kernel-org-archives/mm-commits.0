From: akpm@linux-foundation.org
Subject: - rndis_host-increase-delay-in-command-response-loop.patch removed from -mm tree
Date: Fri, 23 May 2008 11:58:51 -0700
Message-ID: <200805231858.m4NIwpNV004182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756260AbYEWS7G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:59:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linkfanel@yahoo.fr, davem@davemloft.net, david-b@pacbell.net, greg@kroah.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     rndis_host: increase delay in command response loop
has been removed from the -mm tree.  Its filename was
     rndis_host-increase-delay-in-command-response-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rndis_host: increase delay in command response loop
From: Pierre Ynard <linkfanel@yahoo.fr>

Some devices running some WinCE firmware (with SC_* Samsung processors
according to the SynCE project, verified on a HTC P3600 device) fail to
register because they apparently need extra time to respond correctly to
requests.  Increase the existing delay to satisfy them.  Based on code
from the SynCE project, on a suggestion of David Brownell.

This patch Works For Me(tm).

Signed-off-by: Pierre Ynard <linkfanel@yahoo.fr>
Acked-by: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/rndis_host.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/usb/rndis_host.c~rndis_host-increase-delay-in-command-response-loop drivers/net/usb/rndis_host.c
--- a/drivers/net/usb/rndis_host.c~rndis_host-increase-delay-in-command-response-loop
+++ a/drivers/net/usb/rndis_host.c
@@ -194,7 +194,7 @@ int rndis_command(struct usbnet *dev, st
 			dev_dbg(&info->control->dev,
 				"rndis response error, code %d\n", retval);
 		}
-		msleep(2);
+		msleep(20);
 	}
 	dev_dbg(&info->control->dev, "rndis response timeout\n");
 	return -ETIMEDOUT;
_

Patches currently in -mm which might be from linkfanel@yahoo.fr are

git-net.patch

