From: akpm@linux-foundation.org
Subject: + hpsa-do-not-attempt-to-read-from-a-write-only-register.patch added to -mm tree
Date: Mon, 11 Jul 2011 13:19:16 -0700
Message-ID: <201107112019.p6BKJGau000992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754166Ab1GKUTx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jul 2011 16:19:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com


The patch titled
     hpsa: do not attempt to read from a write-only register
has been added to the -mm tree.  Its filename is
     hpsa-do-not-attempt-to-read-from-a-write-only-register.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: do not attempt to read from a write-only register
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Most smartarrays tolerate it, but a few new ones don't.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
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

hpsa-do-not-attempt-to-read-from-a-write-only-register.patch

