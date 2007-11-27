From: akpm@linux-foundation.org
Subject: + plip-fix-creation-of-garbage-names-in-proc.patch added to -mm tree
Date: Mon, 26 Nov 2007 21:40:04 -0800
Message-ID: <200711270540.lAR5e4Vq029506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53276 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbXK0Fkr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 00:40:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikulas@artax.karlin.mff.cuni.cz, davem@davemloft.net, herbert@gondor.apana.org.au, jeff@garzik.org


The patch titled
     plip: fix creation of garbage names in /proc
has been added to the -mm tree.  Its filename is
     plip-fix-creation-of-garbage-names-in-proc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: plip: fix creation of garbage names in /proc
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

Plip passes string "name" that is allocated on stack to
parport_register_device.  parport_register_device holds the pointer to "name"
and when the registering function exits, it points nowhere.

On some machines, this bug causes bad names to appear in /proc filesystem,
such as /proc/sys/dev/parport/parport0/devices/T^/X^/, on others, the plip
proc node is completely missing.

The patch also fixes documentation to note this requirement.

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/parport-lowlevel.txt |    4 ++++
 drivers/net/plip.c                 |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN Documentation/parport-lowlevel.txt~plip-fix-creation-of-garbage-names-in-proc Documentation/parport-lowlevel.txt
--- a/Documentation/parport-lowlevel.txt~plip-fix-creation-of-garbage-names-in-proc
+++ a/Documentation/parport-lowlevel.txt
@@ -339,6 +339,10 @@ Use this function to register your devic
 ('port').  Once you have done that, you will be able to use
 parport_claim and parport_release in order to use the port.
 
+The ('name') argument is the name of the device that appears in /proc
+filesystem. The string must be valid for the whole lifetime of the
+device (until parport_unregister_device is called).
+
 This function will register three callbacks into your driver:
 'preempt', 'wakeup' and 'irq'.  Each of these may be NULL in order to
 indicate that you do not want a callback.
diff -puN drivers/net/plip.c~plip-fix-creation-of-garbage-names-in-proc drivers/net/plip.c
--- a/drivers/net/plip.c~plip-fix-creation-of-garbage-names-in-proc
+++ a/drivers/net/plip.c
@@ -1269,7 +1269,7 @@ static void plip_attach (struct parport 
 
 		nl = netdev_priv(dev);
 		nl->dev = dev;
-		nl->pardev = parport_register_device(port, name, plip_preempt,
+		nl->pardev = parport_register_device(port, dev->name, plip_preempt,
 						 plip_wakeup, plip_interrupt,
 						 0, dev);
 
_

Patches currently in -mm which might be from mikulas@artax.karlin.mff.cuni.cz are

plip-use-netif_rx_ni.patch
plip-fix-creation-of-garbage-names-in-proc.patch
