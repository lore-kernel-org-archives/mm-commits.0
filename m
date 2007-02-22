From: akpm@linux-foundation.org
Subject: + change-rivafb_remove-to-__devexit.patch added to -mm tree
Date: Wed, 21 Feb 2007 19:34:33 -0800
Message-ID: <200702220334.l1M3YX8q003355@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35652 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbXBVDfB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 22:35:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: prarit@redhat.com, adaplas@pol.net, jsimmons@infradead.org


The patch titled
     change rivafb_remove to __devexit
has been added to the -mm tree.  Its filename is
     change-rivafb_remove-to-__devexit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: change rivafb_remove to __devexit
From: Prarit Bhargava <prarit@redhat.com>

Change rivafb_remove to __deviexit to fix MODPOST warnings:

WARNING: drivers/video/riva/rivafb.o - Section mismatch: reference to
.exit.text:rivafb_remove from .data.rel.local after 'rivafb_driver' (at offset 0x28)

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/riva/fbdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/riva/fbdev.c~change-rivafb_remove-to-__devexit drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~change-rivafb_remove-to-__devexit
+++ a/drivers/video/riva/fbdev.c
@@ -2098,7 +2098,7 @@ err_ret:
 	return ret;
 }
 
-static void __exit rivafb_remove(struct pci_dev *pd)
+static void __devexit rivafb_remove(struct pci_dev *pd)
 {
 	struct fb_info *info = pci_get_drvdata(pd);
 	struct riva_par *par = info->par;
@@ -2177,7 +2177,7 @@ static struct pci_driver rivafb_driver =
 	.name		= "rivafb",
 	.id_table	= rivafb_pci_tbl,
 	.probe		= rivafb_probe,
-	.remove		= __exit_p(rivafb_remove),
+	.remove		= __devexit_p(rivafb_remove),
 };
 
 
_

Patches currently in -mm which might be from prarit@redhat.com are

change-sysenter_setup-to-__cpuinit-improve-__init.patch
change-rivafb_remove-to-__devexit.patch
