From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-char-istallionc.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:56 -0800
Message-ID: <200612072300.kB7N0usG029684@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51400 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163748AbWLGXBF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/char/istallion.c
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-char-istallionc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/char/istallion.c
From: Amol Lad <amol@verismonetworks.com>

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/istallion.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/char/istallion.c~ioremap-balanced-with-iounmap-for-drivers-char-istallionc drivers/char/istallion.c
--- a/drivers/char/istallion.c~ioremap-balanced-with-iounmap-for-drivers-char-istallionc
+++ a/drivers/char/istallion.c
@@ -3476,6 +3476,8 @@ static int stli_initecp(stlibrd_t *brdp)
 	if (sig.magic != cpu_to_le32(ECP_MAGIC))
 	{
 		release_region(brdp->iobase, brdp->iosize);
+		iounmap(brdp->membase);
+		brdp->membase = NULL;
 		return -ENODEV;
 	}
 
@@ -3632,6 +3634,8 @@ static int stli_initonb(stlibrd_t *brdp)
 	    sig.magic3 != cpu_to_le16(ONB_MAGIC3))
 	{
 		release_region(brdp->iobase, brdp->iosize);
+		iounmap(brdp->membase);
+		brdp->membase = NULL;
 		return -ENODEV;
 	}
 
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
git-cpufreq.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-megaraidc-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
drivers-isdn-handcrafted-min-max-macro-removal.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
ioremap-balanced-with-iounmap-for-drivers-video-virgefb.patch
ioremap-balanced-with-iounmap-for-drivers-video-vesafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-tridentfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-tgafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-stifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-retz3fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-pvr2fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-platinumfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-offb.patch
ioremap-balanced-with-iounmap-for-drivers-video-macfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-hpfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-fm2fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-ffb.patch
ioremap-balanced-with-iounmap-for-drivers-video-cyberfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-cirrusfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-atyfb_base.patch
ioremap-balanced-with-iounmap-for-drivers-video-atafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-amifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-S3triofb.patch

