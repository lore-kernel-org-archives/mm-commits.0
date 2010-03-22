From: akpm@linux-foundation.org
Subject: [merged] input-bcm5974-retract-efi-broken-suspend_resume.patch removed from -mm tree
Date: Mon, 22 Mar 2010 11:31:26 -0400
Message-ID: <201003221832.o2MIWHWr019996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754764Ab0CVSce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 14:32:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: bcm5974: retract efi-broken suspend_resume
has been removed from the -mm tree.  Its filename was
     input-bcm5974-retract-efi-broken-suspend_resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: bcm5974: retract efi-broken suspend_resume
From: "Henrik Rydberg" <rydberg@euromail.se>

With the recent system-wide improvements on suspend/resume and EFI booting
the suspend_resume method of the bcm5974 has broken.  When waking up from
the S3 state on the MacBookAir, the trackpad is found in a yet unknown
state, unable to switch to the proper multitouch mode.  The result is a
frozen touchpad, and a flood of errors of the kind

bcm5974: bad trackpad package, length: 8.

This patch retracts the reset_resume method altogether, falling back on
the generic unbind/rebind functionality of the usb layer until further
investigations can be made as how to reset the device when booting from
efi.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/bcm5974.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/input/mouse/bcm5974.c~input-bcm5974-retract-efi-broken-suspend_resume drivers/input/mouse/bcm5974.c
--- a/drivers/input/mouse/bcm5974.c~input-bcm5974-retract-efi-broken-suspend_resume
+++ a/drivers/input/mouse/bcm5974.c
@@ -803,7 +803,6 @@ static struct usb_driver bcm5974_driver 
 	.disconnect		= bcm5974_disconnect,
 	.suspend		= bcm5974_suspend,
 	.resume			= bcm5974_resume,
-	.reset_resume		= bcm5974_resume,
 	.id_table		= bcm5974_table,
 	.supports_autosuspend	= 1,
 };
_

Patches currently in -mm which might be from rydberg@euromail.se are

linux-next.patch

