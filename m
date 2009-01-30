From: akpm@linux-foundation.org
Subject: + proc-tty-switch-xtensa-iss-console-to-proc_fops.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:53:54 -0800
Message-ID: <200901302053.n0UKrsUu021620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753984AbZA3UyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:54:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     proc tty: switch xtensa iss console to ->proc_fops
has been added to the -mm tree.  Its filename is
     proc-tty-switch-xtensa-iss-console-to-proc_fops.patch

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
 
@@ -178,22 +179,24 @@ static void rs_wait_until_sent(struct tt
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
@@ -205,7 +208,7 @@ static struct tty_operations serial_ops 
 	.chars_in_buffer = rs_chars_in_buffer,
 	.hangup = rs_hangup,
 	.wait_until_sent = rs_wait_until_sent,
-	.read_proc = rs_read_proc
+	.proc_fops = &rs_proc_fops,
 };
 
 int __init rs_init(void)
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

