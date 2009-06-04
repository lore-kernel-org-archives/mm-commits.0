From: akpm@linux-foundation.org
Subject: + console-make-blank-timeout-value-a-boot-option.patch added to -mm tree
Date: Thu, 04 Jun 2009 01:46:06 -0700
Message-ID: <200906040846.n548k6Vl010422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757193AbZFDIql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2009 04:46:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de


The patch titled
     From: Daniel Mack <daniel@caiaq.de>
has been added to the -mm tree.  Its filename is
     console-make-blank-timeout-value-a-boot-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: Daniel Mack <daniel@caiaq.de>
From: Daniel Mack <daniel@caiaq.de>

On Thu, Jun 04, 2009 at 01:17:40AM -0700, Andrew Morton wrote:
> > That's already possible - there is an ioctl for that. It's just not
> > configurable at boot time, and that occured to be very annoying when
> > developing systems that won't fully boot up for >10mins. You have no way
> > to wake up the console then.
>
> Oh.  Your changelog sucked :)
>
> > Is there any concern why that shouldn't be a kernel option?
>
> I suppose it makes sense.  You really have systems which take more than
> ten minutes to start running initscripts?  Poor you.

This happens during development only. Assume the system tries to mount
an NFS volume for its rootfs and fails due to a broken NIC driver; you
might be interessted in some debug output. Assume the kernel crashes
at boot time and you happen to miss that and come back to the machine
10 minutes later; you would still like to see the Oops. Or think about
situations where you forgot to add a userspace application to disable
the screen saver and you still want to see kernel messages and no input
device is attached to wake up the console. All possible scenarios where
this option would make sense.

I'm not saying it's the most important thing to have, but it's still
handy :)

> Please resend with a more complete description?

Attached. Better now?

Thanks,
Daniel

From 9a77004367e49d41b58b81fb6a4882d0906a4743 Mon Sep 17 00:00:00 2001
Date: Tue, 2 Jun 2009 16:38:44 +0200
Subject: [PATCH] console: make blank timeout value a boot option

The console blank timer is currently hardcoded to 10*60 seconds which
might be annoying on systems with no input devices attached to wake up
the console again. Especially during development, disabling the screen
saver can be handy - for example when debugging the root fs mount
mechanism or other scenarios where no userspace program could be started
to do that at runtime from userspace.

This patch defines a core_param for the variable in charge which allows
users to entirely disable the blank feature at boot time by setting it
0. The value can still be overwritten at runtime using the standard
ioctl call - this just allows to conditionally change the default.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
---

index e87bdbf..67331e8 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 ++++
 drivers/char/vt.c                   |   13 +++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff -puN Documentation/kernel-parameters.txt~console-make-blank-timeout-value-a-boot-option Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~console-make-blank-timeout-value-a-boot-option
+++ a/Documentation/kernel-parameters.txt
@@ -538,6 +538,10 @@ and is between 256 and 4096 characters. 
 			console=brl,ttyS0
 		For now, only VisioBraille is supported.
 
+	consoleblank=	[KNL] The console blank (screen saver) timeout in
+			seconds. Defaults to 10*60 = 10mins. A value of 0
+			disables the blank timer.
+
 	coredump_filter=
 			[KNL] Change the default value for
 			/proc/<pid>/coredump_filter.
diff -puN drivers/char/vt.c~console-make-blank-timeout-value-a-boot-option drivers/char/vt.c
--- a/drivers/char/vt.c~console-make-blank-timeout-value-a-boot-option
+++ a/drivers/char/vt.c
@@ -173,8 +173,9 @@ int do_poke_blanked_console;
 int console_blanked;
 
 static int vesa_blank_mode; /* 0:none 1:suspendV 2:suspendH 3:powerdown */
-static int blankinterval = 10*60*HZ;
 static int vesa_off_interval;
+static int blankinterval = 10*60;
+core_param(consoleblank, blankinterval, int, 0444);
 
 static DECLARE_WORK(console_work, console_callback);
 
@@ -1487,7 +1488,7 @@ static void setterm_command(struct vc_da
 			update_attr(vc);
 			break;
 		case 9:	/* set blanking interval */
-			blankinterval = ((vc->vc_par[1] < 60) ? vc->vc_par[1] : 60) * 60 * HZ;
+			blankinterval = ((vc->vc_par[1] < 60) ? vc->vc_par[1] : 60) * 60;
 			poke_blanked_console();
 			break;
 		case 10: /* set bell frequency in Hz */
@@ -2873,7 +2874,7 @@ static int __init con_init(void)
 
 	if (blankinterval) {
 		blank_state = blank_normal_wait;
-		mod_timer(&console_timer, jiffies + blankinterval);
+		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 	}
 
 	/*
@@ -3688,7 +3689,7 @@ void do_unblank_screen(int leaving_gfx)
 		return; /* but leave console_blanked != 0 */
 
 	if (blankinterval) {
-		mod_timer(&console_timer, jiffies + blankinterval);
+		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 		blank_state = blank_normal_wait;
 	}
 
@@ -3722,7 +3723,7 @@ void unblank_screen(void)
 static void blank_screen_t(unsigned long dummy)
 {
 	if (unlikely(!keventd_up())) {
-		mod_timer(&console_timer, jiffies + blankinterval);
+		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 		return;
 	}
 	blank_timer_expired = 1;
@@ -3752,7 +3753,7 @@ void poke_blanked_console(void)
 	if (console_blanked)
 		unblank_screen();
 	else if (blankinterval) {
-		mod_timer(&console_timer, jiffies + blankinterval);
+		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 		blank_state = blank_normal_wait;
 	}
 }
_

Patches currently in -mm which might be from daniel@caiaq.de are

linux-next.patch
console-make-blank-timeout-value-a-boot-option.patch
w1-gpio-add-external-pull-up-enable-callback.patch

