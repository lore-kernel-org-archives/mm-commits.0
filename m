From: akpm@linux-foundation.org
Subject: [merged] starfire-clean-up-properly-if-firmware-loading-fails.patch removed from -mm tree
Date: Fri, 29 Jan 2010 12:16:37 -0800
Message-ID: <201001292016.o0TKGbWs003252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754858Ab0A2USC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 15:18:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhutchings@solarflare.com, davem@davemloft.net, michael@moffatt.org.nz, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     starfire: clean up properly if firmware loading fails
has been removed from the -mm tree.  Its filename was
     starfire-clean-up-properly-if-firmware-loading-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: starfire: clean up properly if firmware loading fails
From: Ben Hutchings <bhutchings@solarflare.com>

netdev_open() will return without cleaning up net device or hardware state
if firmware loading fails.  This results in a BUG() on a second attempt to
bring the interface up, reported in
<http://bugzilla.kernel.org/show_bug.cgi?id=15117>, and probably has even
worse effects if the driver is removed afterwards.

Call netdev_close() to clean up on failure.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=15091

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Reported-by: Michael Moffatt <michael@moffatt.org.nz>
Tested-by: Michael Moffatt <michael@moffatt.org.nz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/starfire.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/net/starfire.c~starfire-clean-up-properly-if-firmware-loading-fails drivers/net/starfire.c
--- a/drivers/net/starfire.c~starfire-clean-up-properly-if-firmware-loading-fails
+++ a/drivers/net/starfire.c
@@ -1063,7 +1063,7 @@ static int netdev_open(struct net_device
 	if (retval) {
 		printk(KERN_ERR "starfire: Failed to load firmware \"%s\"\n",
 		       FIRMWARE_RX);
-		return retval;
+		goto out_init;
 	}
 	if (fw_rx->size % 4) {
 		printk(KERN_ERR "starfire: bogus length %zu in \"%s\"\n",
@@ -1108,6 +1108,9 @@ out_tx:
 	release_firmware(fw_tx);
 out_rx:
 	release_firmware(fw_rx);
+out_init:
+	if (retval)
+		netdev_close(dev);
 	return retval;
 }
 
_

Patches currently in -mm which might be from bhutchings@solarflare.com are

origin.patch
linux-next.patch

