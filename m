From: akpm@linux-foundation.org
Subject: + proc-switch-proc-scsi-device_info-to-seq_file-interface.patch added to -mm tree
Date: Thu, 10 Apr 2008 14:35:01 -0700
Message-ID: <200804102135.m3ALZ2Kk018559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756803AbYDJVmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 17:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, James.Bottomley@SteelEye.com, matthew@wil.cx, michaelc@cs.wisc.edu


The patch titled
     proc: switch /proc/scsi/device_info to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-switch-proc-scsi-device_info-to-seq_file-interface.patch

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
Subject: proc: switch /proc/scsi/device_info to seq_file interface
From: Alexey Dobriyan <adobriyan@sw.ru>

Note 1: 0644 should be used, but root bypasses permissions, so writing
	to /proc/scsi/device_info still works.
Note 2: looks like scsi_dev_info_list is unprotected
Note 3: probably make proc whine about "unwriteable but with ->write hook"
	entries. Probably.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_devinfo.c |   77 +++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 33 deletions(-)

diff -puN drivers/scsi/scsi_devinfo.c~proc-switch-proc-scsi-device_info-to-seq_file-interface drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c~proc-switch-proc-scsi-device_info-to-seq_file-interface
+++ a/drivers/scsi/scsi_devinfo.c
@@ -449,37 +449,40 @@ int scsi_get_device_flags(struct scsi_de
 }
 
 #ifdef CONFIG_SCSI_PROC_FS
-/* 
- * proc_scsi_dev_info_read: dump the scsi_dev_info_list via
- * /proc/scsi/device_info
- */
-static int proc_scsi_devinfo_read(char *buffer, char **start,
-				  off_t offset, int length)
+static int devinfo_seq_show(struct seq_file *m, void *v)
 {
-	struct scsi_dev_info_list *devinfo;
-	int size, len = 0;
-	off_t begin = 0;
-	off_t pos = 0;
+	struct scsi_dev_info_list *devinfo =
+		list_entry(v, struct scsi_dev_info_list, dev_info_list);
 
-	list_for_each_entry(devinfo, &scsi_dev_info_list, dev_info_list) {
-		size = sprintf(buffer + len, "'%.8s' '%.16s' 0x%x\n",
+	seq_printf(m, "'%.8s' '%.16s' 0x%x\n",
 			devinfo->vendor, devinfo->model, devinfo->flags);
-		len += size;
-		pos = begin + len;
-		if (pos < offset) {
-			len = 0;
-			begin = pos;
-		}
-		if (pos > offset + length)
-			goto stop_output;
-	}
+	return 0;
+}
 
-stop_output:
-	*start = buffer + (offset - begin);	/* Start of wanted data */
-	len -= (offset - begin);	/* Start slop */
-	if (len > length)
-		len = length;	/* Ending slop */
-	return (len);
+static void * devinfo_seq_start(struct seq_file *m, loff_t *pos)
+{
+	return seq_list_start(&scsi_dev_info_list, *pos);
+}
+
+static void * devinfo_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	return seq_list_next(v, &scsi_dev_info_list, pos);
+}
+
+static void devinfo_seq_stop(struct seq_file *m, void *v)
+{
+}
+
+static const struct seq_operations scsi_devinfo_seq_ops = {
+	.start	= devinfo_seq_start,
+	.next	= devinfo_seq_next,
+	.stop	= devinfo_seq_stop,
+	.show	= devinfo_seq_show,
+};
+
+static int proc_scsi_devinfo_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &scsi_devinfo_seq_ops);
 }
 
 /* 
@@ -489,11 +492,12 @@ stop_output:
  * integer value of flag to the scsi device info list.
  * To use, echo "vendor:model:flag" > /proc/scsi/device_info
  */
-static int proc_scsi_devinfo_write(struct file *file, const char __user *buf,
-				   unsigned long length, void *data)
+static ssize_t proc_scsi_devinfo_write(struct file *file,
+				       const char __user *buf,
+				       size_t length, loff_t *ppos)
 {
 	char *buffer;
-	int err = length;
+	ssize_t err = length;
 
 	if (!buf || length>PAGE_SIZE)
 		return -EINVAL;
@@ -517,6 +521,15 @@ out:
 	free_page((unsigned long)buffer);
 	return err;
 }
+
+static const struct file_operations scsi_devinfo_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_scsi_devinfo_open,
+	.read		= seq_read,
+	.write		= proc_scsi_devinfo_write,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
 #endif /* CONFIG_SCSI_PROC_FS */
 
 module_param_string(dev_flags, scsi_dev_flags, sizeof(scsi_dev_flags), 0);
@@ -577,15 +590,13 @@ int __init scsi_init_devinfo(void)
 	}
 
 #ifdef CONFIG_SCSI_PROC_FS
-	p = create_proc_entry("scsi/device_info", 0, NULL);
+	p = proc_create("scsi/device_info", 0, NULL, &scsi_devinfo_proc_fops);
 	if (!p) {
 		error = -ENOMEM;
 		goto out;
 	}
 
 	p->owner = THIS_MODULE;
-	p->get_info = proc_scsi_devinfo_read;
-	p->write_proc = proc_scsi_devinfo_write;
 #endif /* CONFIG_SCSI_PROC_FS */
 
  out:
_

Patches currently in -mm which might be from adobriyan@sw.ru are

git-x86.patch
git-net.patch
git-cryptodev.patch
keys-switch-to-proc_create.patch
proc-print-more-information-when-removing-non-empty-directories.patch
proc-switch-to-proc_create.patch
proc-switch-proc-driver-ray_cs-ray_cs-to-seq_file-interface.patch
proc-switch-proc-driver-radio-typhoon-to-seq_file-interface.patch
proc-switch-proc-bus-zorro-devices-to-seq_file-interface.patch
proc-switch-proc-apm-to-seq_file-interface.patch
proc-remove-proc-mac_iop.patch
proc-switch-proc-bus-ecard-devices-to-seq_file-interface.patch
proc-switch-proc-excite-unit_id-to-seq_file-interface.patch
proc-switch-proc-irda-irnet-to-seq_file-interface.patch
proc-convert-proc-bus-nubus-to-seq_file-interface.patch
proc-switch-proc-ip2mem-to-seq_file-interface.patch
proc-switch-proc-scsi-device_info-to-seq_file-interface.patch
proc-remove-get_info-infrastructure.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
single_open-seq_release-leak-diagnostics.patch

