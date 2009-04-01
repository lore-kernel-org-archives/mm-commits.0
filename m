From: akpm@linux-foundation.org
Subject: [merged] proc-tty-switch-amiserial-to-proc_fops.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:33:59 -0700
Message-ID: <200904011833.n31IXxTs006956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932302AbZDASgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:36:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc tty: switch amiserial to ->proc_fops
has been removed from the -mm tree.  Its filename was
     proc-tty-switch-amiserial-to-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc tty: switch amiserial to ->proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/amiserial.c |   60 ++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 33 deletions(-)

diff -puN drivers/char/amiserial.c~proc-tty-switch-amiserial-to-proc_fops drivers/char/amiserial.c
--- a/drivers/char/amiserial.c~proc-tty-switch-amiserial-to-proc_fops
+++ a/drivers/char/amiserial.c
@@ -79,6 +79,7 @@ static char *serial_version = "4.30";
 #include <linux/ptrace.h>
 #include <linux/ioport.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
@@ -1825,14 +1826,13 @@ static int rs_open(struct tty_struct *tt
  * /proc fs routines....
  */
 
-static inline int line_info(char *buf, struct serial_state *state)
+static inline void line_info(struct seq_file *m, struct serial_state *state)
 {
 	struct async_struct *info = state->info, scr_info;
 	char	stat_buf[30], control, status;
-	int	ret;
 	unsigned long flags;
 
-	ret = sprintf(buf, "%d: uart:amiga_builtin",state->line);
+	seq_printf(m, "%d: uart:amiga_builtin",state->line);
 
 	/*
 	 * Figure out the current RS-232 lines
@@ -1864,55 +1864,49 @@ static inline int line_info(char *buf, s
 		strcat(stat_buf, "|CD");
 
 	if (info->quot) {
-		ret += sprintf(buf+ret, " baud:%d",
-			       state->baud_base / info->quot);
+		seq_printf(m, " baud:%d", state->baud_base / info->quot);
 	}
 
-	ret += sprintf(buf+ret, " tx:%d rx:%d",
-		      state->icount.tx, state->icount.rx);
+	seq_printf(m, " tx:%d rx:%d", state->icount.tx, state->icount.rx);
 
 	if (state->icount.frame)
-		ret += sprintf(buf+ret, " fe:%d", state->icount.frame);
+		seq_printf(m, " fe:%d", state->icount.frame);
 
 	if (state->icount.parity)
-		ret += sprintf(buf+ret, " pe:%d", state->icount.parity);
+		seq_printf(m, " pe:%d", state->icount.parity);
 
 	if (state->icount.brk)
-		ret += sprintf(buf+ret, " brk:%d", state->icount.brk);
+		seq_printf(m, " brk:%d", state->icount.brk);
 
 	if (state->icount.overrun)
-		ret += sprintf(buf+ret, " oe:%d", state->icount.overrun);
+		seq_printf(m, " oe:%d", state->icount.overrun);
 
 	/*
 	 * Last thing is the RS-232 status lines
 	 */
-	ret += sprintf(buf+ret, " %s\n", stat_buf+1);
-	return ret;
+	seq_printf(m, " %s\n", stat_buf+1);
 }
 
-static int rs_read_proc(char *page, char **start, off_t off, int count,
-			int *eof, void *data)
+static int rs_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0, l;
-	off_t	begin = 0;
+	seq_printf(m, "serinfo:1.0 driver:%s\n", serial_version);
+	line_info(m, &rs_table[0]);
+	return 0;
+}
 
-	len += sprintf(page, "serinfo:1.0 driver:%s\n", serial_version);
-	l = line_info(page + len, &rs_table[0]);
-	len += l;
-	if (len+begin > off+count)
-	  goto done;
-	if (len+begin < off) {
-	  begin += len;
-	  len = 0;
-	}
-	*eof = 1;
-done:
-	if (off >= len+begin)
-		return 0;
-	*start = page + (off-begin);
-	return ((count < begin+len-off) ? count : begin+len-off);
+static int rs_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rs_proc_show, NULL);
 }
 
+static const struct file_operations rs_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= rs_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*
  * ---------------------------------------------------------------------
  * rs_init() and friends
@@ -1951,9 +1945,9 @@ static const struct tty_operations seria
 	.break_ctl = rs_break,
 	.send_xchar = rs_send_xchar,
 	.wait_until_sent = rs_wait_until_sent,
-	.read_proc = rs_read_proc,
 	.tiocmget = rs_tiocmget,
 	.tiocmset = rs_tiocmset,
+	.proc_fops = &rs_proc_fops,
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

