From: akpm@linux-foundation.org
Subject: - uml-initialize-a-list-head.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:01 -0800
Message-ID: <200702112249.l1BMn1Fe015687@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59803 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932689AbXBKWtD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: initialize a list head
has been removed from the -mm tree.  Its filename was
     uml-initialize-a-list-head.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: initialize a list head
From: Jeff Dike <jdike@addtoit.com>

We need to initialize lists properly.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/stdio_console.c |    1 +
 1 file changed, 1 insertion(+)

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

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
