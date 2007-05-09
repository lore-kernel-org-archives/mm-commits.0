From: akpm@linux-foundation.org
Subject: - change-rivafb_remove-to-__devexit.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:07 -0700
Message-ID: <200705090259.l492x79D010361@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032430AbXEIC7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:59:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     change rivafb_remove to __devexit
has been removed from the -mm tree.  Its filename was
     change-rivafb_remove-to-__devexit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2104,7 +2104,7 @@ err_ret:
 	return ret;
 }
 
-static void __exit rivafb_remove(struct pci_dev *pd)
+static void __devexit rivafb_remove(struct pci_dev *pd)
 {
 	struct fb_info *info = pci_get_drvdata(pd);
 	struct riva_par *par = info->par;
@@ -2185,7 +2185,7 @@ static struct pci_driver rivafb_driver =
 	.name		= "rivafb",
 	.id_table	= rivafb_pci_tbl,
 	.probe		= rivafb_probe,
-	.remove		= __exit_p(rivafb_remove),
+	.remove		= __devexit_p(rivafb_remove),
 };
 
 
_

Patches currently in -mm which might be from prarit@redhat.com are

origin.patch
