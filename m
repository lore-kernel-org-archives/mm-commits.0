From: akpm@linux-foundation.org
Subject: [merged] add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call.patch removed from -mm tree
Date: Mon, 01 Mar 2010 11:47:02 -0800
Message-ID: <201003011947.o21Jl2V8028720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293Ab0CATuY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Mar 2010 14:50:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: atrigent@ccs.neu.edu, alan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     vt: add a new VT mode which is like VT_PROCESS but doesn't require a VT_RELDISP ioctl call
has been removed from the -mm tree.  Its filename was
     add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt: add a new VT mode which is like VT_PROCESS but doesn't require a VT_RELDISP ioctl call
From: Ari Entlich <atrigent@ccs.neu.edu>

This new VT mode (VT_PROCESS_AUTO) does everything that VT_PROCESS does
except that it doesn't wait for a VT_RELDISP ioctl before switching away
from a VT with that mode.

If the X server eventually uses this new mode, debugging and crash
recovery should become easier.  This is because even when currently in the
VT of a frozen X server it would still be possible to switch out by doing
SysRq-r and then CTRL-<number of a text vt>, sshing in and doing chvt
<number of a text vt>, or any other method of VT switching.  The general
concensus on #xorg-devel seems to be that it should be safe to use this
with X now that we have KMS.

This also moves the VT_ACKACQ define to a more appropriate place, for
clarity's sake.

Signed-off-by: Ari Entlich <atrigent@ccs.neu.edu>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt_ioctl.c |   39 +++++++++++++++++++-------------------
 include/linux/vt.h      |    3 +-
 2 files changed, 22 insertions(+), 20 deletions(-)

diff -puN drivers/char/vt_ioctl.c~add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call drivers/char/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call
+++ a/drivers/char/vt_ioctl.c
@@ -888,7 +888,7 @@ int vt_ioctl(struct tty_struct *tty, str
 			ret = -EFAULT;
 			goto out;
 		}
-		if (tmp.mode != VT_AUTO && tmp.mode != VT_PROCESS) {
+		if (tmp.mode != VT_AUTO && tmp.mode != VT_PROCESS && tmp.mode != VT_PROCESS_AUTO) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -1622,7 +1622,7 @@ static void complete_change_console(stru
 	 * telling it that it has acquired. Also check if it has died and
 	 * clean up (similar to logic employed in change_console())
 	 */
-	if (vc->vt_mode.mode == VT_PROCESS) {
+	if (vc->vt_mode.mode == VT_PROCESS || vc->vt_mode.mode == VT_PROCESS_AUTO) {
 		/*
 		 * Send the signal as privileged - kill_pid() will
 		 * tell us if the process has gone or something else
@@ -1682,7 +1682,7 @@ void change_console(struct vc_data *new_
 	 * vt to auto control.
 	 */
 	vc = vc_cons[fg_console].d;
-	if (vc->vt_mode.mode == VT_PROCESS) {
+	if (vc->vt_mode.mode == VT_PROCESS || vc->vt_mode.mode == VT_PROCESS_AUTO) {
 		/*
 		 * Send the signal as privileged - kill_pid() will
 		 * tell us if the process has gone or something else
@@ -1693,27 +1693,28 @@ void change_console(struct vc_data *new_
 		 */
 		vc->vt_newvt = new_vc->vc_num;
 		if (kill_pid(vc->vt_pid, vc->vt_mode.relsig, 1) == 0) {
+			if(vc->vt_mode.mode == VT_PROCESS)
+				/*
+				 * It worked. Mark the vt to switch to and
+				 * return. The process needs to send us a
+				 * VT_RELDISP ioctl to complete the switch.
+				 */
+				return;
+		} else {
 			/*
-			 * It worked. Mark the vt to switch to and
-			 * return. The process needs to send us a
-			 * VT_RELDISP ioctl to complete the switch.
+			 * The controlling process has died, so we revert back to
+			 * normal operation. In this case, we'll also change back
+			 * to KD_TEXT mode. I'm not sure if this is strictly correct
+			 * but it saves the agony when the X server dies and the screen
+			 * remains blanked due to KD_GRAPHICS! It would be nice to do
+			 * this outside of VT_PROCESS but there is no single process
+			 * to account for and tracking tty count may be undesirable.
 			 */
-			return;
+			reset_vc(vc);
 		}
 
 		/*
-		 * The controlling process has died, so we revert back to
-		 * normal operation. In this case, we'll also change back
-		 * to KD_TEXT mode. I'm not sure if this is strictly correct
-		 * but it saves the agony when the X server dies and the screen
-		 * remains blanked due to KD_GRAPHICS! It would be nice to do
-		 * this outside of VT_PROCESS but there is no single process
-		 * to account for and tracking tty count may be undesirable.
-		 */
-		reset_vc(vc);
-
-		/*
-		 * Fall through to normal (VT_AUTO) handling of the switch...
+		 * Fall through to normal (VT_AUTO and VT_PROCESS_AUTO) handling of the switch...
 		 */
 	}
 
diff -puN include/linux/vt.h~add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call include/linux/vt.h
--- a/include/linux/vt.h~add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call
+++ a/include/linux/vt.h
@@ -27,7 +27,7 @@ struct vt_mode {
 #define VT_SETMODE	0x5602	/* set mode of active vt */
 #define		VT_AUTO		0x00	/* auto vt switching */
 #define		VT_PROCESS	0x01	/* process controls switching */
-#define		VT_ACKACQ	0x02	/* acknowledge switch */
+#define		VT_PROCESS_AUTO 0x02	/* process is notified of switching */
 
 struct vt_stat {
 	unsigned short v_active;	/* active vt */
@@ -38,6 +38,7 @@ struct vt_stat {
 #define VT_SENDSIG	0x5604	/* signal to send to bitmask of vts */
 
 #define VT_RELDISP	0x5605	/* release display */
+#define		VT_ACKACQ	0x02	/* acknowledge switch */
 
 #define VT_ACTIVATE	0x5606	/* make vt active */
 #define VT_WAITACTIVE	0x5607	/* wait for vt active */
_

Patches currently in -mm which might be from atrigent@ccs.neu.edu are

linux-next.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch

