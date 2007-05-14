From: akpm@linux-foundation.org
Subject: + i386-fix-machine-rebooting.patch added to -mm tree
Date: Mon, 14 May 2007 15:55:48 -0700
Message-ID: <200705142255.l4EMtmbT028487@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756367AbXENWz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 18:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trux@truxton.com, ak@suse.de, lee-in-berlin@web.de


The patch titled
     i386: fix machine rebooting
has been added to the -mm tree.  Its filename is
     i386-fix-machine-rebooting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: fix machine rebooting
From: Truxton Fulton <trux@truxton.com>

59f4e7d572980a521b7bdba74ab71b21f5995538 fixed machine rebooting on Truxton's
machine (when no keyboard was present).  But it broke it on Lee's machine.

The patch reinstates the old (pre-59f4e7d572980a521b7bdba74ab71b21f5995538)
code and if that doesn't work out, try the new,
post-59f4e7d572980a521b7bdba74ab71b21f5995538 code instead.

Cc: Lee Garrett <lee-in-berlin@web.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/mach-default/mach_reboot.h |   23 +++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletion(-)

diff -puN include/asm-i386/mach-default/mach_reboot.h~i386-fix-machine-rebooting include/asm-i386/mach-default/mach_reboot.h
--- a/include/asm-i386/mach-default/mach_reboot.h~i386-fix-machine-rebooting
+++ a/include/asm-i386/mach-default/mach_reboot.h
@@ -19,14 +19,35 @@ static inline void kb_wait(void)
 static inline void mach_reboot(void)
 {
 	int i;
+
+	/* old method, works on most machines */
+	for (i = 0; i < 10; i++) {
+		kb_wait();
+		udelay(50);
+		outb(0xfe, 0x64);	/* pulse reset low */
+		udelay(50);
+	}
+
+	/* New method: sets the "System flag" which, when set, indicates
+	 * successful completion of the keyboard controller self-test (Basic
+	 * Assurance Test, BAT).  This is needed for some machines with no
+	 * keyboard plugged in.  This read-modify-write sequence sets only the
+	 * system flag
+	 */
 	for (i = 0; i < 10; i++) {
+		outb(0x20, 0x64);	/* read Controller Command Byte */
+		udelay(50);
+		kb_wait();
+		udelay(50);
+		cmd = inb(0x60);
+		udelay(50);
 		kb_wait();
 		udelay(50);
 		outb(0x60, 0x64);	/* write Controller Command Byte */
 		udelay(50);
 		kb_wait();
 		udelay(50);
-		outb(0x14, 0x60);	/* set "System flag" */
+		outb(cmd | 0x04, 0x60);	/* set "System flag" */
 		udelay(50);
 		kb_wait();
 		udelay(50);
_

Patches currently in -mm which might be from trux@truxton.com are

i386-fix-machine-rebooting.patch
