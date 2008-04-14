From: akpm@linux-foundation.org
Subject: + aacraid-fix-unchecked-down_interruptible.patch added to -mm tree
Date: Mon, 14 Apr 2008 16:41:58 -0700
Message-ID: <200804142341.m3ENfwT9000527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756695AbYDNXmf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 19:42:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Mark_Salyzyn@adaptec.com, James.Bottomley@HansenPartnership.com, alan@lxorguk.ukuu.org.uk


The patch titled
     aacraid: fix unchecked down_interruptible()
has been added to the -mm tree.  Its filename is
     aacraid-fix-unchecked-down_interruptible.patch

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
aacraid-fix-unchecked-down_interruptible.patch

