From: akpm@linux-foundation.org
Subject: + pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay.patch added to -mm tree
Date: Tue, 14 Apr 2009 17:07:44 -0700
Message-ID: <200904150007.n3F07iEW011370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbZDOAJc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 20:09:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, eric.miao@marvell.com


The patch titled
     pxafb: lcsr1 is unused without CONFIG_FB_PXA_OVERLAY
has been added to the -mm tree.  Its filename is
     pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb: lcsr1 is unused without CONFIG_FB_PXA_OVERLAY
From: "Denis V. Lunev" <den@openvz.org>

drivers/video/pxafb.c: In function 'pxafb_handle_irq':
drivers/video/pxafb.c:1442: warning: unused variable 'lcsr1'

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Eric Miao <eric.miao@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/pxafb.c~pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay
+++ a/drivers/video/pxafb.c
@@ -1439,7 +1439,10 @@ static void pxafb_disable_controller(str
 static irqreturn_t pxafb_handle_irq(int irq, void *dev_id)
 {
 	struct pxafb_info *fbi = dev_id;
-	unsigned int lccr0, lcsr, lcsr1;
+	unsigned int lccr0, lcsr;
+#ifdef CONFIG_FB_PXA_OVERLAY
+	unsigned int lcsr1;
+#endif
 
 	lcsr = lcd_readl(fbi, LCSR);
 	if (lcsr & LCSR_LDD) {
_

Patches currently in -mm which might be from den@openvz.org are

pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay.patch
arm-compilation-fix-sys_oabi-compatc.patch

