From: akpm@linux-foundation.org
Subject: + mmc-atmel-mci-fix-two-parameters-swapped.patch added to -mm tree
Date: Wed, 28 Apr 2010 11:25:04 -0700
Message-ID: <201004281825.o3SIP5Zb011924__40126.6228095212$1272479124$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754882Ab0D1SZS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:25:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, anders.grahn@hd-wireless.se, hskinnemoen@atmel.com, linux-mmc@vger.kernel.org


The patch titled
     mmc: atmel-mci: fix two parameters swapped
has been added to the -mm tree.  Its filename is
     mmc-atmel-mci-fix-two-parameters-swapped.patch

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
Subject: mmc: atmel-mci: fix two parameters swapped
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Two parameters were swapped in the calls to atmci_init_slot().

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Reported-by: Anders Grahn <anders.grahn@hd-wireless.se>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/atmel-mci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-fix-two-parameters-swapped drivers/mmc/host/atmel-mci.c
--- a/drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-fix-two-parameters-swapped
+++ a/drivers/mmc/host/atmel-mci.c
@@ -1767,13 +1767,13 @@ static int __init atmci_probe(struct pla
 	ret = -ENODEV;
 	if (pdata->slot[0].bus_width) {
 		ret = atmci_init_slot(host, &pdata->slot[0],
-				MCI_SDCSEL_SLOT_A, 0);
+				0, MCI_SDCSEL_SLOT_A);
 		if (!ret)
 			nr_slots++;
 	}
 	if (pdata->slot[1].bus_width) {
 		ret = atmci_init_slot(host, &pdata->slot[1],
-				MCI_SDCSEL_SLOT_B, 1);
+				1, MCI_SDCSEL_SLOT_B);
 		if (!ret)
 			nr_slots++;
 	}
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

linux-next.patch
mmc-atmel-mci-enable-sd-high-speed-support.patch
mmc-atmel-mci-fix-two-parameters-swapped.patch
mmc-atmel-mci-prevent-kernel-oops-while-removing-card.patch
mmc-atmel-mci-remove-data-error-interrupt-after-xfer.patch
mmc-atmel-mci-add-support-for-sdio-interrupts.patch

