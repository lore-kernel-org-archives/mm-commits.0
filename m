From: akpm@linux-foundation.org
Subject: + fbdev-bfin-t350mcqb-fb-drop-unused-local-variables.patch added to -mm tree
Date: Mon, 15 Jun 2009 13:04:54 -0700
Message-ID: <200906152004.n5FK4suP014542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753682AbZFOUE5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 16:04:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, krzysztof.h1@poczta.fm


The patch titled
     fbdev: bfin-t350mcqb-fb: drop unused local variables
has been added to the -mm tree.  Its filename is
     fbdev-bfin-t350mcqb-fb-drop-unused-local-variables.patch

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
Subject: fbdev: bfin-t350mcqb-fb: drop unused local variables
From: Mike Frysinger <vapier@gentoo.org>

The local fbinfo/info vars in the suspend functions don't actually get
used which cause ugly gcc warnings, so drop them.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bfin-t350mcqb-fb.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-t350mcqb-fb-drop-unused-local-variables drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-t350mcqb-fb-drop-unused-local-variables
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -637,9 +637,6 @@ static int bfin_t350mcqb_remove(struct p
 #ifdef CONFIG_PM
 static int bfin_t350mcqb_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct fb_info *fbinfo = platform_get_drvdata(pdev);
-	struct bfin_t350mcqbfb_info *info = fbinfo->par;
-
 	bfin_t350mcqb_disable_ppi();
 	disable_dma(CH_PPI);
 	bfin_write_PPI_STATUS(0xFFFF);
@@ -649,9 +646,6 @@ static int bfin_t350mcqb_suspend(struct 
 
 static int bfin_t350mcqb_resume(struct platform_device *pdev)
 {
-	struct fb_info *fbinfo = platform_get_drvdata(pdev);
-	struct bfin_t350mcqbfb_info *info = fbinfo->par;
