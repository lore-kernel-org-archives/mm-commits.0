From: akpm@linux-foundation.org
Subject: - i386-fix-reboot-with-no-keyboard-attached.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:16:08 -0800
Message-ID: <200711192316.lAJNG8EY001751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32996 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbXKSXRD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:17:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trux@truxton.com, aris@ruivo.org, dtor@mail.ru, hiroto.shibuya@gmail.com, hpa@zytor.com, lee-in-berlin@web.de, mingo@elte.hu, protasnb@gmail.com, stable@kernel.org, tglx@linutronix.de


The patch titled
     i386: fix reboot with no keyboard attached
has been removed from the -mm tree.  Its filename was
     i386-fix-reboot-with-no-keyboard-attached.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: fix reboot with no keyboard attached
From: Truxton Fulton <trux@truxton.com>

Attempt to fix http://bugzilla.kernel.org/show_bug.cgi?id=8378

Hiroto Shibuya wrote to tell me that he has a VIA EPIA-EK10000 which
suffers from the reboot problem when no keyboard is attached.  My first
patch works for him:

  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59f4e7d572980a521b7bdba74ab71b21f5995538

But the latest patch does not work for him :

  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8b93789808756bcc1e5c90c99f1b1ef52f839a51

We found that it was necessary to also set the "disable keyboard" flag in
the command byte, as the first patch was doing.  The second patch tries to
minimally modify the command byte, but it is not enough.

Please consider this simple one-line patch to help people with low end VIA
motherboards reboot when no keyboard is attached.  Hiroto Shibuya has
verified that this works for him (as I no longer have an afflicted
machine).


Additional discussion:

Note that original patch from Truxton DOES
disable keyboard and this has been in main tree since 2.6.14, thus it must have
quite a bit of air time already.

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.14.y.git;a=commit;h=59f4e7d572980a521b7bdba74ab71b21f5995538

Note that he only mention "System flag" in the description and comment, but
in the code, "disable keyboard" flag is set.

  outb(0x14, 0x60);       /* set "System flag" */

In 2.6.23, he made a change to read the current byte and then mask the flags,
but along this change,  he only set the "System flag" and dropped the setting
of "disable keyboard" flag.

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=commit;h=8b93789808756bcc1e5c90c99f1b1ef52f839a51

   outb(cmd | 0x04, 0x60); /* set "System flag" */

So my request is to restore the setting of disable keyboard flag which has been
there since 2.6.14 but disappeared in 2.6.23.

Cc: Lee Garrett <lee-in-berlin@web.de>
Cc: "Hiroto Shibuya" <hiroto.shibuya@gmail.com>
Cc: Natalie Protasevich <protasnb@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Aristeu Rozanski <aris@ruivo.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/mach-default/mach_reboot.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-x86/mach-default/mach_reboot.h~i386-fix-reboot-with-no-keyboard-attached include/asm-x86/mach-default/mach_reboot.h
--- a/include/asm-x86/mach-default/mach_reboot.h~i386-fix-reboot-with-no-keyboard-attached
+++ a/include/asm-x86/mach-default/mach_reboot.h
@@ -49,7 +49,7 @@ static inline void mach_reboot(void)
 		udelay(50);
 		kb_wait();
 		udelay(50);
-		outb(cmd | 0x04, 0x60);	/* set "System flag" */
+		outb(cmd | 0x14, 0x60); /* set "System flag" and "Keyboard Disabled" */
 		udelay(50);
 		kb_wait();
 		udelay(50);
_

Patches currently in -mm which might be from trux@truxton.com are

origin.patch
