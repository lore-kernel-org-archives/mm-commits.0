From: akpm@osdl.org
Subject: + uml-console-locking-commentary-and-code-cleanup.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:13:27 -0800
Message-ID: <200701052013.l05KDRbt031084@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57163 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbXAEUNa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:13:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: console locking commentary and code cleanup
has been added to the -mm tree.  Its filename is
     uml-console-locking-commentary-and-code-cleanup.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: console locking commentary and code cleanup
From: Jeff Dike <jdike@addtoit.com>

Remove the last vestiges of devfs from console registration.  Change the name
of the function, plus remove a couple of unused fields from the line_driver
structure.

struct lines is no longer needed, all traces of it are gone.

The only way that I can see to mark a structure as being almost-const is to
individually const the fields.  This is the case for the line_driver
structure, which has only one modifiable field - a list_head in a
sub-structure.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/line.c          |    7 ++---
 arch/um/drivers/ssl.c           |   16 +++++--------
 arch/um/drivers/stdio_console.c |   17 +++++---------
 arch/um/include/line.h          |   36 +++++++++++-------------------
 4 files changed, 31 insertions(+), 45 deletions(-)

diff -puN arch/um/drivers/line.c~uml-console-locking-commentary-and-code-cleanup arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-console-locking-commentary-and-code-cleanup
+++ a/arch/um/drivers/line.c
@@ -707,10 +707,9 @@ int line_remove(struct line *lines, unsi
 	return err;
 }
 
-struct tty_driver *line_register_devfs(struct lines *set,
-				       struct line_driver *line_driver,
-				       const struct tty_operations *ops,
-				       struct line *lines, int nlines)
+struct tty_driver *register_lines(struct line_driver *line_driver,
+				  const struct tty_operations *ops,
+				  struct line *lines, int nlines)
 {
 	int i;
 	struct tty_driver *driver = alloc_tty_driver(nlines);
diff -puN arch/um/drivers/ssl.c~uml-console-locking-commentary-and-code-cleanup arch/um/drivers/ssl.c
--- a/arch/um/drivers/ssl.c~uml-console-locking-commentary-and-code-cleanup
+++ a/arch/um/drivers/ssl.c
@@ -51,6 +51,8 @@ static int ssl_config(char *str, char **
 static int ssl_get_config(char *dev, char *str, int size, char **error_out);
 static int ssl_remove(int n, char **error_out);
 
+
+/* Const, except for .mc.list */
 static struct line_driver driver = {
 	.name 			= "UML serial line",
 	.device_name 		= "ttyS",
@@ -62,8 +64,6 @@ static struct line_driver driver = {
 	.read_irq_name 		= "ssl",
 	.write_irq 		= SSL_WRITE_IRQ,
 	.write_irq_name 	= "ssl-write",
-	.symlink_from 		= "serial",
-	.symlink_to 		= "tts",
 	.mc  = {
 		.list		= LIST_HEAD_INIT(driver.mc.list),
 		.name  		= "ssl",
@@ -74,14 +74,12 @@ static struct line_driver driver = {
 	},
 };
 
-/* The array is initialized by line_init, which is an initcall.  The 
- * individual elements are protected by individual semaphores.
+/* The array is initialized by line_init, at initcall time.  The
+ * elements are locked individually as needed.
  */
 static struct line serial_lines[NR_PORTS] =
 	{ [0 ... NR_PORTS - 1] = LINE_INIT(CONFIG_SSL_CHAN, &driver) };
 
-static struct lines lines = LINES_INIT(NR_PORTS);
-
 static int ssl_config(char *str, char **error_out)
 {
 	return line_config(serial_lines, ARRAY_SIZE(serial_lines), str, &opts,
@@ -175,6 +173,7 @@ static int ssl_console_setup(struct cons
 	return console_open_chan(line, co);
 }
 
+/* No locking for register_console call - relies on single-threaded initcalls */
 static struct console ssl_cons = {
 	.name		= "ttyS",
 	.write		= ssl_console_write,
@@ -190,9 +189,8 @@ static int ssl_init(void)
 
 	printk(KERN_INFO "Initializing software serial port version %d\n",
 	       ssl_version);
-	ssl_driver = line_register_devfs(&lines, &driver, &ssl_ops,
-					 serial_lines,
-					 ARRAY_SIZE(serial_lines));
+	ssl_driver = register_lines(&driver, &ssl_ops, serial_lines,
+				    ARRAY_SIZE(serial_lines));
 
 	lines_init(serial_lines, ARRAY_SIZE(serial_lines), &opts);
 
diff -puN arch/um/drivers/stdio_console.c~uml-console-locking-commentary-and-code-cleanup arch/um/drivers/stdio_console.c
--- a/arch/um/drivers/stdio_console.c~uml-console-locking-commentary-and-code-cleanup
+++ a/arch/um/drivers/stdio_console.c
@@ -55,6 +55,8 @@ static int con_config(char *str, char **
 static int con_get_config(char *dev, char *str, int size, char **error_out);
 static int con_remove(int n, char **con_remove);
 
+
+/* Const, except for .mc.list */
 static struct line_driver driver = {
 	.name 			= "UML console",
 	.device_name 		= "tty",
@@ -66,8 +68,6 @@ static struct line_driver driver = {
 	.read_irq_name 		= "console",
 	.write_irq 		= CONSOLE_WRITE_IRQ,
 	.write_irq_name 	= "console-write",
-	.symlink_from 		= "ttys",
-	.symlink_to 		= "vc",
 	.mc  = {
 		.name  		= "con",
 		.config 	= con_config,
@@ -77,10 +77,8 @@ static struct line_driver driver = {
 	},
 };
 
-static struct lines console_lines = LINES_INIT(MAX_TTYS);
-
-/* The array is initialized by line_init, which is an initcall.  The 
- * individual elements are protected by individual semaphores.
+/* The array is initialized by line_init, at initcall time.  The
+ * elements are locked individually as needed.
  */
 static struct line vts[MAX_TTYS] = { LINE_INIT(CONFIG_CON_ZERO_CHAN, &driver),
 				     [ 1 ... MAX_TTYS - 1 ] =
@@ -148,6 +146,7 @@ static int uml_console_setup(struct cons
 	return console_open_chan(line, co);
 }
 
+/* No locking for register_console call - relies on single-threaded initcalls */
 static struct console stdiocons = {
 	.name		= "tty",
 	.write		= uml_console_write,
@@ -155,16 +154,14 @@ static struct console stdiocons = {
 	.setup		= uml_console_setup,
 	.flags		= CON_PRINTBUFFER,
 	.index		= -1,
-	.data		= &vts,
 };
 
 int stdio_init(void)
 {
 	char *new_title;
 
-	console_driver = line_register_devfs(&console_lines, &driver,
-					     &console_ops, vts,
-					     ARRAY_SIZE(vts));
+	console_driver = register_lines(&driver, &console_ops, vts,
+					ARRAY_SIZE(vts));
 	if (console_driver == NULL)
 		return -1;
 	printk(KERN_INFO "Initialized stdio console driver\n");
diff -puN arch/um/include/line.h~uml-console-locking-commentary-and-code-cleanup arch/um/include/line.h
--- a/arch/um/include/line.h~uml-console-locking-commentary-and-code-cleanup
+++ a/arch/um/include/line.h
@@ -15,19 +15,18 @@
 #include "chan_user.h"
 #include "mconsole_kern.h"
 
+/* There's only one modifiable field in this - .mc.list */
 struct line_driver {
-	char *name;
-	char *device_name;
-	short major;
-	short minor_start;
-	short type;
-	short subtype;
-	int read_irq;
-	char *read_irq_name;
-	int write_irq;
-	char *write_irq_name;
-	char *symlink_from;
-	char *symlink_to;
+	const char *name;
+	const char *device_name;
+	const short major;
+	const short minor_start;
+	const short type;
+	const short subtype;
+	const int read_irq;
+	const char *read_irq_name;
+	const int write_irq;
+	const char *write_irq_name;
 	struct mc_device mc;
 };
 
@@ -67,12 +66,6 @@ struct line {
 	  .lock =	SPIN_LOCK_UNLOCKED, \
 	  .driver =	d }
 
-struct lines {
-	int num;
-};
-
-#define LINES_INIT(n) {  .num =	n }
-
 extern void line_close(struct tty_struct *tty, struct file * filp);
 extern int line_open(struct line *lines, struct tty_struct *tty);
 extern int line_setup(struct line *lines, unsigned int sizeof_lines,
@@ -94,10 +87,9 @@ extern char *add_xterm_umid(char *base);
 extern int line_setup_irq(int fd, int input, int output, struct line *line,
 			  void *data);
 extern void line_close_chan(struct line *line);
-extern struct tty_driver * line_register_devfs(struct lines *set,
-					       struct line_driver *line_driver,
-					       const struct tty_operations *driver,
-					       struct line *lines, int nlines);
+extern struct tty_driver *register_lines(struct line_driver *line_driver,
+					 const struct tty_operations *driver,
+					 struct line *lines, int nlines);
 extern void lines_init(struct line *lines, int nlines, struct chan_opts *opts);
 extern void close_lines(struct line *lines, int nlines);
 
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
