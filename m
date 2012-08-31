From: akpm@linux-foundation.org
Subject: + aoe-do-revalidation-steps-in-order.patch added to -mm tree
Date: Fri, 31 Aug 2012 13:11:55 -0700
Message-ID: <20120831201156.926165C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:41482 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab2HaUL6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 16:11:58 -0400
Received: by mail-ey0-f202.google.com with SMTP id c1so171672eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 13:11:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: do revalidation steps in order
has been added to the -mm tree.  Its filename is
     aoe-do-revalidation-steps-in-order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

aoe-for-performance-support-larger-packet-payloads.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking.patch
aoe-become-i-o-request-queue-handler-for-increased-user-control.patch
aoe-use-a-kernel-thread-for-transmissions.patch
aoe-use-packets-that-work-with-the-smallest-mtu-local-interface.patch
aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter.patch
aoe-do-revalidation-steps-in-order.patch
aoe-disallow-unsupported-aoe-minor-addresses.patch
aoe-associate-frames-with-the-aoe-storage-target.patch
aoe-increase-net_device-reference-count-while-using-it.patch
aoe-remove-unused-code-and-add-cosmetic-improvements.patch
aoe-update-internal-version-number-to-49.patch
aoe-update-copyright-year-in-touched-files.patch
aoe-update-documentation-with-new-url-and-vm-settings-reference.patch

