From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pcap-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:02 -0700
Message-ID: <20130430185502.6F8B35A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:64933 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933205Ab3D3SzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:03 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so86689ggc.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-pcap: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pcap-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-pcap: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcap.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-pcap.c~rtc-rtc-pcap-use-module_platform_driver_probe drivers/rtc/rtc-pcap.c
--- a/drivers/rtc/rtc-pcap.c~rtc-rtc-pcap-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-pcap.c
@@ -203,18 +203,7 @@ static struct platform_driver pcap_rtc_d
 	},
 };
 
-static int __init rtc_pcap_init(void)
-{
-	return platform_driver_probe(&pcap_rtc_driver, pcap_rtc_probe);
-}
-
-static void __exit rtc_pcap_exit(void)
-{
-	platform_driver_unregister(&pcap_rtc_driver);
-}
