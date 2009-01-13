From: akpm@linux-foundation.org
Subject: + sis900-generate-fake-mac-address-if-the-hardware-doesnt-have-one.patch added to -mm tree
Date: Tue, 13 Jan 2009 15:44:11 -0800
Message-ID: <200901132344.n0DNiBHg032129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758563AbZAMXoS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 18:44:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venza@brownhat.org, davem@davemloft.net, shemminger@vyatta.com


The patch titled
     sis900: generate fake MAC address if the hardware doesn't have one
has been added to the -mm tree.  Its filename is
     sis900-generate-fake-mac-address-if-the-hardware-doesnt-have-one.patch

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
Subject: sis900: generate fake MAC address if the hardware doesn't have one
From: Daniele Venzano <venza@brownhat.org>

Modify the sis900 driver when the MAC address read from the hardware is
invalid.  As suggested, the patch now generates a random address so that
the user can go on and use the hardware.  In any case a message is also
shown to warn on the unexpected condition.

This seems to happen with newer HW implementation of the sis900 chipset,
since this never came up before.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=10201
Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11649

Signed-off-by: Daniele Venzano <venza@brownhat.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sis900.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/sis900.c~sis900-generate-fake-mac-address-if-the-hardware-doesnt-have-one drivers/net/sis900.c
--- a/drivers/net/sis900.c~sis900-generate-fake-mac-address-if-the-hardware-doesnt-have-one
+++ a/drivers/net/sis900.c
@@ -509,10 +509,10 @@ static int __devinit sis900_probe(struct
 	else
 		ret = sis900_get_mac_addr(pci_dev, net_dev);
 
-	if (ret == 0) {
-		printk(KERN_WARNING "%s: Cannot read MAC address.\n", dev_name);
-		ret = -ENODEV;
-		goto err_unmap_rx;
+	if (!ret || !is_valid_ether_addr(net_dev->dev_addr)) {
+		random_ether_addr(net_dev->dev_addr);
+		printk(KERN_WARNING "%s: Unreadable or invalid MAC address,"
+				"using random generated one\n", dev_name);
 	}
 
 	/* 630ET : set the mii access mode as software-mode */
_

Patches currently in -mm which might be from venza@brownhat.org are

sis900-generate-fake-mac-address-if-the-hardware-doesnt-have-one.patch

