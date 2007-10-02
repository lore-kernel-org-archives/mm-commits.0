From: akpm@linux-foundation.org
Subject: - vt-ioctl-race-fix.patch removed from -mm tree
Date: Tue, 02 Oct 2007 15:54:57 -0700
Message-ID: <200710022254.l92MsvsW026748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36581 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215AbXJBWzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 18:55:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sameo@openedhand.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     VT ioctl race fix
has been removed from the -mm tree.  Its filename was
     vt-ioctl-race-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: VT ioctl race fix
From: Samuel Ortiz <sameo@openedhand.com>

When calling the RELDISP VT ioctl, we are reading vt_newvt while the
console workqueue could be messing with it (through change_console()).  We
fix this race by taking the console semaphore before reading vt_newvt.

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
Acked-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt_ioctl.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/char/vt_ioctl.c~vt-ioctl-race-fix drivers/char/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~vt-ioctl-race-fix
+++ a/drivers/char/vt_ioctl.c
@@ -770,6 +770,7 @@ int vt_ioctl(struct tty_struct *tty, str
 		/*
 		 * Switching-from response
 		 */
+		acquire_console_sem();
 		if (vc->vt_newvt >= 0) {
 			if (arg == 0)
 				/*
@@ -784,7 +785,6 @@ int vt_ioctl(struct tty_struct *tty, str
 				 * complete the switch.
 				 */
 				int newvt;
-				acquire_console_sem();
 				newvt = vc->vt_newvt;
 				vc->vt_newvt = -1;
 				i = vc_allocate(newvt);
@@ -798,7 +798,6 @@ int vt_ioctl(struct tty_struct *tty, str
 				 * other console switches..
 				 */
 				complete_change_console(vc_cons[newvt].d);
-				release_console_sem();
 			}
 		}
 
@@ -810,9 +809,12 @@ int vt_ioctl(struct tty_struct *tty, str
 			/*
 			 * If it's just an ACK, ignore it
 			 */
-			if (arg != VT_ACKACQ)
+			if (arg != VT_ACKACQ) {
+				release_console_sem();
 				return -EINVAL;
+			}
 		}
+		release_console_sem();
 
 		return 0;
 
_

Patches currently in -mm which might be from sameo@openedhand.com are
