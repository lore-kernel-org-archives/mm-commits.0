From: akpm@linux-foundation.org
Subject: - uml-handle-errors-on-opening-host-side-of-consoles.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:51:19 -0700
Message-ID: <200707162051.l6GKpJtA001390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49348 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757769AbXGPVd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:33:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: handle errors on opening host side of consoles
has been removed from the -mm tree.  Its filename was
     uml-handle-errors-on-opening-host-side-of-consoles.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: handle errors on opening host side of consoles
From: Jeff Dike <jdike@addtoit.com>

If the host side of a console can't be opened, this will now produce visible
error messages.

enable_chan now returns a status and this is passed up to con_open and
ssl_open, which will complain if anything went wrong.

The default host device for the serial line driver is now a pts device rather
than a pty device since lots of hosts have LEGACY_PTYS disabled.  This had
always been failing on such hosts, but silently.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/defconfig               |    2 +-
 arch/um/drivers/chan_kern.c     |   23 +++++++++++++++++++----
 arch/um/drivers/line.c          |    5 ++++-
 arch/um/drivers/ssl.c           |    8 +++++++-
 arch/um/drivers/stdio_console.c |    7 ++++++-
 arch/um/include/chan_kern.h     |    2 +-
 6 files changed, 38 insertions(+), 9 deletions(-)

diff -puN arch/um/defconfig~uml-handle-errors-on-opening-host-side-of-consoles arch/um/defconfig
--- a/arch/um/defconfig~uml-handle-errors-on-opening-host-side-of-consoles
+++ a/arch/um/defconfig
@@ -189,7 +189,7 @@ CONFIG_XTERM_CHAN=y
 # CONFIG_NOCONFIG_CHAN is not set
 CONFIG_CON_ZERO_CHAN="fd:0,fd:1"
 CONFIG_CON_CHAN="xterm"
-CONFIG_SSL_CHAN="pty"
+CONFIG_SSL_CHAN="pts"
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
diff -puN arch/um/drivers/chan_kern.c~uml-handle-errors-on-opening-host-side-of-consoles arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~uml-handle-errors-on-opening-host-side-of-consoles
+++ a/arch/um/drivers/chan_kern.c
@@ -203,22 +203,37 @@ void chan_enable_winch(struct list_head 
 	}
 }
 
-void enable_chan(struct line *line)
+int enable_chan(struct line *line)
 {
 	struct list_head *ele;
 	struct chan *chan;
+	int err;
 
 	list_for_each(ele, &line->chan_list){
 		chan = list_entry(ele, struct chan, list);
-		if(open_one_chan(chan))
+		err = open_one_chan(chan);
+		if (err) {
+			if (chan->primary)
+				goto out_close;
+
 			continue;
+		}
 
 		if(chan->enabled)
 			continue;
-		line_setup_irq(chan->fd, chan->input, chan->output, line,
-			       chan);
+		err = line_setup_irq(chan->fd, chan->input, chan->output, line,
+				     chan);
+		if (err)
+			goto out_close;
+
 		chan->enabled = 1;
 	}
+
+	return 0;
+
+ out_close:
+	close_chan(&line->chan_list, 0);
+	return err;
 }
 
 /* Items are added in IRQ context, when free_irq can't be called, and
diff -puN arch/um/drivers/line.c~uml-handle-errors-on-opening-host-side-of-consoles arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-handle-errors-on-opening-host-side-of-consoles
+++ a/arch/um/drivers/line.c
@@ -454,7 +454,10 @@ int line_open(struct line *lines, struct
 	tty->driver_data = line;
 	line->tty = tty;
 
-	enable_chan(line);
+	err = enable_chan(line);
+	if (err)
+		return err;
+
 	INIT_DELAYED_WORK(&line->task, line_timer_cb);
 
 	if(!line->sigio){
diff -puN arch/um/drivers/ssl.c~uml-handle-errors-on-opening-host-side-of-consoles arch/um/drivers/ssl.c
--- a/arch/um/drivers/ssl.c~uml-handle-errors-on-opening-host-side-of-consoles
+++ a/arch/um/drivers/ssl.c
@@ -97,7 +97,13 @@ static int ssl_remove(int n, char **erro
 
 static int ssl_open(struct tty_struct *tty, struct file *filp)
 {
-	return line_open(serial_lines, tty);
+	int err = line_open(serial_lines, tty);
+
+	if (err)
+		printk(KERN_ERR "Failed to open serial line %d, err = %d\n",
+		       tty->index, err);
+
+	return err;
 }
 
 #if 0
diff -puN arch/um/drivers/stdio_console.c~uml-handle-errors-on-opening-host-side-of-consoles arch/um/drivers/stdio_console.c
--- a/arch/um/drivers/stdio_console.c~uml-handle-errors-on-opening-host-side-of-consoles
+++ a/arch/um/drivers/stdio_console.c
@@ -99,7 +99,12 @@ static int con_remove(int n, char **erro
 
 static int con_open(struct tty_struct *tty, struct file *filp)
 {
-	return line_open(vts, tty);
+	int err = line_open(vts, tty);
+	if (err)
+		printk(KERN_ERR "Failed to open console %d, err = %d\n",
+		       tty->index, err);
+
+	return err;
 }
 
 /* Set in an initcall, checked in an exitcall */
diff -puN arch/um/include/chan_kern.h~uml-handle-errors-on-opening-host-side-of-consoles arch/um/include/chan_kern.h
--- a/arch/um/include/chan_kern.h~uml-handle-errors-on-opening-host-side-of-consoles
+++ a/arch/um/include/chan_kern.h
@@ -40,7 +40,7 @@ extern int console_open_chan(struct line
 extern void deactivate_chan(struct list_head *chans, int irq);
 extern void reactivate_chan(struct list_head *chans, int irq);
 extern void chan_enable_winch(struct list_head *chans, struct tty_struct *tty);
-extern void enable_chan(struct line *line);
+extern int enable_chan(struct line *line);
 extern void close_chan(struct list_head *chans, int delay_free_irq);
 extern int chan_window_size(struct list_head *chans, 
 			     unsigned short *rows_out, 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
hostfs-convert-to-new-aops.patch
