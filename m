From: akpm@osdl.org
Subject: + uml-initialize-a-list-head.patch added to -mm tree
Date: Tue, 09 Jan 2007 12:57:41 -0800
Message-ID: <200701092057.l09KvfW6015066@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43433 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932432AbXAIU5w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:57:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: initialize a list head
has been added to the -mm tree.  Its filename is
     uml-initialize-a-list-head.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: initialize a list head
From: Jeff Dike <jdike@addtoit.com>

We need to initialize lists properly.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/stdio_console.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/um/drivers/stdio_console.c~uml-initialize-a-list-head arch/um/drivers/stdio_console.c
--- a/arch/um/drivers/stdio_console.c~uml-initialize-a-list-head
+++ a/arch/um/drivers/stdio_console.c
@@ -69,6 +69,7 @@ static struct line_driver driver = {
 	.write_irq 		= CONSOLE_WRITE_IRQ,
 	.write_irq_name 	= "console-write",
 	.mc  = {
+		.list		= LIST_HEAD_INIT(driver.mc.list),
 		.name  		= "con",
 		.config 	= con_config,
 		.get_config 	= con_get_config,
_

Patches currently in -mm which might be from jdike@addtoit.com are

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
proc-remove-useless-and-buggy-nlink-settings.patch
