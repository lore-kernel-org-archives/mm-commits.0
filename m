From: akpm@linux-foundation.org
Subject: + drivers-net-ac3200c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch added to -mm tree
Date: Sun, 02 Mar 2008 23:25:58 -0800
Message-ID: <200803030725.m237Pw05004536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863AbYCCH0G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 02:26:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkschind@gmail.com


The patch titled
     drivers/net/ac3200.c: replace init_module&cleanup_module with module_init&module_exit
has been added to the -mm tree.  Its filename is
     drivers-net-ac3200c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/ac3200.c: replace init_module&cleanup_module with module_init&module_exit
From: Jon Schindler <jkschind@gmail.com>

Replace init_module and cleanup_module with static functions and
module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ac3200.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/net/ac3200.c~drivers-net-ac3200c-replace-init_modulecleanup_module-with-module_initmodule_exit drivers/net/ac3200.c
--- a/drivers/net/ac3200.c~drivers-net-ac3200c-replace-init_modulecleanup_module-with-module_initmodule_exit
+++ a/drivers/net/ac3200.c
@@ -369,7 +369,7 @@ MODULE_PARM_DESC(mem, "Memory base addre
 MODULE_DESCRIPTION("Ansel AC3200 EISA ethernet driver");
 MODULE_LICENSE("GPL");
 
-int __init init_module(void)
+static int __init ac3200_module_init(void)
 {
 	struct net_device *dev;
 	int this_dev, found = 0;
@@ -404,8 +404,7 @@ static void cleanup_card(struct net_devi
 	iounmap(ei_status.mem);
 }
 
-void __exit
-cleanup_module(void)
+static void __exit ac3200_module_exit(void)
 {
 	int this_dev;
 
@@ -418,4 +417,6 @@ cleanup_module(void)
 		}
 	}
 }
+module_init(ac3200_module_init);
+module_exit(ac3200_module_exit);
 #endif /* MODULE */
_

Patches currently in -mm which might be from jkschind@gmail.com are

drivers-net-apnec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-appletalk-copsc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-appletalk-ltpcc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-arcnet-capmodec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-arcnet-com20020c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-at1700c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-atarilancec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-8390c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-ac3200c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

