From: akpm@linux-foundation.org
Subject: + proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch added to -mm tree
Date: Mon, 14 Apr 2008 23:38:22 -0700
Message-ID: <200804150638.m3F6cMq9015084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436AbYDOGjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 02:39:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     proc: convert /proc/tty/ldiscs to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -221,8 +236,7 @@ void __init proc_tty_init(void)
 	 * password lengths and inter-keystroke timings during password
 	 * entry.
 	 */
-	proc_tty_driver = proc_mkdir_mode("tty/driver", S_IRUSR | S_IXUSR, NULL);
-
-	create_proc_read_entry("tty/ldiscs", 0, NULL, tty_ldiscs_read_proc, NULL);
+	proc_tty_driver = proc_mkdir_mode("tty/driver", S_IRUSR|S_IXUSR, NULL);
+	proc_create("tty/ldiscs", 0, NULL, &tty_ldiscs_proc_fops);
 	proc_create("tty/drivers", 0, NULL, &proc_tty_drivers_operations);
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

fbdev-fix-proc-fb-oops-after-module-removal.patch
v4l-fix-concurrent-read-from-proc-videocodecs.patch
tags-add-menuconfig-symbols-as-well.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
remove-the-macro-get_personality.patch
nv-drop-useless-module-ifdefs.patch
nv-drop-useless-config_pci-checks.patch
nv-fix-sparse-noise.patch
fb-convert-proc-fb-to-seq_file-interface.patch
fb-convert-proc-fb-to-seq_file-interface-checkpatch-fixes.patch
ipmi-remove-write_proc-code.patch
procfs-mem-permission-cleanup.patch
proc-simplify-locking-in-remove_proc_entry.patch
proc-less-special-case-in-xlate-code.patch
proc-drop-several-pde-valid-invalid-checks.patch
proc-remove-proc_bus.patch
proc-remove-proc_root_fs.patch
proc-remove-proc_root_driver.patch
proc-remove-proc_root-from-drivers.patch
proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

