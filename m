From: akpm@linux-foundation.org
Subject: [merged] proc-tty-switch-cyclades-to-proc_fops.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:33:35 -0700
Message-ID: <200904011833.n31IXZZ4006761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757766AbZDASgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:36:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc tty: switch cyclades to ->proc_fops
has been removed from the -mm tree.  Its filename was
     proc-tty-switch-cyclades-to-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc tty: switch cyclades to ->proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   54 ++++++++++++++------------------------
 1 file changed, 20 insertions(+), 34 deletions(-)

diff -puN drivers/char/cyclades.c~proc-tty-switch-cyclades-to-proc_fops drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~proc-tty-switch-cyclades-to-proc_fops
+++ a/drivers/char/cyclades.c
@@ -657,6 +657,7 @@
 
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 static void cy_throttle(struct tty_struct *tty);
 static void cy_send_xchar(struct tty_struct *tty, char ch);
@@ -868,8 +869,6 @@ static int cyz_issue_cmd(struct cyclades
 static unsigned detect_isa_irq(void __iomem *);
 #endif				/* CONFIG_ISA */
 
-static int cyclades_get_proc_info(char *, char **, off_t, int, int *, void *);
-
 #ifndef CONFIG_CYZ_INTR
 static void cyz_poll(unsigned long);
 
@@ -5216,31 +5215,22 @@ static struct pci_driver cy_pci_driver =
 };
 #endif
 
-static int
-cyclades_get_proc_info(char *buf, char **start, off_t offset, int length,
-		int *eof, void *data)
+static int cyclades_proc_show(struct seq_file *m, void *v)
 {
 	struct cyclades_port *info;
 	unsigned int i, j;
-	int len = 0;
-	off_t begin = 0;
-	off_t pos = 0;
-	int size;
 	__u32 cur_jifs = jiffies;
 
-	size = sprintf(buf, "Dev TimeOpen   BytesOut  IdleOut    BytesIn   "
+	seq_puts(m, "Dev TimeOpen   BytesOut  IdleOut    BytesIn   "
 			"IdleIn  Overruns  Ldisc\n");
 
-	pos += size;
-	len += size;
-
 	/* Output one line for each known port */
 	for (i = 0; i < NR_CARDS; i++)
 		for (j = 0; j < cy_card[i].nports; j++) {
 			info = &cy_card[i].ports[j];
 
 			if (info->port.count)
-				size = sprintf(buf + len, "%3d %8lu %10lu %8lu "
+				seq_printf(m, "%3d %8lu %10lu %8lu "
 					"%10lu %8lu %9lu %6ld\n", info->line,
 					(cur_jifs - info->idle_stats.in_use) /
 					HZ, info->idle_stats.xmit_bytes,
@@ -5251,30 +5241,26 @@ cyclades_get_proc_info(char *buf, char *
 					/* FIXME: double check locking */
 					(long)info->port.tty->ldisc.ops->num);
 			else
-				size = sprintf(buf + len, "%3d %8lu %10lu %8lu "
+				seq_printf(m, "%3d %8lu %10lu %8lu "
 					"%10lu %8lu %9lu %6ld\n",
 					info->line, 0L, 0L, 0L, 0L, 0L, 0L, 0L);
-			len += size;
-			pos = begin + len;
-
-			if (pos < offset) {
-				len = 0;
-				begin = pos;
-			}
-			if (pos > offset + length)
-				goto done;
 		}
-	*eof = 1;
-done:
-	*start = buf + (offset - begin);	/* Start of wanted data */
-	len -= (offset - begin);	/* Start slop */
-	if (len > length)
-		len = length;	/* Ending slop */
-	if (len < 0)
-		len = 0;
-	return len;
+	return 0;
+}
+
+static int cyclades_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cyclades_proc_show, NULL);
 }
 
+static const struct file_operations cyclades_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cyclades_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /* The serial driver boot-time initialization code!
     Hardware I/O ports are mapped to character special devices on a
     first found, first allocated manner.  That is, this code searches
@@ -5311,9 +5297,9 @@ static const struct tty_operations cy_op
 	.hangup = cy_hangup,
 	.break_ctl = cy_break,
 	.wait_until_sent = cy_wait_until_sent,
-	.read_proc = cyclades_get_proc_info,
 	.tiocmget = cy_tiocmget,
 	.tiocmset = cy_tiocmset,
+	.proc_fops = &cyclades_proc_fops,
 };
 
 static int __init cy_init(void)
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

