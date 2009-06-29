From: akpm@linux-foundation.org
Subject: + floppy-fix-lock-imbalance.patch added to -mm tree
Date: Mon, 29 Jun 2009 14:35:18 -0700
Message-ID: <200906292135.n5TLZI6s014167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324AbZF2VfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 17:35:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, jens.axboe@oracle.com


The patch titled
     floppy: fix lock imbalance
has been added to the -mm tree.  Its filename is
     floppy-fix-lock-imbalance.patch

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
Subject: floppy: fix lock imbalance
From: Jiri Slaby <jirislaby@gmail.com>

A crappy macro prevents us unlocking on a fail path.

Expand the macro and unlock appropriatelly.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/block/floppy.c~floppy-fix-lock-imbalance drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-fix-lock-imbalance
+++ a/drivers/block/floppy.c
@@ -3327,7 +3327,10 @@ static inline int set_geometry(unsigned 
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		mutex_lock(&open_lock);
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1)) {
+			mutex_unlock(&open_lock);
+			return -EINTR;
+		}
 		floppy_type[type] = *g;
 		floppy_type[type].name = "user format";
 		for (cnt = type << 2; cnt < (type << 2) + 4; cnt++)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
icom-converting-space-to-tabs.patch
floppy-fix-lock-imbalance.patch
reiser4.patch

