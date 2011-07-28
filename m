From: akpm@linux-foundation.org
Subject: [merged] hpsa-do-not-attempt-to-read-from-a-write-only-register.patch removed from -mm tree
Date: Thu, 28 Jul 2011 13:01:30 -0700
Message-ID: <201107282000.p6SK05Ob005384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755365Ab1G1UAO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 16:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     hpsa: do not attempt to read from a write-only register
has been removed from the -mm tree.  Its filename was
     hpsa-do-not-attempt-to-read-from-a-write-only-register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: do not attempt to read from a write-only register
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Most smartarrays tolerate it, but a few new ones don't.

When the controller doesn't tolerate the bug, the firmware on it locks up.
 No interrupts are received, no commands complete.  I/o on that controller
grinds to a halt.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hpsa.h~hpsa-do-not-attempt-to-read-from-a-write-only-register drivers/scsi/hpsa.h
--- a/drivers/scsi/hpsa.h~hpsa-do-not-attempt-to-read-from-a-write-only-register
+++ a/drivers/scsi/hpsa.h
@@ -214,7 +214,7 @@ static void SA5_submit_command(struct ct
 	dev_dbg(&h->pdev->dev, "Sending %x, tag = %x\n", c->busaddr,
 		c->Header.Tag.lower);
 	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
-	(void) readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	(void) readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 	h->commands_outstanding++;
 	if (h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding = h->commands_outstanding;
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

origin.patch
linux-next.patch

