From: akpm@linux-foundation.org
Subject: + omapfb-suspend-resume-only-if-fb-device-is-already-initialized.patch added to -mm tree
Date: Wed, 24 Jun 2009 17:08:17 -0700
Message-ID: <200906250008.n5P08HpS005152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756227AbZFYAIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 20:08:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jouni.hogander@nokia.com, imre.deak@nokia.com, krzysztof.h1@wp.pl, tony@atomide.com


The patch titled
     omapfb: suspend/resume only if FB device is already initialized
has been added to the -mm tree.  Its filename is
     omapfb-suspend-resume-only-if-fb-device-is-already-initialized.patch

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
Subject: omapfb: suspend/resume only if FB device is already initialized
From: Jouni Hogander <jouni.hogander@nokia.com>

Check wether fbdev is NULL in suspend / resume functions. Fbdev is
NULL, if there is no lcd or it is not enabled in configuration.

Signed-off-by: Jouni Hogander <jouni.hogander@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/omapfb_main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/video/omap/omapfb_main.c~omapfb-suspend-resume-only-if-fb-device-is-already-initialized drivers/video/omap/omapfb_main.c
--- a/drivers/video/omap/omapfb_main.c~omapfb-suspend-resume-only-if-fb-device-is-already-initialized
+++ a/drivers/video/omap/omapfb_main.c
@@ -1846,8 +1846,8 @@ static int omapfb_suspend(struct platfor
 {
 	struct omapfb_device *fbdev = platform_get_drvdata(pdev);
 
-	omapfb_blank(FB_BLANK_POWERDOWN, fbdev->fb_info[0]);
