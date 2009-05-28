From: akpm@linux-foundation.org
Subject: + crypto-hifn_795x-fix-__devinitexit-markings.patch added to -mm tree
Date: Wed, 27 May 2009 23:22:19 -0700
Message-ID: <200905280622.n4S6MJPT032311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbZE1GXG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:23:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, herbert@gondor.apana.org.au, kaber@trash.net, zbr@ioremap.net


The patch titled
     crypto: hifn_795x - fix __dev{init,exit} markings
has been added to the -mm tree.  Its filename is
     crypto-hifn_795x-fix-__devinitexit-markings.patch

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
Subject: crypto: hifn_795x - fix __dev{init,exit} markings
From: Mike Frysinger <vapier@gentoo.org>

The remove member of the pci_driver hifn_pci_driver uses __devexit_p(), so
the remove function itself should be marked with __devexit.  And where
there be __devexit on the remove, so is there __devinit on the probe.

Similarly, the module_init/module_exit functions should be declared with
plain __init/__exit markings, not the hotplug __dev{init,exit} ones.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/hifn_795x.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/crypto/hifn_795x.c~crypto-hifn_795x-fix-__devinitexit-markings drivers/crypto/hifn_795x.c
--- a/drivers/crypto/hifn_795x.c~crypto-hifn_795x-fix-__devinitexit-markings
+++ a/drivers/crypto/hifn_795x.c
@@ -2564,7 +2564,7 @@ static void hifn_tasklet_callback(unsign
 		hifn_process_queue(dev);
 }
 
-static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int __devinit hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int err, i;
 	struct hifn_device *dev;
@@ -2696,7 +2696,7 @@ err_out_disable_pci_device:
 	return err;
 }
 
-static void hifn_remove(struct pci_dev *pdev)
+static void __devexit hifn_remove(struct pci_dev *pdev)
 {
 	int i;
 	struct hifn_device *dev;
@@ -2744,7 +2744,7 @@ static struct pci_driver hifn_pci_driver
 	.remove   = __devexit_p(hifn_remove),
 };
 
-static int __devinit hifn_init(void)
+static int __init hifn_init(void)
 {
 	unsigned int freq;
 	int err;
@@ -2789,7 +2789,7 @@ static int __devinit hifn_init(void)
 	return 0;
 }
 
-static void __devexit hifn_fini(void)
+static void __exit hifn_fini(void)
 {
 	pci_unregister_driver(&hifn_pci_driver);
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
plat_nand-add-missing-__devexit_p.patch
irda-new-blackfin-on-chip-sir-irda-driver.patch
crypto-hifn_795x-fix-__devinitexit-markings.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch

