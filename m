From: akpm@linux-foundation.org
Subject: + proc-switch-proc-bus-ecard-devices-to-seq_file-interface.patch added to -mm tree
Date: Thu, 10 Apr 2008 14:34:49 -0700
Message-ID: <200804102134.m3ALYnSr018472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757245AbYDJVgT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 17:36:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, rmk@arm.linux.org.uk, tglx@linutronix.de, yani.ioannou@gmail.com


The patch titled
     proc: switch /proc/bus/ecard/devices to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-switch-proc-bus-ecard-devices-to-seq_file-interface.patch

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
Subject: proc: switch /proc/bus/ecard/devices to seq_file interface
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Yani Ioannou <yani.ioannou@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/ecard.c |   52 ++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff -puN arch/arm/kernel/ecard.c~proc-switch-proc-bus-ecard-devices-to-seq_file-interface arch/arm/kernel/ecard.c
--- a/arch/arm/kernel/ecard.c~proc-switch-proc-bus-ecard-devices-to-seq_file-interface
+++ a/arch/arm/kernel/ecard.c
@@ -37,6 +37,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
@@ -723,17 +724,14 @@ unsigned int __ecard_address(ecard_t *ec
 	return address;
 }
 
-static int ecard_prints(char *buffer, ecard_t *ec)
+static int ecard_prints(struct seq_file *m, ecard_t *ec)
 {
-	char *start = buffer;
-
-	buffer += sprintf(buffer, "  %d: %s ", ec->slot_no,
-			  ec->easi ? "EASI" : "    ");
+	seq_printf(m, "  %d: %s ", ec->slot_no, ec->easi ? "EASI" : "    ");
 
 	if (ec->cid.id == 0) {
 		struct in_chunk_dir incd;
 
-		buffer += sprintf(buffer, "[%04X:%04X] ",
+		seq_printf(m, "[%04X:%04X] ",
 			ec->cid.manufacturer, ec->cid.product);
 
 		if (!ec->card_desc && ec->cid.cd &&
@@ -744,43 +742,43 @@ static int ecard_prints(char *buffer, ec
 				strcpy((char *)ec->card_desc, incd.d.string);
 		}
 
-		buffer += sprintf(buffer, "%s\n", ec->card_desc ? ec->card_desc : "*unknown*");
+		seq_printf(m, "%s\n", ec->card_desc ? ec->card_desc : "*unknown*");
 	} else
-		buffer += sprintf(buffer, "Simple card %d\n", ec->cid.id);
+		seq_printf(m, "Simple card %d\n", ec->cid.id);
 
-	return buffer - start;
+	return 0;
 }
 
-static int get_ecard_dev_info(char *buf, char **start, off_t pos, int count)
+static int ecard_devices_proc_show(struct seq_file *m, void *v)
 {
 	ecard_t *ec = cards;
-	off_t at = 0;
-	int len, cnt;
 
-	cnt = 0;
-	while (ec && count > cnt) {
-		len = ecard_prints(buf, ec);
-		at += len;
-		if (at >= pos) {
-			if (!*start) {
-				*start = buf + (pos - (at - len));
-				cnt = at - pos;
-			} else
-				cnt += len;
-			buf += len;
-		}
+	while (ec) {
+		ecard_prints(m, ec);
 		ec = ec->next;
 	}
-	return (count > cnt) ? cnt : count;
+	return 0;
 }
 
+static int ecard_devices_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ecard_devices_proc_show, NULL);
+}
+
+static const struct file_operations bus_ecard_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ecard_devices_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static struct proc_dir_entry *proc_bus_ecard_dir = NULL;
 
 static void ecard_proc_init(void)
 {
 	proc_bus_ecard_dir = proc_mkdir("bus/ecard", NULL);
-	create_proc_info_entry("devices", 0, proc_bus_ecard_dir,
-		get_ecard_dev_info);
+	proc_create("devices", 0, proc_bus_ecard_dir, &bus_ecard_proc_fops);
 }
 
 #define ec_set_resource(ec,nr,st,sz)				\
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

