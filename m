From: akpm@linux-foundation.org
Subject: + viafb-switch-to-seq_file.patch added to -mm tree
Date: Thu, 03 Sep 2009 15:32:48 -0700
Message-ID: <200909032232.n83MWm56010500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932070AbZICWcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Sep 2009 18:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: switch to seq_file
has been added to the -mm tree.  Its filename is
     viafb-switch-to-seq_file.patch

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
Subject: viafb: switch to seq_file
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |  179 ++++++++++++++++++++-------------
 1 file changed, 110 insertions(+), 69 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-switch-to-seq_file drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-switch-to-seq_file
+++ a/drivers/video/via/viafbdev.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/seq_file.h>
 #define _MASTER_FILE
 
 #include "global.h"
@@ -1479,10 +1480,8 @@ static void parse_dvi_port(void)
  * DVP1Driving, DFPHigh, DFPLow CR96,   SR2A[5], SR1B[1], SR2A[4], SR1E[2],
  * CR9B,    SR65,    CR97,    CR99
  */
-static int viafb_dvp0_proc_read(char *buf, char **start, off_t offset,
-int count, int *eof, void *data)
+static int viafb_dvp0_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
 	u8 dvp0_data_dri = 0, dvp0_clk_dri = 0, dvp0 = 0;
 	dvp0_data_dri =
 	    (viafb_read_reg(VIASR, SR2A) & BIT5) >> 4 |
@@ -1491,13 +1490,17 @@ int count, int *eof, void *data)
 	    (viafb_read_reg(VIASR, SR2A) & BIT4) >> 3 |
 	    (viafb_read_reg(VIASR, SR1E) & BIT2) >> 2;
 	dvp0 = viafb_read_reg(VIACR, CR96) & 0x0f;
-	len +=
-	    sprintf(buf + len, "%x %x %x\n", dvp0, dvp0_data_dri, dvp0_clk_dri);
-	*eof = 1;		/*Inform kernel end of data */
-	return len;
+	seq_printf(m, "%x %x %x\n", dvp0, dvp0_data_dri, dvp0_clk_dri);
+	return 0;
 }
-static int viafb_dvp0_proc_write(struct file *file,
-	const char __user *buffer, unsigned long count, void *data)
+
+static int viafb_dvp0_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, viafb_dvp0_proc_show, NULL);
+}
+
+static ssize_t viafb_dvp0_proc_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[20], *value, *pbuf;
 	u8 reg_val = 0;
@@ -1541,21 +1544,33 @@ static int viafb_dvp0_proc_write(struct 
 	}
 	return count;
 }
-static int viafb_dvp1_proc_read(char *buf, char **start, off_t offset,
-	int count, int *eof, void *data)
+
+static const struct file_operations viafb_dvp0_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= viafb_dvp0_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= viafb_dvp0_proc_write,
+};
+
+static int viafb_dvp1_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
 	u8 dvp1 = 0, dvp1_data_dri = 0, dvp1_clk_dri = 0;
 	dvp1 = viafb_read_reg(VIACR, CR9B) & 0x0f;
 	dvp1_data_dri = (viafb_read_reg(VIASR, SR65) & 0x0c) >> 2;
 	dvp1_clk_dri = viafb_read_reg(VIASR, SR65) & 0x03;
-	len +=
-	    sprintf(buf + len, "%x %x %x\n", dvp1, dvp1_data_dri, dvp1_clk_dri);
-	*eof = 1;		/*Inform kernel end of data */
-	return len;
+	seq_printf(m, "%x %x %x\n", dvp1, dvp1_data_dri, dvp1_clk_dri);
+	return 0;
+}
+
+static int viafb_dvp1_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, viafb_dvp1_proc_show, NULL);
 }
-static int viafb_dvp1_proc_write(struct file *file,
-	const char __user *buffer, unsigned long count, void *data)
+
+static ssize_t viafb_dvp1_proc_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[20], *value, *pbuf;
 	u8 reg_val = 0;
@@ -1594,18 +1609,30 @@ static int viafb_dvp1_proc_write(struct 
 	return count;
 }
 
-static int viafb_dfph_proc_read(char *buf, char **start, off_t offset,
-	int count, int *eof, void *data)
+static const struct file_operations viafb_dvp1_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= viafb_dvp1_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= viafb_dvp1_proc_write,
+};
+
+static int viafb_dfph_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
 	u8 dfp_high = 0;
 	dfp_high = viafb_read_reg(VIACR, CR97) & 0x0f;
-	len += sprintf(buf + len, "%x\n", dfp_high);
-	*eof = 1;		/*Inform kernel end of data */
-	return len;
+	seq_printf(m, "%x\n", dfp_high);
+	return 0;
 }
-static int viafb_dfph_proc_write(struct file *file,
-	const char __user *buffer, unsigned long count, void *data)
+
+static int viafb_dfph_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, viafb_dfph_proc_show, NULL);
+}
+
+static ssize_t viafb_dfph_proc_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[20];
 	u8 reg_val = 0;
@@ -1620,18 +1647,31 @@ static int viafb_dfph_proc_write(struct 
 	viafb_write_reg_mask(CR97, VIACR, reg_val, 0x0f);
 	return count;
 }
-static int viafb_dfpl_proc_read(char *buf, char **start, off_t offset,
-	int count, int *eof, void *data)
+
+static const struct file_operations viafb_dfph_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= viafb_dfph_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= viafb_dfph_proc_write,
+};
+
+static int viafb_dfpl_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
 	u8 dfp_low = 0;
 	dfp_low = viafb_read_reg(VIACR, CR99) & 0x0f;
-	len += sprintf(buf + len, "%x\n", dfp_low);
-	*eof = 1;		/*Inform kernel end of data */
-	return len;
+	seq_printf(m, "%x\n", dfp_low);
+	return 0;
+}
+
+static int viafb_dfpl_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, viafb_dfpl_proc_show, NULL);
 }
-static int viafb_dfpl_proc_write(struct file *file,
-	const char __user *buffer, unsigned long count, void *data)
+
+static ssize_t viafb_dfpl_proc_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[20];
 	u8 reg_val = 0;
@@ -1646,10 +1686,18 @@ static int viafb_dfpl_proc_write(struct 
 	viafb_write_reg_mask(CR99, VIACR, reg_val, 0x0f);
 	return count;
 }
-static int viafb_vt1636_proc_read(char *buf, char **start,
-	off_t offset, int count, int *eof, void *data)
+
+static const struct file_operations viafb_dfpl_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= viafb_dfpl_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= viafb_dfpl_proc_write,
+};
+
+static int viafb_vt1636_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
 	u8 vt1636_08 = 0, vt1636_09 = 0;
 	switch (viaparinfo->chip_info->lvds_chip_info.lvds_chip_name) {
 	case VT1636_LVDS:
@@ -1659,7 +1707,7 @@ static int viafb_vt1636_proc_read(char *
 		vt1636_09 =
 		    viafb_gpio_i2c_read_lvds(viaparinfo->lvds_setting_info,
 		    &viaparinfo->chip_info->lvds_chip_info, 0x09) & 0x1f;
-		len += sprintf(buf + len, "%x %x\n", vt1636_08, vt1636_09);
+		seq_printf(m, "%x %x\n", vt1636_08, vt1636_09);
 		break;
 	default:
 		break;
@@ -1672,16 +1720,21 @@ static int viafb_vt1636_proc_read(char *
 		vt1636_09 =
 		    viafb_gpio_i2c_read_lvds(viaparinfo->lvds_setting_info2,
 			&viaparinfo->chip_info->lvds_chip_info2, 0x09) & 0x1f;
-		len += sprintf(buf + len, " %x %x\n", vt1636_08, vt1636_09);
+		seq_printf(m, " %x %x\n", vt1636_08, vt1636_09);
 		break;
 	default:
 		break;
 	}
-	*eof = 1;		/*Inform kernel end of data */
-	return len;
+	return 0;
+}
+
+static int viafb_vt1636_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, viafb_vt1636_proc_show, NULL);
 }
-static int viafb_vt1636_proc_write(struct file *file,
-	const char __user *buffer, unsigned long count, void *data)
+
+static ssize_t viafb_vt1636_proc_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[30], *value, *pbuf;
 	struct IODATA reg_val;
@@ -1770,39 +1823,27 @@ static int viafb_vt1636_proc_write(struc
 	return count;
 }
 
+static const struct file_operations viafb_vt1636_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= viafb_vt1636_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= viafb_vt1636_proc_write,
+};
+
 static void viafb_init_proc(struct proc_dir_entry **viafb_entry)
 {
-	struct proc_dir_entry *entry;
 	*viafb_entry = proc_mkdir("viafb", NULL);
 	if (viafb_entry) {
-		entry = create_proc_entry("dvp0", 0, *viafb_entry);
-		if (entry) {
-			entry->read_proc = viafb_dvp0_proc_read;
-			entry->write_proc = viafb_dvp0_proc_write;
-		}
-		entry = create_proc_entry("dvp1", 0, *viafb_entry);
-		if (entry) {
-			entry->read_proc = viafb_dvp1_proc_read;
-			entry->write_proc = viafb_dvp1_proc_write;
-		}
-		entry = create_proc_entry("dfph", 0, *viafb_entry);
-		if (entry) {
-			entry->read_proc = viafb_dfph_proc_read;
-			entry->write_proc = viafb_dfph_proc_write;
-		}
-		entry = create_proc_entry("dfpl", 0, *viafb_entry);
-		if (entry) {
-			entry->read_proc = viafb_dfpl_proc_read;
-			entry->write_proc = viafb_dfpl_proc_write;
-		}
+		proc_create("dvp0", 0, *viafb_entry, &viafb_dvp0_proc_fops);
+		proc_create("dvp1", 0, *viafb_entry, &viafb_dvp1_proc_fops);
+		proc_create("dfph", 0, *viafb_entry, &viafb_dfph_proc_fops);
+		proc_create("dfpl", 0, *viafb_entry, &viafb_dfpl_proc_fops);
 		if (VT1636_LVDS == viaparinfo->chip_info->lvds_chip_info.
 			lvds_chip_name || VT1636_LVDS ==
 		    viaparinfo->chip_info->lvds_chip_info2.lvds_chip_name) {
-			entry = create_proc_entry("vt1636", 0, *viafb_entry);
-			if (entry) {
-				entry->read_proc = viafb_vt1636_proc_read;
-				entry->write_proc = viafb_vt1636_proc_write;
-			}
+			proc_create("vt1636", 0, *viafb_entry, &viafb_vt1636_proc_fops);
 		}
 
 	}
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
acpi-switch-proc-acpi-debug_layerdebug_level-to-seq_file.patch
pcmcia-switch-proc-bus-pccard-drivers-to-seq_file.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
kernel-profilec-switch-proc-irq-prof_cpu_mask-to-seq_file.patch
cpqarray-switch-to-seq_file.patch
dac960-switch-to-seq_file.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
viafb-switch-to-seq_file.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch
gru-use-proc_create.patch

