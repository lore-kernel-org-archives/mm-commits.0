From: akpm@linux-foundation.org
Subject: + asus_acpi-convert-to-seq_file.patch added to -mm tree
Date: Wed, 25 Nov 2009 13:11:54 -0800
Message-ID: <200911252111.nAPLBsPr018012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932749AbZKYVMh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 16:12:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, corentincj@iksaif.net, len.brown@intel.com, sziwan@users.sourceforge.net


The patch titled
     asus_acpi: convert to seq_file
has been added to the -mm tree.  Its filename is
     asus_acpi-convert-to-seq_file.patch

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
Subject: asus_acpi: convert to seq_file
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Karol Kozimor <sziwan@users.sourceforge.net>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/asus_acpi.c |  321 +++++++++++++++++------------
 1 file changed, 194 insertions(+), 127 deletions(-)

diff -puN drivers/platform/x86/asus_acpi.c~asus_acpi-convert-to-seq_file drivers/platform/x86/asus_acpi.c
--- a/drivers/platform/x86/asus_acpi.c~asus_acpi-convert-to-seq_file
+++ a/drivers/platform/x86/asus_acpi.c
@@ -35,6 +35,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/backlight.h>
 #include <acpi/acpi_drivers.h>
 #include <acpi/acpi_bus.h>
@@ -512,26 +513,12 @@ static int read_acpi_int(acpi_handle han
 	return (status == AE_OK) && (out_obj.type == ACPI_TYPE_INTEGER);
 }
 
-/*
- * We write our info in page, we begin at offset off and cannot write more
- * than count bytes. We set eof to 1 if we handle those 2 values. We return the
- * number of bytes written in page
- */
-static int
-proc_read_info(char *page, char **start, off_t off, int count, int *eof,
-	       void *data)
+static int asus_info_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
 	int temp;
-	char buf[16];		/* enough for all info */
-	/*
-	 * We use the easy way, we don't care of off and count,
-	 * so we don't set eof to 1
-	 */
 
-	len += sprintf(page, ACPI_HOTK_NAME " " ASUS_ACPI_VERSION "\n");
-	len += sprintf(page + len, "Model reference    : %s\n",
-		       hotk->methods->name);
+	seq_printf(m, ACPI_HOTK_NAME " " ASUS_ACPI_VERSION "\n");
+	seq_printf(m, "Model reference    : %s\n", hotk->methods->name);
 	/*
 	 * The SFUN method probably allows the original driver to get the list
 	 * of features supported by a given model. For now, 0x0100 or 0x0800
@@ -539,8 +526,7 @@ proc_read_info(char *page, char **start,
 	 * The significance of others is yet to be found.
 	 */
 	if (read_acpi_int(hotk->handle, "SFUN", &temp))
-		len +=
-		    sprintf(page + len, "SFUN value         : 0x%04x\n", temp);
+		seq_printf(m, "SFUN value         : 0x%04x\n", temp);
 	/*
 	 * Another value for userspace: the ASYM method returns 0x02 for
 	 * battery low and 0x04 for battery critical, its readings tend to be
@@ -549,30 +535,34 @@ proc_read_info(char *page, char **start,
 	 * silently ignored.
 	 */
 	if (read_acpi_int(hotk->handle, "ASYM", &temp))
-		len +=
-		    sprintf(page + len, "ASYM value         : 0x%04x\n", temp);
+		seq_printf(m, "ASYM value         : 0x%04x\n", temp);
 	if (asus_info) {
-		snprintf(buf, 16, "%d", asus_info->length);
-		len += sprintf(page + len, "DSDT length        : %s\n", buf);
-		snprintf(buf, 16, "%d", asus_info->checksum);
-		len += sprintf(page + len, "DSDT checksum      : %s\n", buf);
-		snprintf(buf, 16, "%d", asus_info->revision);
-		len += sprintf(page + len, "DSDT revision      : %s\n", buf);
-		snprintf(buf, 7, "%s", asus_info->oem_id);
-		len += sprintf(page + len, "OEM id             : %s\n", buf);
-		snprintf(buf, 9, "%s", asus_info->oem_table_id);
-		len += sprintf(page + len, "OEM table id       : %s\n", buf);
-		snprintf(buf, 16, "%x", asus_info->oem_revision);
-		len += sprintf(page + len, "OEM revision       : 0x%s\n", buf);
-		snprintf(buf, 5, "%s", asus_info->asl_compiler_id);
-		len += sprintf(page + len, "ASL comp vendor id : %s\n", buf);
-		snprintf(buf, 16, "%x", asus_info->asl_compiler_revision);
-		len += sprintf(page + len, "ASL comp revision  : 0x%s\n", buf);
+		seq_printf(m, "DSDT length        : %d\n", asus_info->length);
+		seq_printf(m, "DSDT checksum      : %d\n", asus_info->checksum);
+		seq_printf(m, "DSDT revision      : %d\n", asus_info->revision);
+		seq_printf(m, "OEM id             : %.*s\n", ACPI_OEM_ID_SIZE, asus_info->oem_id);
+		seq_printf(m, "OEM table id       : %.*s\n", ACPI_OEM_TABLE_ID_SIZE, asus_info->oem_table_id);
+		seq_printf(m, "OEM revision       : 0x%x\n", asus_info->oem_revision);
+		seq_printf(m, "ASL comp vendor id : %.*s\n", ACPI_NAME_SIZE, asus_info->asl_compiler_id);
+		seq_printf(m, "ASL comp revision  : 0x%x\n", asus_info->asl_compiler_revision);
 	}
 
-	return len;
+	return 0;
+}
+
+static int asus_info_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, asus_info_proc_show, NULL);
 }
 
+static const struct file_operations asus_info_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= asus_info_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*
  * /proc handlers
  * We write our info in page, we begin at offset off and cannot write more
@@ -638,34 +628,48 @@ write_led(const char __user *buffer, uns
 /*
  * Proc handlers for MLED
  */
-static int
-proc_read_mled(char *page, char **start, off_t off, int count, int *eof,
-	       void *data)
+static int mled_proc_show(struct seq_file *m, void *v)
 {
-	return sprintf(page, "%d\n",
-		       read_led(hotk->methods->mled_status, MLED_ON));
+	seq_printf(m, "%d\n", read_led(hotk->methods->mled_status, MLED_ON));
+	return 0;
 }
 
-static int
-proc_write_mled(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+static int mled_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mled_proc_show, NULL);
+}
+
+static ssize_t mled_proc_write(struct file *file, const char __user *buffer,
+		size_t count, loff_t *pos)
 {
 	return write_led(buffer, count, hotk->methods->mt_mled, MLED_ON, 1);
 }
 
+static const struct file_operations mled_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mled_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= mled_proc_write,
+};
+
 /*
  * Proc handlers for LED display
  */
-static int
-proc_read_ledd(char *page, char **start, off_t off, int count, int *eof,
-	       void *data)
+static int ledd_proc_show(struct seq_file *m, void *v)
 {
-	return sprintf(page, "0x%08x\n", hotk->ledd_status);
+	seq_printf(m, "0x%08x\n", hotk->ledd_status);
+	return 0;
 }
 
-static int
-proc_write_ledd(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+static int ledd_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ledd_proc_show, NULL);
+}
+
+static ssize_t ledd_proc_write(struct file *file, const char __user *buffer,
+		size_t count, loff_t *pos)
 {
 	int rv, value;
 
@@ -681,61 +685,104 @@ proc_write_ledd(struct file *file, const
 	return rv;
 }
 
+static const struct file_operations ledd_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ledd_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= ledd_proc_write,
+};
+
 /*
  * Proc handlers for WLED
  */
-static int
-proc_read_wled(char *page, char **start, off_t off, int count, int *eof,
-	       void *data)
+static int wled_proc_show(struct seq_file *m, void *v)
 {
-	return sprintf(page, "%d\n",
-		       read_led(hotk->methods->wled_status, WLED_ON));
+	seq_printf(m, "%d\n", read_led(hotk->methods->wled_status, WLED_ON));
+	return 0;
 }
 
-static int
-proc_write_wled(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+static int wled_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wled_proc_show, NULL);
+}
+
+static ssize_t wled_proc_write(struct file *file, const char __user *buffer,
+		size_t count, loff_t *pos)
 {
 	return write_led(buffer, count, hotk->methods->mt_wled, WLED_ON, 0);
 }
 
+static const struct file_operations wled_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= wled_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= wled_proc_write,
+};
+
 /*
  * Proc handlers for Bluetooth
  */
-static int
-proc_read_bluetooth(char *page, char **start, off_t off, int count, int *eof,
-		    void *data)
+static int bluetooth_proc_show(struct seq_file *m, void *v)
 {
-	return sprintf(page, "%d\n", read_led(hotk->methods->bt_status, BT_ON));
+	seq_printf(m, "%d\n", read_led(hotk->methods->bt_status, BT_ON));
+	return 0;
 }
 
-static int
-proc_write_bluetooth(struct file *file, const char __user *buffer,
-		     unsigned long count, void *data)
+static int bluetooth_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, bluetooth_proc_show, NULL);
+}
+
+static ssize_t bluetooth_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *pos)
 {
 	/* Note: mt_bt_switch controls both internal Bluetooth adapter's
 	   presence and its LED */
 	return write_led(buffer, count, hotk->methods->mt_bt_switch, BT_ON, 0);
 }
 
+static const struct file_operations bluetooth_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= bluetooth_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= bluetooth_proc_write,
+};
+
 /*
  * Proc handlers for TLED
  */
-static int
-proc_read_tled(char *page, char **start, off_t off, int count, int *eof,
-	       void *data)
+static int tled_proc_show(struct seq_file *m, void *v)
 {
-	return sprintf(page, "%d\n",
-		       read_led(hotk->methods->tled_status, TLED_ON));
+	seq_printf(m, "%d\n", read_led(hotk->methods->tled_status, TLED_ON));
+	return 0;
 }
 
-static int
-proc_write_tled(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+static int tled_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, tled_proc_show, NULL);
+}
+
+static ssize_t tled_proc_write(struct file *file, const char __user *buffer,
+		size_t count, loff_t *pos)
 {
 	return write_led(buffer, count, hotk->methods->mt_tled, TLED_ON, 0);
 }
 
+static const struct file_operations tled_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= tled_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= tled_proc_write,
+};
+
 static int get_lcd_state(void)
 {
 	int lcd = 0;
@@ -828,16 +875,19 @@ static int set_lcd_state(int value)
 
 }
 
-static int
-proc_read_lcd(char *page, char **start, off_t off, int count, int *eof,
-	      void *data)
+static int lcd_proc_show(struct seq_file *m, void *v)
 {
-	return sprintf(page, "%d\n", get_lcd_state());
+	seq_printf(m, "%d\n", get_lcd_state());
+	return 0;
 }
 
-static int
-proc_write_lcd(struct file *file, const char __user *buffer,
-	       unsigned long count, void *data)
+static int lcd_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, lcd_proc_show, NULL);
+}
+
+static ssize_t lcd_proc_write(struct file *file, const char __user *buffer,
+	       size_t count, loff_t *pos)
 {
 	int rv, value;
 
@@ -847,6 +897,15 @@ proc_write_lcd(struct file *file, const 
 	return rv;
 }
 
+static const struct file_operations lcd_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= lcd_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= lcd_proc_write,
+};
+
 static int read_brightness(struct backlight_device *bd)
 {
 	int value;
@@ -906,16 +965,19 @@ static int set_brightness_status(struct 
 	return set_brightness(bd->props.brightness);
 }
 
-static int
-proc_read_brn(char *page, char **start, off_t off, int count, int *eof,
-	      void *data)
+static int brn_proc_show(struct seq_file *m, void *v)
 {
-	return sprintf(page, "%d\n", read_brightness(NULL));
+	seq_printf(m, "%d\n", read_brightness(NULL));
+	return 0;
 }
 
-static int
-proc_write_brn(struct file *file, const char __user *buffer,
-	       unsigned long count, void *data)
+static int brn_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, brn_proc_show, NULL);
+}
+
+static ssize_t brn_proc_write(struct file *file, const char __user *buffer,
+	       size_t count, loff_t *pos)
 {
 	int rv, value;
 
@@ -928,6 +990,15 @@ proc_write_brn(struct file *file, const 
 	return rv;
 }
 
+static const struct file_operations brn_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= brn_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= brn_proc_write,
+};
+
 static void set_display(int value)
 {
 	/* no sanity check needed for now */
@@ -941,9 +1012,7 @@ static void set_display(int value)
  * Now, *this* one could be more user-friendly, but so far, no-one has
  * complained. The significance of bits is the same as in proc_write_disp()
  */
-static int
-proc_read_disp(char *page, char **start, off_t off, int count, int *eof,
-	       void *data)
+static int disp_proc_show(struct seq_file *m, void *v)
 {
 	int value = 0;
 
@@ -951,7 +1020,13 @@ proc_read_disp(char *page, char **start,
 		printk(KERN_WARNING
 		       "Asus ACPI: Error reading display status\n");
 	value &= 0x07;	/* needed for some models, shouldn't hurt others */
-	return sprintf(page, "%d\n", value);
+	seq_printf(m, "%d\n", value);
+	return 0;
+}
+
+static int disp_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, disp_proc_show, NULL);
 }
 
 /*
@@ -960,9 +1035,8 @@ proc_read_disp(char *page, char **start,
  * (bitwise) of these will suffice. I never actually tested 3 displays hooked
  * up simultaneously, so be warned. See the acpi4asus README for more info.
  */
-static int
-proc_write_disp(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+static ssize_t disp_proc_write(struct file *file, const char __user *buffer,
+		size_t count, loff_t *pos)
 {
 	int rv, value;
 
@@ -972,25 +1046,27 @@ proc_write_disp(struct file *file, const
 	return rv;
 }
 
-typedef int (proc_readfunc) (char *page, char **start, off_t off, int count,
-			     int *eof, void *data);
-typedef int (proc_writefunc) (struct file *file, const char __user *buffer,
-			      unsigned long count, void *data);
+static const struct file_operations disp_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= disp_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= disp_proc_write,
+};
 
 static int
-asus_proc_add(char *name, proc_writefunc *writefunc,
-		     proc_readfunc *readfunc, mode_t mode,
+asus_proc_add(char *name, const struct file_operations *proc_fops, mode_t mode,
 		     struct acpi_device *device)
 {
-	struct proc_dir_entry *proc =
-	    create_proc_entry(name, mode, acpi_device_dir(device));
+	struct proc_dir_entry *proc;
+
+	proc = proc_create_data(name, mode, acpi_device_dir(device),
+				proc_fops, acpi_driver_data(device));
 	if (!proc) {
 		printk(KERN_WARNING "  Unable to create %s fs entry\n", name);
 		return -1;
 	}
-	proc->write_proc = writefunc;
-	proc->read_proc = readfunc;
-	proc->data = acpi_driver_data(device);
 	proc->uid = asus_uid;
 	proc->gid = asus_gid;
 	return 0;
@@ -1019,10 +1095,9 @@ static int asus_hotk_add_fs(struct acpi_
 	if (!acpi_device_dir(device))
 		return -ENODEV;
 
-	proc = create_proc_entry(PROC_INFO, mode, acpi_device_dir(device));
+	proc = proc_create(PROC_INFO, mode, acpi_device_dir(device),
+			   &asus_info_proc_fops);
 	if (proc) {
-		proc->read_proc = proc_read_info;
-		proc->data = acpi_driver_data(device);
 		proc->uid = asus_uid;
 		proc->gid = asus_gid;
 	} else {
@@ -1031,28 +1106,23 @@ static int asus_hotk_add_fs(struct acpi_
 	}
 
 	if (hotk->methods->mt_wled) {
-		asus_proc_add(PROC_WLED, &proc_write_wled, &proc_read_wled,
-			      mode, device);
+		asus_proc_add(PROC_WLED, &wled_proc_fops, mode, device);
 	}
 
 	if (hotk->methods->mt_ledd) {
-		asus_proc_add(PROC_LEDD, &proc_write_ledd, &proc_read_ledd,
-			      mode, device);
+		asus_proc_add(PROC_LEDD, &ledd_proc_fops, mode, device);
 	}
 
 	if (hotk->methods->mt_mled) {
-		asus_proc_add(PROC_MLED, &proc_write_mled, &proc_read_mled,
-			      mode, device);
+		asus_proc_add(PROC_MLED, &mled_proc_fops, mode, device);
 	}
 
 	if (hotk->methods->mt_tled) {
-		asus_proc_add(PROC_TLED, &proc_write_tled, &proc_read_tled,
-			      mode, device);
+		asus_proc_add(PROC_TLED, &tled_proc_fops, mode, device);
 	}
 
 	if (hotk->methods->mt_bt_switch) {
-		asus_proc_add(PROC_BT, &proc_write_bluetooth,
-			      &proc_read_bluetooth, mode, device);
+		asus_proc_add(PROC_BT, &bluetooth_proc_fops, mode, device);
 	}
 
 	/*
@@ -1060,19 +1130,16 @@ static int asus_hotk_add_fs(struct acpi_
 	 * accessible from the keyboard
 	 */
 	if (hotk->methods->mt_lcd_switch && hotk->methods->lcd_status) {
-		asus_proc_add(PROC_LCD, &proc_write_lcd, &proc_read_lcd, mode,
-			      device);
+		asus_proc_add(PROC_LCD, &lcd_proc_fops, mode, device);
 	}
 
 	if ((hotk->methods->brightness_up && hotk->methods->brightness_down) ||
 	    (hotk->methods->brightness_get && hotk->methods->brightness_set)) {
-		asus_proc_add(PROC_BRN, &proc_write_brn, &proc_read_brn, mode,
-			      device);
+		asus_proc_add(PROC_BRN, &brn_proc_fops, mode, device);
 	}
 
 	if (hotk->methods->display_set) {
-		asus_proc_add(PROC_DISP, &proc_write_disp, &proc_read_disp,
-			      mode, device);
+		asus_proc_add(PROC_DISP, &disp_proc_fops, mode, device);
 	}
 
 	return 0;
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

