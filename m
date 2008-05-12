From: akpm@linux-foundation.org
Subject: + asic3-remove-children-platform-data.patch added to -mm tree
Date: Mon, 12 May 2008 16:25:00 -0700
Message-ID: <200805122325.m4CNP0ew014426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754311AbYELXZF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:25:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sameo@openedhand.com, david-b@pacbell.net


The patch titled
     asic3: remove children platform data
has been added to the -mm tree.  Its filename is
     asic3-remove-children-platform-data.patch

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
Subject: asic3: remove children platform data
From: Samuel Ortiz <sameo@openedhand.com>

Platform devices should be dynamically allocated, and each supported
device should have its own platform data.  For now we just remove this
buggy code.

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/asic3.c       |    8 --------
 include/linux/mfd/asic3.h |    3 ---
 2 files changed, 11 deletions(-)

diff -puN drivers/mfd/asic3.c~asic3-remove-children-platform-data drivers/mfd/asic3.c
--- a/drivers/mfd/asic3.c~asic3-remove-children-platform-data
+++ a/drivers/mfd/asic3.c
@@ -607,14 +607,6 @@ static int asic3_probe(struct platform_d
 		goto out_irq;
 	}
 
-	if (pdata->children) {
-		int i;
-		for (i = 0; i < pdata->n_children; i++) {
-			pdata->children[i]->dev.parent = &pdev->dev;
-			platform_device_register(pdata->children[i]);
-		}
-	}
-
 	printk(KERN_INFO "ASIC3 Core driver\n");
 
 	return 0;
diff -puN include/linux/mfd/asic3.h~asic3-remove-children-platform-data include/linux/mfd/asic3.h
--- a/include/linux/mfd/asic3.h~asic3-remove-children-platform-data
+++ a/include/linux/mfd/asic3.h
@@ -32,9 +32,6 @@ struct asic3_platform_data {
 	unsigned int irq_base;
 
 	unsigned int gpio_base;
