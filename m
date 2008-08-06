From: akpm@linux-foundation.org
Subject: + sm501-update-debugging-low-information-messages.patch added to -mm tree
Date: Wed, 06 Aug 2008 09:10:52 -0700
Message-ID: <200808061610.m76GAqFQ002665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759288AbYHFQWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 12:22:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, sameo@openedhand.com


The patch titled
     sm501: update debugging/low information messages
has been added to the -mm tree.  Its filename is
     sm501-update-debugging-low-information-messages.patch

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
Subject: sm501: update debugging/low information messages
From: Ben Dooks <ben-linux@fluff.org>

Make the default output of the SM501 driver to be less noisy wrt to
message that have low informational value, or simply should be debug.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Samuel Ortiz <sameo@openedhand.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mfd/sm501.c~sm501-update-debugging-low-information-messages drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-update-debugging-low-information-messages
+++ a/drivers/mfd/sm501.c
@@ -623,8 +623,8 @@ unsigned long sm501_set_clock(struct dev
 
 	sm501_sync_regs(sm);
 
-	dev_info(sm->dev, "gate %08lx, clock %08lx, mode %08lx\n",
-		 gate, clock, mode);
+	dev_dbg(sm->dev, "gate %08lx, clock %08lx, mode %08lx\n",
+		gate, clock, mode);
 
 	sm501_mdelay(sm, 16);
 	mutex_unlock(&sm->clock_lock);
@@ -742,7 +742,7 @@ static int sm501_register_device(struct 
 	int ret;
 
 	for (ptr = 0; ptr < pdev->num_resources; ptr++) {
-		printk("%s[%d] flags %08lx: %08llx..%08llx\n",
+		printk(KERN_DEBUG "%s[%d] flags %08lx: %08llx..%08llx\n",
 		       pdev->name, ptr,
 		       pdev->resource[ptr].flags,
 		       (unsigned long long)pdev->resource[ptr].start,
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
backlight-add-more-information-output-to-pwm_backlight.patch
backlight-add-module_alias-to-pwm_backlight-driver.patch
sm501-update-debugging-low-information-messages.patch
linux-next.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

