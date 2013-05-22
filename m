From: akpm@linux-foundation.org
Subject: + video-imxfb-make-local-symbols-static.patch added to -mm tree
Date: Wed, 22 May 2013 14:37:26 -0700
Message-ID: <519d3a96.PyNKqLHai1aHglDz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab3EVVh1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 17:37:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org

Subject: + video-imxfb-make-local-symbols-static.patch added to -mm tree
To: sachin.kamat@linaro.org
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 14:37:26 -0700


The patch titled
     Subject: drivers/video/imxfb.c: make local symbols static
has been added to the -mm tree.  Its filename is
     video-imxfb-make-local-symbols-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/video/imxfb.c: make local symbols static

These symbols are used only in this file.  Make them static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/imxfb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/imxfb.c~video-imxfb-make-local-symbols-static drivers/video/imxfb.c
--- a/drivers/video/imxfb.c~video-imxfb-make-local-symbols-static
+++ a/drivers/video/imxfb.c
@@ -960,7 +960,7 @@ static int imxfb_remove(struct platform_
 	return 0;
 }
 
-void  imxfb_shutdown(struct platform_device * dev)
+static void imxfb_shutdown(struct platform_device *dev)
 {
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct imxfb_info *fbi = info->par;
@@ -999,7 +999,7 @@ static int imxfb_setup(void)
 	return 0;
 }
 
-int __init imxfb_init(void)
+static int __init imxfb_init(void)
 {
 	int ret = imxfb_setup();
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
video-smscufx-use-null-instead-of-0.patch
video-udlfb-use-null-instead-of-0.patch
video-udlfb-make-local-symbol-static.patch
video-imxfb-make-local-symbols-static.patch
drivers-rtc-rtc-v3020c-remove-redundant-goto.patch
drivers-rtc-interfacec-fix-checkpatch-errors.patch
drivers-rtc-rtc-at32ap700xc-fix-checkpatch-error.patch
drivers-rtc-rtc-at91rm9200c-include-linux-uaccessh.patch
drivers-rtc-rtc-cmosc-fix-whitespace-related-errors.patch
drivers-rtc-rtc-davincic-fix-whitespace-warning.patch
drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof.patch
drivers-rtc-rtc-ds1374c-fix-spacing-related-issues.patch
drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces.patch
drivers-rtc-rtc-ds3234c-fix-whitespace-issue.patch
drivers-rtc-rtc-fm3130c-fix-whitespace-related-issue.patch
drivers-rtc-rtc-m41t80c-fix-spacing-related-issue.patch
drivers-rtc-rtc-max6902c-remove-unwanted-spaces.patch
drivers-rtc-rtc-max77686c-remove-space-before-semicolon.patch
drivers-rtc-rtc-max8997c-remove-space-before-semicolon.patch
drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch
drivers-rtc-rtc-msm6242c-use-pr_warn.patch
drivers-rtc-rtc-mxcc-fix-checkpatch-error.patch
drivers-rtc-rtc-omapc-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-pcf2123c-remove-space-before-tabs.patch
drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition.patch
drivers-rtc-rtc-rs5c313c-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues.patch
drivers-rtc-rtc-v3020c-fix-spacing-issues.patch
drivers-rtc-rtc-vr41xxc-fix-spacing-issues.patch
drivers-rtc-rtc-x1205c-fix-checkpatch-issues.patch
drivers-rtc-rtc-m48t86c-remove-empty-function.patch
drivers-rtc-rtc-tilec-remove-empty-function.patch
drivers-rtc-rtc-nuc900c-remove-empty-function.patch
drivers-rtc-rtc-msm6242c-remove-empty-function.patch
drivers-rtc-rtc-max8998c-remove-empty-function.patch
drivers-rtc-rtc-max8925c-remove-empty-function.patch
drivers-rtc-rtc-ls1xc-remove-empty-function.patch
drivers-rtc-rtc-lp8788c-remove-empty-function.patch
drivers-rtc-rtc-ds1302c-remove-empty-function.patch
drivers-rtc-rtc-dm355evmc-remove-empty-function.patch
drivers-rtc-rtc-da9055c-remove-empty-function.patch
drivers-rtc-rtc-da9052c-remove-empty-function.patch
drivers-rtc-rtc-bq4802c-remove-empty-function.patch
drivers-rtc-rtc-au1xxxc-remove-empty-function.patch
drivers-rtc-rtc-ab3100c-remove-empty-function.patch

