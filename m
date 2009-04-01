From: akpm@linux-foundation.org
Subject: [merged] proc-tty-switch-synclink-to-proc_fops.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:33:45 -0700
Message-ID: <200904011833.n31IXjg1006855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765785AbZDASg0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:36:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc tty: switch synclink to ->proc_fops
has been removed from the -mm tree.  Its filename was
     proc-tty-switch-synclink-to-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc tty: switch synclink to ->proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink.c |   98 +++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 59 deletions(-)

diff -puN drivers/char/synclink.c~proc-tty-switch-synclink-to-proc_fops drivers/char/synclink.c
--- a/drivers/char/synclink.c~proc-tty-switch-synclink-to-proc_fops
+++ a/drivers/char/synclink.c
@@ -79,6 +79,7 @@
 #include <linux/ptrace.h>
 #include <linux/ioport.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
@@ -3459,18 +3460,17 @@ cleanup:			
  * /proc fs routines....
  */
 
-static inline int line_info(char *buf, struct mgsl_struct *info)
+static inline void line_info(struct seq_file *m, struct mgsl_struct *info)
 {
 	char	stat_buf[30];
-	int	ret;
 	unsigned long flags;
 
 	if (info->bus_type == MGSL_BUS_TYPE_PCI) {
-		ret = sprintf(buf, "%s:PCI io:%04X irq:%d mem:%08X lcr:%08X",
+		seq_printf(m, "%s:PCI io:%04X irq:%d mem:%08X lcr:%08X",
 			info->device_name, info->io_base, info->irq_level,
 			info->phys_memory_base, info->phys_lcr_base);
 	} else {
-		ret = sprintf(buf, "%s:(E)ISA io:%04X irq:%d dma:%d",
+		seq_printf(m, "%s:(E)ISA io:%04X irq:%d dma:%d",
 			info->device_name, info->io_base, 
 			info->irq_level, info->dma_level);
 	}
@@ -3497,37 +3497,37 @@ static inline int line_info(char *buf, s
 
 	if (info->params.mode == MGSL_MODE_HDLC ||
 	    info->params.mode == MGSL_MODE_RAW ) {
-		ret += sprintf(buf+ret, " HDLC txok:%d rxok:%d",
+		seq_printf(m, " HDLC txok:%d rxok:%d",
 			      info->icount.txok, info->icount.rxok);
 		if (info->icount.txunder)
-			ret += sprintf(buf+ret, " txunder:%d", info->icount.txunder);
+			seq_printf(m, " txunder:%d", info->icount.txunder);
 		if (info->icount.txabort)
-			ret += sprintf(buf+ret, " txabort:%d", info->icount.txabort);
+			seq_printf(m, " txabort:%d", info->icount.txabort);
 		if (info->icount.rxshort)
-			ret += sprintf(buf+ret, " rxshort:%d", info->icount.rxshort);	
+			seq_printf(m, " rxshort:%d", info->icount.rxshort);
 		if (info->icount.rxlong)
-			ret += sprintf(buf+ret, " rxlong:%d", info->icount.rxlong);
+			seq_printf(m, " rxlong:%d", info->icount.rxlong);
 		if (info->icount.rxover)
-			ret += sprintf(buf+ret, " rxover:%d", info->icount.rxover);
+			seq_printf(m, " rxover:%d", info->icount.rxover);
 		if (info->icount.rxcrc)
-			ret += sprintf(buf+ret, " rxcrc:%d", info->icount.rxcrc);
+			seq_printf(m, " rxcrc:%d", info->icount.rxcrc);
 	} else {
-		ret += sprintf(buf+ret, " ASYNC tx:%d rx:%d",
+		seq_printf(m, " ASYNC tx:%d rx:%d",
 			      info->icount.tx, info->icount.rx);
 		if (info->icount.frame)
-			ret += sprintf(buf+ret, " fe:%d", info->icount.frame);
+			seq_printf(m, " fe:%d", info->icount.frame);
 		if (info->icount.parity)
-			ret += sprintf(buf+ret, " pe:%d", info->icount.parity);
+			seq_printf(m, " pe:%d", info->icount.parity);
 		if (info->icount.brk)
-			ret += sprintf(buf+ret, " brk:%d", info->icount.brk);	
+			seq_printf(m, " brk:%d", info->icount.brk);
 		if (info->icount.overrun)
-			ret += sprintf(buf+ret, " oe:%d", info->icount.overrun);
+			seq_printf(m, " oe:%d", info->icount.overrun);
 	}
 	
 	/* Append serial signal status to end */
-	ret += sprintf(buf+ret, " %s\n", stat_buf+1);
+	seq_printf(m, " %s\n", stat_buf+1);
 	
-	ret += sprintf(buf+ret, "txactive=%d bh_req=%d bh_run=%d pending_bh=%x\n",
+	seq_printf(m, "txactive=%d bh_req=%d bh_run=%d pending_bh=%x\n",
 	 info->tx_active,info->bh_requested,info->bh_running,
 	 info->pending_bh);
 	 
@@ -3544,60 +3544,40 @@ static inline int line_info(char *buf, s
 	u16 Tmr = usc_InReg( info, TMR );
 	u16 Tccr = usc_InReg( info, TCCR );
 	u16 Ccar = inw( info->io_base + CCAR );
-	ret += sprintf(buf+ret, "tcsr=%04X tdmr=%04X ticr=%04X rcsr=%04X rdmr=%04X\n"
+	seq_printf(m, "tcsr=%04X tdmr=%04X ticr=%04X rcsr=%04X rdmr=%04X\n"
                         "ricr=%04X icr =%04X dccr=%04X tmr=%04X tccr=%04X ccar=%04X\n",
 	 		Tcsr,Tdmr,Ticr,Rscr,Rdmr,Ricr,Icr,Dccr,Tmr,Tccr,Ccar );
 	}
 	spin_unlock_irqrestore(&info->irq_spinlock,flags);
-	
-	return ret;
-	
-}	/* end of line_info() */
+}
 
-/* mgsl_read_proc()
- * 
- * Called to print information about devices
- * 
- * Arguments:
- * 	page	page of memory to hold returned info
- * 	start	
- * 	off
- * 	count
- * 	eof
- * 	data
- * 	
- * Return Value:
- */
-static int mgsl_read_proc(char *page, char **start, off_t off, int count,
-		 int *eof, void *data)
+/* Called to print information about devices */
+static int mgsl_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0, l;
-	off_t	begin = 0;
 	struct mgsl_struct *info;
 	
-	len += sprintf(page, "synclink driver:%s\n", driver_version);
+	seq_printf(m, "synclink driver:%s\n", driver_version);
 	
 	info = mgsl_device_list;
 	while( info ) {
-		l = line_info(page + len, info);
-		len += l;
-		if (len+begin > off+count)
-			goto done;
-		if (len+begin < off) {
-			begin += len;
-			len = 0;
-		}
+		line_info(m, info);
 		info = info->next_device;
 	}
+	return 0;
+}
 
-	*eof = 1;
-done:
-	if (off >= len+begin)
-		return 0;
-	*start = page + (off-begin);
-	return ((count < begin+len-off) ? count : begin+len-off);
-	
-}	/* end of mgsl_read_proc() */
+static int mgsl_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mgsl_proc_show, NULL);
+}
+
+static const struct file_operations mgsl_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mgsl_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
 /* mgsl_allocate_dma_buffers()
  * 
@@ -4335,13 +4315,13 @@ static const struct tty_operations mgsl_
 	.send_xchar = mgsl_send_xchar,
 	.break_ctl = mgsl_break,
 	.wait_until_sent = mgsl_wait_until_sent,
- 	.read_proc = mgsl_read_proc,
 	.set_termios = mgsl_set_termios,
 	.stop = mgsl_stop,
 	.start = mgsl_start,
 	.hangup = mgsl_hangup,
 	.tiocmget = tiocmget,
 	.tiocmset = tiocmset,
+	.proc_fops = &mgsl_proc_fops,
 };
 
 /*
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

