From: akpm@linux-foundation.org
Subject: + proc-tty-switch-synclink_cs-to-proc_fops.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:53:31 -0800
Message-ID: <200901302053.n0UKrVtd020960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754819AbZA3UyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:54:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     proc tty: switch synclink_cs to ->proc_fops
has been added to the -mm tree.  Its filename is
     proc-tty-switch-synclink_cs-to-proc_fops.patch

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
Subject: proc tty: switch synclink_cs to ->proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/synclink_cs.c |   73 +++++++++++++---------------
 1 file changed, 34 insertions(+), 39 deletions(-)

diff -puN drivers/char/pcmcia/synclink_cs.c~proc-tty-switch-synclink_cs-to-proc_fops drivers/char/pcmcia/synclink_cs.c
--- a/drivers/char/pcmcia/synclink_cs.c~proc-tty-switch-synclink_cs-to-proc_fops
+++ a/drivers/char/pcmcia/synclink_cs.c
@@ -51,6 +51,7 @@
 #include <linux/ptrace.h>
 #include <linux/ioport.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
 #include <linux/vmalloc.h>
@@ -2619,13 +2620,12 @@ cleanup:
  * /proc fs routines....
  */
 
-static inline int line_info(char *buf, MGSLPC_INFO *info)
+static inline void line_info(struct seq_file *m, MGSLPC_INFO *info)
 {
 	char	stat_buf[30];
-	int	ret;
 	unsigned long flags;
 
-	ret = sprintf(buf, "%s:io:%04X irq:%d",
+	seq_printf(m, "%s:io:%04X irq:%d",
 		      info->device_name, info->io_base, info->irq_level);
 
 	/* output current serial signal states */
@@ -2649,75 +2649,70 @@ static inline int line_info(char *buf, M
 		strcat(stat_buf, "|RI");
 
 	if (info->params.mode == MGSL_MODE_HDLC) {
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
-
-	return ret;
 }
 
 /* Called to print information about devices
  */
-static int mgslpc_read_proc(char *page, char **start, off_t off, int count,
-		 int *eof, void *data)
+static int mgslpc_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0, l;
-	off_t	begin = 0;
 	MGSLPC_INFO *info;
 
-	len += sprintf(page, "synclink driver:%s\n", driver_version);
+	seq_printf(m, "synclink driver:%s\n", driver_version);
 
 	info = mgslpc_device_list;
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
+static int mgslpc_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mgslpc_proc_show, NULL);
 }
 
+static const struct file_operations mgslpc_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mgslpc_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int rx_alloc_buffers(MGSLPC_INFO *info)
 {
 	/* each buffer has header and data */
@@ -2861,13 +2856,13 @@ static const struct tty_operations mgslp
 	.send_xchar = mgslpc_send_xchar,
 	.break_ctl = mgslpc_break,
 	.wait_until_sent = mgslpc_wait_until_sent,
-	.read_proc = mgslpc_read_proc,
 	.set_termios = mgslpc_set_termios,
 	.stop = tx_pause,
 	.start = tx_release,
 	.hangup = mgslpc_hangup,
 	.tiocmget = tiocmget,
 	.tiocmset = tiocmset,
+	.proc_fops = &mgslpc_proc_fops,
 };
 
 static void synclink_cs_cleanup(void)
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

