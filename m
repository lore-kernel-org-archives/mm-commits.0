From: akpm@linux-foundation.org
Subject: - fix-failure-to-resume-from-initrds.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:15:17 -0700
Message-ID: <200709202115.l8KLFHwC002894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41769 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975AbXITVQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nigel@nigel.suspend2.net, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Fix failure to resume from initrds
has been removed from the -mm tree.  Its filename was
     fix-failure-to-resume-from-initrds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix failure to resume from initrds
From: Nigel Cunningham <nigel@nigel.suspend2.net>

Commit 831441862956fffa17b9801db37e6ea1650b0f69 (Freezer: make kernel
threads nonfreezable by default) breaks freezing when attempting to resume
from an initrd, because the init (which is freezeable) spins while waiting
for another thread to run /linuxrc, but doesn't check whether it has been
told to enter the refrigerator.  The original patch replaced a call to
try_to_freeze() with a call to yield().  I believe a simple reversion is
wrong because if !CONFIG_PM_SLEEP, try_to_freeze() is a noop.  It should
still yield.

Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_initrd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN init/do_mounts_initrd.c~fix-failure-to-resume-from-initrds init/do_mounts_initrd.c
--- a/init/do_mounts_initrd.c~fix-failure-to-resume-from-initrds
+++ a/init/do_mounts_initrd.c
@@ -57,8 +57,10 @@ static void __init handle_initrd(void)
 
 	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
 	if (pid > 0)
-		while (pid != sys_wait4(-1, NULL, 0, NULL))
+		while (pid != sys_wait4(-1, NULL, 0, NULL)) {
+			try_to_freeze();
 			yield();
+		}
 
 	/* move initrd to rootfs' /old */
 	sys_fchdir(old_fd);
_

Patches currently in -mm which might be from nigel@nigel.suspend2.net are

freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
freezer-be-more-verbose.patch
