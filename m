From: akpm@linux-foundation.org
Subject: - aacraid-fix-unchecked-down_interruptible.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:49 -0700
Message-ID: <200804162255.m3GMtnqk011153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275AbYDPW4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 18:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Mark_Salyzyn@adaptec.com, James.Bottomley@HansenPartnership.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     aacraid: fix unchecked down_interruptible()
has been removed from the -mm tree.  Its filename was
     aacraid-fix-unchecked-down_interruptible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aacraid: fix unchecked down_interruptible()
From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>

drivers/scsi/aacraid/commsup.c: In function 'aac_fib_send':
drivers/scsi/aacraid/commsup.c:519: warning: ignoring return value of 'down_interruptible', declared with attribute warn_unused_result

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/commsup.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/aacraid/commsup.c~aacraid-fix-unchecked-down_interruptible drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c~aacraid-fix-unchecked-down_interruptible
+++ a/drivers/scsi/aacraid/commsup.c
@@ -515,10 +515,12 @@ int aac_fib_send(u16 command, struct fib
 				}
 				udelay(5);
 			}
-		} else
-			(void)down_interruptible(&fibptr->event_wait);
+		} else if (down_interruptible(&fibptr->event_wait) == 0) {
+			fibptr->done = 2;
+			up(&fibptr->event_wait);
+		}
 		spin_lock_irqsave(&fibptr->event_lock, flags);
-		if (fibptr->done == 0) {
+		if ((fibptr->done == 0) || (fibptr->done == 2)) {
 			fibptr->done = 2; /* Tell interrupt we aborted */
 			spin_unlock_irqrestore(&fibptr->event_lock, flags);
 			return -EINTR;
_

Patches currently in -mm which might be from Mark_Salyzyn@adaptec.com are

git-scsi-misc.patch

