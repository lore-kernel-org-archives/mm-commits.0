From: akpm@linux-foundation.org
Subject: + x86-init-annotations-in-early_printk-setup.patch added to -mm tree
Date: Tue, 02 Sep 2008 15:01:29 -0700
Message-ID: <200809022201.m82M1Thv014992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752792AbYIBWCQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 18:02:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: init annotations in early_printk() setup
has been added to the -mm tree.  Its filename is
     x86-init-annotations-in-early_printk-setup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: init annotations in early_printk() setup
From: "Jan Beulich" <jbeulich@novell.com>

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/early_printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/early_printk.c~x86-init-annotations-in-early_printk-setup arch/x86/kernel/early_printk.c
--- a/arch/x86/kernel/early_printk.c~x86-init-annotations-in-early_printk-setup
+++ a/arch/x86/kernel/early_printk.c
@@ -120,7 +120,7 @@ static __init void early_serial_init(cha
 		if (!strncmp(s, "0x", 2)) {
 			early_serial_base = simple_strtoul(s, &e, 16);
 		} else {
-			static int bases[] = { 0x3f8, 0x2f8 };
+			static const int __initconst bases[] = { 0x3f8, 0x2f8 };
 
 			if (!strncmp(s, "ttyS", 4))
 				s += 4;
@@ -920,7 +920,7 @@ static struct console simnow_console = {
 
 /* Direct interface for emergencies */
 static struct console *early_console = &early_vga_console;
-static int early_console_initialized;
+static int __initdata early_console_initialized;
 
 asmlinkage void early_printk(const char *fmt, ...)
 {
_

Patches currently in -mm which might be from jbeulich@novell.com are

linux-next.patch
x86-init-annotations-in-early_printk-setup.patch
adjust-init-section-definitions.patch
kconfig-eliminate-def_bool-n-constructs.patch

