From: akpm@linux-foundation.org
Subject: + starfire-clean-up-properly-if-firmware-loading-fails.patch added to -mm tree
Date: Mon, 25 Jan 2010 18:15:55 -0800
Message-ID: <201001260215.o0Q2FtcF025156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852Ab0AZCRM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 21:17:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhutchings@solarflare.com, davem@davemloft.net, michael@moffatt.org.nz, stable@kernel.org


The patch titled
     starfire: clean up properly if firmware loading fails
has been added to the -mm tree.  Its filename is
     starfire-clean-up-properly-if-firmware-loading-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
starfire-clean-up-properly-if-firmware-loading-fails.patch

