From: akpm@linux-foundation.org
Subject: + driver-video-cirrusfb-fix-ram-address-printk.patch added to -mm tree
Date: Tue, 10 Jun 2008 16:32:16 -0700
Message-ID: <200806102332.m5ANWGU0002720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbYFJXcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 19:32:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: phdm@macqel.be, jirislaby@gmail.com


The patch titled
     driver/video/cirrusfb: fix RAM address printk
has been added to the -mm tree.  Its filename is
     driver-video-cirrusfb-fix-ram-address-printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: driver/video/cirrusfb: fix RAM address printk
From: Philippe De Muyter <phdm@macqel.be>

In the cirrusfb driver, the RAM address printk has a superfluous 'x' that
could be interpreted as "don't care", while it is actually a typo.  Fix
that.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/cirrusfb.c~driver-video-cirrusfb-fix-ram-address-printk drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~driver-video-cirrusfb-fix-ram-address-printk
+++ a/drivers/video/cirrusfb.c
@@ -2432,7 +2432,7 @@ static int cirrusfb_pci_register(struct 
 	info->screen_size = board_size;
 	cinfo->unmap = cirrusfb_pci_unmap;
 
-	printk(KERN_INFO " RAM (%lu kB) at 0xx%lx, ",
+	printk(KERN_INFO " RAM (%lu kB) at 0x%lx, ",
 		info->screen_size >> 10, board_addr);
 	printk(KERN_INFO "Cirrus Logic chipset on PCI bus\n");
 	pci_set_drvdata(pdev, info);
_

Patches currently in -mm which might be from phdm@macqel.be are

m68knommu-init-coldfire-timer-trr-with-n-1-not-n.patch
driver-char-generic_nvram-fix-banner.patch
driver-video-cirrusfb-fix-ram-address-printk.patch

