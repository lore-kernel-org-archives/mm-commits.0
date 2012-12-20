From: akpm@linux-foundation.org
Subject: + rtc-ds2404-use-module_platform_driver-macro.patch added to -mm tree
Date: Thu, 20 Dec 2012 15:55:03 -0800
Message-ID: <20121220235503.F39F920005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:64948 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2LTXzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 18:55:06 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so214418fae.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 15:55:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srinivas.kandagatla@st.com


The patch titled
     Subject: drivers/rtc/rtc-ds2404.c: use module_platform_driver macro
has been added to the -mm tree.  Its filename is
     rtc-ds2404-use-module_platform_driver-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
