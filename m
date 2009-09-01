From: akpm@linux-foundation.org
Subject: + cpqarray-switch-to-seq_file.patch added to -mm tree
Date: Tue, 01 Sep 2009 16:01:07 -0700
Message-ID: <200909012301.n81N17ch012929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbZIAXCs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Sep 2009 19:02:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, chirag.kantharia@hp.com, grant.likely@secretlab.ca, jens.axboe@oracle.com, tj@kernel.org


The patch titled
     cpqarray: switch to seq_file
has been added to the -mm tree.  Its filename is
     cpqarray-switch-to-seq_file.patch

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
Subject: cpqarray: switch to seq_file
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Chirag Kantharia <chirag.kantharia@hp.com>   
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cpqarray.c |   61 +++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

diff -puN drivers/block/cpqarray.c~cpqarray-switch-to-seq_file drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c~cpqarray-switch-to-seq_file
+++ a/drivers/block/cpqarray.c
@@ -32,6 +32,7 @@
 #include <linux/blkpg.h>
 #include <linux/timer.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/hdreg.h>
 #include <linux/spinlock.h>
@@ -177,7 +178,6 @@ static int cpqarray_register_ctlr(int ct
 
 #ifdef CONFIG_PROC_FS
 static void ida_procinit(int i);
-static int ida_proc_get_info(char *buffer, char **start, off_t offset, int length, int *eof, void *data);
 #else
 static void ida_procinit(int i) {}
 #endif
@@ -206,6 +206,7 @@ static struct block_device_operations id
 #ifdef CONFIG_PROC_FS
 
 static struct proc_dir_entry *proc_array;
+static const struct file_operations ida_proc_fops;
 
 /*
  * Get us a file in /proc/array that says something about each controller.
@@ -218,19 +219,16 @@ static void __init ida_procinit(int i)
 		if (!proc_array) return;
 	}
 
-	create_proc_read_entry(hba[i]->devname, 0, proc_array,
-			       ida_proc_get_info, hba[i]);
+	proc_create_data(hba[i]->devname, 0, proc_array, &ida_proc_fops, hba[i]);
 }
 
 /*
  * Report information about this controller.
  */
-static int ida_proc_get_info(char *buffer, char **start, off_t offset, int length, int *eof, void *data)
+static int ida_proc_show(struct seq_file *m, void *v)
 {
-	off_t pos = 0;
-	off_t len = 0;
-	int size, i, ctlr;
-	ctlr_info_t *h = (ctlr_info_t*)data;
+	int i, ctlr;
+	ctlr_info_t *h = (ctlr_info_t*)m->private;
 	drv_info_t *drv;
 #ifdef CPQ_PROC_PRINT_QUEUES
 	cmdlist_t *c;
@@ -238,7 +236,7 @@ static int ida_proc_get_info(char *buffe
 #endif
 
 	ctlr = h->ctlr;
-	size = sprintf(buffer, "%s:  Compaq %s Controller\n"
+	seq_printf(m, "%s:  Compaq %s Controller\n"
 		"       Board ID: 0x%08lx\n"
 		"       Firmware Revision: %c%c%c%c\n"
 		"       Controller Sig: 0x%08lx\n"
@@ -258,55 +256,54 @@ static int ida_proc_get_info(char *buffe
 		h->log_drives, h->phys_drives,
 		h->Qdepth, h->maxQsinceinit);
 
-	pos += size; len += size;
-	
-	size = sprintf(buffer+len, "Logical Drive Info:\n");
-	pos += size; len += size;
+	seq_puts(m, "Logical Drive Info:\n");
 
 	for(i=0; i<h->log_drives; i++) {
 		drv = &h->drv[i];
-		size = sprintf(buffer+len, "ida/c%dd%d: blksz=%d nr_blks=%d\n",
+		seq_printf(m, "ida/c%dd%d: blksz=%d nr_blks=%d\n",
 				ctlr, i, drv->blk_size, drv->nr_blks);
-		pos += size; len += size;
 	}
 
 #ifdef CPQ_PROC_PRINT_QUEUES
 	spin_lock_irqsave(IDA_LOCK(h->ctlr), flags); 
-	size = sprintf(buffer+len, "\nCurrent Queues:\n");
-	pos += size; len += size;
+	seq_puts(m, "\nCurrent Queues:\n");
 
 	c = h->reqQ;
-	size = sprintf(buffer+len, "reqQ = %p", c); pos += size; len += size;
+	seq_printf(m, "reqQ = %p", c);
 	if (c) c=c->next;
 	while(c && c != h->reqQ) {
-		size = sprintf(buffer+len, "->%p", c);
-		pos += size; len += size;
+		seq_printf(m, "->%p", c);
 		c=c->next;
 	}
 
 	c = h->cmpQ;
-	size = sprintf(buffer+len, "\ncmpQ = %p", c); pos += size; len += size;
+	seq_printf(m, "\ncmpQ = %p", c);
 	if (c) c=c->next;
 	while(c && c != h->cmpQ) {
-		size = sprintf(buffer+len, "->%p", c);
-		pos += size; len += size;
+		seq_printf(m, "->%p", c);
 		c=c->next;
 	}
 
-	size = sprintf(buffer+len, "\n"); pos += size; len += size;
+	seq_putc(m, '\n');
 	spin_unlock_irqrestore(IDA_LOCK(h->ctlr), flags); 
 #endif
-	size = sprintf(buffer+len, "nr_allocs = %d\nnr_frees = %d\n",
+	seq_printf(m, "nr_allocs = %d\nnr_frees = %d\n",
 			h->nr_allocs, h->nr_frees);
-	pos += size; len += size;
+	return 0;
+}
 
-	*eof = 1;
-	*start = buffer+offset;
-	len -= offset;
-	if (len>length)
-		len = length;
-	return len;
+static int ida_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ida_proc_show, PDE(inode)->data);
 }
+
+static const struct file_operations ida_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ida_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif /* CONFIG_PROC_FS */
 
 module_param_array(eisa, int, NULL, 0);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
pcmcia-switch-proc-bus-pccard-drivers-to-seq_file.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
kernel-profilec-switch-proc-irq-prof_cpu_mask-to-seq_file.patch
cpqarray-switch-to-seq_file.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch

