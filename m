From: akpm@linux-foundation.org
Subject: + change-nvidiafb_remove-to-__devexit.patch added to -mm tree
Date: Fri, 09 Feb 2007 01:57:06 -0800
Message-ID: <200702090957.l199v6gR010129@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40373 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946285AbXBIJ5U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 04:57:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: prarit@redhat.com, jsimmons@infradead.org


The patch titled
     change nvidiafb_remove to __devexit
has been added to the -mm tree.  Its filename is
     change-nvidiafb_remove-to-__devexit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: change nvidiafb_remove to __devexit
From: Prarit Bhargava <prarit@redhat.com>

Change nvidiafb_remove to __devexit to fix MODPOST warnings:

WARNING: drivers/video/nvidia/nvidiafb.o - Section mismatch: reference to
.exit.text:nvidiafb_remove from .data.rel.local after 'nvidiafb_driver' (at
offset 0x28)

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-By: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nvidia.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/nvidia/nvidia.c~change-nvidiafb_remove-to-__devexit drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~change-nvidiafb_remove-to-__devexit
+++ a/drivers/video/nvidia/nvidia.c
@@ -1347,7 +1347,7 @@ err_out:
 	return -ENODEV;
 }
 
-static void __exit nvidiafb_remove(struct pci_dev *pd)
+static void __devexit nvidiafb_remove(struct pci_dev *pd)
 {
 	struct fb_info *info = pci_get_drvdata(pd);
 	struct nvidia_par *par = info->par;
@@ -1433,7 +1433,7 @@ static struct pci_driver nvidiafb_driver
 	.probe    = nvidiafb_probe,
 	.suspend  = nvidiafb_suspend,
 	.resume   = nvidiafb_resume,
-	.remove   = __exit_p(nvidiafb_remove),
+	.remove   = __devexit_p(nvidiafb_remove),
 };
 
 /* ------------------------------------------------------------------------- *
_

Patches currently in -mm which might be from prarit@redhat.com are

change-__init-to-__devinit-for-isp116x_probe.patch
change-__init-to-__devinit-in-2-rtc-drivers.patch
change-nvidiafb_remove-to-__devexit.patch
