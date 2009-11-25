From: akpm@linux-foundation.org
Subject: + thinkpad_acpi-convert-to-seq_file.patch added to -mm tree
Date: Wed, 25 Nov 2009 13:11:51 -0800
Message-ID: <200911252111.nAPLBpAF017837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934938AbZKYVMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 16:12:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, ibm-acpi@hmh.eng.br, len.brown@intel.com


The patch titled
     thinkpad_acpi: convert to seq_file
has been added to the -mm tree.  Its filename is
     thinkpad_acpi-convert-to-seq_file.patch

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
Subject: thinkpad_acpi: convert to seq_file
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/thinkpad_acpi.c |  281 +++++++++++--------------
 1 file changed, 130 insertions(+), 151 deletions(-)

diff -puN drivers/platform/x86/thinkpad_acpi.c~thinkpad_acpi-convert-to-seq_file drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~thinkpad_acpi-convert-to-seq_file
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -61,6 +61,7 @@
 
 #include <linux/nvram.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/sysfs.h>
 #include <linux/backlight.h>
 #include <linux/fb.h>
@@ -256,7 +257,7 @@ struct tp_acpi_drv_struct {
 struct ibm_struct {
 	char *name;
 
-	int (*read) (char *);
+	int (*read) (struct seq_file *);
 	int (*write) (char *);
 	void (*exit) (void);
 	void (*resume) (void);
@@ -776,36 +777,25 @@ static int __init register_tpacpi_subdri
  ****************************************************************************
  ****************************************************************************/
 
-static int dispatch_procfs_read(char *page, char **start, off_t off,
-			int count, int *eof, void *data)
+static int dispatch_proc_show(struct seq_file *m, void *v)
 {
-	struct ibm_struct *ibm = data;
-	int len;
+	struct ibm_struct *ibm = m->private;
 
 	if (!ibm || !ibm->read)
 		return -EINVAL;
+	return ibm->read(m);
+}
 
-	len = ibm->read(page);
-	if (len < 0)
-		return len;
-
-	if (len <= off + count)
-		*eof = 1;
-	*start = page + off;
-	len -= off;
-	if (len > count)
-		len = count;
-	if (len < 0)
-		len = 0;
-
-	return len;
+static int dispatch_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dispatch_proc_show, PDE(inode)->data);
 }
 
-static int dispatch_procfs_write(struct file *file,
+static ssize_t dispatch_proc_write(struct file *file,
 			const char __user *userbuf,
-			unsigned long count, void *data)
+			size_t count, loff_t *pos)
 {
-	struct ibm_struct *ibm = data;
+	struct ibm_struct *ibm = PDE(file->f_path.dentry->d_inode)->data;
 	char *kernbuf;
 	int ret;
 
@@ -834,6 +824,15 @@ static int dispatch_procfs_write(struct 
 	return ret;
 }
 
+static const struct file_operations dispatch_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= dispatch_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= dispatch_proc_write,
+};
+
 static char *next_cmd(char **cmds)
 {
 	char *start = *cmds;
@@ -1383,12 +1382,10 @@ static ssize_t tpacpi_rfk_sysfs_enable_s
 }
 
 /* procfs -------------------------------------------------------------- */
-static int tpacpi_rfk_procfs_read(const enum tpacpi_rfk_id id, char *p)
+static int tpacpi_rfk_procfs_read(const enum tpacpi_rfk_id id, struct seq_file *m)
 {
-	int len = 0;
-
 	if (id >= TPACPI_RFK_SW_MAX)
-		len += sprintf(p + len, "status:\t\tnot supported\n");
+		seq_printf(m, "status:\t\tnot supported\n");
 	else {
 		int status;
 
@@ -1402,13 +1399,13 @@ static int tpacpi_rfk_procfs_read(const 
 				return status;
 		}
 
-		len += sprintf(p + len, "status:\t\t%s\n",
+		seq_printf(m, "status:\t\t%s\n",
 				(status == TPACPI_RFK_RADIO_ON) ?
 					"enabled" : "disabled");
-		len += sprintf(p + len, "commands:\tenable, disable\n");
+		seq_printf(m, "commands:\tenable, disable\n");
 	}
 
-	return len;
+	return 0;
 }
 
 static int tpacpi_rfk_procfs_write(const enum tpacpi_rfk_id id, char *buf)
@@ -1886,14 +1883,11 @@ static int __init thinkpad_acpi_driver_i
 	return 0;
 }
 
-static int thinkpad_acpi_driver_read(char *p)
+static int thinkpad_acpi_driver_read(struct seq_file *m)
 {
-	int len = 0;
-
-	len += sprintf(p + len, "driver:\t\t%s\n", TPACPI_DESC);
-	len += sprintf(p + len, "version:\t%s\n", TPACPI_VERSION);
-
-	return len;
+	seq_printf(m, "driver:\t\t%s\n", TPACPI_DESC);
+	seq_printf(m, "version:\t%s\n", TPACPI_VERSION);
+	return 0;
 }
 
 static struct ibm_struct thinkpad_acpi_driver_data = {
@@ -3730,14 +3724,13 @@ static void hotkey_resume(void)
 }
 
 /* procfs -------------------------------------------------------------- */
-static int hotkey_read(char *p)
+static int hotkey_read(struct seq_file *m)
 {
 	int res, status;
-	int len = 0;
 
 	if (!tp_features.hotkey) {
-		len += sprintf(p + len, "status:\t\tnot supported\n");
-		return len;
+		seq_printf(m, "status:\t\tnot supported\n");
+		return 0;
 	}
 
 	if (mutex_lock_killable(&hotkey_mutex))
@@ -3749,17 +3742,16 @@ static int hotkey_read(char *p)
 	if (res)
 		return res;
 
-	len += sprintf(p + len, "status:\t\t%s\n", enabled(status, 0));
+	seq_printf(m, "status:\t\t%s\n", enabled(status, 0));
 	if (hotkey_all_mask) {
-		len += sprintf(p + len, "mask:\t\t0x%08x\n", hotkey_user_mask);
-		len += sprintf(p + len,
-			       "commands:\tenable, disable, reset, <mask>\n");
+		seq_printf(m, "mask:\t\t0x%08x\n", hotkey_user_mask);
+		seq_printf(m, "commands:\tenable, disable, reset, <mask>\n");
 	} else {
-		len += sprintf(p + len, "mask:\t\tnot supported\n");
-		len += sprintf(p + len, "commands:\tenable, disable, reset\n");
+		seq_printf(m, "mask:\t\tnot supported\n");
+		seq_printf(m, "commands:\tenable, disable, reset\n");
 	}
 
-	return len;
+	return 0;
 }
 
 static void hotkey_enabledisable_warn(bool enable)
@@ -4035,9 +4027,9 @@ static int __init bluetooth_init(struct 
 }
 
 /* procfs -------------------------------------------------------------- */
-static int bluetooth_read(char *p)
+static int bluetooth_read(struct seq_file *m)
 {
-	return tpacpi_rfk_procfs_read(TPACPI_RFK_BLUETOOTH_SW_ID, p);
+	return tpacpi_rfk_procfs_read(TPACPI_RFK_BLUETOOTH_SW_ID, m);
 }
 
 static int bluetooth_write(char *buf)
@@ -4236,9 +4228,9 @@ static int __init wan_init(struct ibm_in
 }
 
 /* procfs -------------------------------------------------------------- */
-static int wan_read(char *p)
+static int wan_read(struct seq_file *m)
 {
-	return tpacpi_rfk_procfs_read(TPACPI_RFK_WWAN_SW_ID, p);
+	return tpacpi_rfk_procfs_read(TPACPI_RFK_WWAN_SW_ID, m);
 }
 
 static int wan_write(char *buf)
@@ -4614,14 +4606,13 @@ static int video_expand_toggle(void)
 	/* not reached */
 }
 
-static int video_read(char *p)
+static int video_read(struct seq_file *m)
 {
 	int status, autosw;
-	int len = 0;
 
 	if (video_supported == TPACPI_VIDEO_NONE) {
-		len += sprintf(p + len, "status:\t\tnot supported\n");
-		return len;
+		seq_printf(m, "status:\t\tnot supported\n");
+		return 0;
 	}
 
 	status = video_outputsw_get();
@@ -4632,20 +4623,20 @@ static int video_read(char *p)
 	if (autosw < 0)
 		return autosw;
 
-	len += sprintf(p + len, "status:\t\tsupported\n");
-	len += sprintf(p + len, "lcd:\t\t%s\n", enabled(status, 0));
-	len += sprintf(p + len, "crt:\t\t%s\n", enabled(status, 1));
+	seq_printf(m, "status:\t\tsupported\n");
+	seq_printf(m, "lcd:\t\t%s\n", enabled(status, 0));
+	seq_printf(m, "crt:\t\t%s\n", enabled(status, 1));
 	if (video_supported == TPACPI_VIDEO_NEW)
-		len += sprintf(p + len, "dvi:\t\t%s\n", enabled(status, 3));
-	len += sprintf(p + len, "auto:\t\t%s\n", enabled(autosw, 0));
-	len += sprintf(p + len, "commands:\tlcd_enable, lcd_disable\n");
-	len += sprintf(p + len, "commands:\tcrt_enable, crt_disable\n");
+		seq_printf(m, "dvi:\t\t%s\n", enabled(status, 3));
+	seq_printf(m, "auto:\t\t%s\n", enabled(autosw, 0));
+	seq_printf(m, "commands:\tlcd_enable, lcd_disable\n");
+	seq_printf(m, "commands:\tcrt_enable, crt_disable\n");
 	if (video_supported == TPACPI_VIDEO_NEW)
-		len += sprintf(p + len, "commands:\tdvi_enable, dvi_disable\n");
-	len += sprintf(p + len, "commands:\tauto_enable, auto_disable\n");
-	len += sprintf(p + len, "commands:\tvideo_switch, expand_toggle\n");
+		seq_printf(m, "commands:\tdvi_enable, dvi_disable\n");
+	seq_printf(m, "commands:\tauto_enable, auto_disable\n");
+	seq_printf(m, "commands:\tvideo_switch, expand_toggle\n");
 
-	return len;
+	return 0;
 }
 
 static int video_write(char *buf)
@@ -4837,25 +4828,24 @@ static void light_exit(void)
 		flush_workqueue(tpacpi_wq);
 }
 
-static int light_read(char *p)
+static int light_read(struct seq_file *m)
 {
-	int len = 0;
 	int status;
 
 	if (!tp_features.light) {
-		len += sprintf(p + len, "status:\t\tnot supported\n");
+		seq_printf(m, "status:\t\tnot supported\n");
 	} else if (!tp_features.light_status) {
-		len += sprintf(p + len, "status:\t\tunknown\n");
-		len += sprintf(p + len, "commands:\ton, off\n");
+		seq_printf(m, "status:\t\tunknown\n");
+		seq_printf(m, "commands:\ton, off\n");
 	} else {
 		status = light_get_status();
 		if (status < 0)
 			return status;
-		len += sprintf(p + len, "status:\t\t%s\n", onoff(status, 0));
-		len += sprintf(p + len, "commands:\ton, off\n");
+		seq_printf(m, "status:\t\t%s\n", onoff(status, 0));
+		seq_printf(m, "commands:\ton, off\n");
 	}
 
-	return len;
+	return 0;
 }
 
 static int light_write(char *buf)
@@ -4933,20 +4923,18 @@ static void cmos_exit(void)
 	device_remove_file(&tpacpi_pdev->dev, &dev_attr_cmos_command);
 }
 
-static int cmos_read(char *p)
+static int cmos_read(struct seq_file *m)
 {
-	int len = 0;
-
 	/* cmos not supported on 570, 600e/x, 770e, 770x, A21e, A2xm/p,
 	   R30, R31, T20-22, X20-21 */
 	if (!cmos_handle)
-		len += sprintf(p + len, "status:\t\tnot supported\n");
+		seq_printf(m, "status:\t\tnot supported\n");
 	else {
-		len += sprintf(p + len, "status:\t\tsupported\n");
-		len += sprintf(p + len, "commands:\t<cmd> (<cmd> is 0-21)\n");
+		seq_printf(m, "status:\t\tsupported\n");
+		seq_printf(m, "commands:\t<cmd> (<cmd> is 0-21)\n");
 	}
 
-	return len;
+	return 0;
 }
 
 static int cmos_write(char *buf)
@@ -5321,15 +5309,13 @@ static int __init led_init(struct ibm_in
 	((s) == TPACPI_LED_OFF ? "off" : \
 		((s) == TPACPI_LED_ON ? "on" : "blinking"))
 
-static int led_read(char *p)
+static int led_read(struct seq_file *m)
 {
-	int len = 0;
-
 	if (!led_supported) {
-		len += sprintf(p + len, "status:\t\tnot supported\n");
-		return len;
+		seq_printf(m, "status:\t\tnot supported\n");
+		return 0;
 	}
-	len += sprintf(p + len, "status:\t\tsupported\n");
+	seq_printf(m, "status:\t\tsupported\n");
 
 	if (led_supported == TPACPI_LED_570) {
 		/* 570 */
@@ -5338,15 +5324,15 @@ static int led_read(char *p)
 			status = led_get_status(i);
 			if (status < 0)
 				return -EIO;
-			len += sprintf(p + len, "%d:\t\t%s\n",
+			seq_printf(m, "%d:\t\t%s\n",
 				       i, str_led_status(status));
 		}
 	}
 
-	len += sprintf(p + len, "commands:\t"
+	seq_printf(m, "commands:\t"
 		       "<led> on, <led> off, <led> blink (<led> is 0-15)\n");
 
-	return len;
+	return 0;
 }
 
 static int led_write(char *buf)
@@ -5419,18 +5405,16 @@ static int __init beep_init(struct ibm_i
 	return (beep_handle)? 0 : 1;
 }
 
-static int beep_read(char *p)
+static int beep_read(struct seq_file *m)
 {
-	int len = 0;
-
 	if (!beep_handle)
-		len += sprintf(p + len, "status:\t\tnot supported\n");
+		seq_printf(m, "status:\t\tnot supported\n");
 	else {
-		len += sprintf(p + len, "status:\t\tsupported\n");
-		len += sprintf(p + len, "commands:\t<cmd> (<cmd> is 0-17)\n");
+		seq_printf(m, "status:\t\tsupported\n");
+		seq_printf(m, "commands:\t<cmd> (<cmd> is 0-17)\n");
 	}
 
-	return len;
+	return 0;
 }
 
 static int beep_write(char *buf)
@@ -5766,9 +5750,8 @@ static void thermal_exit(void)
 	}
 }
 
-static int thermal_read(char *p)
+static int thermal_read(struct seq_file *m)
 {
-	int len = 0;
 	int n, i;
 	struct ibm_thermal_sensors_struct t;
 
@@ -5776,16 +5759,16 @@ static int thermal_read(char *p)
 	if (unlikely(n < 0))
 		return n;
 
-	len += sprintf(p + len, "temperatures:\t");
+	seq_printf(m, "temperatures:\t");
 
 	if (n > 0) {
 		for (i = 0; i < (n - 1); i++)
-			len += sprintf(p + len, "%d ", t.temp[i] / 1000);
-		len += sprintf(p + len, "%d\n", t.temp[i] / 1000);
+			seq_printf(m, "%d ", t.temp[i] / 1000);
+		seq_printf(m, "%d\n", t.temp[i] / 1000);
 	} else
-		len += sprintf(p + len, "not supported\n");
+		seq_printf(m, "not supported\n");
 
-	return len;
+	return 0;
 }
 
 static struct ibm_struct thermal_driver_data = {
@@ -5800,39 +5783,38 @@ static struct ibm_struct thermal_driver_
 
 static u8 ecdump_regs[256];
 
-static int ecdump_read(char *p)
+static int ecdump_read(struct seq_file *m)
 {
-	int len = 0;
 	int i, j;
 	u8 v;
 
-	len += sprintf(p + len, "EC      "
+	seq_printf(m, "EC      "
 		       " +00 +01 +02 +03 +04 +05 +06 +07"
 		       " +08 +09 +0a +0b +0c +0d +0e +0f\n");
 	for (i = 0; i < 256; i += 16) {
-		len += sprintf(p + len, "EC 0x%02x:", i);
+		seq_printf(m, "EC 0x%02x:", i);
 		for (j = 0; j < 16; j++) {
 			if (!acpi_ec_read(i + j, &v))
 				break;
 			if (v != ecdump_regs[i + j])
-				len += sprintf(p + len, " *%02x", v);
+				seq_printf(m, " *%02x", v);
 			else
-				len += sprintf(p + len, "  %02x", v);
+				seq_printf(m, "  %02x", v);
 			ecdump_regs[i + j] = v;
 		}
-		len += sprintf(p + len, "\n");
+		seq_putc(m, '\n');
 		if (j != 16)
 			break;
 	}
 
 	/* These are way too dangerous to advertise openly... */
 #if 0
-	len += sprintf(p + len, "commands:\t0x<offset> 0x<value>"
+	seq_printf(m, "commands:\t0x<offset> 0x<value>"
 		       " (<offset> is 00-ff, <value> is 00-ff)\n");
-	len += sprintf(p + len, "commands:\t0x<offset> <value>  "
+	seq_printf(m, "commands:\t0x<offset> <value>  "
 		       " (<offset> is 00-ff, <value> is 0-255)\n");
 #endif
-	return len;
+	return 0;
 }
 
 static int ecdump_write(char *buf)
@@ -6285,23 +6267,22 @@ static void brightness_exit(void)
 	tpacpi_brightness_checkpoint_nvram();
 }
 
-static int brightness_read(char *p)
+static int brightness_read(struct seq_file *m)
 {
-	int len = 0;
 	int level;
 
 	level = brightness_get(NULL);
 	if (level < 0) {
-		len += sprintf(p + len, "level:\t\tunreadable\n");
+		seq_printf(m, "level:\t\tunreadable\n");
 	} else {
-		len += sprintf(p + len, "level:\t\t%d\n", level);
-		len += sprintf(p + len, "commands:\tup, down\n");
-		len += sprintf(p + len, "commands:\tlevel <level>"
+		seq_printf(m, "level:\t\t%d\n", level);
+		seq_printf(m, "commands:\tup, down\n");
+		seq_printf(m, "commands:\tlevel <level>"
 			       " (<level> is 0-%d)\n",
 			       (tp_features.bright_16levels) ? 15 : 7);
 	}
 
-	return len;
+	return 0;
 }
 
 static int brightness_write(char *buf)
@@ -6358,22 +6339,21 @@ static struct ibm_struct brightness_driv
 
 static int volume_offset = 0x30;
 
-static int volume_read(char *p)
+static int volume_read(struct seq_file *m)
 {
-	int len = 0;
 	u8 level;
 
 	if (!acpi_ec_read(volume_offset, &level)) {
-		len += sprintf(p + len, "level:\t\tunreadable\n");
+		seq_printf(m, "level:\t\tunreadable\n");
 	} else {
-		len += sprintf(p + len, "level:\t\t%d\n", level & 0xf);
-		len += sprintf(p + len, "mute:\t\t%s\n", onoff(level, 6));
-		len += sprintf(p + len, "commands:\tup, down, mute\n");
-		len += sprintf(p + len, "commands:\tlevel <level>"
+		seq_printf(m, "level:\t\t%d\n", level & 0xf);
+		seq_printf(m, "mute:\t\t%s\n", onoff(level, 6));
+		seq_printf(m, "commands:\tup, down, mute\n");
+		seq_printf(m, "commands:\tlevel <level>"
 			       " (<level> is 0-15)\n");
 	}
 
-	return len;
+	return 0;
 }
 
 static int volume_write(char *buf)
@@ -7525,9 +7505,8 @@ static void fan_resume(void)
 	}
 }
 
-static int fan_read(char *p)
+static int fan_read(struct seq_file *m)
 {
-	int len = 0;
 	int rc;
 	u8 status;
 	unsigned int speed = 0;
@@ -7539,7 +7518,7 @@ static int fan_read(char *p)
 		if (rc < 0)
 			return rc;
 
-		len += sprintf(p + len, "status:\t\t%s\n"
+		seq_printf(m, "status:\t\t%s\n"
 			       "level:\t\t%d\n",
 			       (status != 0) ? "enabled" : "disabled", status);
 		break;
@@ -7550,54 +7529,54 @@ static int fan_read(char *p)
 		if (rc < 0)
 			return rc;
 
-		len += sprintf(p + len, "status:\t\t%s\n",
+		seq_printf(m, "status:\t\t%s\n",
 			       (status != 0) ? "enabled" : "disabled");
 
 		rc = fan_get_speed(&speed);
 		if (rc < 0)
 			return rc;
 
-		len += sprintf(p + len, "speed:\t\t%d\n", speed);
+		seq_printf(m, "speed:\t\t%d\n", speed);
 
 		if (status & TP_EC_FAN_FULLSPEED)
 			/* Disengaged mode takes precedence */
-			len += sprintf(p + len, "level:\t\tdisengaged\n");
+			seq_printf(m, "level:\t\tdisengaged\n");
 		else if (status & TP_EC_FAN_AUTO)
-			len += sprintf(p + len, "level:\t\tauto\n");
+			seq_printf(m, "level:\t\tauto\n");
 		else
-			len += sprintf(p + len, "level:\t\t%d\n", status);
+			seq_printf(m, "level:\t\t%d\n", status);
 		break;
 
 	case TPACPI_FAN_NONE:
 	default:
-		len += sprintf(p + len, "status:\t\tnot supported\n");
+		seq_printf(m, "status:\t\tnot supported\n");
 	}
 
 	if (fan_control_commands & TPACPI_FAN_CMD_LEVEL) {
-		len += sprintf(p + len, "commands:\tlevel <level>");
+		seq_printf(m, "commands:\tlevel <level>");
 
 		switch (fan_control_access_mode) {
 		case TPACPI_FAN_WR_ACPI_SFAN:
-			len += sprintf(p + len, " (<level> is 0-7)\n");
+			seq_printf(m, " (<level> is 0-7)\n");
 			break;
 
 		default:
-			len += sprintf(p + len, " (<level> is 0-7, "
+			seq_printf(m, " (<level> is 0-7, "
 				       "auto, disengaged, full-speed)\n");
 			break;
 		}
 	}
 
 	if (fan_control_commands & TPACPI_FAN_CMD_ENABLE)
-		len += sprintf(p + len, "commands:\tenable, disable\n"
+		seq_printf(m, "commands:\tenable, disable\n"
 			       "commands:\twatchdog <timeout> (<timeout> "
 			       "is 0 (off), 1-120 (seconds))\n");
 
 	if (fan_control_commands & TPACPI_FAN_CMD_SPEED)
-		len += sprintf(p + len, "commands:\tspeed <speed>"
+		seq_printf(m, "commands:\tspeed <speed>"
 			       " (<speed> is 0-65535)\n");
 
-	return len;
+	return 0;
 }
 
 static int fan_write_cmd_level(const char *cmd, int *rc)
@@ -7878,19 +7857,19 @@ static int __init ibm_init(struct ibm_in
 		"%s installed\n", ibm->name);
 
 	if (ibm->read) {
-		entry = create_proc_entry(ibm->name,
-					  S_IFREG | S_IRUGO | S_IWUSR,
-					  proc_dir);
+		mode_t mode;
+
+		mode = S_IRUGO;
+		if (ibm->write)
+			mode |= S_IWUSR;
+		entry = proc_create_data(ibm->name, mode, proc_dir,
+					 &dispatch_proc_fops, ibm);
 		if (!entry) {
 			printk(TPACPI_ERR "unable to create proc entry %s\n",
 			       ibm->name);
 			ret = -ENODEV;
 			goto err_out;
 		}
-		entry->data = ibm;
-		entry->read_proc = &dispatch_procfs_read;
-		if (ibm->write)
-			entry->write_proc = &dispatch_procfs_write;
 		ibm->flags.proc_created = 1;
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

