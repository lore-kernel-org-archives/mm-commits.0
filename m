From: akpm@linux-foundation.org
Subject: - ibmtr_cs-fix-hang-on-eject.patch removed from -mm tree
Date: Fri, 11 May 2007 22:14:43 -0700
Message-ID: <200705120514.l4C5Ehdo001682@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756545AbXELFQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul@booyaka.com, bunk@stusta.de, jeff@garzik.org, linux@dominikbrodowski.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ibmtr_cs: fix hang on eject
has been removed from the -mm tree.  Its filename was
     ibmtr_cs-fix-hang-on-eject.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ibmtr_cs: fix hang on eject
From: Paul Walmsley <paul@booyaka.com>

Ejecting a PCMCIA IBM Token Ring card that has not had its dev->open()
called will reliably trigger an uninitialized spinlock oops when spinlock
debugging is enabled.  The system then hangs, occasionally softlockup
oopsing.  Apparently ibmtr.c:tok_interrupt() doesn't expect to be called
before tok_open(), but tok_interrupt() gets called anyway when the card is
ejected.  So, set an already-existing flag which causes tok_interrupt() to
bail out early upon card ejection.  Tested by inserting and removing the
PCMCIA card several times.

Signed-off-by: Paul Walmsley <paul@booyaka.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <stable@kernel.org>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pcmcia/ibmtr_cs.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/net/pcmcia/ibmtr_cs.c~ibmtr_cs-fix-hang-on-eject drivers/net/pcmcia/ibmtr_cs.c
--- a/drivers/net/pcmcia/ibmtr_cs.c~ibmtr_cs-fix-hang-on-eject
+++ a/drivers/net/pcmcia/ibmtr_cs.c
@@ -189,16 +189,20 @@ static void ibmtr_detach(struct pcmcia_d
 {
     struct ibmtr_dev_t *info = link->priv;
     struct net_device *dev = info->dev;
+    struct tok_info *ti = netdev_priv(dev);
 
     DEBUG(0, "ibmtr_detach(0x%p)\n", link);
 
+    /*
+     * When the card removal interrupt hits tok_interrupt(),
+     * bail out early, so we don't crash the machine
+     */
+    ti->sram_phys |= 1;
+
     if (link->dev_node)
 	unregister_netdev(dev);
 
-    {
-	struct tok_info *ti = netdev_priv(dev);
-	del_timer_sync(&(ti->tr_timer));
-    }
+    del_timer_sync(&(ti->tr_timer));
 
     ibmtr_release(link);
 
_

Patches currently in -mm which might be from paul@booyaka.com are

origin.patch
