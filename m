From: akpm@osdl.org
Subject: - fix-compilation-of-via-pmu-backlight.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:24:24 -0800
Message-ID: <200701020724.l027OOns012943@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37313 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744AbXABHYa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:24:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwab@suse.de, benh@kernel.crashing.org, luming.yu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Fix compilation of via-pmu-backlight
has been removed from the -mm tree.  Its filename was
     fix-compilation-of-via-pmu-backlight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix compilation of via-pmu-backlight
From: Andreas Schwab <schwab@suse.de>

Signed-off-by: Andreas Schwab <schwab@suse.de>
Cc: "Yu, Luming" <luming.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/macintosh/via-pmu-backlight.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/macintosh/via-pmu-backlight.c~fix-compilation-of-via-pmu-backlight drivers/macintosh/via-pmu-backlight.c
--- a/drivers/macintosh/via-pmu-backlight.c~fix-compilation-of-via-pmu-backlight
+++ a/drivers/macintosh/via-pmu-backlight.c
@@ -147,7 +147,7 @@ void __init pmu_backlight_init()
 
 	snprintf(name, sizeof(name), "pmubl");
 
-	bd = backlight_device_register(name, NULL, &pmu_backlight_data);
+	bd = backlight_device_register(name, NULL, NULL, &pmu_backlight_data);
 	if (IS_ERR(bd)) {
 		printk("pmubl: Backlight registration failed\n");
 		goto error;
_

Patches currently in -mm which might be from schwab@suse.de are
