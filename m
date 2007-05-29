From: akpm@linux-foundation.org
Subject: + e1000-restore-netif_poll_enable-call-but-make-sure-irqs-are-off.patch added to -mm tree
Date: Tue, 29 May 2007 14:55:43 -0700
Message-ID: <200705292155.l4TLthvw012590@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901AbXE2V4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:56:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herbert@gondor.apana.org.au, akpm@linux-foundation.org, auke-jan.h.kok@intel.com, jeff@garzik.org


The patch titled
     e1000: restore netif_poll_enable call but make sure IRQs are off
has been added to the -mm tree.  Its filename is
     e1000-restore-netif_poll_enable-call-but-make-sure-irqs-are-off.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: e1000: restore netif_poll_enable call but make sure IRQs are off
From: Herbert Xu <herbert@gondor.apana.org.au>

This restores the previously removed netif_poll_enable call in e1000_open. 
It's needed on all but the first call to e1000_open for a NIC as
e1000_close always calls netif_poll_disable.

netif_poll_enable can only be called safely if no polls have been
scheduled.  This should be the case as long as we don't enter our IRQ
handler.

In order to guarantee this we explicitly disable IRQs as early as possible
when we're probing the NIC.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_main.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/net/e1000/e1000_main.c~e1000-restore-netif_poll_enable-call-but-make-sure-irqs-are-off drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000-restore-netif_poll_enable-call-but-make-sure-irqs-are-off
+++ a/drivers/net/e1000/e1000_main.c
@@ -1325,7 +1325,10 @@ e1000_sw_init(struct e1000_adapter *adap
 	spin_lock_init(&adapter->tx_queue_lock);
 #endif
 
-	atomic_set(&adapter->irq_sem, 1);
+	/* Explicitly disable IRQ since the NIC can be in any state. */
+	atomic_set(&adapter->irq_sem, 0);
+	e1000_irq_disable(adapter);
+
 	spin_lock_init(&adapter->stats_lock);
 
 	set_bit(__E1000_DOWN, &adapter->flags);
@@ -1431,6 +1434,10 @@ e1000_open(struct net_device *netdev)
 	/* From here on the code is the same as e1000_up() */
 	clear_bit(__E1000_DOWN, &adapter->flags);
 
+#ifdef CONFIG_E1000_NAPI
+	netif_poll_enable(netdev);
+#endif
+
 	e1000_irq_enable(adapter);
 
 	/* fire a link status change interrupt to start the watchdog */
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

git-wireless.patch
git-cryptodev.patch
e1000-restore-netif_poll_enable-call-but-make-sure-irqs-are-off.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
