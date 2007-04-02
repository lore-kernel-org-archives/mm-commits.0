From: akpm@linux-foundation.org
Subject: + vt-fix-potential-race-in-vt_waitactive-handler.patch added to -mm tree
Date: Sun, 01 Apr 2007 22:27:15 -0700
Message-ID: <200704020527.l325RF2f024944@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36033 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbXDBF1Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 01:27:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, adaplas@pol.net


The patch titled
     vt: fix potential race in VT_WAITACTIVE handler
has been added to the -mm tree.  Its filename is
     vt-fix-potential-race-in-vt_waitactive-handler.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vt: fix potential race in VT_WAITACTIVE handler
From: Michal Januszewski <spock@gentoo.org>

On a multiprocessor machine the VT_WAITACTIVE ioctl call may return 0 if
fg_console has already been updated in redraw_screen() but the console
switch itself hasn't been completed.  Fix this by checking fg_console in
vt_waitactive() with the console sem held.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Acked-by: Antonino Daplas <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt_ioctl.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN drivers/char/vt_ioctl.c~vt-fix-potential-race-in-vt_waitactive-handler drivers/char/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~vt-fix-potential-race-in-vt_waitactive-handler
+++ a/drivers/char/vt_ioctl.c
@@ -1039,10 +1039,22 @@ int vt_waitactive(int vt)
 
 	add_wait_queue(&vt_activate_queue, &wait);
 	for (;;) {
-		set_current_state(TASK_INTERRUPTIBLE);
 		retval = 0;
-		if (vt == fg_console)
+
+		/*
+		 * Synchronize with redraw_screen(). By acquiring the console
+		 * semaphore we make sure that the console switch is completed
+		 * before we return. If we didn't wait for the semaphore, we
+		 * could return at a point where fg_console has already been
+		 * updated, but the console switch hasn't been completed.
+		 */
+		acquire_console_sem();
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (vt == fg_console) {
+			release_console_sem();
 			break;
+		}
+		release_console_sem();
 		retval = -EINTR;
 		if (signal_pending(current))
 			break;
_

Patches currently in -mm which might be from spock@gentoo.org are

vt-fix-potential-race-in-vt_waitactive-handler.patch
