From: akpm@linux-foundation.org
Subject: + istallion-add-missing-__devexit-marking.patch added to -mm tree
Date: Wed, 27 May 2009 23:22:58 -0700
Message-ID: <200905280622.n4S6MwHM000305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbZE1GXE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:23:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, gerg@uclinux.org


The patch titled
     istallion: add missing __devexit marking
has been added to the -mm tree.  Its filename is
     istallion-add-missing-__devexit-marking.patch

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
Subject: istallion: add missing __devexit marking
From: Mike Frysinger <vapier@gentoo.org>

The remove member of the pci_driver stli_pcidriver uses __devexit_p(), so
the remove function itself should be marked with __devexit.  Even more so
considering the probe function is marked with __devinit.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/istallion.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/istallion.c~istallion-add-missing-__devexit-marking drivers/char/istallion.c
--- a/drivers/char/istallion.c~istallion-add-missing-__devexit-marking
+++ a/drivers/char/istallion.c
@@ -3785,7 +3785,7 @@ err:
 	return retval;
 }
 
-static void stli_pciremove(struct pci_dev *pdev)
+static void __devexit stli_pciremove(struct pci_dev *pdev)
 {
 	struct stlibrd *brdp = pci_get_drvdata(pdev);
 
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
istallion-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch

