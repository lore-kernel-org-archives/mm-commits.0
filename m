From: akpm@linux-foundation.org
Subject: + pcmcia-yenta-add-missing-__devexit-marking.patch added to -mm tree
Date: Wed, 27 May 2009 23:20:17 -0700
Message-ID: <200905280620.n4S6KHbI030863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbZE1GUY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:20:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, daniel.ritz-ml@swissonline.ch, linux@dominikbrodowski.net


The patch titled
     pcmcia: yenta: add missing __devexit marking
has been added to the -mm tree.  Its filename is
     pcmcia-yenta-add-missing-__devexit-marking.patch

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
Subject: pcmcia: yenta: add missing __devexit marking
From: Mike Frysinger <vapier@gentoo.org>

The remove member of the pci_driver yenta_cardbus_driver uses
__devexit_p(), so the remove function itself should be marked with
__devexit.  Even more so considering the probe function is marked with
__devinit.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/yenta_socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pcmcia/yenta_socket.c~pcmcia-yenta-add-missing-__devexit-marking drivers/pcmcia/yenta_socket.c
--- a/drivers/pcmcia/yenta_socket.c~pcmcia-yenta-add-missing-__devexit-marking
+++ a/drivers/pcmcia/yenta_socket.c
@@ -717,7 +717,7 @@ static void yenta_free_resources(struct 
 /*
  * Close it down - release our resources and go home..
  */
-static void yenta_close(struct pci_dev *dev)
+static void __devexit yenta_close(struct pci_dev *dev)
 {
 	struct yenta_socket *sock = pci_get_drvdata(dev);
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
plat_nand-add-missing-__devexit_p.patch
irda-new-blackfin-on-chip-sir-irda-driver.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch

