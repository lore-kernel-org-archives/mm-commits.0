From: akpm@linux-foundation.org
Subject: [merged] via-pmu-convert-to-proc_fops-seq_file.patch removed from -mm tree
Date: Wed, 09 Dec 2009 11:49:54 -0800
Message-ID: <200912091949.nB9JnsqM029000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754864AbZLITuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2009 14:50:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, benh@kernel.crashing.org, galak@kernel.crashing.org, grant.likely@secretlab.ca, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     via-pmu: convert to proc_fops/seq_file
has been removed from the -mm tree.  Its filename was
     via-pmu-convert-to-proc_fops-seq_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: via-pmu: convert to proc_fops/seq_file
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/via-pmu.c |  160 +++++++++++++++++++---------------
 1 file changed, 91 insertions(+), 69 deletions(-)

diff -puN drivers/macintosh/via-pmu.c~via-pmu-convert-to-proc_fops-seq_file drivers/macintosh/via-pmu.c
--- a/drivers/macintosh/via-pmu.c~via-pmu-convert-to-proc_fops-seq_file
+++ a/drivers/macintosh/via-pmu.c
@@ -36,6 +36,7 @@
 #include <linux/spinlock.h>
 #include <linux/pm.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
@@ -186,17 +187,11 @@ static int init_pmu(void);
 static void pmu_start(void);
 static irqreturn_t via_pmu_interrupt(int irq, void *arg);
 static irqreturn_t gpio1_interrupt(int irq, void *arg);
-static int proc_get_info(char *page, char **start, off_t off,
-			  int count, int *eof, void *data);
-static int proc_get_irqstats(char *page, char **start, off_t off,
-			  int count, int *eof, void *data);
+static const struct file_operations pmu_info_proc_fops;
+static const struct file_operations pmu_irqstats_proc_fops;
 static void pmu_pass_intr(unsigned char *data, int len);
-static int proc_get_batt(char *page, char **start, off_t off,
-			int count, int *eof, void *data);
-static int proc_read_options(char *page, char **start, off_t off,
-			int count, int *eof, void *data);
-static int proc_write_options(struct file *file, const char __user *buffer,
-			unsigned long count, void *data);
+static const struct file_operations pmu_battery_proc_fops;
+static const struct file_operations pmu_options_proc_fops;
 
 #ifdef CONFIG_ADB
 struct adb_driver via_pmu_driver = {
@@ -507,19 +502,15 @@ static int __init via_pmu_dev_init(void)
 		for (i=0; i<pmu_battery_count; i++) {
 			char title[16];
 			sprintf(title, "battery_%ld", i);
-			proc_pmu_batt[i] = create_proc_read_entry(title, 0, proc_pmu_root,
-						proc_get_batt, (void *)i);
+			proc_pmu_batt[i] = proc_create_data(title, 0, proc_pmu_root,
+					&pmu_battery_proc_fops, (void *)i);
 		}
 
-		proc_pmu_info = create_proc_read_entry("info", 0, proc_pmu_root,
-					proc_get_info, NULL);
-		proc_pmu_irqstats = create_proc_read_entry("interrupts", 0, proc_pmu_root,
-					proc_get_irqstats, NULL);
-		proc_pmu_options = create_proc_entry("options", 0600, proc_pmu_root);
-		if (proc_pmu_options) {
-			proc_pmu_options->read_proc = proc_read_options;
-			proc_pmu_options->write_proc = proc_write_options;
-		}
+		proc_pmu_info = proc_create("info", 0, proc_pmu_root, &pmu_info_proc_fops);
+		proc_pmu_irqstats = proc_create("interrupts", 0, proc_pmu_root,
+						&pmu_irqstats_proc_fops);
+		proc_pmu_options = proc_create("options", 0600, proc_pmu_root,
+						&pmu_options_proc_fops);
 	}
 	return 0;
 }
@@ -799,27 +790,33 @@ query_battery_state(void)
 			2, PMU_SMART_BATTERY_STATE, pmu_cur_battery+1);
 }
 
-static int
-proc_get_info(char *page, char **start, off_t off,
-		int count, int *eof, void *data)
+static int pmu_info_proc_show(struct seq_file *m, void *v)
 {
-	char* p = page;
-
-	p += sprintf(p, "PMU driver version     : %d\n", PMU_DRIVER_VERSION);
-	p += sprintf(p, "PMU firmware version   : %02x\n", pmu_version);
-	p += sprintf(p, "AC Power               : %d\n",
+	seq_printf(m, "PMU driver version     : %d\n", PMU_DRIVER_VERSION);
+	seq_printf(m, "PMU firmware version   : %02x\n", pmu_version);
+	seq_printf(m, "AC Power               : %d\n",
 		((pmu_power_flags & PMU_PWR_AC_PRESENT) != 0) || pmu_battery_count == 0);
-	p += sprintf(p, "Battery count          : %d\n", pmu_battery_count);
+	seq_printf(m, "Battery count          : %d\n", pmu_battery_count);
+
+	return 0;
+}
 
-	return p - page;
+static int pmu_info_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pmu_info_proc_show, NULL);
 }
 
-static int
-proc_get_irqstats(char *page, char **start, off_t off,
-		  int count, int *eof, void *data)
+static const struct file_operations pmu_info_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pmu_info_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int pmu_irqstats_proc_show(struct seq_file *m, void *v)
 {
 	int i;
-	char* p = page;
 	static const char *irq_names[] = {
 		"Total CB1 triggered events",
 		"Total GPIO1 triggered events",
@@ -835,60 +832,76 @@ proc_get_irqstats(char *page, char **sta
         };
 
 	for (i=0; i<11; i++) {
-		p += sprintf(p, " %2u: %10u (%s)\n",
+		seq_printf(m, " %2u: %10u (%s)\n",
 			     i, pmu_irq_stats[i], irq_names[i]);
 	}
-	return p - page;
+	return 0;
 }
 
-static int
-proc_get_batt(char *page, char **start, off_t off,
-		int count, int *eof, void *data)
+static int pmu_irqstats_proc_open(struct inode *inode, struct file *file)
 {
-	long batnum = (long)data;
-	char *p = page;
-	
-	p += sprintf(p, "\n");
-	p += sprintf(p, "flags      : %08x\n",
-		pmu_batteries[batnum].flags);
-	p += sprintf(p, "charge     : %d\n",
-		pmu_batteries[batnum].charge);
-	p += sprintf(p, "max_charge : %d\n",
-		pmu_batteries[batnum].max_charge);
-	p += sprintf(p, "current    : %d\n",
-		pmu_batteries[batnum].amperage);
-	p += sprintf(p, "voltage    : %d\n",
-		pmu_batteries[batnum].voltage);
-	p += sprintf(p, "time rem.  : %d\n",
-		pmu_batteries[batnum].time_remaining);
+	return single_open(file, pmu_irqstats_proc_show, NULL);
+}
+
+static const struct file_operations pmu_irqstats_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pmu_irqstats_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
-	return p - page;
+static int pmu_battery_proc_show(struct seq_file *m, void *v)
+{
+	long batnum = (long)m->private;
+	
+	seq_putc(m, '\n');
+	seq_printf(m, "flags      : %08x\n", pmu_batteries[batnum].flags);
+	seq_printf(m, "charge     : %d\n", pmu_batteries[batnum].charge);
+	seq_printf(m, "max_charge : %d\n", pmu_batteries[batnum].max_charge);
+	seq_printf(m, "current    : %d\n", pmu_batteries[batnum].amperage);
+	seq_printf(m, "voltage    : %d\n", pmu_batteries[batnum].voltage);
+	seq_printf(m, "time rem.  : %d\n", pmu_batteries[batnum].time_remaining);
+	return 0;
 }
 
-static int
-proc_read_options(char *page, char **start, off_t off,
-			int count, int *eof, void *data)
+static int pmu_battery_proc_open(struct inode *inode, struct file *file)
 {
-	char *p = page;
+	return single_open(file, pmu_battery_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations pmu_battery_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pmu_battery_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
+static int pmu_options_proc_show(struct seq_file *m, void *v)
+{
 #if defined(CONFIG_SUSPEND) && defined(CONFIG_PPC32)
 	if (pmu_kind == PMU_KEYLARGO_BASED &&
 	    pmac_call_feature(PMAC_FTR_SLEEP_STATE,NULL,0,-1) >= 0)
-		p += sprintf(p, "lid_wakeup=%d\n", option_lid_wakeup);
+		seq_printf(m, "lid_wakeup=%d\n", option_lid_wakeup);
 #endif
 	if (pmu_kind == PMU_KEYLARGO_BASED)
-		p += sprintf(p, "server_mode=%d\n", option_server_mode);
+		seq_printf(m, "server_mode=%d\n", option_server_mode);
 
-	return p - page;
+	return 0;
 }
-			
-static int
-proc_write_options(struct file *file, const char __user *buffer,
-			unsigned long count, void *data)
+
+static int pmu_options_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pmu_options_proc_show, NULL);
+}
+
+static ssize_t pmu_options_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *pos)
 {
 	char tmp[33];
 	char *label, *val;
-	unsigned long fcount = count;
+	size_t fcount = count;
 	
 	if (!count)
 		return -EINVAL;
@@ -927,6 +940,15 @@ proc_write_options(struct file *file, co
 	return fcount;
 }
 
+static const struct file_operations pmu_options_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pmu_options_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= pmu_options_proc_write,
+};
+
 #ifdef CONFIG_ADB
 /* Send an ADB command */
 static int pmu_send_request(struct adb_request *req, int sync)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
bsdacct-fix-uid-gid-misreporting.patch
hfs-fix-a-potential-buffer-overflow.patch
linux-next.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
thinkpad_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file-fix.patch
iseries-convert-to-proc_fops.patch
proc_fops-convert-av7110.patch
proc_fops-convert-cpia.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
parisc-convert-proc-pdc-lcdled-to-seq_file.patch
mpt-fusion-convert-to-seq_file.patch
sysctl_max_map_count-should-be-non-negative.patch
alpha-convert-srm-code-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
uml-convert-to-seq_file-proc_fops.patch
uml-irq-register-race-condition.patch
make-debug_bugverbose-default-to-y.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
clps711xfb-convert-to-proc_fops.patch
pnpbios-convert-to-seq_file.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
proc-remove-docbook-and-example.patch
seq_file-use-proc_create-in-documentation.patch

