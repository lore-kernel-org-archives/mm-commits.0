From: akpm@linux-foundation.org
Subject: + mbxfb-fix-incorrect-argument-type.patch added to -mm tree
Date: Wed, 05 Mar 2008 22:21:52 -0800
Message-ID: <200803060621.m266Lq8X012421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbYCFGWd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 01:22:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net, mike@compulab.co.il


The patch titled
     mbxfb: fix incorrect argument type
has been added to the -mm tree.  Its filename is
     mbxfb-fix-incorrect-argument-type.patch

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
Subject: mbxfb: fix incorrect argument type
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix wrong pointer type passed into the dev_dbg() function.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Acked-by: Mike Rapoport <mike@compulab.co.il>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mbx/mbxfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/mbx/mbxfb.c~mbxfb-fix-incorrect-argument-type drivers/video/mbx/mbxfb.c
--- a/drivers/video/mbx/mbxfb.c~mbxfb-fix-incorrect-argument-type
+++ a/drivers/video/mbx/mbxfb.c
@@ -889,7 +889,7 @@ static int __devinit mbxfb_probe(struct 
 	struct mbxfb_info *mfbi;
 	struct mbxfb_platform_data *pdata;
 
-	dev_dbg(dev, "mbxfb_probe\n");
+	dev_dbg(&dev->dev, "mbxfb_probe\n");
 
 	pdata = dev->dev.platform_data;
 	if (!pdata) {
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

tridentfb-register-should-be-left-in-non-locked-state.patch
tridentfb-fix-memory-size-detection.patch
pm2fb-correct-error-values-returned-from-probe-function.patch
pm2fb-change-option-mode-to-mode_option.patch
tridentfb-change-option-mode-to-mode_option.patch
pm3fb-change-option-mode-to-mode_option.patch
update-modedbtxt-documentation-about-mode_option-parameter-change.patch
vt8623fb-change-option-mode-to-mode_option.patch
arkfb-add-option-mode_option.patch
s3fb-add-option-mode_option.patch
fbdev-add-removed-option-mode-to-keep-compatibility.patch
mbxfb-fix-incorrect-argument-type.patch

