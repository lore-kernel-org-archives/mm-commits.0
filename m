From: akpm@linux-foundation.org
Subject: [merged] floppy-fix-lock-imbalance.patch removed from -mm tree
Date: Wed, 01 Jul 2009 10:28:13 -0700
Message-ID: <200907011728.n61HSDFO003164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753481AbZGAR2P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:28:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     floppy: fix lock imbalance
has been removed from the -mm tree.  Its filename was
     floppy-fix-lock-imbalance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
isdn-hisax-fix-lock-imbalance.patch
icom-converting-space-to-tabs.patch
base-firmware_class-fix-lock-imbalance.patch
md-fix-lock-imbalance.patch
wireless-nl80211-fix-lock-imbalance.patch
reiser4.patch

