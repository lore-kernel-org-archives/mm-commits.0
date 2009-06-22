From: akpm@linux-foundation.org
Subject: [merged] istallion-add-missing-__devexit-marking.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:00:30 -0700
Message-ID: <200906221700.n5MH0UJx009831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630AbZFVRBI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:01:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     istallion: add missing __devexit marking
has been removed from the -mm tree.  Its filename was
     istallion-add-missing-__devexit-marking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
rmap-fixup-page_referenced-for-nommu-systems.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch

