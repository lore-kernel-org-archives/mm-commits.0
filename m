From: akpm@linux-foundation.org
Subject: + ds1wm-should-check-for-is_errclk-instead-of-null.patch added to -mm tree
Date: Mon, 25 Feb 2008 14:35:22 -0800
Message-ID: <200802252236.m1PMaECt023376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761049AbYBYWsa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 17:48:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cbouatmailru@gmail.com, johnpol@2ka.mipt.ru


The patch titled
     ds1wm: should check for IS_ERR(clk) instead of NULL
has been added to the -mm tree.  Its filename is
     ds1wm-should-check-for-is_errclk-instead-of-null.patch

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
Subject: ds1wm: should check for IS_ERR(clk) instead of NULL
From: Anton Vorontsov <cbouatmailru@gmail.com>

On the error condition clk_get() returns ERR_PTR(..), so checking for NULL
doesn't work.  ds1wm module causes a kernel oops when ds1wm clock isn't
registered.

This patch converts NULL check to IS_ERR(), plus uses PTR_ERR()
for the return code.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds1wm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/w1/masters/ds1wm.c~ds1wm-should-check-for-is_errclk-instead-of-null drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~ds1wm-should-check-for-is_errclk-instead-of-null
+++ a/drivers/w1/masters/ds1wm.c
@@ -17,6 +17,7 @@
 #include <linux/pm.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
+#include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/ds1wm.h>
 
@@ -374,8 +375,8 @@ static int ds1wm_probe(struct platform_d
 		goto err1;
 
 	ds1wm_data->clk = clk_get(&pdev->dev, "ds1wm");
-	if (!ds1wm_data->clk) {
-		ret = -ENOENT;
+	if (IS_ERR(ds1wm_data->clk)) {
+		ret = PTR_ERR(ds1wm_data->clk);
 		goto err2;
 	}
 
_

Patches currently in -mm which might be from cbouatmailru@gmail.com are

ds1wm-should-check-for-is_errclk-instead-of-null.patch
ds1wm-report-bus-reset-error.patch
