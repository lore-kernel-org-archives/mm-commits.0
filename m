From: akpm@linux-foundation.org
Subject: [merged] proc_fops-convert-av7110.patch removed from -mm tree
Date: Thu, 14 Jan 2010 13:20:39 -0800
Message-ID: <201001142120.o0ELKdQh031614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754790Ab0ANVVV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 16:21:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     proc_fops: convert av7110
has been removed from the -mm tree.  Its filename was
     proc_fops-convert-av7110.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc_fops: convert av7110
From: Alexey Dobriyan <adobriyan@gmail.com>

Drop S_IRUGO, proc entry doesn't contain read hooks.
Drop S_IFREG, simply unnecessary.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/ttpci/av7110_ir.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/media/dvb/ttpci/av7110_ir.c~proc_fops-convert-av7110 drivers/media/dvb/ttpci/av7110_ir.c
--- a/drivers/media/dvb/ttpci/av7110_ir.c~proc_fops-convert-av7110
+++ a/drivers/media/dvb/ttpci/av7110_ir.c
@@ -268,8 +268,8 @@ int av7110_check_ir_config(struct av7110
 
 
 /* /proc/av7110_ir interface */
-static int av7110_ir_write_proc(struct file *file, const char __user *buffer,
-				unsigned long count, void *data)
+static ssize_t av7110_ir_proc_write(struct file *file, const char __user *buffer,
+				    size_t count, loff_t *pos)
 {
 	char *page;
 	u32 ir_config;
@@ -309,6 +309,10 @@ static int av7110_ir_write_proc(struct f
 	return count;
 }
 
+static const struct file_operations av7110_ir_proc_fops = {
+	.owner		= THIS_MODULE,
+	.write		= av7110_ir_proc_write,
+};
 
 /* interrupt handler */
 static void ir_handler(struct av7110 *av7110, u32 ircom)
@@ -368,11 +372,9 @@ int __devinit av7110_ir_init(struct av71
 	input_dev->timer.data = (unsigned long) &av7110->ir;
 
 	if (av_cnt == 1) {
-		e = create_proc_entry("av7110_ir", S_IFREG | S_IRUGO | S_IWUSR, NULL);
-		if (e) {
-			e->write_proc = av7110_ir_write_proc;
+		e = proc_create("av7110_ir", S_IWUSR, NULL, &av7110_ir_proc_fops);
+		if (e)
 			e->size = 4 + 256 * sizeof(u16);
-		}
 	}
 
 	tasklet_init(&av7110->ir.ir_tasklet, av7110_emit_key, (unsigned long) &av7110->ir);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
mpt-fusion-convert-to-seq_file.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch

