From: akpm@linux-foundation.org
Subject: - wistron_btns-add-support-for-x86_64-systems.patch removed from -mm tree
Date: Sun, 23 Dec 2007 12:15:35 -0800
Message-ID: <200712232015.lBNKFx8O004585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161AbXLWUQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 23 Dec 2007 15:16:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rherilier@yahoo.fr, ak@suse.de, dtor@mail.ru, jikos@jikos.cz, mitr@volny.cz, mm-commits@vger.kernel.org


The patch titled
     wistron_btns: add support for X86_64 systems
has been removed from the -mm tree.  Its filename was
     wistron_btns-add-support-for-x86_64-systems.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wistron_btns: add support for X86_64 systems
From: Remi Herilier <rherilier@yahoo.fr>

Wistron button support for X86_64 systems.

Signed-off-by: Remi Herilier <rherilier@yahoo.fr>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jikos@jikos.cz>
Cc: Miloslav Trmac <mitr@volny.cz>
Cc: Andi Kleen <ak@suse.de>
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
wistron_btns-add-support-for-fujitsu-siemens-amilo-pro-edition-v3505.patch
