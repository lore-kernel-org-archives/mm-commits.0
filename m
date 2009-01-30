From: akpm@linux-foundation.org
Subject: + proc-tty-switch-synclinkmp-to-proc_fops.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:53:39 -0800
Message-ID: <200901302053.n0UKre7V021205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900AbZA3U4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:56:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     proc tty: switch synclinkmp to ->proc_fops
has been added to the -mm tree.  Its filename is
     proc-tty-switch-synclinkmp-to-proc_fops.patch

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
Subject: proc tty: switch synclinkmp to ->proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclinkmp.c |   74 ++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 40 deletions(-)

diff -puN drivers/char/synclinkmp.c~proc-tty-switch-synclinkmp-to-proc_fops drivers/char/synclinkmp.c
--- a/drivers/char/synclinkmp.c~proc-tty-switch-synclinkmp-to-proc_fops
+++ a/drivers/char/synclinkmp.c
@@ -50,6 +50,7 @@
 #include <linux/ptrace.h>
 #include <linux/ioport.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
 #include <linux/vmalloc.h>
@@ -520,7 +521,6 @@ static void tx_hold(struct tty_struct *t
 static void tx_release(struct tty_struct *tty);
 
 static int  ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg);
-static int  read_proc(char *page, char **start, off_t off, int count,int *eof, void *data);
 static int  chars_in_buffer(struct tty_struct *tty);
 static void throttle(struct tty_struct * tty);
 static void unthrottle(struct tty_struct * tty);
@@ -1354,13 +1354,12 @@ static int ioctl(struct tty_struct *tty,
  * /proc fs routines....
  */
 
-static inline int line_info(char *buf, SLMP_INFO *info)
+static inline void line_info(struct seq_file *m, SLMP_INFO *info)
 {
 	char	stat_buf[30];
-	int	ret;
 	unsigned long flags;
 
-	ret = sprintf(buf, "%s: SCABase=%08x Mem=%08X StatusControl=%08x LCR=%08X\n"
+	seq_printf(m, "%s: SCABase=%08x Mem=%08X StatusControl=%08x LCR=%08X\n"
 		       "\tIRQ=%d MaxFrameSize=%u\n",
 		info->device_name,
 		info->phys_sca_base,
@@ -1391,75 +1390,70 @@ static inline int line_info(char *buf, S
 		strcat(stat_buf, "|RI");
 
 	if (info->params.mode == MGSL_MODE_HDLC) {
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
-			ret += sprintf(buf+ret, " rxlong:%d", info->icount.rxcrc);
+			seq_printf(m, " rxlong:%d", info->icount.rxcrc);
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
-	      int *eof, void *data)
+static int synclinkmp_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0, l;
-	off_t	begin = 0;
 	SLMP_INFO *info;
 
-	len += sprintf(page, "synclinkmp driver:%s\n", driver_version);
+	seq_printf(m, "synclinkmp driver:%s\n", driver_version);
 
 	info = synclinkmp_device_list;
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
+static int synclinkmp_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, synclinkmp_proc_show, NULL);
 }
 
+static const struct file_operations synclinkmp_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= synclinkmp_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /* Return the count of bytes in transmit buffer
  */
 static int chars_in_buffer(struct tty_struct *tty)
@@ -3905,13 +3899,13 @@ static const struct tty_operations ops =
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
+	.proc_fops = &synclinkmp_proc_fops,
 };
 
 
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

