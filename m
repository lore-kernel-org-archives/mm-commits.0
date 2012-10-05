From: akpm@linux-foundation.org
Subject: [merged] aoe-do-revalidation-steps-in-order.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:21:22 -0700
Message-ID: <20121005202123.025ED5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:60969 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUVY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:21:24 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so140000wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:21:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: do revalidation steps in order
has been removed from the -mm tree.  Its filename was
     aoe-do-revalidation-steps-in-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: do revalidation steps in order

The discovery process begins with an optional AoE config query command and
an AoE config query response.  Normally when an aoe device is already
open, the config query response does not trigger an ATA identify device
command to be sent out, since the response contains storage capacity
information that, if changed, could surprise the user of the device.

The userland "aoe-revalidate" tool uses a character device to trigger an
AoE config query for a particular AoE storage target and an ATA device
identify command, even when the device is open.

This change causes the config query to go out first, reflecting the normal
discovery sequence.  The responses could come back in any order, so this
change is fairly cosmetic.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoechr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/aoe/aoechr.c~aoe-do-revalidation-steps-in-order drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c~aoe-do-revalidation-steps-in-order
+++ a/drivers/block/aoe/aoechr.c
@@ -96,13 +96,14 @@ revalidate(const char __user *str, size_
 		return -EINVAL;
 	spin_lock_irqsave(&d->lock, flags);
 	aoecmd_cleanslate(d);
+	aoecmd_cfg(major, minor);
 loop:
 	skb = aoecmd_ata_id(d);
 	spin_unlock_irqrestore(&d->lock, flags);
 	/* try again if we are able to sleep a bit,
 	 * otherwise give up this revalidation
 	 */
-	if (!skb && !msleep_interruptible(200)) {
+	if (!skb && !msleep_interruptible(250)) {
 		spin_lock_irqsave(&d->lock, flags);
 		goto loop;
 	}
@@ -113,7 +114,6 @@ loop:
 		__skb_queue_tail(&queue, skb);
 		aoenet_xmit(&queue);
 	}
-	aoecmd_cfg(major, minor);
 	return 0;
 }
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch

