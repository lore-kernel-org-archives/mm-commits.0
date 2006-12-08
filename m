From: akpm@osdl.org
Subject: - tty-signal-tty-locking-3270-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:43:29 -0800
Message-ID: <200612080843.kB88hT6E013743@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36494 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425191AbWLHIoJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:44:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwidefsky@de.ibm.com, a.p.zijlstra@chello.nl, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty-signal-tty-locking 3270 fix
has been removed from the -mm tree.  Its filename was
     tty-signal-tty-locking-3270-fix.patch

This patch was dropped because it was folded into tty-signal-tty-locking.patch

------------------------------------------------------
Subject: tty-signal-tty-locking 3270 fix
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

In case of a non 3270 tty the mutex won't get freed.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/s390/char/fs3270.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/s390/char/fs3270.c~tty-signal-tty-locking-3270-fix drivers/s390/char/fs3270.c
--- a/drivers/s390/char/fs3270.c~tty-signal-tty-locking-3270-fix
+++ a/drivers/s390/char/fs3270.c
@@ -427,10 +427,10 @@ fs3270_open(struct inode *inode, struct 
 		struct tty_struct *tty;
 		mutex_lock(&tty_mutex);
 		tty = get_current_tty();
-		if (!tty)
-			return -ENODEV;
-		if (tty->driver->major != IBM_TTY3270_MAJOR)
+		if (!tty || tty->driver->major != IBM_TTY3270_MAJOR) {
+			mutex_unlock(&tty_mutex);
 			return -ENODEV;
+		}
 		minor = tty->index + RAW3270_FIRSTMINOR;
 		mutex_unlock(&tty_mutex);
 	}
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

origin.patch
tty-signal-tty-locking.patch
tty-signal-tty-locking-3270-fix.patch
generic-ioremap_page_range-s390-conversion.patch

