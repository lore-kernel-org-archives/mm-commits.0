From: akpm@linux-foundation.org
Subject: + proc-tty-switch-ia64-simserial-to-proc_fops.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:53:52 -0800
Message-ID: <200901302053.n0UKrrNl021531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754415AbZA3UyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:54:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     proc tty: switch ia64 simserial to ->proc_fops
has been added to the -mm tree.  Its filename is
     proc-tty-switch-ia64-simserial-to-proc_fops.patch

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

