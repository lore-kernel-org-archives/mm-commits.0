From: akpm@linux-foundation.org
Subject: [merged] proc-tty-switch-ircomm-to-proc_fops.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:33:57 -0700
Message-ID: <200904011833.n31IXvos006913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758258AbZDATTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:19:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc tty: switch ircomm to ->proc_fops
has been removed from the -mm tree.  Its filename was
     proc-tty-switch-ircomm-to-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc tty: switch ircomm to ->proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/irda/ircomm/ircomm_tty.c |  246 +++++++++++++++++----------------
 1 file changed, 133 insertions(+), 113 deletions(-)

diff -puN net/irda/ircomm/ircomm_tty.c~proc-tty-switch-ircomm-to-proc_fops net/irda/ircomm/ircomm_tty.c
--- a/net/irda/ircomm/ircomm_tty.c~proc-tty-switch-ircomm-to-proc_fops
+++ a/net/irda/ircomm/ircomm_tty.c
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
+#include <linux/seq_file.h>
 #include <linux/termios.h>
 #include <linux/tty.h>
 #include <linux/interrupt.h>
@@ -72,8 +73,7 @@ static int ircomm_tty_control_indication
 static void ircomm_tty_flow_indication(void *instance, void *sap,
 				       LOCAL_FLOW cmd);
 #ifdef CONFIG_PROC_FS
-static int ircomm_tty_read_proc(char *buf, char **start, off_t offset, int len,
-				int *eof, void *unused);
+static const struct file_operations ircomm_tty_proc_fops;
 #endif /* CONFIG_PROC_FS */
 static struct tty_driver *driver;
 
@@ -98,7 +98,7 @@ static const struct tty_operations ops =
 	.hangup          = ircomm_tty_hangup,
 	.wait_until_sent = ircomm_tty_wait_until_sent,
 #ifdef CONFIG_PROC_FS
-	.read_proc       = ircomm_tty_read_proc,
+	.proc_fops       = &ircomm_tty_proc_fops,
 #endif /* CONFIG_PROC_FS */
 };
 
@@ -1245,150 +1245,170 @@ static void ircomm_tty_flow_indication(v
 }
 
 #ifdef CONFIG_PROC_FS
-static int ircomm_tty_line_info(struct ircomm_tty_cb *self, char *buf)
+static void ircomm_tty_line_info(struct ircomm_tty_cb *self, struct seq_file *m)
 {
-	int  ret=0;
+	char sep;
 
-	ret += sprintf(buf+ret, "State: %s\n", ircomm_tty_state[self->state]);
+	seq_printf(m, "State: %s\n", ircomm_tty_state[self->state]);
 
-	ret += sprintf(buf+ret, "Service type: ");
+	seq_puts(m, "Service type: ");
 	if (self->service_type & IRCOMM_9_WIRE)
-		ret += sprintf(buf+ret, "9_WIRE");
+		seq_puts(m, "9_WIRE");
 	else if (self->service_type & IRCOMM_3_WIRE)
-		ret += sprintf(buf+ret, "3_WIRE");
+		seq_puts(m, "3_WIRE");
 	else if (self->service_type & IRCOMM_3_WIRE_RAW)
-		ret += sprintf(buf+ret, "3_WIRE_RAW");
+		seq_puts(m, "3_WIRE_RAW");
 	else
-		ret += sprintf(buf+ret, "No common service type!\n");
-	ret += sprintf(buf+ret, "\n");
+		seq_puts(m, "No common service type!\n");
+	seq_putc(m, '\n');
 
-	ret += sprintf(buf+ret, "Port name: %s\n", self->settings.port_name);
+	seq_printf(m, "Port name: %s\n", self->settings.port_name);
 
-	ret += sprintf(buf+ret, "DTE status: ");
-	if (self->settings.dte & IRCOMM_RTS)
-		ret += sprintf(buf+ret, "RTS|");
-	if (self->settings.dte & IRCOMM_DTR)
-		ret += sprintf(buf+ret, "DTR|");
-	if (self->settings.dte)
-		ret--; /* remove the last | */
-	ret += sprintf(buf+ret, "\n");
-
-	ret += sprintf(buf+ret, "DCE status: ");
-	if (self->settings.dce & IRCOMM_CTS)
-		ret += sprintf(buf+ret, "CTS|");
-	if (self->settings.dce & IRCOMM_DSR)
-		ret += sprintf(buf+ret, "DSR|");
-	if (self->settings.dce & IRCOMM_CD)
-		ret += sprintf(buf+ret, "CD|");
-	if (self->settings.dce & IRCOMM_RI)
-		ret += sprintf(buf+ret, "RI|");
-	if (self->settings.dce)
-		ret--; /* remove the last | */
-	ret += sprintf(buf+ret, "\n");
+	seq_printf(m, "DTE status:");
+	sep = ' ';
+	if (self->settings.dte & IRCOMM_RTS) {
+		seq_printf(m, "%cRTS", sep);
+		sep = '|';
+	}
+	if (self->settings.dte & IRCOMM_DTR) {
+		seq_printf(m, "%cDTR", sep);
+		sep = '|';
+	}
+	seq_putc(m, '\n');
 
-	ret += sprintf(buf+ret, "Configuration: ");
+	seq_puts(m, "DCE status:");
+	sep = ' ';
+	if (self->settings.dce & IRCOMM_CTS) {
+		seq_printf(m, "%cCTS", sep);
+		sep = '|';
+	}
+	if (self->settings.dce & IRCOMM_DSR) {
+		seq_printf(m, "%cDSR", sep);
+		sep = '|';
+	}
+	if (self->settings.dce & IRCOMM_CD) {
+		seq_printf(m, "%cCD", sep);
+		sep = '|';
+	}
+	if (self->settings.dce & IRCOMM_RI) {
+		seq_printf(m, "%cRI", sep);
+		sep = '|';
+	}
+	seq_putc(m, '\n');
+
+	seq_puts(m, "Configuration: ");
 	if (!self->settings.null_modem)
-		ret += sprintf(buf+ret, "DTE <-> DCE\n");
+		seq_puts(m, "DTE <-> DCE\n");
 	else
-		ret += sprintf(buf+ret,
-			       "DTE <-> DTE (null modem emulation)\n");
+		seq_puts(m, "DTE <-> DTE (null modem emulation)\n");
 
-	ret += sprintf(buf+ret, "Data rate: %d\n", self->settings.data_rate);
+	seq_printf(m, "Data rate: %d\n", self->settings.data_rate);
 
-	ret += sprintf(buf+ret, "Flow control: ");
-	if (self->settings.flow_control & IRCOMM_XON_XOFF_IN)
-		ret += sprintf(buf+ret, "XON_XOFF_IN|");
-	if (self->settings.flow_control & IRCOMM_XON_XOFF_OUT)
-		ret += sprintf(buf+ret, "XON_XOFF_OUT|");
-	if (self->settings.flow_control & IRCOMM_RTS_CTS_IN)
-		ret += sprintf(buf+ret, "RTS_CTS_IN|");
-	if (self->settings.flow_control & IRCOMM_RTS_CTS_OUT)
-		ret += sprintf(buf+ret, "RTS_CTS_OUT|");
-	if (self->settings.flow_control & IRCOMM_DSR_DTR_IN)
-		ret += sprintf(buf+ret, "DSR_DTR_IN|");
-	if (self->settings.flow_control & IRCOMM_DSR_DTR_OUT)
-		ret += sprintf(buf+ret, "DSR_DTR_OUT|");
-	if (self->settings.flow_control & IRCOMM_ENQ_ACK_IN)
-		ret += sprintf(buf+ret, "ENQ_ACK_IN|");
-	if (self->settings.flow_control & IRCOMM_ENQ_ACK_OUT)
-		ret += sprintf(buf+ret, "ENQ_ACK_OUT|");
-	if (self->settings.flow_control)
-		ret--; /* remove the last | */
-	ret += sprintf(buf+ret, "\n");
-
-	ret += sprintf(buf+ret, "Flags: ");
-	if (self->flags & ASYNC_CTS_FLOW)
-		ret += sprintf(buf+ret, "ASYNC_CTS_FLOW|");
-	if (self->flags & ASYNC_CHECK_CD)
-		ret += sprintf(buf+ret, "ASYNC_CHECK_CD|");
-	if (self->flags & ASYNC_INITIALIZED)
-		ret += sprintf(buf+ret, "ASYNC_INITIALIZED|");
-	if (self->flags & ASYNC_LOW_LATENCY)
-		ret += sprintf(buf+ret, "ASYNC_LOW_LATENCY|");
-	if (self->flags & ASYNC_CLOSING)
-		ret += sprintf(buf+ret, "ASYNC_CLOSING|");
-	if (self->flags & ASYNC_NORMAL_ACTIVE)
-		ret += sprintf(buf+ret, "ASYNC_NORMAL_ACTIVE|");
-	if (self->flags)
-		ret--; /* remove the last | */
-	ret += sprintf(buf+ret, "\n");
-
-	ret += sprintf(buf+ret, "Role: %s\n", self->client ?
-		       "client" : "server");
-	ret += sprintf(buf+ret, "Open count: %d\n", self->open_count);
-	ret += sprintf(buf+ret, "Max data size: %d\n", self->max_data_size);
-	ret += sprintf(buf+ret, "Max header size: %d\n", self->max_header_size);
+	seq_puts(m, "Flow control:");
+	sep = ' ';
+	if (self->settings.flow_control & IRCOMM_XON_XOFF_IN) {
+		seq_printf(m, "%cXON_XOFF_IN", sep);
+		sep = '|';
+	}
+	if (self->settings.flow_control & IRCOMM_XON_XOFF_OUT) {
+		seq_printf(m, "%cXON_XOFF_OUT", sep);
+		sep = '|';
+	}
+	if (self->settings.flow_control & IRCOMM_RTS_CTS_IN) {
+		seq_printf(m, "%cRTS_CTS_IN", sep);
+		sep = '|';
+	}
+	if (self->settings.flow_control & IRCOMM_RTS_CTS_OUT) {
+		seq_printf(m, "%cRTS_CTS_OUT", sep);
+		sep = '|';
+	}
+	if (self->settings.flow_control & IRCOMM_DSR_DTR_IN) {
+		seq_printf(m, "%cDSR_DTR_IN", sep);
+		sep = '|';
+	}
+	if (self->settings.flow_control & IRCOMM_DSR_DTR_OUT) {
+		seq_printf(m, "%cDSR_DTR_OUT", sep);
+		sep = '|';
+	}
+	if (self->settings.flow_control & IRCOMM_ENQ_ACK_IN) {
+		seq_printf(m, "%cENQ_ACK_IN", sep);
+		sep = '|';
+	}
+	if (self->settings.flow_control & IRCOMM_ENQ_ACK_OUT) {
+		seq_printf(m, "%cENQ_ACK_OUT", sep);
+		sep = '|';
+	}
+	seq_putc(m, '\n');
+
+	seq_puts(m, "Flags:");
+	sep = ' ';
+	if (self->flags & ASYNC_CTS_FLOW) {
+		seq_printf(m, "%cASYNC_CTS_FLOW", sep);
+		sep = '|';
+	}
+	if (self->flags & ASYNC_CHECK_CD) {
+		seq_printf(m, "%cASYNC_CHECK_CD", sep);
+		sep = '|';
+	}
+	if (self->flags & ASYNC_INITIALIZED) {
+		seq_printf(m, "%cASYNC_INITIALIZED", sep);
+		sep = '|';
+	}
+	if (self->flags & ASYNC_LOW_LATENCY) {
+		seq_printf(m, "%cASYNC_LOW_LATENCY", sep);
+		sep = '|';
+	}
+	if (self->flags & ASYNC_CLOSING) {
+		seq_printf(m, "%cASYNC_CLOSING", sep);
+		sep = '|';
+	}
+	if (self->flags & ASYNC_NORMAL_ACTIVE) {
+		seq_printf(m, "%cASYNC_NORMAL_ACTIVE", sep);
+		sep = '|';
+	}
+	seq_putc(m, '\n');
+
+	seq_printf(m, "Role: %s\n", self->client ? "client" : "server");
+	seq_printf(m, "Open count: %d\n", self->open_count);
+	seq_printf(m, "Max data size: %d\n", self->max_data_size);
+	seq_printf(m, "Max header size: %d\n", self->max_header_size);
 
 	if (self->tty)
-		ret += sprintf(buf+ret, "Hardware: %s\n",
+		seq_printf(m, "Hardware: %s\n",
 			       self->tty->hw_stopped ? "Stopped" : "Running");
-
-	ret += sprintf(buf+ret, "\n");
-	return ret;
 }
 
-
-/*
- * Function ircomm_tty_read_proc (buf, start, offset, len, eof, unused)
- *
- *
- *
- */
-static int ircomm_tty_read_proc(char *buf, char **start, off_t offset, int len,
-				int *eof, void *unused)
+static int ircomm_tty_proc_show(struct seq_file *m, void *v)
 {
 	struct ircomm_tty_cb *self;
-	int count = 0, l;
-	off_t begin = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ircomm_tty->hb_spinlock, flags);
 
 	self = (struct ircomm_tty_cb *) hashbin_get_first(ircomm_tty);
-	while ((self != NULL) && (count < 4000)) {
+	while (self != NULL) {
 		if (self->magic != IRCOMM_TTY_MAGIC)
 			break;
 
-		l = ircomm_tty_line_info(self, buf + count);
-		count += l;
-		if (count+begin > offset+len)
-			goto done;
-		if (count+begin < offset) {
-			begin += count;
-			count = 0;
-		}
-
+		ircomm_tty_line_info(self, m);
 		self = (struct ircomm_tty_cb *) hashbin_get_next(ircomm_tty);
 	}
-	*eof = 1;
-done:
 	spin_unlock_irqrestore(&ircomm_tty->hb_spinlock, flags);
+	return 0;
+}
 
-	if (offset >= count+begin)
-		return 0;
-	*start = buf + (offset-begin);
-	return ((len < begin+count-offset) ? len : begin+count-offset);
+static int ircomm_tty_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ircomm_tty_proc_show, NULL);
 }
+
+static const struct file_operations ircomm_tty_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ircomm_tty_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif /* CONFIG_PROC_FS */
 
 MODULE_AUTHOR("Dag Brattli <dagb@cs.uit.no>");
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

