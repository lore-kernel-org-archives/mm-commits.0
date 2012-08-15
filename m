From: akpm@linux-foundation.org
Subject: + rtc-at91sam9-use-module_platform_driver-macro.patch added to -mm tree
Date: Wed, 15 Aug 2012 15:38:48 -0700
Message-ID: <20120815223849.079255C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:62883 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2HOWiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 18:38:51 -0400
Received: by lbbge1 with SMTP id ge1so101750lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 15:38:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: develkernel412222@gmail.com, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-at91sam9.c: use module_platform_driver() macro
has been added to the -mm tree.  Its filename is
     rtc-at91sam9-use-module_platform_driver-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Devendra Naga <develkernel412222@gmail.com>
Subject: drivers/rtc/rtc-at91sam9.c: use module_platform_driver() macro

This driver does seems to do only platform_driver_register in the init
function and platform_driver_unregister in the exit function,

so replace all this code including the module_init and module_exit with
module_platform_driver macro...

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91sam9.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-at91sam9.c~rtc-at91sam9-use-module_platform_driver-macro drivers/rtc/rtc-at91sam9.c
--- a/drivers/rtc/rtc-at91sam9.c~rtc-at91sam9-use-module_platform_driver-macro
+++ a/drivers/rtc/rtc-at91sam9.c
@@ -465,18 +465,7 @@ static struct platform_driver at91_rtc_d
 	},
 };
 
-static int __init at91_rtc_init(void)
-{
-	return platform_driver_register(&at91_rtc_driver);
-}
-module_init(at91_rtc_init);
-
-static void __exit at91_rtc_exit(void)
-{
-	platform_driver_unregister(&at91_rtc_driver);
-}
-module_exit(at91_rtc_exit);
