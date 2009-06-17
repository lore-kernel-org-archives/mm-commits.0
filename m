From: akpm@linux-foundation.org
Subject: [merged] console-make-blank-timeout-value-a-boot-option.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:51 -0700
Message-ID: <200906171837.n5HIbpHZ003941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753697AbZFQSpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:45:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@caiaq.de, mm-commits@vger.kernel.org


The patch titled
     console: make blank timeout value a boot option
has been removed from the -mm tree.  Its filename was
     console-make-blank-timeout-value-a-boot-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: console: make blank timeout value a boot option
From: Daniel Mack <daniel@caiaq.de>

The console blank timer is currently hardcoded to 10*60 seconds which
might be annoying on systems with no input devices attached to wake up the
console again.  Especially during development, disabling the screen saver
can be handy - for example when debugging the root fs mount mechanism or
other scenarios where no userspace program could be started to do that at
runtime from userspace.

This patch defines a core_param for the variable in charge which allows
users to entirely disable the blank feature at boot time by setting it 0. 
The value can still be overwritten at runtime using the standard ioctl
call - this just allows to conditionally change the default.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 ++++
 drivers/char/vt.c                   |   13 +++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff -puN Documentation/kernel-parameters.txt~console-make-blank-timeout-value-a-boot-option Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~console-make-blank-timeout-value-a-boot-option
+++ a/Documentation/kernel-parameters.txt
@@ -546,6 +546,10 @@ and is between 256 and 4096 characters. 
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
@@ -171,8 +171,9 @@ int do_poke_blanked_console;
 int console_blanked;
 
 static int vesa_blank_mode; /* 0:none 1:suspendV 2:suspendH 3:powerdown */
-static int blankinterval = 10*60*HZ;
 static int vesa_off_interval;
+static int blankinterval = 10*60;
+core_param(consoleblank, blankinterval, int, 0444);
 
 static DECLARE_WORK(console_work, console_callback);
 
@@ -1485,7 +1486,7 @@ static void setterm_command(struct vc_da
 			update_attr(vc);
 			break;
 		case 9:	/* set blanking interval */
-			blankinterval = ((vc->vc_par[1] < 60) ? vc->vc_par[1] : 60) * 60 * HZ;
+			blankinterval = ((vc->vc_par[1] < 60) ? vc->vc_par[1] : 60) * 60;
 			poke_blanked_console();
 			break;
 		case 10: /* set bell frequency in Hz */
@@ -2871,7 +2872,7 @@ static int __init con_init(void)
 
 	if (blankinterval) {
 		blank_state = blank_normal_wait;
-		mod_timer(&console_timer, jiffies + blankinterval);
+		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 	}
 
 	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
@@ -3677,7 +3678,7 @@ void do_unblank_screen(int leaving_gfx)
 		return; /* but leave console_blanked != 0 */
 
 	if (blankinterval) {
-		mod_timer(&console_timer, jiffies + blankinterval);
+		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 		blank_state = blank_normal_wait;
 	}
 
@@ -3711,7 +3712,7 @@ void unblank_screen(void)
 static void blank_screen_t(unsigned long dummy)
 {
 	if (unlikely(!keventd_up())) {
-		mod_timer(&console_timer, jiffies + blankinterval);
+		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 		return;
 	}
 	blank_timer_expired = 1;
@@ -3741,7 +3742,7 @@ void poke_blanked_console(void)
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

origin.patch
linux-next.patch
w1-gpio-add-external-pull-up-enable-callback.patch

