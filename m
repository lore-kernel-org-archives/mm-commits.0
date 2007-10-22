From: akpm@linux-foundation.org
Subject: + i386-fix-reboot-with-no-keyboard-attached.patch added to -mm tree
Date: Mon, 22 Oct 2007 14:45:46 -0700
Message-ID: <200710222145.l9MLjkha016616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34277 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbXJVVqt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 17:46:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trux@truxton.com, dtor@mail.ru, hiroto.shibuya@gmail.com, hpa@zytor.com, lee-in-berlin@web.de, mingo@elte.hu, protasnb@gmail.com, tglx@linutronix.de


The patch titled
     i386: fix reboot with no keyboard attached
has been added to the -mm tree.  Its filename is
     i386-fix-reboot-with-no-keyboard-attached.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Cc: Lee Garrett <lee-in-berlin@web.de>
Cc: "Hiroto Shibuya" <hiroto.shibuya@gmail.com>
Cc: Natalie Protasevich <protasnb@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
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

i386-fix-reboot-with-no-keyboard-attached.patch
