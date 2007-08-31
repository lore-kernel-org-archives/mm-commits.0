From: akpm@linux-foundation.org
Subject: + drivers-edac-fix-e752x-correct-return-code.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:58:46 -0700
Message-ID: <200708311858.l7VIwkx9021873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965980AbXHaS6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:58:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aris@ruivo.org, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com, mark.gross@intel.com


The patch titled
     drivers/edac: fix e752x correct return code
has been added to the -mm tree.  Its filename is
     drivers-edac-fix-e752x-correct-return-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/edac: fix e752x correct return code
From: Aristeu Rozanski <aris@ruivo.org>

This patch changes the error code when dev0:fun1 was hidden by BIOS to one
more appropriate.

Signed-off-by: Aristeu Rozanski <aris@ruivo.org>
Signed-off-by: Mark Gross <mark.gross@intel.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/e752x_edac.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/e752x_edac.c~drivers-edac-fix-e752x-correct-return-code drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~drivers-edac-fix-e752x-correct-return-code
+++ a/drivers/edac/e752x_edac.c
@@ -967,7 +967,7 @@ static int e752x_probe1(struct pci_dev *
 	if (!force_function_unhide && !(stat8 & (1 << 5))) {
 		printk(KERN_INFO "Contact your BIOS vendor to see if the "
 			"E752x error registers can be safely un-hidden\n");
-		return -ENOMEM;
+		return -ENODEV;
 	}
 	stat8 |= (1 << 5);
 	pci_write_config_byte(pdev, E752X_DEVPRES1, stat8);
_

Patches currently in -mm which might be from aris@ruivo.org are

drivers-edac-fix-e752x-correct-return-code.patch
