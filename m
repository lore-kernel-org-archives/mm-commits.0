From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-efi-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:43 -0700
Message-ID: <20130430185443.7192A31C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:39171 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab3D3Syo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:44 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so86676qen.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-efi: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-efi-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-efi: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-efi.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-efi.c~rtc-rtc-efi-use-module_platform_driver_probe drivers/rtc/rtc-efi.c
--- a/drivers/rtc/rtc-efi.c~rtc-rtc-efi-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-efi.c
@@ -218,18 +218,7 @@ static struct platform_driver efi_rtc_dr
 	.remove = __exit_p(efi_rtc_remove),
 };
 
-static int __init efi_rtc_init(void)
-{
-	return platform_driver_probe(&efi_rtc_driver, efi_rtc_probe);
-}
-
-static void __exit efi_rtc_exit(void)
-{
-	platform_driver_unregister(&efi_rtc_driver);
-}
