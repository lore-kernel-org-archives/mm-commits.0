From: akpm@linux-foundation.org
Subject: [merged] proc-tty-switch-sdio_uart-to-proc_fops.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:33:51 -0700
Message-ID: <200904011833.n31IXpBF006904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758181AbZDATP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:15:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc tty: switch sdio_uart to ->proc_fops
has been removed from the -mm tree.  Its filename was
     proc-tty-switch-sdio_uart-to-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
sysctl-dont-take-the-use-count-of-multiple-heads-at-a-time.patch
sysctl-lockdep-support-for-sysctl-reference-counting.patch
simplify-copy_thread.patch
simplify-copy_thread-checkpatch-fixes.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers.patch
sysctl-fix-suid_dumpable-and-lease-break-time-sysctls.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch

