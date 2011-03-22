From: akpm@linux-foundation.org
Subject: [folded] bh1780gli-convert-to-dev-pm-ops-update.patch removed from -mm tree
Date: Tue, 22 Mar 2011 16:02:08 -0700
Message-ID: <201103222302.p2MN28CA000371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754393Ab1CVXC6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 19:02:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shubhrajyoti@ti.com, mm-commits@vger.kernel.org


The patch titled
     bh1780gli-convert-to-dev-pm-ops-update
has been removed from the -mm tree.  Its filename was
     bh1780gli-convert-to-dev-pm-ops-update.patch

This patch was dropped because it was folded into bh1780gli-convert-to-dev-pm-ops.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bh1780gli-convert-to-dev-pm-ops-update
From: Shubhrajyoti D <shubhrajyoti@ti.com>

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/bh1780gli.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/misc/bh1780gli.c~bh1780gli-convert-to-dev-pm-ops-update drivers/misc/bh1780gli.c
--- a/drivers/misc/bh1780gli.c~bh1780gli-convert-to-dev-pm-ops-update
+++ a/drivers/misc/bh1780gli.c
@@ -235,6 +235,9 @@ static int bh1780_resume(struct device *
 	return 0;
 }
 static SIMPLE_DEV_PM_OPS(bh1780_pm, bh1780_suspend, bh1780_resume);
+#define BH1780_PMOPS (&bh1780_pm)
+#else
+#define BH1780_PMOPS NULL
 #endif /* CONFIG_PM */
 
 static const struct i2c_device_id bh1780_id[] = {
@@ -248,9 +251,7 @@ static struct i2c_driver bh1780_driver =
 	.id_table	= bh1780_id,
 	.driver = {
 		.name = "bh1780",
-#ifdef CONFIG_PM
-		.pm	= &bh1780_pm,
-#endif
+		.pm	= BH1780_PMOPS,
 },
 };
 
_

Patches currently in -mm which might be from shubhrajyoti@ti.com are

origin.patch
bh1780gli-convert-to-dev-pm-ops.patch
drivers-misc-bmp085c-free-initmem-memory.patch

