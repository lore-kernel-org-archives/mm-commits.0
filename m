From: akpm@linux-foundation.org
Subject: + uml-fix-helper_wait-calls-in-watchdog.patch added to -mm tree
Date: Tue, 12 Feb 2008 12:05:44 -0800
Message-ID: <200802122005.m1CK5ir1019804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58833 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbYBLUGT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 15:06:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johfel@users.sourceforge.net, jdike@linux.intel.com


The patch titled
     uml: fix helper_wait calls in watchdog
has been added to the -mm tree.  Its filename is
     uml-fix-helper_wait-calls-in-watchdog.patch

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
Subject: uml: fix helper_wait calls in watchdog
From: Johann Felix Soden <johfel@users.sourceforge.net>

In 1aa351a308d2c3ddb92b6cc45083fc54271d0010 the arguments of helper_wait() were
changed. The adaptation of harddog_user.c was forgotten, so this errors occur:

/arch/um/drivers/harddog_user.c: In function 'start_watchdog':
/arch/um/drivers/harddog_user.c:82: error: too many arguments to function 'helper_wait'
/arch/um/drivers/harddog_user.c:89: error: too many arguments to function 'helper_wait'

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/harddog_user.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/harddog_user.c~uml-fix-helper_wait-calls-in-watchdog arch/um/drivers/harddog_user.c
--- a/arch/um/drivers/harddog_user.c~uml-fix-helper_wait-calls-in-watchdog
+++ a/arch/um/drivers/harddog_user.c
@@ -79,14 +79,14 @@ int start_watchdog(int *in_fd_ret, int *
 	n = read(in_fds[0], &c, sizeof(c));
 	if (n == 0) {
 		printk("harddog_open - EOF on watchdog pipe\n");
-		helper_wait(pid, 1, NULL);
+		helper_wait(pid);
 		err = -EIO;
 		goto out_close_out;
 	}
 	else if (n < 0) {
 		printk("harddog_open - read of watchdog pipe failed, "
 		       "err = %d\n", errno);
-		helper_wait(pid, 1, NULL);
+		helper_wait(pid);
 		err = n;
 		goto out_close_out;
 	}
_

Patches currently in -mm which might be from johfel@users.sourceforge.net are

origin.patch
rtc-remove-unused-var-in-drivers-rtc-rtc-r9701o.patch
uml-fix-initrd-printk.patch
uml-fix-helper_wait-calls-in-watchdog.patch
