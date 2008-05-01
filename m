From: akpm@linux-foundation.org
Subject: - tty-fix-routine-name-in-ptmx_open.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:04 -0700
Message-ID: <200805010931.m419V4OW030835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755557AbYEAJbp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: h-shimamoto@ct.jp.nec.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty: fix routine name in ptmx_open()
has been removed from the -mm tree.  Its filename was
     tty-fix-routine-name-in-ptmx_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty: fix routine name in ptmx_open()
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

At ptmx_open(), the 2nd parameter for check_tty_count() should
be "ptmx_open".

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/tty_io.c~tty-fix-routine-name-in-ptmx_open drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-fix-routine-name-in-ptmx_open
+++ a/drivers/char/tty_io.c
@@ -2842,7 +2842,7 @@ static int ptmx_open(struct inode *inode
 	if (devpts_pty_new(tty->link))
 		goto out1;
 
-	check_tty_count(tty, "tty_open");
+	check_tty_count(tty, "ptmx_open");
 	retval = ptm_driver->ops->open(tty, filp);
 	if (!retval)
 		return 0;
_

Patches currently in -mm which might be from h-shimamoto@ct.jp.nec.com are

origin.patch

