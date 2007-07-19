From: akpm@linux-foundation.org
Subject: - driver-edac-fix-ignored-return-i82875p.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:49 -0700
Message-ID: <200707192006.l6JK6nKS020176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759534AbXGSUPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: fix ignored return i82875p
has been removed from the -mm tree.  Its filename was
     driver-edac-fix-ignored-return-i82875p.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: fix ignored return i82875p
From: Douglas Thompson <dougthompson@xmission.com>

Compiling this module gave a warning that the return value of
'pci_bus_add_device()' was not checked.

This patch adds that check and an output message

Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i82875p_edac.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/edac/i82875p_edac.c~driver-edac-fix-ignored-return-i82875p drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~driver-edac-fix-ignored-return-i82875p
+++ a/drivers/edac/i82875p_edac.c
@@ -270,6 +270,7 @@ static int i82875p_setup_overfl_dev(stru
 {
 	struct pci_dev *dev;
 	void __iomem *window;
+	int err;
 
 	*ovrfl_pdev = NULL;
 	*ovrfl_window = NULL;
@@ -287,7 +288,12 @@ static int i82875p_setup_overfl_dev(stru
 		if (dev == NULL)
 			return 1;
 
-		pci_bus_add_device(dev);
+		err = pci_bus_add_device(dev);
+		if (err) {
+			i82875p_printk(KERN_ERR,
+				"%s(): pci_bus_add_device() Failed\n",
+				__func__);
+		}
 	}
 
 	*ovrfl_pdev = dev;
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
