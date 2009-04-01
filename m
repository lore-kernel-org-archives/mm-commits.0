From: akpm@linux-foundation.org
Subject: [merged] proc-tty-switch-xtensa-iss-console-to-proc_fops.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:34:03 -0700
Message-ID: <200904011834.n31IY3OW006969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762568AbZDASgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc tty: switch xtensa iss console to ->proc_fops
has been removed from the -mm tree.  Its filename was
     proc-tty-switch-xtensa-iss-console-to-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc tty: switch xtensa iss console to ->proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/platforms/iss/console.c |   29 ++++++++++++++------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff -puN arch/xtensa/platforms/iss/console.c~proc-tty-switch-xtensa-iss-console-to-proc_fops arch/xtensa/platforms/iss/console.c
--- a/arch/xtensa/platforms/iss/console.c~proc-tty-switch-xtensa-iss-console-to-proc_fops
+++ a/arch/xtensa/platforms/iss/console.c
@@ -18,6 +18,7 @@
 #include <linux/mm.h>
 #include <linux/major.h>
 #include <linux/param.h>
+#include <linux/seq_file.h>
 #include <linux/serial.h>
 #include <linux/serialP.h>
 
@@ -176,22 +177,24 @@ static void rs_wait_until_sent(struct tt
 	/* Stub, once again.. */
 }
 
-static int rs_read_proc(char *page, char **start, off_t off, int count,
-			int *eof, void *data)
+static int rs_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
-	off_t begin = 0;
-
-	len += sprintf(page, "serinfo:1.0 driver:%s\n", serial_version);
-	*eof = 1;
-
-	if (off >= len + begin)
-		return 0;
+	seq_printf(m, "serinfo:1.0 driver:%s\n", serial_version);
+	return 0;
+}
 
-	*start = page + (off - begin);
-	return ((count < begin + len - off) ? count : begin + len - off);
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
 
 static struct tty_operations serial_ops = {
 	.open = rs_open,
@@ -203,7 +206,7 @@ static struct tty_operations serial_ops 
 	.chars_in_buffer = rs_chars_in_buffer,
 	.hangup = rs_hangup,
 	.wait_until_sent = rs_wait_until_sent,
-	.read_proc = rs_read_proc
+	.proc_fops = &rs_proc_fops,
 };
 
 int __init rs_init(void)
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

