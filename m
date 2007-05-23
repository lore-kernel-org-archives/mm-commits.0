From: akpm@linux-foundation.org
Subject: + rocketc-fix-unchecked-mutex_lock_interruptible.patch added to -mm tree
Date: Wed, 23 May 2007 11:17:38 -0700
Message-ID: <200705231817.l4NIHb5J028992@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755042AbXEWSRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 14:17:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam.sharma@gmail.com, jirislaby@gmail.com


The patch titled
     rocket.c: fix unchecked mutex_lock_interruptible()
has been added to the -mm tree.  Its filename is
     rocketc-fix-unchecked-mutex_lock_interruptible.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-ubi.patch
rocketc-fix-unchecked-mutex_lock_interruptible.patch
