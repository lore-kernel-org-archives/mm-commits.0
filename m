From: akpm@linux-foundation.org
Subject: + vt-ioctl-race-fix.patch added to -mm tree
Date: Thu, 27 Sep 2007 13:48:42 -0700
Message-ID: <200709272048.l8RKmg5S027387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35311 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743AbXI0Usv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 16:48:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sameo@openedhand.com


The patch titled
     VT ioctl race fix
has been added to the -mm tree.  Its filename is
     vt-ioctl-race-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: VT ioctl race fix
From: Samuel Ortiz <sameo@openedhand.com>

When calling the RELDISP VT ioctl, we are reading vt_newvt while the
console workqueue could be messing with it (through change_console()).  We
fix this race by taking the console semaphore before reading vt_newvt.

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/char/vt_ioctl.c~vt-ioctl-race-fix drivers/char/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~vt-ioctl-race-fix
+++ a/drivers/char/vt_ioctl.c
@@ -812,6 +812,7 @@ int vt_ioctl(struct tty_struct *tty, str
 		/*
 		 * Switching-from response
 		 */
+		acquire_console_sem();
 		if (vc->vt_newvt >= 0) {
 			if (arg == 0)
 				/*
@@ -826,7 +827,6 @@ int vt_ioctl(struct tty_struct *tty, str
 				 * complete the switch.
 				 */
 				int newvt;
-				acquire_console_sem();
 				newvt = vc->vt_newvt;
 				vc->vt_newvt = -1;
 				i = vc_allocate(newvt);
@@ -840,7 +840,6 @@ int vt_ioctl(struct tty_struct *tty, str
 				 * other console switches..
 				 */
 				complete_change_console(vc_cons[newvt].d);
-				release_console_sem();
 			}
 		}
 
@@ -852,9 +851,12 @@ int vt_ioctl(struct tty_struct *tty, str
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

vt-ioctl-race-fix.patch
