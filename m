From: akpm@linux-foundation.org
Subject: [merged] proc-move-proc_consolec-to-fs-proc-consolesc.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:43 -0800
Message-ID: <201101132011.p0DKBOPZ030171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933754Ab1AMUUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:20:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: move proc_console.c to fs/proc/consoles.c
has been removed from the -mm tree.  Its filename was
     proc-move-proc_consolec-to-fs-proc-consolesc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: move proc_console.c to fs/proc/consoles.c
From: Alexey Dobriyan <adobriyan@gmail.com>

Filename is supposed to match procfile name for random junk.

Add __init while I'm at it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/Makefile       |    2 
 fs/proc/consoles.c     |  114 +++++++++++++++++++++++++++++++++++++++
 fs/proc/proc_console.c |  114 ---------------------------------------
 3 files changed, 115 insertions(+), 115 deletions(-)

diff -puN fs/proc/Makefile~proc-move-proc_consolec-to-fs-proc-consolesc fs/proc/Makefile
--- a/fs/proc/Makefile~proc-move-proc_consolec-to-fs-proc-consolesc
+++ a/fs/proc/Makefile
@@ -10,12 +10,12 @@ proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 proc-y       += inode.o root.o base.o generic.o array.o \
 		proc_tty.o
 proc-y	+= cmdline.o
+proc-y	+= consoles.o
 proc-y	+= cpuinfo.o
 proc-y	+= devices.o
 proc-y	+= interrupts.o
 proc-y	+= loadavg.o
 proc-y	+= meminfo.o
-proc-y	+= proc_console.o
 proc-y	+= stat.o
 proc-y	+= uptime.o
 proc-y	+= version.o
diff -puN /dev/null fs/proc/consoles.c
--- /dev/null
+++ a/fs/proc/consoles.c
@@ -0,0 +1,114 @@
+/*
+ * Copyright (c) 2010 Werner Fink, Jiri Slaby
+ *
+ * Licensed under GPLv2
+ */
+
+#include <linux/console.h>
+#include <linux/kernel.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/tty_driver.h>
+
+/*
+ * This is handler for /proc/consoles
+ */
+static int show_console_dev(struct seq_file *m, void *v)
+{
+	static const struct {
+		short flag;
+		char name;
+	} con_flags[] = {
+		{ CON_ENABLED,		'E' },
+		{ CON_CONSDEV,		'C' },
+		{ CON_BOOT,		'B' },
+		{ CON_PRINTBUFFER,	'p' },
+		{ CON_BRL,		'b' },
+		{ CON_ANYTIME,		'a' },
+	};
+	char flags[ARRAY_SIZE(con_flags) + 1];
+	struct console *con = v;
+	unsigned int a;
+	int len;
+	dev_t dev = 0;
+
+	if (con->device) {
+		const struct tty_driver *driver;
+		int index;
+		driver = con->device(con, &index);
+		if (driver) {
+			dev = MKDEV(driver->major, driver->minor_start);
+			dev += index;
+		}
+	}
+
+	for (a = 0; a < ARRAY_SIZE(con_flags); a++)
+		flags[a] = (con->flags & con_flags[a].flag) ?
+			con_flags[a].name : ' ';
+	flags[a] = 0;
+
+	seq_printf(m, "%s%d%n", con->name, con->index, &len);
+	len = 21 - len;
+	if (len < 1)
+		len = 1;
+	seq_printf(m, "%*c%c%c%c (%s)", len, ' ', con->read ? 'R' : '-',
+			con->write ? 'W' : '-', con->unblank ? 'U' : '-',
+			flags);
+	if (dev)
+		seq_printf(m, " %4d:%d", MAJOR(dev), MINOR(dev));
+
+	seq_printf(m, "\n");
+
+	return 0;
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	struct console *con;
+	loff_t off = 0;
+
+	acquire_console_sem();
+	for_each_console(con)
+		if (off++ == *pos)
+			break;
+
+	return con;
+}
+
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct console *con = v;
+	++*pos;
+	return con->next;
+}
+
+static void c_stop(struct seq_file *m, void *v)
+{
+	release_console_sem();
+}
+
+static const struct seq_operations consoles_op = {
+	.start	= c_start,
+	.next	= c_next,
+	.stop	= c_stop,
+	.show	= show_console_dev
+};
+
+static int consoles_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &consoles_op);
+}
+
+static const struct file_operations proc_consoles_operations = {
+	.open		= consoles_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int __init proc_consoles_init(void)
+{
+	proc_create("consoles", 0, NULL, &proc_consoles_operations);
+	return 0;
+}
+module_init(proc_consoles_init);
diff -puN fs/proc/proc_console.c~proc-move-proc_consolec-to-fs-proc-consolesc /dev/null
--- a/fs/proc/proc_console.c
+++ /dev/null
@@ -1,114 +0,0 @@
-/*
- * Copyright (c) 2010 Werner Fink, Jiri Slaby
- *
- * Licensed under GPLv2
- */
-
-#include <linux/console.h>
-#include <linux/kernel.h>
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-#include <linux/tty_driver.h>
-
-/*
- * This is handler for /proc/consoles
- */
-static int show_console_dev(struct seq_file *m, void *v)
-{
-	static const struct {
-		short flag;
-		char name;
-	} con_flags[] = {
-		{ CON_ENABLED,		'E' },
-		{ CON_CONSDEV,		'C' },
-		{ CON_BOOT,		'B' },
-		{ CON_PRINTBUFFER,	'p' },
-		{ CON_BRL,		'b' },
-		{ CON_ANYTIME,		'a' },
-	};
-	char flags[ARRAY_SIZE(con_flags) + 1];
-	struct console *con = v;
-	unsigned int a;
-	int len;
-	dev_t dev = 0;
-
-	if (con->device) {
-		const struct tty_driver *driver;
-		int index;
-		driver = con->device(con, &index);
-		if (driver) {
-			dev = MKDEV(driver->major, driver->minor_start);
-			dev += index;
-		}
-	}
-
-	for (a = 0; a < ARRAY_SIZE(con_flags); a++)
-		flags[a] = (con->flags & con_flags[a].flag) ?
-			con_flags[a].name : ' ';
-	flags[a] = 0;
-
-	seq_printf(m, "%s%d%n", con->name, con->index, &len);
-	len = 21 - len;
-	if (len < 1)
-		len = 1;
-	seq_printf(m, "%*c%c%c%c (%s)", len, ' ', con->read ? 'R' : '-',
-			con->write ? 'W' : '-', con->unblank ? 'U' : '-',
-			flags);
-	if (dev)
-		seq_printf(m, " %4d:%d", MAJOR(dev), MINOR(dev));
-
-	seq_printf(m, "\n");
-
-	return 0;
-}
-
-static void *c_start(struct seq_file *m, loff_t *pos)
-{
-	struct console *con;
-	loff_t off = 0;
-
-	acquire_console_sem();
-	for_each_console(con)
-		if (off++ == *pos)
-			break;
-
-	return con;
-}
-
-static void *c_next(struct seq_file *m, void *v, loff_t *pos)
-{
-	struct console *con = v;
-	++*pos;
-	return con->next;
-}
-
-static void c_stop(struct seq_file *m, void *v)
-{
-	release_console_sem();
-}
-
-static const struct seq_operations consoles_op = {
-	.start	= c_start,
-	.next	= c_next,
-	.stop	= c_stop,
-	.show	= show_console_dev
-};
-
-static int consoles_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &consoles_op);
-}
-
-static const struct file_operations proc_consoles_operations = {
-	.open		= consoles_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
