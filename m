From: akpm@linux-foundation.org
Subject: - fbcon-delay-the-start-of-the-cursor-timer-until-a-con_switch.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:16:57 -0700
Message-ID: <200710162116.l9GLGw0A017573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37518 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965387AbXJPVRa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:17:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbcon: delay the start of the cursor timer until a con_switch()
has been removed from the -mm tree.  Its filename was
     fbcon-delay-the-start-of-the-cursor-timer-until-a-con_switch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbcon: delay the start of the cursor timer until a con_switch()
From: Antonino Daplas <adaplas@gmail.com>

As reported in Bugzilla Bug 9093, upon switching to X, a small rectangular
cursor can still be seen blinking in the upper left part of the screen.  It is
fbcon's text cursor.  This is caused by a strange ioctl(..., KDSETMODE,
KD_TEXT) call done by something in userspace, perhaps by X itself, while the
tty is still in graphics mode.  And when the tty is in KD_TEXT mode, the
cursor timer is restarted.

Although this is a userspace problem, we can work around it by delaying the
restart of the cursor timer until an fbcon_switch() is called.  In other
words, the cursor timer will not be restarted even if a KD_TEXT mode switch is
requested.

Regression potential: Present but low

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.c~fbcon-delay-the-start-of-the-cursor-timer-until-a-con_switch drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-delay-the-start-of-the-cursor-timer-until-a-con_switch
+++ a/drivers/video/console/fbcon.c
@@ -2405,7 +2405,7 @@ static int fbcon_blank(struct vc_data *v
 			update_screen(vc);
 	}
 
-	if (fbcon_is_inactive(vc, info) ||
+	if (mode_switch || fbcon_is_inactive(vc, info) ||
 	    ops->blank_state != FB_BLANK_UNBLANK)
 		fbcon_del_cursor_timer(info);
 	else
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
fbcon-delay-the-start-of-the-cursor-timer-until-a-con_switch.patch
cyber2000fb-checkpatch-fixes.patch
