From: akpm@linux-foundation.org
Subject: - devpts-propagate-error-code-from-devpts_pty_new.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:07 -0700
Message-ID: <200805010931.m419V7wV030842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757624AbYEAJbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, hpa@zytor.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devpts: propagate error code from devpts_pty_new
has been removed from the -mm tree.  Its filename was
     devpts-propagate-error-code-from-devpts_pty_new.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devpts: propagate error code from devpts_pty_new
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Have ptmx_open() propagate any error code returned by devpts_pty_new()
(which returns either 0 or -ENOMEM anyway).

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/tty_io.c~devpts-propagate-error-code-from-devpts_pty_new drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~devpts-propagate-error-code-from-devpts_pty_new
+++ a/drivers/char/tty_io.c
@@ -2838,8 +2838,8 @@ static int ptmx_open(struct inode *inode
 	filp->private_data = tty;
 	file_move(filp, &tty->tty_files);
 
-	retval = -ENOMEM;
-	if (devpts_pty_new(tty->link))
+	retval = devpts_pty_new(tty->link);
+	if (retval)
 		goto out1;
 
 	check_tty_count(tty, "ptmx_open");
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

origin.patch

