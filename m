From: akpm@linux-foundation.org
Subject: [merged] proc-tty-switch-serial_core-to-proc_fops.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:33:53 -0700
Message-ID: <200904011833.n31IXrpx006907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758525AbZDATRB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:17:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc tty: switch serial_core to ->proc_fops
has been removed from the -mm tree.  Its filename was
     proc-tty-switch-serial_core-to-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc tty: switch serial_core to ->proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |   76 +++++++++++++++------------------
 1 file changed, 36 insertions(+), 40 deletions(-)

diff -puN drivers/serial/serial_core.c~proc-tty-switch-serial_core-to-proc_fops drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~proc-tty-switch-serial_core-to-proc_fops
+++ a/drivers/serial/serial_core.c
@@ -27,6 +27,8 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/console.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/serial_core.h>
 #include <linux/smp_lock.h>
 #include <linux/device.h>
@@ -1682,20 +1684,20 @@ static const char *uart_type(struct uart
 
 #ifdef CONFIG_PROC_FS
 
-static int uart_line_info(char *buf, struct uart_driver *drv, int i)
+static void uart_line_info(struct seq_file *m, struct uart_driver *drv, int i)
 {
 	struct uart_state *state = drv->state + i;
 	int pm_state;
 	struct uart_port *port = state->port;
 	char stat_buf[32];
 	unsigned int status;
-	int mmio, ret;
+	int mmio;
 
 	if (!port)
-		return 0;
+		return;
 
 	mmio = port->iotype >= UPIO_MEM;
-	ret = sprintf(buf, "%d: uart:%s %s%08llX irq:%d",
+	seq_printf(m, "%d: uart:%s %s%08llX irq:%d",
 			port->line, uart_type(port),
 			mmio ? "mmio:0x" : "port:",
 			mmio ? (unsigned long long)port->mapbase
@@ -1703,8 +1705,8 @@ static int uart_line_info(char *buf, str
 			port->irq);
 
 	if (port->type == PORT_UNKNOWN) {
-		strcat(buf, "\n");
-		return ret + 1;
+		seq_putc(m, '\n');
+		return;
 	}
 
 	if (capable(CAP_SYS_ADMIN)) {
@@ -1719,19 +1721,19 @@ static int uart_line_info(char *buf, str
 			uart_change_pm(state, pm_state);
 		mutex_unlock(&state->mutex);
 
-		ret += sprintf(buf + ret, " tx:%d rx:%d",
+		seq_printf(m, " tx:%d rx:%d",
 				port->icount.tx, port->icount.rx);
 		if (port->icount.frame)
-			ret += sprintf(buf + ret, " fe:%d",
+			seq_printf(m, " fe:%d",
 				port->icount.frame);
 		if (port->icount.parity)
-			ret += sprintf(buf + ret, " pe:%d",
+			seq_printf(m, " pe:%d",
 				port->icount.parity);
 		if (port->icount.brk)
-			ret += sprintf(buf + ret, " brk:%d",
+			seq_printf(m, " brk:%d",
 				port->icount.brk);
 		if (port->icount.overrun)
-			ret += sprintf(buf + ret, " oe:%d",
+			seq_printf(m, " oe:%d",
 				port->icount.overrun);
 
 #define INFOBIT(bit, str) \
@@ -1753,45 +1755,39 @@ static int uart_line_info(char *buf, str
 		STATBIT(TIOCM_RNG, "|RI");
 		if (stat_buf[0])
 			stat_buf[0] = ' ';
-		strcat(stat_buf, "\n");
 
-		ret += sprintf(buf + ret, stat_buf);
-	} else {
-		strcat(buf, "\n");
-		ret++;
+		seq_puts(m, stat_buf);
 	}
+	seq_putc(m, '\n');
 #undef STATBIT
 #undef INFOBIT
-	return ret;
 }
 
-static int uart_read_proc(char *page, char **start, off_t off,
-			  int count, int *eof, void *data)
+static int uart_proc_show(struct seq_file *m, void *v)
 {
-	struct tty_driver *ttydrv = data;
+	struct tty_driver *ttydrv = v;
 	struct uart_driver *drv = ttydrv->driver_state;
-	int i, len = 0, l;
-	off_t begin = 0;
+	int i;
 
-	len += sprintf(page, "serinfo:1.0 driver%s%s revision:%s\n",
+	seq_printf(m, "serinfo:1.0 driver%s%s revision:%s\n",
 			"", "", "");
-	for (i = 0; i < drv->nr && len < PAGE_SIZE - 96; i++) {
-		l = uart_line_info(page + len, drv, i);
-		len += l;
-		if (len + begin > off + count)
-			goto done;
-		if (len + begin < off) {
-			begin += len;
-			len = 0;
-		}
-	}
-	*eof = 1;
- done:
-	if (off >= len + begin)
-		return 0;
-	*start = page + (off - begin);
-	return (count < begin + len - off) ? count : (begin + len - off);
+	for (i = 0; i < drv->nr; i++)
+		uart_line_info(m, drv, i);
+	return 0;
 }
+
+static int uart_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, uart_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations uart_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= uart_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif
 
 #if defined(CONFIG_SERIAL_CORE_CONSOLE) || defined(CONFIG_CONSOLE_POLL)
@@ -2299,7 +2295,7 @@ static const struct tty_operations uart_
 	.break_ctl	= uart_break_ctl,
 	.wait_until_sent= uart_wait_until_sent,
 #ifdef CONFIG_PROC_FS
-	.read_proc	= uart_read_proc,
+	.proc_fops	= &uart_proc_fops,
 #endif
 	.tiocmget	= uart_tiocmget,
 	.tiocmset	= uart_tiocmset,
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

