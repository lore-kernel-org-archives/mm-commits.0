From: akpm@linux-foundation.org
Subject: + proc_fops-convert-av7110.patch added to -mm tree
Date: Tue, 24 Nov 2009 12:50:53 -0800
Message-ID: <200911242050.nAOKorll016175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932736AbZKXUuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 15:50:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, mchehab@infradead.org


The patch titled
     proc_fops: convert av7110
has been added to the -mm tree.  Its filename is
     proc_fops-convert-av7110.patch

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
proc_fops-convert-av7110.patch
proc_fops-convert-cpia.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
uml-irq-register-race-condition.patch
make-debug_bugverbose-default-to-y.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch

