From: akpm@linux-foundation.org
Subject: + devpts-propagate-error-code-from-devpts_pty_new.patch added to -mm tree
Date: Thu, 17 Apr 2008 14:18:40 -0700
Message-ID: <200804172118.m3HLIexK028413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663AbYDQVYo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 17:24:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@us.ibm.com, hpa@zytor.com, serue@us.ibm.com


The patch titled
     devpts: propagate error code from devpts_pty_new
has been added to the -mm tree.  Its filename is
     devpts-propagate-error-code-from-devpts_pty_new.patch

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

devpts-propagate-error-code-from-devpts_pty_new.patch
devpts-factor-out-pty-index-allocation.patch
devpts-factor-out-pty-index-allocation-fix.patch
deprecate-find_task_by_pid-warning-fix.patch

