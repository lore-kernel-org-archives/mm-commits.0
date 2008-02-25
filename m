From: akpm@linux-foundation.org
Subject: - uml-fix-helper_wait-calls-in-watchdog.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:45:03 -0800
Message-ID: <200802250045.m1P0j3mP006225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648AbYBYAsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:48:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johfel@users.sourceforge.net, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix helper_wait calls in watchdog
has been removed from the -mm tree.  Its filename was
     uml-fix-helper_wait-calls-in-watchdog.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
