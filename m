From: akpm@linux-foundation.org
Subject: + drivers-scsi-sun3x_espc-convert-to.patch added to -mm tree
Date: Thu, 16 Oct 2008 14:44:08 -0700
Message-ID: <200810162144.m9GLi8Tj025071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992AbYJPVow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 17:44:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, sammy@sammy.net, tsbogend@alpha.franken.de


The patch titled
     drivers/scsi/sun3x_esp.c: Convert && to ||
has been added to the -mm tree.  Its filename is
     drivers-scsi-sun3x_espc-convert-to.patch

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
Subject: drivers/scsi/sun3x_esp.c: Convert && to ||
From: Julia Lawall <julia@diku.dk>

The pattern !E && !E->fld is nonsensical.  The patch below updates this
according to the assumption that && should be ||.  But perhaps another
solution was intended.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@disable and_comm@
expression E;
identifier fld;
@@

- !E && !E->fld
+ !E || !E->fld
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-By: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Acked-By: Sam Creasey <sammy@sammy.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sun3x_esp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/sun3x_esp.c~drivers-scsi-sun3x_espc-convert-to drivers/scsi/sun3x_esp.c
--- a/drivers/scsi/sun3x_esp.c~drivers-scsi-sun3x_espc-convert-to
+++ a/drivers/scsi/sun3x_esp.c
@@ -213,7 +213,7 @@ static int __devinit esp_sun3x_probe(str
 	esp->ops = &sun3x_esp_ops;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res && !res->start)
+	if (!res || !res->start)
 		goto fail_unlink;
 
 	esp->regs = ioremap_nocache(res->start, 0x20);
@@ -221,7 +221,7 @@ static int __devinit esp_sun3x_probe(str
 		goto fail_unmap_regs;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 1);
-	if (!res && !res->start)
+	if (!res || !res->start)
 		goto fail_unmap_regs;
 
 	esp->dma_regs = ioremap_nocache(res->start, 0x10);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
drivers-misc-use-div_round_up.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch
drivers-net-xen-netfrontc-use-div_round_up.patch
drivers-i2c-busses-i2c-s3c2410c-correct-use-of-and.patch
drivers-pci-hotplug-cpqphp_ctrlc-convert-to.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
drivers-scsi-sun3x_espc-convert-to.patch
fs-namespacec-drop-code-after-return.patch

