From: akpm@linux-foundation.org
Subject: + ibmtr_cs-fix-hang-on-eject.patch added to -mm tree
Date: Sun, 29 Apr 2007 02:36:25 -0700
Message-ID: <200704290936.l3T9aPej013007@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756322AbXD2JiU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Apr 2007 05:38:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paul@booyaka.com, bunk@stusta.de, jeff@garzik.org, linux@dominikbrodowski.net, stable@kernel.org


The patch titled
     ibmtr_cs: fix hang on eject
has been added to the -mm tree.  Its filename is
     ibmtr_cs-fix-hang-on-eject.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-hid.patch
ibmtr_cs-fix-hang-on-eject.patch
