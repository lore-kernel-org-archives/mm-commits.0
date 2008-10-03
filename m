From: akpm@linux-foundation.org
Subject: + piix3-warn-softer-about-enabling-passive-release.patch added to -mm tree
Date: Thu, 02 Oct 2008 23:59:58 -0700
Message-ID: <200810030659.m936xwBG015569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754201AbYJCHAv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 03:00:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ajax@redhat.com, bzolnier@gmail.com, htejun@gmail.com, jbarnes@virtuousgeek.org, jeff@garzik.org


The patch titled
     piix3: warn softer about enabling passive release
has been added to the -mm tree.  Its filename is
     piix3-warn-softer-about-enabling-passive-release.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: piix3: warn softer about enabling passive release
From: Adam Jackson <ajax@redhat.com>

All the other quirks are dev_info() not dev_err(), this one isn't special.
This makes 'quiet' boot in qemu really quiet.

Signed-off-by: Adam Jackson <ajax@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/quirks.c~piix3-warn-softer-about-enabling-passive-release drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~piix3-warn-softer-about-enabling-passive-release
+++ a/drivers/pci/quirks.c
@@ -55,7 +55,7 @@ static void quirk_passive_release(struct
 	while ((d = pci_get_device(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371SB_0, d))) {
 		pci_read_config_byte(d, 0x82, &dlc);
 		if (!(dlc & 1<<1)) {
-			dev_err(&d->dev, "PIIX3: Enabling Passive Release\n");
+			dev_info(&d->dev, "PIIX3: Enabling Passive Release\n");
 			dlc |= 1<<1;
 			pci_write_config_byte(d, 0x82, dlc);
 		}
_

Patches currently in -mm which might be from ajax@redhat.com are

piix3-warn-softer-about-enabling-passive-release.patch

