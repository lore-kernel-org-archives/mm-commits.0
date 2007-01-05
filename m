From: akpm@osdl.org
Subject: + uml-mostly-const-a-structure.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:13:23 -0800
Message-ID: <200701052013.l05KDNER031078@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57154 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbXAEUN0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:13:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: mostly const a structure
has been added to the -mm tree.  Its filename is
     uml-mostly-const-a-structure.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: mostly const a structure
From: Jeff Dike <jdike@addtoit.com>

The chan_opts structure is mostly const, and needs no locking.  Comment the
lack of locking on the one field that can change.

Make all the other fields const.  It turned out that console_open_chan didn't
use its chan_opts argument, so that is deleted from the function and its
callers.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/chan_kern.c     |    5 ++---
 arch/um/drivers/ssl.c           |    3 ++-
 arch/um/drivers/stdio_console.c |    3 ++-
 arch/um/include/chan_kern.h     |    3 +--
 arch/um/include/chan_user.h     |    8 ++++----
 5 files changed, 11 insertions(+), 11 deletions(-)

diff -puN arch/um/drivers/chan_kern.c~uml-mostly-const-a-structure arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~uml-mostly-const-a-structure
+++ a/arch/um/drivers/chan_kern.c
@@ -354,8 +354,7 @@ int console_write_chan(struct list_head 
 	return ret;
 }
 
-int console_open_chan(struct line *line, struct console *co,
-		      const struct chan_opts *opts)
+int console_open_chan(struct line *line, struct console *co)
 {
 	int err;
 
@@ -363,7 +362,7 @@ int console_open_chan(struct line *line,
 	if(err)
 		return err;
 
-	printk("Console initialized on /dev/%s%d\n",co->name,co->index);
+	printk("Console initialized on /dev/%s%d\n", co->name, co->index);
 	return 0;
 }
 
diff -puN arch/um/drivers/ssl.c~uml-mostly-const-a-structure arch/um/drivers/ssl.c
--- a/arch/um/drivers/ssl.c~uml-mostly-const-a-structure
+++ a/arch/um/drivers/ssl.c
@@ -38,6 +38,7 @@ static void ssl_announce(char *dev_name,
 	       dev_name);
 }
 
+/* Almost const, except that xterm_title may be changed in an initcall */
 static struct chan_opts opts = {
 	.announce 	= ssl_announce,
 	.xterm_title	= "Serial Line #%d",
@@ -171,7 +172,7 @@ static int ssl_console_setup(struct cons
 {
 	struct line *line = &serial_lines[co->index];
 
-	return console_open_chan(line, co, &opts);
+	return console_open_chan(line, co);
 }
 
 static struct console ssl_cons = {
diff -puN arch/um/drivers/stdio_console.c~uml-mostly-const-a-structure arch/um/drivers/stdio_console.c
--- a/arch/um/drivers/stdio_console.c~uml-mostly-const-a-structure
+++ a/arch/um/drivers/stdio_console.c
@@ -42,6 +42,7 @@ void stdio_announce(char *dev_name, int 
 	       dev_name);
 }
 
+/* Almost const, except that xterm_title may be changed in an initcall */
 static struct chan_opts opts = {
 	.announce 	= stdio_announce,
 	.xterm_title	= "Virtual Console #%d",
@@ -144,7 +145,7 @@ static int uml_console_setup(struct cons
 {
 	struct line *line = &vts[co->index];
 
-	return console_open_chan(line, co, &opts);
+	return console_open_chan(line, co);
 }
 
 static struct console stdiocons = {
diff -puN arch/um/include/chan_kern.h~uml-mostly-const-a-structure arch/um/include/chan_kern.h
--- a/arch/um/include/chan_kern.h~uml-mostly-const-a-structure
+++ a/arch/um/include/chan_kern.h
@@ -36,8 +36,7 @@ extern int write_chan(struct list_head *
 			     int write_irq);
 extern int console_write_chan(struct list_head *chans, const char *buf, 
 			      int len);
-extern int console_open_chan(struct line *line, struct console *co,
-			     const struct chan_opts *opts);
+extern int console_open_chan(struct line *line, struct console *co);
 extern void deactivate_chan(struct list_head *chans, int irq);
 extern void reactivate_chan(struct list_head *chans, int irq);
 extern void chan_enable_winch(struct list_head *chans, struct tty_struct *tty);
diff -puN arch/um/include/chan_user.h~uml-mostly-const-a-structure arch/um/include/chan_user.h
--- a/arch/um/include/chan_user.h~uml-mostly-const-a-structure
+++ a/arch/um/include/chan_user.h
@@ -9,11 +9,11 @@
 #include "init.h"
 
 struct chan_opts {
-	void (*announce)(char *dev_name, int dev);
+	void (*const announce)(char *dev_name, int dev);
 	char *xterm_title;
-	int raw;
-	unsigned long tramp_stack;
-	int in_kernel;
+	const int raw;
+	const unsigned long tramp_stack;
+	const int in_kernel;
 };
 
 enum chan_init_pri { INIT_STATIC, INIT_ALL, INIT_ONE };
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
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
