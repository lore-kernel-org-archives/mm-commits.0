From: akpm@linux-foundation.org
Subject: [merged] proc-tty-switch-ia64-simserial-to-proc_fops.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:34:01 -0700
Message-ID: <200904011834.n31IY1ML006960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760115AbZDATM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:12:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc tty: switch ia64 simserial to ->proc_fops
has been removed from the -mm tree.  Its filename was
     proc-tty-switch-ia64-simserial-to-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc tty: switch ia64 simserial to ->proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/sim/simserial.c |   47 ++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff -puN arch/ia64/hp/sim/simserial.c~proc-tty-switch-ia64-simserial-to-proc_fops arch/ia64/hp/sim/simserial.c
--- a/arch/ia64/hp/sim/simserial.c~proc-tty-switch-ia64-simserial-to-proc_fops
+++ a/arch/ia64/hp/sim/simserial.c
@@ -24,6 +24,7 @@
 #include <linux/major.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/capability.h>
 #include <linux/console.h>
@@ -848,38 +849,36 @@ static int rs_open(struct tty_struct *tt
  * /proc fs routines....
  */
 
-static inline int line_info(char *buf, struct serial_state *state)
+static inline void line_info(struct seq_file *m, struct serial_state *state)
 {
-	return sprintf(buf, "%d: uart:%s port:%lX irq:%d\n",
+	seq_printf(m, "%d: uart:%s port:%lX irq:%d\n",
 		       state->line, uart_config[state->type].name,
 		       state->port, state->irq);
 }
 
-static int rs_read_proc(char *page, char **start, off_t off, int count,
-		 int *eof, void *data)
+static int rs_proc_show(struct seq_file *m, void *v)
 {
-	int i, len = 0, l;
-	off_t	begin = 0;
+	int i;
 
-	len += sprintf(page, "simserinfo:1.0 driver:%s\n", serial_version);
-	for (i = 0; i < NR_PORTS && len < 4000; i++) {
-		l = line_info(page + len, &rs_table[i]);
-		len += l;
-		if (len+begin > off+count)
-			goto done;
-		if (len+begin < off) {
-			begin += len;
-			len = 0;
-		}
-	}
-	*eof = 1;
-done:
-	if (off >= len+begin)
-		return 0;
-	*start = page + (begin-off);
-	return ((count < begin+len-off) ? count : begin+len-off);
+	seq_printf(m, "simserinfo:1.0 driver:%s\n", serial_version);
+	for (i = 0; i < NR_PORTS; i++)
+		line_info(m, &rs_table[i]);
+	return 0;
 }
 
+static int rs_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rs_proc_show, NULL);
+}
+
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
@@ -917,7 +916,7 @@ static const struct tty_operations hp_op
 	.start = rs_start,
 	.hangup = rs_hangup,
 	.wait_until_sent = rs_wait_until_sent,
-	.read_proc = rs_read_proc,
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

