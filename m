From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-atyfb_base.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:51 -0800
Message-ID: <200612082012.kB8KCpjh003036@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59391 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946737AbWLHUM6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/atyfb_base
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-atyfb_base.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/atyfb_base
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/aty/atyfb_base.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/video/aty/atyfb_base.c~ioremap-balanced-with-iounmap-for-drivers-video-atyfb_base drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~ioremap-balanced-with-iounmap-for-drivers-video-atyfb_base
+++ a/drivers/video/aty/atyfb_base.c
@@ -3527,6 +3527,10 @@ static int __devinit atyfb_setup_generic
 atyfb_setup_generic_fail:
 	iounmap(par->ati_regbase);
 	par->ati_regbase = NULL;
+	if (info->screen_base) {
+		iounmap(info->screen_base);
+		info->screen_base = NULL;
+	}
 	return ret;
 }
 
@@ -3695,6 +3699,10 @@ static int __devinit atyfb_atari_probe(v
 		}
 
 		if (aty_init(info, "ISA bus")) {
+			if (info->screen_base)
+				iounmap(info->screen_base);
+			if (par->ati_regbase)
+				iounmap(par->ati_regbase);
 			framebuffer_release(info);
 			/* This is insufficient! kernel_map has added two large chunks!! */
 			return -ENXIO;
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
ioremap-balanced-with-iounmap-for-drivers-video-atyfb_base.patch
ioremap-balanced-with-iounmap-for-drivers-video-atafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-amifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-S3triofb.patch
git-cpufreq.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-megaraidc-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch

