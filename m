From: akpm@linux-foundation.org
Subject: - proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:46:33 -0700
Message-ID: <200804300546.m3U5kXFi029624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760306AbYD3GMG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc: convert /proc/tty/ldiscs to seq_file interface
has been removed from the -mm tree.  Its filename was
     proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: convert /proc/tty/ldiscs to seq_file interface
From: Alexey Dobriyan <adobriyan@gmail.com>

Note: THIS_MODULE and header addition aren't technically needed because
      this code is not modular, but let's keep it anyway because people
      can copy this code into modular code.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_tty.c |   76 +++++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 31 deletions(-)

diff -puN fs/proc/proc_tty.c~proc-convert-proc-tty-ldiscs-to-seq_file-interface fs/proc/proc_tty.c
--- a/fs/proc/proc_tty.c~proc-convert-proc-tty-ldiscs-to-seq_file-interface
+++ a/fs/proc/proc_tty.c
@@ -5,7 +5,7 @@
  */
 
 #include <asm/uaccess.h>
-
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/time.h>
@@ -136,39 +136,54 @@ static const struct file_operations proc
 	.release	= seq_release,
 };
 
-/*
- * This is the handler for /proc/tty/ldiscs
- */
-static int tty_ldiscs_read_proc(char *page, char **start, off_t off,
-				int count, int *eof, void *data)
+static void * tty_ldiscs_seq_start(struct seq_file *m, loff_t *pos)
 {
-	int	i;
-	int	len = 0;
-	off_t	begin = 0;
+	return (*pos < NR_LDISCS) ? pos : NULL;
+}
+
+static void * tty_ldiscs_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return (*pos < NR_LDISCS) ? pos : NULL;
+}
+
+static void tty_ldiscs_seq_stop(struct seq_file *m, void *v)
+{
+}
+
+static int tty_ldiscs_seq_show(struct seq_file *m, void *v)
+{
+	int i = *(loff_t *)v;
 	struct tty_ldisc *ld;
 	
-	for (i=0; i < NR_LDISCS; i++) {
-		ld = tty_ldisc_get(i);
-		if (ld == NULL)
-			continue;
-		len += sprintf(page+len, "%-10s %2d\n",
-			       ld->name ? ld->name : "???", i);
-		tty_ldisc_put(i);
-		if (len+begin > off+count)
-			break;
-		if (len+begin < off) {
-			begin += len;
-			len = 0;
-		}
-	}
-	if (i >= NR_LDISCS)
-		*eof = 1;
-	if (off >= len+begin)
+	ld = tty_ldisc_get(i);
+	if (ld == NULL)
 		return 0;
-	*start = page + (off-begin);
-	return ((count < begin+len-off) ? count : begin+len-off);
+	seq_printf(m, "%-10s %2d\n", ld->name ? ld->name : "???", i);
+	tty_ldisc_put(i);
+	return 0;
+}
+
+static const struct seq_operations tty_ldiscs_seq_ops = {
+	.start	= tty_ldiscs_seq_start,
+	.next	= tty_ldiscs_seq_next,
+	.stop	= tty_ldiscs_seq_stop,
+	.show	= tty_ldiscs_seq_show,
+};
+
+static int proc_tty_ldiscs_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &tty_ldiscs_seq_ops);
 }
 
+static const struct file_operations tty_ldiscs_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_tty_ldiscs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 /*
  * This function is called by tty_register_driver() to handle
  * registering the driver's /proc handler into /proc/tty/driver/<foo>
@@ -223,8 +238,7 @@ void __init proc_tty_init(void)
 	 * password lengths and inter-keystroke timings during password
 	 * entry.
 	 */
-	proc_tty_driver = proc_mkdir_mode("tty/driver", S_IRUSR | S_IXUSR, NULL);
