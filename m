From: akpm@linux-foundation.org
Subject: - ds1wm-should-check-for-is_errclk-instead-of-null.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:17 -0800
Message-ID: <200803050744.m257iHYE021494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756036AbYCEHov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:44:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cbouatmailru@gmail.com, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     ds1wm: should check for IS_ERR(clk) instead of NULL
has been removed from the -mm tree.  Its filename was
     ds1wm-should-check-for-is_errclk-instead-of-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


