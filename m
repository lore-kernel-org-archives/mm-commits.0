From: akpm@linux-foundation.org
Subject: + print-utsname-on-oops-on-all-architectures-fix.patch added to -mm tree
Date: Fri, 13 Jul 2007 01:23:43 -0700
Message-ID: <200707130823.l6D8NhE7008162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43863 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751774AbXGMIYQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 04:24:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jwise@google.com, ak@suse.de, benh@kernel.crashing.org, ink@jurassic.park.msu.ru, linux-arch@vger.kernel.org, paulus@samba.org, rmk@arm.linux.org.uk, rth@twiddle.net


The patch titled
     print-utsname-on-oops-on-all-architectures fix
has been added to the -mm tree.  Its filename is
     print-utsname-on-oops-on-all-architectures-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: print-utsname-on-oops-on-all-architectures fix
From: Joshua Wise <jwise@google.com>

- Removed the delete of the printk on ARM, as per RMK's request.

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/process.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN arch/arm/kernel/process.c~print-utsname-on-oops-on-all-architectures-fix arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~print-utsname-on-oops-on-all-architectures-fix
+++ a/arch/arm/kernel/process.c
@@ -28,6 +28,7 @@
 #include <linux/elfcore.h>
 #include <linux/pm.h>
 #include <linux/tick.h>
+#include <linux/utsname.h>
 
 #include <asm/leds.h>
 #include <asm/processor.h>
@@ -206,8 +207,10 @@ void __show_regs(struct pt_regs *regs)
 	unsigned long flags;
 	char buf[64];
 
-	printk("CPU: %d    %s\n",
-		smp_processor_id(), print_tainted());
+	printk("CPU: %d    %s  (%s %.*s)\n",
+		smp_processor_id(), print_tainted(), init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
 	print_symbol("PC is at %s\n", instruction_pointer(regs));
 	print_symbol("LR is at %s\n", regs->ARM_lr);
 	printk("pc : [<%08lx>]    lr : [<%08lx>]    psr: %08lx\n"
_

Patches currently in -mm which might be from jwise@google.com are

print-utsname-on-oops-on-all-architectures.patch
print-utsname-on-oops-on-all-architectures-fix.patch
