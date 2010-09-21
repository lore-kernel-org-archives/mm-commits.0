From: akpm@linux-foundation.org
Subject: + viafb-add-interface-for-output-device-configuration.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:37:03 -0700
Message-ID: <201009212237.o8LMb3xB006775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257Ab0IUWhm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:37:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, akpm@linux-foundation.org, corbet@lwn.net


The patch titled
     viafb: add interface for output device configuration
has been added to the -mm tree.  Its filename is
     viafb-add-interface-for-output-device-configuration.patch

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
Subject: viafb: add interface for output device configuration
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Extend the proc entry to contain a possibility to view and change the
output devices for each IGA.

This is useful for debugging output problems as it provides a reliable way
to query which low level devices are active after VIAs output device
configuration nightmare happended.

It's also well suitable for daily use as one can change the output
configuration on the fly for example to connect a projector.  At the
moment it's still unstable.  The reason is that we have to handle a bunch
of undocumented output devices (those without a proper name) and that this
patch is the first step to collect and verify the needed information. 
Basically the only configuration change that is expected to work at the
moment is switching output devices between IGA1 and IGA2.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Acked-by: Jonathan Corbet <corbet@lwn.net>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c       |   53 +++++++++
 drivers/video/via/hw.h       |   10 +
 drivers/video/via/viafbdev.c |  175 ++++++++++++++++++++++++++++-----
 drivers/video/via/viafbdev.h |    2 
 4 files changed, 216 insertions(+), 24 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-add-interface-for-output-device-configuration drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-add-interface-for-output-device-configuration
+++ a/drivers/video/via/hw.c
@@ -718,6 +718,16 @@ static struct rgbLUT palLUT_table[] = {
 								     0x00}
 };
 
+static struct via_device_mapping device_mapping[] = {
+	{VIA_6C, "6C"},
+	{VIA_93, "93"},
+	{VIA_96, "96"},
+	{VIA_CRT, "CRT"},
+	{VIA_DVP1, "DVP1"},
+	{VIA_LVDS1, "LVDS1"},
+	{VIA_LVDS2, "LVDS2"}
+};
+
 static void load_fix_bit_crtc_reg(void);
 static void __devinit init_gfx_chip_info(int chip_type);
 static void __devinit init_tmds_chip_info(void);
@@ -1026,6 +1036,49 @@ void via_set_source(u32 devices, u8 iga)
 		set_lvds2_source(iga);
 }
 
+u32 via_parse_odev(char *input, char **end)
+{
+	char *ptr = input;
+	u32 odev = 0;
+	bool next = true;
+	int i, len;
+
+	while (next) {
+		next = false;
+		for (i = 0; i < ARRAY_SIZE(device_mapping); i++) {
+			len = strlen(device_mapping[i].name);
+			if (!strncmp(ptr, device_mapping[i].name, len)) {
+				odev |= device_mapping[i].device;
+				ptr += len;
+				if (*ptr == ',') {
+					ptr++;
+					next = true;
+				}
+			}
+		}
+	}
+
+	*end = ptr;
+	return odev;
+}
+
+void via_odev_to_seq(struct seq_file *m, u32 odev)
+{
+	int i, count = 0;
+
+	for (i = 0; i < ARRAY_SIZE(device_mapping); i++) {
+		if (odev & device_mapping[i].device) {
+			if (count > 0)
+				seq_putc(m, ',');
+
+			seq_puts(m, device_mapping[i].name);
+			count++;
+		}
+	}
+
+	seq_putc(m, '\n');
+}
+
 static void load_fix_bit_crtc_reg(void)
 {
 	/* always set to 1 */
diff -puN drivers/video/via/hw.h~viafb-add-interface-for-output-device-configuration drivers/video/via/hw.h
--- a/drivers/video/via/hw.h~viafb-add-interface-for-output-device-configuration
+++ a/drivers/video/via/hw.h
@@ -22,6 +22,8 @@
 #ifndef __HW_H__
 #define __HW_H__
 
+#include <linux/seq_file.h>
+
 #include "viamode.h"
 #include "global.h"
 #include "via_modesetting.h"
@@ -882,6 +884,11 @@ struct pci_device_id_info {
 	u32 chip_index;
 };
 
+struct via_device_mapping {
+	u32 device;
+	const char *name;
+};
+
 extern unsigned int viafb_second_virtual_xres;
 extern int viafb_SAMM_ON;
 extern int viafb_dual_fb;
@@ -899,6 +906,9 @@ void viafb_load_reg(int timing_value, in
 	      int io_type);
 void viafb_crt_disable(void);
 void viafb_crt_enable(void);
+void via_set_source(u32 devices, u8 iga);
+u32 via_parse_odev(char *input, char **end);
+void via_odev_to_seq(struct seq_file *m, u32 odev);
 void init_ad9389(void);
 /* Access I/O Function */
 void viafb_lock_crt(void);
diff -puN drivers/video/via/viafbdev.c~viafb-add-interface-for-output-device-configuration drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-add-interface-for-output-device-configuration
+++ a/drivers/video/via/viafbdev.c
@@ -1431,38 +1431,169 @@ static const struct file_operations viaf
 	.write		= viafb_vt1636_proc_write,
 };
 
-static void viafb_init_proc(struct proc_dir_entry **viafb_entry)
+#endif /* CONFIG_FB_VIA_DIRECT_PROCFS */
+
+static ssize_t odev_update(const char __user *buffer, size_t count, u32 *odev)
 {
-	*viafb_entry = proc_mkdir("viafb", NULL);
-	if (*viafb_entry) {
-		proc_create("dvp0", 0, *viafb_entry, &viafb_dvp0_proc_fops);
-		proc_create("dvp1", 0, *viafb_entry, &viafb_dvp1_proc_fops);
-		proc_create("dfph", 0, *viafb_entry, &viafb_dfph_proc_fops);
-		proc_create("dfpl", 0, *viafb_entry, &viafb_dfpl_proc_fops);
-		if (VT1636_LVDS == viaparinfo->chip_info->lvds_chip_info.
-			lvds_chip_name || VT1636_LVDS ==
-		    viaparinfo->chip_info->lvds_chip_info2.lvds_chip_name) {
-			proc_create("vt1636", 0, *viafb_entry, &viafb_vt1636_proc_fops);
-		}
+	char buf[64], *ptr = buf;
+	u32 devices;
+	bool add, sub;
+
+	if (count < 1 || count > 63)
+		return -EINVAL;
+	if (copy_from_user(&buf[0], buffer, count))
+		return -EFAULT;
+	buf[count] = '\0';
+	add = buf[0] == '+';
+	sub = buf[0] == '-';
+	if (add || sub)
+		ptr++;
+	devices = via_parse_odev(ptr, &ptr);
+	if (*ptr == '\n')
+		ptr++;
+	if (*ptr != 0)
+		return -EINVAL;
+	if (add)
+		*odev |= devices;
+	else if (sub)
+		*odev &= ~devices;
+	else
+		*odev = devices;
+	return count;
+}
+
+static int viafb_iga1_odev_proc_show(struct seq_file *m, void *v)
+{
+	via_odev_to_seq(m, viaparinfo->shared->iga1_devices);
+	return 0;
+}
+
+static int viafb_iga1_odev_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, viafb_iga1_odev_proc_show, NULL);
+}
+
+static ssize_t viafb_iga1_odev_proc_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *pos)
+{
+	u32 dev_on, dev_off, dev_old, dev_new;
+	ssize_t res;
+
+	dev_old = dev_new = viaparinfo->shared->iga1_devices;
+	res = odev_update(buffer, count, &dev_new);
+	if (res != count)
+		return res;
+	dev_off = dev_old & ~dev_new;
+	dev_on = dev_new & ~dev_old;
+	viaparinfo->shared->iga1_devices = dev_new;
+	viaparinfo->shared->iga2_devices &= ~dev_new;
+	via_set_source(dev_new, IGA1);
+	return res;
+}
+
+static const struct file_operations viafb_iga1_odev_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= viafb_iga1_odev_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= viafb_iga1_odev_proc_write,
+};
+
+static int viafb_iga2_odev_proc_show(struct seq_file *m, void *v)
+{
+	via_odev_to_seq(m, viaparinfo->shared->iga2_devices);
+	return 0;
+}
+
+static int viafb_iga2_odev_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, viafb_iga2_odev_proc_show, NULL);
+}
+
+static ssize_t viafb_iga2_odev_proc_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *pos)
+{
+	u32 dev_on, dev_off, dev_old, dev_new;
+	ssize_t res;
+
+	dev_old = dev_new = viaparinfo->shared->iga2_devices;
+	res = odev_update(buffer, count, &dev_new);
+	if (res != count)
+		return res;
+	dev_off = dev_old & ~dev_new;
+	dev_on = dev_new & ~dev_old;
+	viaparinfo->shared->iga2_devices = dev_new;
+	viaparinfo->shared->iga1_devices &= ~dev_new;
+	via_set_source(dev_new, IGA2);
+	return res;
+}
+
+static const struct file_operations viafb_iga2_odev_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= viafb_iga2_odev_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= viafb_iga2_odev_proc_write,
+};
+
+#define IS_VT1636(lvds_chip)	((lvds_chip).lvds_chip_name == VT1636_LVDS)
+static void viafb_init_proc(struct viafb_shared *shared)
+{
+	struct proc_dir_entry *iga1_entry, *iga2_entry,
+		*viafb_entry = proc_mkdir("viafb", NULL);
 
+	shared->proc_entry = viafb_entry;
+	if (viafb_entry) {
+#ifdef CONFIG_FB_VIA_DIRECT_PROCFS
+		proc_create("dvp0", 0, viafb_entry, &viafb_dvp0_proc_fops);
+		proc_create("dvp1", 0, viafb_entry, &viafb_dvp1_proc_fops);
+		proc_create("dfph", 0, viafb_entry, &viafb_dfph_proc_fops);
+		proc_create("dfpl", 0, viafb_entry, &viafb_dfpl_proc_fops);
+		if (IS_VT1636(shared->chip_info.lvds_chip_info)
+			|| IS_VT1636(shared->chip_info.lvds_chip_info2))
+			proc_create("vt1636", 0, viafb_entry,
+				&viafb_vt1636_proc_fops);
+#endif /* CONFIG_FB_VIA_DIRECT_PROCFS */
+
+		iga1_entry = proc_mkdir("iga1", viafb_entry);
+		shared->iga1_proc_entry = iga1_entry;
+		proc_create("output_devices", 0, iga1_entry,
+			&viafb_iga1_odev_proc_fops);
+		iga2_entry = proc_mkdir("iga2", viafb_entry);
+		shared->iga2_proc_entry = iga2_entry;
+		proc_create("output_devices", 0, iga2_entry,
+			&viafb_iga2_odev_proc_fops);
 	}
 }
-static void viafb_remove_proc(struct proc_dir_entry *viafb_entry)
+static void viafb_remove_proc(struct viafb_shared *shared)
 {
-	struct chip_information *chip_info = &viaparinfo->shared->chip_info;
+	struct proc_dir_entry *viafb_entry = shared->proc_entry,
+		*iga1_entry = shared->iga1_proc_entry,
+		*iga2_entry = shared->iga2_proc_entry;
+
+	if (!viafb_entry)
+		return;
+
+	remove_proc_entry("output_devices", iga2_entry);
+	remove_proc_entry("iga2", viafb_entry);
+	remove_proc_entry("output_devices", iga1_entry);
+	remove_proc_entry("iga1", viafb_entry);
 
+#ifdef CONFIG_FB_VIA_DIRECT_PROCFS
 	remove_proc_entry("dvp0", viafb_entry);/* parent dir */
 	remove_proc_entry("dvp1", viafb_entry);
 	remove_proc_entry("dfph", viafb_entry);
 	remove_proc_entry("dfpl", viafb_entry);
-	if (chip_info->lvds_chip_info.lvds_chip_name == VT1636_LVDS
-		|| chip_info->lvds_chip_info2.lvds_chip_name == VT1636_LVDS)
+	if (IS_VT1636(shared->chip_info.lvds_chip_info)
+		|| IS_VT1636(shared->chip_info.lvds_chip_info2))
 		remove_proc_entry("vt1636", viafb_entry);
+#endif /* CONFIG_FB_VIA_DIRECT_PROCFS */
 
 	remove_proc_entry("viafb", NULL);
 }
-
-#endif /* CONFIG_FB_VIA_DIRECT_PROCFS */
+#undef IS_VT1636
 
 static int parse_mode(const char *str, u32 *xres, u32 *yres)
 {
@@ -1671,9 +1802,7 @@ int __devinit via_fb_pci_probe(struct vi
 		  viafbinfo->node, viafbinfo->fix.id, default_var.xres,
 		  default_var.yres, default_var.bits_per_pixel);
 
-#ifdef CONFIG_FB_VIA_DIRECT_PROCFS
-	viafb_init_proc(&viaparinfo->shared->proc_entry);
-#endif
+	viafb_init_proc(viaparinfo->shared);
 	viafb_init_dac(IGA2);
 	return 0;
 
@@ -1700,9 +1829,7 @@ void __devexit via_fb_pci_remove(struct 
 	unregister_framebuffer(viafbinfo);
 	if (viafb_dual_fb)
 		unregister_framebuffer(viafbinfo1);
-#ifdef CONFIG_FB_VIA_DIRECT_PROCFS
-	viafb_remove_proc(viaparinfo->shared->proc_entry);
-#endif
+	viafb_remove_proc(viaparinfo->shared);
 	framebuffer_release(viafbinfo);
 	if (viafb_dual_fb)
 		framebuffer_release(viafbinfo1);
diff -puN drivers/video/via/viafbdev.h~viafb-add-interface-for-output-device-configuration drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h~viafb-add-interface-for-output-device-configuration
+++ a/drivers/video/via/viafbdev.h
@@ -44,6 +44,8 @@ struct viafb_shared {
 	u32 iga2_devices;
 
 	struct proc_dir_entry *proc_entry;	/*viafb proc entry */
+	struct proc_dir_entry *iga1_proc_entry;
+	struct proc_dir_entry *iga2_proc_entry;
 	struct viafb_dev *vdev;			/* Global dev info */
 
 	/* All the information will be needed to set engine */
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

linux-next.patch
viafb-add-interface-for-output-device-configuration.patch
viafb-limit-lcd-code-impact.patch
viafb-introduce-per-output-device-power-management.patch
viafb-vt1636-cleanup.patch
viafb-fix-i2c_transfer-error-handling.patch
viafb-enable-i2c-for-crt.patch
viafb-reduce-i2c-timeout-and-delay.patch
viafb-add-function-to-change-sync-polarity-per-device.patch
viafb-set-sync-polarity-for-all-output-devices.patch
viafb-add-a-mapping-of-supported-output-devices.patch
viafb-rename-output-devices.patch
viafb-add-documentation-for-proc-interface.patch

