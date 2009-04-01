From: akpm@linux-foundation.org
Subject: [merged] proc-tty-switch-synclink_gt-to-proc_fops.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:33:47 -0700
Message-ID: <200904011833.n31IXlOx006858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764815AbZDASgZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:36:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc tty: switch synclink_gt to ->proc_fops
has been removed from the -mm tree.  Its filename was
     proc-tty-switch-synclink_gt-to-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc tty: switch synclink_gt to ->proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |   74 ++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 40 deletions(-)

diff -puN drivers/char/synclink_gt.c~proc-tty-switch-synclink_gt-to-proc_fops drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~proc-tty-switch-synclink_gt-to-proc_fops
+++ a/drivers/char/synclink_gt.c
@@ -60,6 +60,7 @@
 #include <linux/ptrace.h>
 #include <linux/ioport.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
 #include <linux/vmalloc.h>
@@ -154,7 +155,6 @@ static void tx_hold(struct tty_struct *t
 static void tx_release(struct tty_struct *tty);
 
 static int  ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg);
-static int  read_proc(char *page, char **start, off_t off, int count,int *eof, void *data);
 static int  chars_in_buffer(struct tty_struct *tty);
 static void throttle(struct tty_struct * tty);
 static void unthrottle(struct tty_struct * tty);
@@ -1229,13 +1229,12 @@ static long slgt_compat_ioctl(struct tty
 /*
  * proc fs support
  */
-static inline int line_info(char *buf, struct slgt_info *info)
+static inline void line_info(struct seq_file *m, struct slgt_info *info)
 {
 	char stat_buf[30];
-	int ret;
 	unsigned long flags;
 
-	ret = sprintf(buf, "%s: IO=%08X IRQ=%d MaxFrameSize=%u\n",
+	seq_printf(m, "%s: IO=%08X IRQ=%d MaxFrameSize=%u\n",
 		      info->device_name, info->phys_reg_addr,
 		      info->irq_level, info->max_frame_size);
 
@@ -1260,75 +1259,70 @@ static inline int line_info(char *buf, s
 		strcat(stat_buf, "|RI");
 
 	if (info->params.mode != MGSL_MODE_ASYNC) {
-		ret += sprintf(buf+ret, "\tHDLC txok:%d rxok:%d",
+		seq_printf(m, "\tHDLC txok:%d rxok:%d",
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
-		ret += sprintf(buf+ret, "\tASYNC tx:%d rx:%d",
+		seq_printf(m, "\tASYNC tx:%d rx:%d",
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
 
-	ret += sprintf(buf+ret, "\ttxactive=%d bh_req=%d bh_run=%d pending_bh=%x\n",
+	seq_printf(m, "\ttxactive=%d bh_req=%d bh_run=%d pending_bh=%x\n",
 		       info->tx_active,info->bh_requested,info->bh_running,
 		       info->pending_bh);
-
-	return ret;
 }
 
 /* Called to print information about devices
  */
-static int read_proc(char *page, char **start, off_t off, int count,
-		     int *eof, void *data)
+static int synclink_gt_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0, l;
-	off_t	begin = 0;
 	struct slgt_info *info;
 
-	len += sprintf(page, "synclink_gt driver\n");
+	seq_puts(m, "synclink_gt driver\n");
 
 	info = slgt_device_list;
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
+static int synclink_gt_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, synclink_gt_proc_show, NULL);
 }
 
+static const struct file_operations synclink_gt_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= synclink_gt_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*
  * return count of bytes in transmit buffer
  */
@@ -3562,13 +3556,13 @@ static const struct tty_operations ops =
 	.send_xchar = send_xchar,
 	.break_ctl = set_break,
 	.wait_until_sent = wait_until_sent,
- 	.read_proc = read_proc,
 	.set_termios = set_termios,
 	.stop = tx_hold,
 	.start = tx_release,
 	.hangup = hangup,
 	.tiocmget = tiocmget,
 	.tiocmset = tiocmset,
+	.proc_fops = &synclink_gt_proc_fops,
 };
 
 static void slgt_cleanup(void)
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

