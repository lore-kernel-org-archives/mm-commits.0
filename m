From: akpm@linux-foundation.org
Subject: + tty-fix-routine-name-in-ptmx_open.patch added to -mm tree
Date: Tue, 15 Apr 2008 15:01:47 -0700
Message-ID: <200804152201.m3FM1lD8018018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765482AbYDOWCj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 18:02:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: h-shimamoto@ct.jp.nec.com, alan@redhat.com


The patch titled
     tty: fix routine name in ptmx_open()
has been added to the -mm tree.  Its filename is
     tty-fix-routine-name-in-ptmx_open.patch

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
@@ -2843,7 +2843,7 @@ static int ptmx_open(struct inode *inode
 	if (devpts_pty_new(tty->link))
 		goto out1;
 
-	check_tty_count(tty, "tty_open");
+	check_tty_count(tty, "ptmx_open");
 	retval = ptm_driver->ops->open(tty, filp);
 	if (!retval)
 		return 0;
_

Patches currently in -mm which might be from h-shimamoto@ct.jp.nec.com are

git-x86.patch
tty-fix-routine-name-in-ptmx_open.patch

