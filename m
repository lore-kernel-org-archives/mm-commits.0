From: akpm@linux-foundation.org
Subject: + uml-user-of-helper_wait-got-missed-when-it-got-extra-arguments.patch added to -mm tree
Date: Fri, 04 Jan 2008 22:48:56 -0800
Message-ID: <200801050649.m056nnq2032423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49173 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073AbYAEGuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 Jan 2008 01:50:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, jdike@addtoit.com, viro@zeniv.linux.org.uk


The patch titled
     uml: user of helper_wait() got missed when it got extra arguments
has been added to the -mm tree.  Its filename is
     uml-user-of-helper_wait-got-missed-when-it-got-extra-arguments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: user of helper_wait() got missed when it got extra arguments
From: Al Viro <viro@ftp.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/harddog_user.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/harddog_user.c~uml-user-of-helper_wait-got-missed-when-it-got-extra-arguments arch/um/drivers/harddog_user.c
--- a/arch/um/drivers/harddog_user.c~uml-user-of-helper_wait-got-missed-when-it-got-extra-arguments
+++ a/arch/um/drivers/harddog_user.c
@@ -79,14 +79,14 @@ int start_watchdog(int *in_fd_ret, int *
 	n = read(in_fds[0], &c, sizeof(c));
 	if (n == 0) {
 		printk("harddog_open - EOF on watchdog pipe\n");
-		helper_wait(pid);
+		helper_wait(pid, 1, NULL);
 		err = -EIO;
 		goto out_close_out;
 	}
 	else if (n < 0) {
 		printk("harddog_open - read of watchdog pipe failed, "
 		       "err = %d\n", errno);
-		helper_wait(pid);
+		helper_wait(pid, 1, NULL);
 		err = n;
 		goto out_close_out;
 	}
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

uml-user-of-helper_wait-got-missed-when-it-got-extra-arguments.patch
sdio-fix-module-device-table-definition-for-m68k.patch
git-netdev-all.patch
slab-leaks3-default-y.patch
