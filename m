From: akpm@linux-foundation.org
Subject: + viafb-add-a-mapping-of-supported-output-devices.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:37:21 -0700
Message-ID: <201009212237.o8LMbLF0006811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749Ab0IUWmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:42:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, corbet@lwn.net


The patch titled
     viafb: add a mapping of supported output devices
has been added to the -mm tree.  Its filename is
     viafb-add-a-mapping-of-supported-output-devices.patch

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
Subject: viafb: add a mapping of supported output devices
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Map supported output devices to IGP versions.  This list may contain
errors as most of it is derived of the driver source but it should be
correct enough to provide a good help.  The devices are exported via a
proc entry in the same format as those showing the output devices per IGA.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |   48 +++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff -puN drivers/video/via/viafbdev.c~viafb-add-a-mapping-of-supported-output-devices drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-add-a-mapping-of-supported-output-devices
+++ a/drivers/video/via/viafbdev.c
@@ -56,6 +56,31 @@ static int viafb_pan_display(struct fb_v
 
 static struct fb_ops viafb_ops;
 
+/* supported output devices on each IGP
+ * only CX700, VX800, VX855 were documented
+ * VIA_CRT should be everywhere
+ * VIA_6C can be onle pre-CX700 (probably only on CLE266) as 6C is used for PLL
+ * source selection on CX700 and later
+ * K400 seems to support VIA_96, VIA_DVP1, VIA_LVDS{1,2} as in viamode.c
+ */
+static const u32 supported_odev_map[] = {
+	[UNICHROME_CLE266]	= VIA_CRT | VIA_6C | VIA_93,
+	[UNICHROME_K400]	= VIA_CRT | VIA_96 | VIA_DVP1 | VIA_LVDS1
+				| VIA_LVDS2,
+	[UNICHROME_K800]	= VIA_CRT | VIA_96 | VIA_DVP1 | VIA_LVDS1
+				| VIA_LVDS2,
+	[UNICHROME_PM800]	= VIA_CRT | VIA_96 | VIA_DVP1 | VIA_LVDS1
+				| VIA_LVDS2,
+	[UNICHROME_CN700]	= VIA_CRT | VIA_96 | VIA_DVP1 | VIA_LVDS1
+				| VIA_LVDS2,
+	[UNICHROME_CX700]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
+	[UNICHROME_CN750]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
+	[UNICHROME_K8M890]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
+	[UNICHROME_P4M890]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
+	[UNICHROME_P4M900]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
+	[UNICHROME_VX800]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
+	[UNICHROME_VX855]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
+};
 
 static void viafb_fill_var_color_info(struct fb_var_screeninfo *var, u8 depth)
 {
@@ -1433,6 +1458,26 @@ static const struct file_operations viaf
 
 #endif /* CONFIG_FB_VIA_DIRECT_PROCFS */
 
+static int viafb_sup_odev_proc_show(struct seq_file *m, void *v)
+{
+	via_odev_to_seq(m, supported_odev_map[
+		viaparinfo->shared->chip_info.gfx_chip_name]);
+	return 0;
+}
+
+static int viafb_sup_odev_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, viafb_sup_odev_proc_show, NULL);
+}
+
+static const struct file_operations viafb_sup_odev_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= viafb_sup_odev_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static ssize_t odev_update(const char __user *buffer, size_t count, u32 *odev)
 {
 	char buf[64], *ptr = buf;
@@ -1561,6 +1606,8 @@ static void viafb_init_proc(struct viafb
 				&viafb_vt1636_proc_fops);
 #endif /* CONFIG_FB_VIA_DIRECT_PROCFS */
 
+		proc_create("supported_output_devices", 0, viafb_entry,
+			&viafb_sup_odev_proc_fops);
 		iga1_entry = proc_mkdir("iga1", viafb_entry);
 		shared->iga1_proc_entry = iga1_entry;
 		proc_create("output_devices", 0, iga1_entry,
@@ -1584,6 +1631,7 @@ static void viafb_remove_proc(struct via
 	remove_proc_entry("iga2", viafb_entry);
 	remove_proc_entry("output_devices", iga1_entry);
 	remove_proc_entry("iga1", viafb_entry);
+	remove_proc_entry("supported_output_devices", viafb_entry);
 
 #ifdef CONFIG_FB_VIA_DIRECT_PROCFS
 	remove_proc_entry("dvp0", viafb_entry);/* parent dir */
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

