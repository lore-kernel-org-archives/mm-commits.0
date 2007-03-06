From: akpm@linux-foundation.org
Subject: + uml-mark-both-consoles-as-con_anytime.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:26:33 -0800
Message-ID: <200703060426.l264QXgG011751@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50201 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933942AbXCFE0g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:26:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, jdike@addtoit.com


The patch titled
     um: mark both consoles as CON_ANYTIME
has been added to the -mm tree.  Its filename is
     uml-mark-both-consoles-as-con_anytime.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: um: mark both consoles as CON_ANYTIME
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Since both UML consoles do not use percpu variables, they may be called when
the cpu is still offline, and they may be marked CON_ANYTIME (this is
documented in kernel/printk.c, grep for CON_ANYTIME to find mentions of this).

Works well in testing done with lock debug enabled, should be safe but is not
needed for next release.

This would probably help also stderr_console.c, but this is yet to test.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ssl.c           |    2 +-
 arch/um/drivers/stdio_console.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/ssl.c~uml-mark-both-consoles-as-con_anytime arch/um/drivers/ssl.c
--- a/arch/um/drivers/ssl.c~uml-mark-both-consoles-as-con_anytime
+++ a/arch/um/drivers/ssl.c
@@ -179,7 +179,7 @@ static struct console ssl_cons = {
 	.write		= ssl_console_write,
 	.device		= ssl_console_device,
 	.setup		= ssl_console_setup,
-	.flags		= CON_PRINTBUFFER,
+	.flags		= CON_PRINTBUFFER|CON_ANYTIME,
 	.index		= -1,
 };
 
diff -puN arch/um/drivers/stdio_console.c~uml-mark-both-consoles-as-con_anytime arch/um/drivers/stdio_console.c
--- a/arch/um/drivers/stdio_console.c~uml-mark-both-consoles-as-con_anytime
+++ a/arch/um/drivers/stdio_console.c
@@ -153,7 +153,7 @@ static struct console stdiocons = {
 	.write		= uml_console_write,
 	.device		= uml_console_device,
 	.setup		= uml_console_setup,
-	.flags		= CON_PRINTBUFFER,
+	.flags		= CON_PRINTBUFFER|CON_ANYTIME,
 	.index		= -1,
 };
 
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
x86_64-fix-2618-regression-ptrace_oldsetoptions-should-be-accepted.patch
uml-hostfs-fix-double-free.patch
uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
uml-fix-a-memory-leak-in-the-multicast-driver.patch
uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
uml-mark-both-consoles-as-con_anytime.patch
uml-fix-confusion-irq-early-reenabling.patch
uml-activate_fd-return-enomem-only-when-appropriate.patch
uml-fix-errno-usage.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch
git-gccbug.patch
