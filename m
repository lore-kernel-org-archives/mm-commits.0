From: akpm@osdl.org
Subject: + fix-compilation-of-via-pmu-backlight.patch added to -mm tree
Date: Tue, 26 Dec 2006 23:57:39 -0800
Message-ID: <200612270757.kBR7vdWI004949@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37995 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940AbWL0H5o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 02:57:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwab@suse.de, benh@kernel.crashing.org, luming.yu@intel.com


The patch titled
     Fix compilation of via-pmu-backlight
has been added to the -mm tree.  Its filename is
     fix-compilation-of-via-pmu-backlight.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-compilation-of-via-pmu-backlight.patch

