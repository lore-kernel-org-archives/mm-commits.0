From: akpm@linux-foundation.org
Subject: - char-mxser_new-do-not-put-pdev.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:06 -0800
Message-ID: <200702112252.l1BMq6EY015987@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60214 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932777AbXBKWwI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, do not put pdev
has been removed from the -mm tree.  Its filename was
     char-mxser_new-do-not-put-pdev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, do not put pdev
From: Jiri Slaby <jirislaby@gmail.com>

We don't call pci_dev_get, so do not call pci_dev_put in the pci release
function.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-do-not-put-pdev drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-do-not-put-pdev
+++ a/drivers/char/mxser_new.c
@@ -2348,7 +2348,6 @@ static void mxser_release_res(struct mxs
 #ifdef CONFIG_PCI
 		pci_release_region(pdev, 2);
 		pci_release_region(pdev, 3);
-		pci_dev_put(pdev);
 #endif
 	} else {
 		release_region(brd->ports[0].ioaddr, 8 * brd->info->nports);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
