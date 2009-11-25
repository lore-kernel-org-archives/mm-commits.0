From: akpm@linux-foundation.org
Subject: + pnpbios-convert-to-seq_file.patch added to -mm tree
Date: Wed, 25 Nov 2009 13:11:59 -0800
Message-ID: <200911252111.nAPLBxJE018209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935063AbZKYVMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 16:12:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, abelay@mit.edu, bjorn.helgaas@hp.com


The patch titled
     pnpbios: convert to seq_file
has been added to the -mm tree.  Its filename is
     pnpbios-convert-to-seq_file.patch

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
Subject: pnpbios: convert to seq_file
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Adam Belay <abelay@mit.edu>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpbios/proc.c |  204 ++++++++++++++++++++++-------------
 1 file changed, 129 insertions(+), 75 deletions(-)

diff -puN drivers/pnp/pnpbios/proc.c~pnpbios-convert-to-seq_file drivers/pnp/pnpbios/proc.c
--- a/drivers/pnp/pnpbios/proc.c~pnpbios-convert-to-seq_file
+++ a/drivers/pnp/pnpbios/proc.c
@@ -24,6 +24,7 @@
 #include <linux/types.h>
 #include <linux/proc_fs.h>
 #include <linux/pnp.h>
+#include <linux/seq_file.h>
 #include <linux/init.h>
 
 #include <asm/uaccess.h>
@@ -33,42 +34,65 @@
 static struct proc_dir_entry *proc_pnp = NULL;
 static struct proc_dir_entry *proc_pnp_boot = NULL;
 
-static int proc_read_pnpconfig(char *buf, char **start, off_t pos,
-			       int count, int *eof, void *data)
+static int pnpconfig_proc_show(struct seq_file *m, void *v)
 {
 	struct pnp_isa_config_struc pnps;
 
 	if (pnp_bios_isapnp_config(&pnps))
 		return -EIO;
-	return snprintf(buf, count,
-			"structure_revision %d\n"
-			"number_of_CSNs %d\n"
-			"ISA_read_data_port 0x%x\n",
-			pnps.revision, pnps.no_csns, pnps.isa_rd_data_port);
+	seq_printf(m, "structure_revision %d\n"
+		      "number_of_CSNs %d\n"
+		      "ISA_read_data_port 0x%x\n",
+		   pnps.revision, pnps.no_csns, pnps.isa_rd_data_port);
+	return 0;
 }
 
-static int proc_read_escdinfo(char *buf, char **start, off_t pos,
-			      int count, int *eof, void *data)
+static int pnpconfig_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pnpconfig_proc_show, NULL);
+}
+
+static const struct file_operations pnpconfig_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pnpconfig_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int escd_info_proc_show(struct seq_file *m, void *v)
 {
 	struct escd_info_struc escd;
 
 	if (pnp_bios_escd_info(&escd))
 		return -EIO;
-	return snprintf(buf, count,
-			"min_ESCD_write_size %d\n"
+	seq_printf(m, "min_ESCD_write_size %d\n"
 			"ESCD_size %d\n"
 			"NVRAM_base 0x%x\n",
 			escd.min_escd_write_size,
 			escd.escd_size, escd.nv_storage_base);
+	return 0;
 }
 
+static int escd_info_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, escd_info_proc_show, NULL);
+}
+
+static const struct file_operations escd_info_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= escd_info_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 #define MAX_SANE_ESCD_SIZE (32*1024)
-static int proc_read_escd(char *buf, char **start, off_t pos,
-			  int count, int *eof, void *data)
+static int escd_proc_show(struct seq_file *m, void *v)
 {
 	struct escd_info_struc escd;
 	char *tmpbuf;
-	int escd_size, escd_left_to_read, n;
+	int escd_size;
 
 	if (pnp_bios_escd_info(&escd))
 		return -EIO;
@@ -76,7 +100,7 @@ static int proc_read_escd(char *buf, cha
 	/* sanity check */
 	if (escd.escd_size > MAX_SANE_ESCD_SIZE) {
 		printk(KERN_ERR
-		       "PnPBIOS: proc_read_escd: ESCD size reported by BIOS escd_info call is too great\n");
+		       "PnPBIOS: %s: ESCD size reported by BIOS escd_info call is too great\n", __func__);
 		return -EFBIG;
 	}
 
@@ -94,56 +118,75 @@ static int proc_read_escd(char *buf, cha
 
 	/* sanity check */
 	if (escd_size > MAX_SANE_ESCD_SIZE) {
-		printk(KERN_ERR "PnPBIOS: proc_read_escd: ESCD size reported by"
-				" BIOS read_escd call is too great\n");
+		printk(KERN_ERR "PnPBIOS: %s: ESCD size reported by"
+				" BIOS read_escd call is too great\n", __func__);
 		kfree(tmpbuf);
 		return -EFBIG;
 	}
 
-	escd_left_to_read = escd_size - pos;
-	if (escd_left_to_read < 0)
-		escd_left_to_read = 0;
-	if (escd_left_to_read == 0)
-		*eof = 1;
-	n = min(count, escd_left_to_read);
-	memcpy(buf, tmpbuf + pos, n);
+	seq_write(m, tmpbuf, escd_size);
 	kfree(tmpbuf);
-	*start = buf;
-	return n;
+	return 0;
 }
 
-static int proc_read_legacyres(char *buf, char **start, off_t pos,
-			       int count, int *eof, void *data)
+static int escd_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, escd_proc_show, NULL);
+}
+
+static const struct file_operations escd_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= escd_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int pnp_legacyres_proc_show(struct seq_file *m, void *v)
 {
-	/* Assume that the following won't overflow the buffer */
-	if (pnp_bios_get_stat_res(buf))
+	void *buf;
+
+	buf = kmalloc(65536, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	if (pnp_bios_get_stat_res(buf)) {
+		kfree(buf);
 		return -EIO;
+	}
+
+	seq_write(m, buf, 65536);
+	kfree(buf);
+	return 0;
+}
 
-	return count;		// FIXME: Return actual length
+static int pnp_legacyres_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pnp_legacyres_proc_show, NULL);
 }
 
-static int proc_read_devices(char *buf, char **start, off_t pos,
-			     int count, int *eof, void *data)
+static const struct file_operations pnp_legacyres_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pnp_legacyres_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int pnp_devices_proc_show(struct seq_file *m, void *v)
 {
 	struct pnp_bios_node *node;
 	u8 nodenum;
-	char *p = buf;
-
-	if (pos >= 0xff)
-		return 0;
 
 	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node)
 		return -ENOMEM;
 
-	for (nodenum = pos; nodenum < 0xff;) {
+	for (nodenum = 0; nodenum < 0xff;) {
 		u8 thisnodenum = nodenum;
-		/* 26 = the number of characters per line sprintf'ed */
-		if ((p - buf + 26) > count)
-			break;
+
 		if (pnp_bios_get_dev_node(&nodenum, PNPMODE_DYNAMIC, node))
 			break;
-		p += sprintf(p, "%02x\t%08x\t%02x:%02x:%02x\t%04x\n",
+		seq_printf(m, "%02x\t%08x\t%02x:%02x:%02x\t%04x\n",
 			     node->handle, node->eisa_id,
 			     node->type_code[0], node->type_code[1],
 			     node->type_code[2], node->flags);
@@ -153,20 +196,29 @@ static int proc_read_devices(char *buf, 
 			       "PnPBIOS: proc_read_devices:",
 			       (unsigned int)nodenum,
 			       (unsigned int)thisnodenum);
-			*eof = 1;
 			break;
 		}
 	}
 	kfree(node);
-	if (nodenum == 0xff)
-		*eof = 1;
-	*start = (char *)((off_t) nodenum - pos);
-	return p - buf;
+	return 0;
+}
+
+static int pnp_devices_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pnp_devices_proc_show, NULL);
 }
 
-static int proc_read_node(char *buf, char **start, off_t pos,
-			  int count, int *eof, void *data)
+static const struct file_operations pnp_devices_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pnp_devices_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int pnpbios_proc_show(struct seq_file *m, void *v)
 {
+	void *data = m->private;
 	struct pnp_bios_node *node;
 	int boot = (long)data >> 8;
 	u8 nodenum = (long)data;
@@ -180,14 +232,20 @@ static int proc_read_node(char *buf, cha
 		return -EIO;
 	}
 	len = node->size - sizeof(struct pnp_bios_node);
-	memcpy(buf, node->data, len);
+	seq_write(m, node->data, len);
 	kfree(node);
-	return len;
+	return 0;
+}
+
+static int pnpbios_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pnpbios_proc_show, PDE(inode)->data);
 }
 
-static int proc_write_node(struct file *file, const char __user * buf,
-			   unsigned long count, void *data)
+static ssize_t pnpbios_proc_write(struct file *file, const char __user *buf,
+				  size_t count, loff_t *pos)
 {
+	void *data = PDE(file->f_path.dentry->d_inode)->data;
 	struct pnp_bios_node *node;
 	int boot = (long)data >> 8;
 	u8 nodenum = (long)data;
@@ -218,34 +276,33 @@ out:
 	return ret;
 }
 
+static const struct file_operations pnpbios_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pnpbios_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= pnpbios_proc_write,
+};
+
 int pnpbios_interface_attach_device(struct pnp_bios_node *node)
 {
 	char name[3];
-	struct proc_dir_entry *ent;
 
 	sprintf(name, "%02x", node->handle);
 
 	if (!proc_pnp)
 		return -EIO;
 	if (!pnpbios_dont_use_current_config) {
-		ent = create_proc_entry(name, 0, proc_pnp);
-		if (ent) {
-			ent->read_proc = proc_read_node;
-			ent->write_proc = proc_write_node;
-			ent->data = (void *)(long)(node->handle);
-		}
+		proc_create_data(name, 0644, proc_pnp, &pnpbios_proc_fops,
+				 (void *)(long)(node->handle));
 	}
 
 	if (!proc_pnp_boot)
 		return -EIO;
-	ent = create_proc_entry(name, 0, proc_pnp_boot);
-	if (ent) {
-		ent->read_proc = proc_read_node;
-		ent->write_proc = proc_write_node;
-		ent->data = (void *)(long)(node->handle + 0x100);
+	if (proc_create_data(name, 0644, proc_pnp_boot, &pnpbios_proc_fops,
+			     (void *)(long)(node->handle + 0x100)))
 		return 0;
-	}
-
 	return -EIO;
 }
 
@@ -262,14 +319,11 @@ int __init pnpbios_proc_init(void)
 	proc_pnp_boot = proc_mkdir("boot", proc_pnp);
 	if (!proc_pnp_boot)
 		return -EIO;
-	create_proc_read_entry("devices", 0, proc_pnp, proc_read_devices, NULL);
-	create_proc_read_entry("configuration_info", 0, proc_pnp,
-			       proc_read_pnpconfig, NULL);
-	create_proc_read_entry("escd_info", 0, proc_pnp, proc_read_escdinfo,
-			       NULL);
-	create_proc_read_entry("escd", S_IRUSR, proc_pnp, proc_read_escd, NULL);
-	create_proc_read_entry("legacy_device_resources", 0, proc_pnp,
-			       proc_read_legacyres, NULL);
+	proc_create("devices", 0, proc_pnp, &pnp_devices_proc_fops);
+	proc_create("configuration_info", 0, proc_pnp, &pnpconfig_proc_fops);
+	proc_create("escd_info", 0, proc_pnp, &escd_info_proc_fops);
+	proc_create("escd", S_IRUSR, proc_pnp, &escd_proc_fops);
+	proc_create("legacy_device_resources", 0, proc_pnp, &pnp_legacyres_proc_fops);
 
 	return 0;
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
proc_fops-convert-av7110.patch
proc_fops-convert-cpia.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
const-constify-remaining-dev_pm_ops.patch
uml-irq-register-race-condition.patch
make-debug_bugverbose-default-to-y.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
mpt-fusion-convert-to-seq_file.patch
ray_cs-convert-to-proc_fops.patch
ipw2x00-convert-to-seq_file.patch
thinkpad_acpi-convert-to-seq_file.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
pnpbios-convert-to-seq_file.patch

