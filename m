From: akpm@linux-foundation.org
Subject: - rocketc-fix-unchecked-mutex_lock_interruptible.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:23 -0700
Message-ID: <200707162054.l6GKsNxr001796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52829 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761177AbXGPVWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:22:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam.sharma@gmail.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     rocket.c: fix unchecked mutex_lock_interruptible()
has been removed from the -mm tree.  Its filename was
     rocketc-fix-unchecked-mutex_lock_interruptible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rocket.c: fix unchecked mutex_lock_interruptible()
From: "Satyam Sharma" <satyam.sharma@gmail.com>

Check the return of mutex_lock_interruptible() in drivers/char/rocket.c and
return ERESTARTSYS if we were interrupted.

Signed-off-by: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/rocket.c~rocketc-fix-unchecked-mutex_lock_interruptible drivers/char/rocket.c
--- a/drivers/char/rocket.c~rocketc-fix-unchecked-mutex_lock_interruptible
+++ a/drivers/char/rocket.c
@@ -1702,7 +1702,8 @@ static int rp_write(struct tty_struct *t
 	if (count <= 0 || rocket_paranoia_check(info, "rp_write"))
 		return 0;
 
-	mutex_lock_interruptible(&info->write_mtx);
+	if (mutex_lock_interruptible(&info->write_mtx))
+		return -ERESTARTSYS;
 
 #ifdef ROCKET_DEBUG_WRITE
 	printk(KERN_INFO "rp_write %d chars...", count);
_

Patches currently in -mm which might be from satyam.sharma@gmail.com are

origin.patch
git-ubi.patch
