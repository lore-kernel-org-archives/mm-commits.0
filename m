From: akpm@linux-foundation.org
Subject: [merged] rtc-ds2404-use-module_platform_driver-macro.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:32 -0800
Message-ID: <20130222204332.A1C6831C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:52833 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758169Ab3BVUnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:33 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so104001yhr.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srinivas.kandagatla@st.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds2404.c: use module_platform_driver macro
has been removed from the -mm tree.  Its filename was
     rtc-ds2404-use-module_platform_driver-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: drivers/rtc/rtc-ds2404.c: use module_platform_driver macro

Remove removes some code duplication by using module_platform_driver().

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds2404.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-ds2404.c~rtc-ds2404-use-module_platform_driver-macro drivers/rtc/rtc-ds2404.c
--- a/drivers/rtc/rtc-ds2404.c~rtc-ds2404-use-module_platform_driver-macro
+++ a/drivers/rtc/rtc-ds2404.c
@@ -283,19 +283,7 @@ static struct platform_driver rtc_device
 		.owner	= THIS_MODULE,
 	},
 };
-
-static __init int ds2404_init(void)
-{
-	return platform_driver_register(&rtc_device_driver);
-}
-
-static __exit void ds2404_exit(void)
-{
-	platform_driver_unregister(&rtc_device_driver);
-}
