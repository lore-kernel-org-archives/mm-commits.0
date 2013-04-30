From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-mv-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:56 -0700
Message-ID: <20130430185456.729605A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:34149 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab3D3Sy5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:57 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so86715qcr.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-mv: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-mv-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-mv: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mv.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-mv.c~rtc-rtc-mv-use-module_platform_driver_probe drivers/rtc/rtc-mv.c
--- a/drivers/rtc/rtc-mv.c~rtc-rtc-mv-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-mv.c
@@ -331,18 +331,7 @@ static struct platform_driver mv_rtc_dri
 	},
 };
 
-static __init int mv_init(void)
-{
-	return platform_driver_probe(&mv_rtc_driver, mv_rtc_probe);
-}
-
-static __exit void mv_exit(void)
-{
-	platform_driver_unregister(&mv_rtc_driver);
-}
