From: akpm@linux-foundation.org
Subject: + proc-tty-switch-sdio_uart-to-proc_fops.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:53:42 -0800
Message-ID: <200901302053.n0UKrgS5021302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754697AbZA3UyV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:54:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     proc tty: switch sdio_uart to ->proc_fops
has been added to the -mm tree.  Its filename is
     proc-tty-switch-sdio_uart-to-proc_fops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc tty: switch sdio_uart to ->proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/sdio_uart.c |   62 +++++++++++++++------------------
 1 file changed, 30 insertions(+), 32 deletions(-)

diff -puN drivers/mmc/card/sdio_uart.c~proc-tty-switch-sdio_uart-to-proc_fops drivers/mmc/card/sdio_uart.c
--- a/drivers/mmc/card/sdio_uart.c~proc-tty-switch-sdio_uart-to-proc_fops
+++ a/drivers/mmc/card/sdio_uart.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
+#include <linux/seq_file.h>
 #include <linux/serial_reg.h>
 #include <linux/circ_buf.h>
 #include <linux/gfp.h>
@@ -933,67 +934,64 @@ static int sdio_uart_tiocmset(struct tty
 	return result;
 }
 
-static int sdio_uart_read_proc(char *page, char **start, off_t off,
-			       int count, int *eof, void *data)
+static int sdio_uart_proc_show(struct seq_file *m, void *v)
 {
-	int i, len = 0;
-	off_t begin = 0;
+	int i;
 
-	len += sprintf(page, "serinfo:1.0 driver%s%s revision:%s\n",
+	seq_printf(m, "serinfo:1.0 driver%s%s revision:%s\n",
 		       "", "", "");
-	for (i = 0; i < UART_NR && len < PAGE_SIZE - 96; i++) {
+	for (i = 0; i < UART_NR; i++) {
 		struct sdio_uart_port *port = sdio_uart_port_get(i);
 		if (port) {
-			len += sprintf(page+len, "%d: uart:SDIO", i);
+			seq_printf(m, "%d: uart:SDIO", i);
 			if(capable(CAP_SYS_ADMIN)) {
-				len += sprintf(page + len, " tx:%d rx:%d",
+				seq_printf(m, " tx:%d rx:%d",
 					       port->icount.tx, port->icount.rx);
 				if (port->icount.frame)
-					len += sprintf(page + len, " fe:%d",
+					seq_printf(m, " fe:%d",
 						       port->icount.frame);
 				if (port->icount.parity)
-					len += sprintf(page + len, " pe:%d",
+					seq_printf(m, " pe:%d",
 						       port->icount.parity);
 				if (port->icount.brk)
-					len += sprintf(page + len, " brk:%d",
+					seq_printf(m, " brk:%d",
 						       port->icount.brk);
 				if (port->icount.overrun)
-					len += sprintf(page + len, " oe:%d",
+					seq_printf(m, " oe:%d",
 						       port->icount.overrun);
 				if (port->icount.cts)
-					len += sprintf(page + len, " cts:%d",
+					seq_printf(m, " cts:%d",
 						       port->icount.cts);
 				if (port->icount.dsr)
-					len += sprintf(page + len, " dsr:%d",
+					seq_printf(m, " dsr:%d",
 						       port->icount.dsr);
 				if (port->icount.rng)
-					len += sprintf(page + len, " rng:%d",
+					seq_printf(m, " rng:%d",
 						       port->icount.rng);
 				if (port->icount.dcd)
-					len += sprintf(page + len, " dcd:%d",
+					seq_printf(m, " dcd:%d",
 						       port->icount.dcd);
 			}
-			strcat(page, "\n");
-			len++;
 			sdio_uart_port_put(port);
-		}
-
-		if (len + begin > off + count)
-			goto done;
-		if (len + begin < off) {
-			begin += len;
-			len = 0;
+			seq_putc(m, '\n');
 		}
 	}
-	*eof = 1;
+	return 0;
+}
 
-done:
-	if (off >= len + begin)
-		return 0;
-	*start = page + (off - begin);
-	return (count < begin + len - off) ? count : (begin + len - off);
+static int sdio_uart_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, sdio_uart_proc_show, NULL);
 }
 
+static const struct file_operations sdio_uart_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= sdio_uart_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static const struct tty_operations sdio_uart_ops = {
 	.open			= sdio_uart_open,
 	.close			= sdio_uart_close,
@@ -1007,7 +1005,7 @@ static const struct tty_operations sdio_
 	.break_ctl		= sdio_uart_break_ctl,
 	.tiocmget		= sdio_uart_tiocmget,
 	.tiocmset		= sdio_uart_tiocmset,
-	.read_proc		= sdio_uart_read_proc,
+	.proc_fops		= &sdio_uart_proc_fops,
 };
 
 static struct tty_driver *sdio_uart_tty_driver;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

seq_file-move-traverse-so-it-can-be-used-from-seq_read.patch
seq_file-properly-cope-with-pread.patch
linux-next.patch
eeepc-should-depend-on-input.patch
tags-fix-config-symbols-generation.patch
sm501-fix-section-mismatches.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
proc-tty-add-struct-tty_operations-proc_fops.patch
proc-tty-switch-cyclades-to-proc_fops.patch
proc-tty-switch-ip2-to-proc_fops.patch
proc-tty-switch-istallion-to-proc_fops.patch
proc-tty-switch-synclink_cs-to-proc_fops.patch
proc-tty-switch-stallion-to-proc_fops.patch
proc-tty-switch-synclink-to-proc_fops.patch
proc-tty-switch-synclink_gt-to-proc_fops.patch
proc-tty-switch-synclinkmp-to-proc_fops.patch
proc-tty-switch-sdio_uart-to-proc_fops.patch
proc-tty-switch-serial_core-to-proc_fops.patch
proc-tty-switch-usb-serial-to-proc_fops.patch
proc-tty-switch-ircomm-to-proc_fops.patch
proc-tty-switch-amiserial-to-proc_fops.patch
proc-tty-switch-ia64-simserial-to-proc_fops.patch
proc-tty-switch-xtensa-iss-console-to-proc_fops.patch
proc-tty-remove-struct-tty_operations-read_proc.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch

