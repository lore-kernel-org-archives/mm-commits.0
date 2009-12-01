From: akpm@linux-foundation.org
Subject: + iseries-convert-to-proc_fops.patch added to -mm tree
Date: Tue, 01 Dec 2009 14:05:35 -0800
Message-ID: <200912012205.nB1M5Z3n025210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753191AbZLAWGH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 17:06:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, benh@kernel.crashing.org, michael@ellerman.id.au


The patch titled
     iseries: convert to proc_fops
has been added to the -mm tree.  Its filename is
     iseries-convert-to-proc_fops.patch

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
Subject: iseries: convert to proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/iseries/mf.c |  147 ++++++++++++++------------
 1 file changed, 83 insertions(+), 64 deletions(-)

diff -puN arch/powerpc/platforms/iseries/mf.c~iseries-convert-to-proc_fops arch/powerpc/platforms/iseries/mf.c
--- a/arch/powerpc/platforms/iseries/mf.c~iseries-convert-to-proc_fops
+++ a/arch/powerpc/platforms/iseries/mf.c
@@ -855,59 +855,58 @@ static int mf_get_boot_rtc(struct rtc_ti
 }
 
 #ifdef CONFIG_PROC_FS
-
-static int proc_mf_dump_cmdline(char *page, char **start, off_t off,
-		int count, int *eof, void *data)
+static int mf_cmdline_proc_show(struct seq_file *m, void *v)
 {
-	int len;
-	char *p;
+	char *page, *p;
 	struct vsp_cmd_data vsp_cmd;
 	int rc;
 	dma_addr_t dma_addr;
 
 	/* The HV appears to return no more than 256 bytes of command line */
-	if (off >= 256)
-		return 0;
-	if ((off + count) > 256)
-		count = 256 - off;
+	page = kmalloc(256, GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
 
-	dma_addr = iseries_hv_map(page, off + count, DMA_FROM_DEVICE);
-	if (dma_addr == DMA_ERROR_CODE)
+	dma_addr = iseries_hv_map(page, 256, DMA_FROM_DEVICE);
+	if (dma_addr == DMA_ERROR_CODE) {
+		kfree(page);
 		return -ENOMEM;
-	memset(page, 0, off + count);
+	}
+	memset(page, 0, 256);
 	memset(&vsp_cmd, 0, sizeof(vsp_cmd));
 	vsp_cmd.cmd = 33;
 	vsp_cmd.sub_data.kern.token = dma_addr;
 	vsp_cmd.sub_data.kern.address_type = HvLpDma_AddressType_TceIndex;
-	vsp_cmd.sub_data.kern.side = (u64)data;
-	vsp_cmd.sub_data.kern.length = off + count;
+	vsp_cmd.sub_data.kern.side = (u64)m->private;
+	vsp_cmd.sub_data.kern.length = 256;
 	mb();
 	rc = signal_vsp_instruction(&vsp_cmd);
-	iseries_hv_unmap(dma_addr, off + count, DMA_FROM_DEVICE);
-	if (rc)
+	iseries_hv_unmap(dma_addr, 256, DMA_FROM_DEVICE);
+	if (rc) {
+		kfree(page);
 		return rc;
-	if (vsp_cmd.result_code != 0)
+	}
+	if (vsp_cmd.result_code != 0) {
+		kfree(page);
 		return -ENOMEM;
+	}
 	p = page;
-	len = 0;
-	while (len < (off + count)) {
-		if ((*p == '\0') || (*p == '\n')) {
-			if (*p == '\0')
-				*p = '\n';
-			p++;
-			len++;
-			*eof = 1;
+	while (p - page < 256) {
+		if (*p == '\0' || *p == '\n') {
+			*p = '\n';
 			break;
 		}
 		p++;
-		len++;
-	}
 
-	if (len < off) {
-		*eof = 1;
-		len = 0;
 	}
-	return len;
+	seq_write(m, page, p - page);
+	kfree(page);
+	return 0;
+}
+
+static int mf_cmdline_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mf_cmdline_proc_show, PDE(inode)->data);
 }
 
 #if 0
@@ -962,10 +961,8 @@ static int proc_mf_dump_vmlinux(char *pa
 }
 #endif
 
-static int proc_mf_dump_side(char *page, char **start, off_t off,
-		int count, int *eof, void *data)
+static int mf_side_proc_show(struct seq_file *m, void *v)
 {
-	int len;
 	char mf_current_side = ' ';
 	struct vsp_cmd_data vsp_cmd;
 
@@ -989,21 +986,17 @@ static int proc_mf_dump_side(char *page,
 		}
 	}
 
-	len = sprintf(page, "%c\n", mf_current_side);
+	seq_printf(m, "%c\n", mf_current_side);
+	return 0;
+}
 
-	if (len <= (off + count))
-		*eof = 1;
-	*start = page + off;
-	len -= off;
-	if (len > count)
-		len = count;
-	if (len < 0)
-		len = 0;
-	return len;
+static int mf_side_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mf_side_proc_show, NULL);
 }
 
-static int proc_mf_change_side(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+static ssize_t mf_side_proc_write(struct file *file, const char __user *buffer,
+				  size_t count, loff_t *pos)
 {
 	char side;
 	u64 newSide;
@@ -1041,6 +1034,15 @@ static int proc_mf_change_side(struct fi
 	return count;
 }
 
+static const struct file_operations mf_side_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mf_side_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= mf_side_proc_write,
+};
+
 #if 0
 static void mf_getSrcHistory(char *buffer, int size)
 {
@@ -1087,8 +1089,7 @@ static void mf_getSrcHistory(char *buffe
 }
 #endif
 
-static int proc_mf_dump_src(char *page, char **start, off_t off,
-		int count, int *eof, void *data)
+static int mf_src_proc_show(struct seq_file *m, void *v)
 {
 #if 0
 	int len;
@@ -1109,8 +1110,13 @@ static int proc_mf_dump_src(char *page, 
 #endif
 }
 
-static int proc_mf_change_src(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+static int mf_src_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mf_src_proc_show, NULL);
+}
+
+static ssize_t mf_src_proc_write(struct file *file, const char __user *buffer,
+				 size_t count, loff_t *pos)
 {
 	char stkbuf[10];
 
@@ -1135,9 +1141,19 @@ static int proc_mf_change_src(struct fil
 	return count;
 }
 
-static int proc_mf_change_cmdline(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+static const struct file_operations mf_src_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mf_src_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= mf_src_proc_write,
+};
+
+static ssize_t mf_cmdline_proc_write(struct file *file, const char __user *buffer,
+				     size_t count, loff_t *pos)
 {
+	void *data = PDE(file->f_path.dentry->d_inode)->data;
 	struct vsp_cmd_data vsp_cmd;
 	dma_addr_t dma_addr;
 	char *page;
@@ -1172,6 +1188,15 @@ out:
 	return ret;
 }
 
+static const struct file_operations mf_cmdline_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mf_cmdline_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= mf_cmdline_proc_write,
+};
+
 static ssize_t proc_mf_change_vmlinux(struct file *file,
 				      const char __user *buf,
 				      size_t count, loff_t *ppos)
@@ -1246,12 +1271,10 @@ static int __init mf_proc_init(void)
 		if (!mf)
 			return 1;
 
-		ent = create_proc_entry("cmdline", S_IFREG|S_IRUSR|S_IWUSR, mf);
+		ent = proc_create_data("cmdline", S_IRUSR|S_IWUSR, mf,
+				       &mf_cmdline_proc_fops, (void *)(long)i);
 		if (!ent)
 			return 1;
-		ent->data = (void *)(long)i;
-		ent->read_proc = proc_mf_dump_cmdline;
-		ent->write_proc = proc_mf_change_cmdline;
 
 		if (i == 3)	/* no vmlinux entry for 'D' */
 			continue;
@@ -1263,19 +1286,15 @@ static int __init mf_proc_init(void)
 			return 1;
 	}
 
-	ent = create_proc_entry("side", S_IFREG|S_IRUSR|S_IWUSR, mf_proc_root);
+	ent = proc_create("side", S_IFREG|S_IRUSR|S_IWUSR, mf_proc_root,
+			  &mf_side_proc_fops);
 	if (!ent)
 		return 1;
-	ent->data = (void *)0;
-	ent->read_proc = proc_mf_dump_side;
-	ent->write_proc = proc_mf_change_side;
 
-	ent = create_proc_entry("src", S_IFREG|S_IRUSR|S_IWUSR, mf_proc_root);
+	ent = proc_create("src", S_IFREG|S_IRUSR|S_IWUSR, mf_proc_root,
+			  &mf_src_proc_fops);
 	if (!ent)
 		return 1;
-	ent->data = (void *)0;
-	ent->read_proc = proc_mf_dump_src;
-	ent->write_proc = proc_mf_change_src;
 
 	return 0;
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
thinkpad_acpi-convert-to-seq_file.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
proc_fops-convert-av7110.patch
proc_fops-convert-cpia.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
mpt-fusion-convert-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
uml-irq-register-race-condition.patch
make-debug_bugverbose-default-to-y.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
pnpbios-convert-to-seq_file.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
uml-convert-to-seq_file-proc_fops.patch
alpha-convert-srm-code-to-seq_file.patch
iseries-convert-to-proc_fops.patch
clps711xfb-convert-to-proc_fops.patch
parisc-convert-proc-pdc-lcdled-to-seq_file.patch
via-pmu-convert-to-proc_fops-seq_file.patch

