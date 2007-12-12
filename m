From: akpm@linux-foundation.org
Subject: + wistron_btns-add-support-for-x86_64-systems.patch added to -mm tree
Date: Wed, 12 Dec 2007 00:27:49 -0800
Message-ID: <200712120827.lBC8RngY000990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755351AbXLLI2Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 03:28:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rherilier@yahoo.fr, dtor@mail.ru, jikos@jikos.cz, mitr@volny.cz


The patch titled
     wistron_btns: add support for X86_64 systems
has been added to the -mm tree.  Its filename is
     wistron_btns-add-support-for-x86_64-systems.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wistron_btns: add support for X86_64 systems
From: Remi Herilier <rherilier@yahoo.fr>

Wistron button support for X86_64 systems.

Signed-off-by: Remi Herilier <rherilier@yahoo.fr>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jikos@jikos.cz>
Cc: Miloslav Trmac <mitr@volny.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/Kconfig        |    2 +-
 drivers/input/misc/wistron_btns.c |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/input/misc/Kconfig~wistron_btns-add-support-for-x86_64-systems drivers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~wistron_btns-add-support-for-x86_64-systems
+++ a/drivers/input/misc/Kconfig
@@ -78,7 +78,7 @@ config INPUT_COBALT_BTNS
 
 config INPUT_WISTRON_BTNS
 	tristate "x86 Wistron laptop button interface"
-	depends on X86 && !X86_64
+	depends on X86
 	select INPUT_POLLDEV
 	select NEW_LEDS
 	select LEDS_CLASS
diff -puN drivers/input/misc/wistron_btns.c~wistron_btns-add-support-for-x86_64-systems drivers/input/misc/wistron_btns.c
--- a/drivers/input/misc/wistron_btns.c~wistron_btns-add-support-for-x86_64-systems
+++ a/drivers/input/misc/wistron_btns.c
@@ -74,10 +74,18 @@ static void call_bios(struct regs *regs)
 
 	preempt_disable();
 	local_irq_save(flags);
+#ifdef CONFIG_X86_64
+	asm volatile ("pushq %%rbp;"
+#else
 	asm volatile ("pushl %%ebp;"
+#endif
 		      "movl %7, %%ebp;"
 		      "call *%6;"
+#ifdef CONFIG_X86_64
+		      "popq %%rbp"
+#else
 		      "popl %%ebp"
+#endif
 		      : "=a" (regs->eax), "=b" (regs->ebx), "=c" (regs->ecx)
 		      : "0" (regs->eax), "1" (regs->ebx), "2" (regs->ecx),
 			"m" (bios_entry_point), "m" (bios_data_map_base)
_

Patches currently in -mm which might be from rherilier@yahoo.fr are

wistron_btns-add-support-for-x86_64-systems.patch
