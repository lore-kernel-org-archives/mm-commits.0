From: akpm@linux-foundation.org
Subject: + simple_open-automatically-convert-to-simple_open.patch added to -mm tree
Date: Mon, 19 Mar 2012 15:24:51 -0700
Message-ID: <20120319222451.DBA3AA00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:45141 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2CSWYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Mar 2012 18:24:55 -0400
Received: by wgbdt11 with SMTP id dt11so42398wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Mar 2012 15:24:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, Julia.Lawall@lip6.fr, gregkh@linuxfoundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk


The patch titled
     Subject: simple_open: automatically convert to simple_open()
has been added to the -mm tree.  Its filename is
     simple_open-automatically-convert-to-simple_open.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: simple_open: automatically convert to simple_open()

Many users of debugfs copy the implementation of default_open() when they
want to support a custom read/write function op.  This leads to a
proliferation of the default_open() implementation across the entire tree.
 Now that the common implementation has been consolidated into libfs we
can replace all the users of this function with simple_open().

This replacement was done with the following semantic patch:

<smpl>
@ open @
identifier open_f != simple_open;
identifier i, f;
@@
-int open_f(struct inode *i, struct file *f)
-{
(
-if (i->i_private)
-f->private_data = i->i_private;
|
-f->private_data = i->i_private;
)
-return 0;
-}

@ has_open depends on open @
identifier fops;
identifier open.open_f;
@@
struct file_operations fops = {
...
-.open = open_f,
+.open = simple_open,
...
};
</smpl>

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-msm/smd_debug.c                   |    8 --
 arch/x86/kernel/kdebugfs.c                      |    9 ---
 drivers/acpi/ec_sys.c                           |    8 --
 drivers/base/regmap/regmap-debugfs.c            |   12 +---
 drivers/bluetooth/btmrvl_debugfs.c              |   26 +++-----
 drivers/char/virtio_console.c                   |    8 --
 drivers/dma/coh901318.c                         |    9 ---
 drivers/gpu/drm/i915/i915_debugfs.c             |   14 +---
 drivers/hid/hid-picolcd.c                       |   16 -----
 drivers/hid/hid-wiimote-debug.c                 |    8 --
 drivers/idle/i7300_idle.c                       |    8 --
 drivers/iommu/omap-iommu-debug.c                |   10 ---
 drivers/mfd/aat2870-core.c                      |    9 ---
 drivers/mfd/ab3100-core.c                       |    8 --
 drivers/misc/ibmasm/ibmasmfs.c                  |    8 --
 drivers/mtd/ubi/debug.c                         |   10 ---
 drivers/net/caif/caif_spi.c                     |   10 ---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |    9 ---
 drivers/net/wimax/i2400m/debugfs.c              |   15 -----
 drivers/net/wireless/ath/ath5k/debug.c          |   23 ++-----
 drivers/net/wireless/ath/ath6kl/debug.c         |   42 ++++++--------
 drivers/net/wireless/ath/ath9k/debug.c          |   37 +++++-------
 drivers/net/wireless/ath/ath9k/dfs_debug.c      |    9 ---
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c  |   26 +++-----
 drivers/net/wireless/ath/ath9k/rc.c             |    8 --
 drivers/net/wireless/ath/carl9170/debug.c       |    7 --
 drivers/net/wireless/b43/debugfs.c              |    8 --
 drivers/net/wireless/b43legacy/debugfs.c        |    8 --
 drivers/net/wireless/iwlegacy/3945-rs.c         |    8 --
 drivers/net/wireless/iwlegacy/4965-rs.c         |   12 +---
 drivers/net/wireless/iwlegacy/debug.c           |   12 +---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c       |   11 +--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c      |   12 +---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c   |   12 +---
 drivers/net/wireless/iwmc3200wifi/debugfs.c     |   14 +---
 drivers/net/wireless/iwmc3200wifi/sdio.c        |    9 ---
 drivers/net/wireless/libertas/debugfs.c         |   10 ---
 drivers/net/wireless/mwifiex/debugfs.c          |   18 +-----
 drivers/net/wireless/wl1251/debugfs.c           |   14 +---
 drivers/net/wireless/wl12xx/debugfs.c           |   38 +++++-------
 drivers/oprofile/oprofilefs.c                   |   14 +---
 drivers/remoteproc/remoteproc_debugfs.c         |   13 +---
 drivers/scsi/lpfc/lpfc_debugfs.c                |    9 ---
 drivers/spi/spi-dw.c                            |    8 --
 drivers/tty/serial/mfd.c                        |    9 ---
 drivers/tty/serial/pch_uart.c                   |    8 --
 drivers/usb/core/inode.c                        |   10 ---
 drivers/usb/host/ehci-dbg.c                     |    9 ---
 drivers/uwb/uwb-debug.c                         |    9 ---
 fs/debugfs/file.c                               |   14 +---
 fs/dlm/debug_fs.c                               |    9 ---
 fs/pstore/inode.c                               |    8 --
 kernel/trace/blktrace.c                         |   18 ------
 net/mac80211/debugfs.c                          |   12 +---
 net/mac80211/debugfs.h                          |    1 
 net/mac80211/debugfs_key.c                      |    4 -
 net/mac80211/debugfs_netdev.c                   |    2 
 net/mac80211/debugfs_sta.c                      |    4 -
 net/mac80211/rate.c                             |    2 
 net/wireless/debugfs.c                          |   10 ---
 sound/soc/imx/imx-audmux.c                      |    8 --
 sound/soc/soc-core.c                            |    8 --
 sound/soc/soc-dapm.c                            |   16 -----
 63 files changed, 176 insertions(+), 572 deletions(-)

diff -puN arch/arm/mach-msm/smd_debug.c~simple_open-automatically-convert-to-simple_open arch/arm/mach-msm/smd_debug.c
--- a/arch/arm/mach-msm/smd_debug.c~simple_open-automatically-convert-to-simple_open
+++ a/arch/arm/mach-msm/smd_debug.c
@@ -203,15 +203,9 @@ static ssize_t debug_read(struct file *f
 	return simple_read_from_buffer(buf, count, ppos, debug_buffer, bsize);
 }
 
-static int debug_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static const struct file_operations debug_ops = {
 	.read = debug_read,
-	.open = debug_open,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
diff -puN arch/x86/kernel/kdebugfs.c~simple_open-automatically-convert-to-simple_open arch/x86/kernel/kdebugfs.c
--- a/arch/x86/kernel/kdebugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/arch/x86/kernel/kdebugfs.c
@@ -68,16 +68,9 @@ static ssize_t setup_data_read(struct fi
 	return count;
 }
 
-static int setup_data_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static const struct file_operations fops_setup_data = {
 	.read		= setup_data_read,
-	.open		= setup_data_open,
+	.open		= simple_open,
 	.llseek		= default_llseek,
 };
 
diff -puN drivers/acpi/ec_sys.c~simple_open-automatically-convert-to-simple_open drivers/acpi/ec_sys.c
--- a/drivers/acpi/ec_sys.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/acpi/ec_sys.c
@@ -27,12 +27,6 @@ MODULE_PARM_DESC(write_support, "Dangero
 
 static struct dentry *acpi_ec_debugfs_dir;
 
-static int acpi_ec_open_io(struct inode *i, struct file *f)
-{
-	f->private_data = i->i_private;
-	return 0;
-}
-
 static ssize_t acpi_ec_read_io(struct file *f, char __user *buf,
 			       size_t count, loff_t *off)
 {
@@ -95,7 +89,7 @@ static ssize_t acpi_ec_write_io(struct f
 
 static const struct file_operations acpi_ec_io_ops = {
 	.owner = THIS_MODULE,
-	.open  = acpi_ec_open_io,
+	.open  = simple_open,
 	.read  = acpi_ec_read_io,
 	.write = acpi_ec_write_io,
 	.llseek = default_llseek,
diff -puN drivers/base/regmap/regmap-debugfs.c~simple_open-automatically-convert-to-simple_open drivers/base/regmap/regmap-debugfs.c
--- a/drivers/base/regmap/regmap-debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/base/regmap/regmap-debugfs.c
@@ -27,12 +27,6 @@ static size_t regmap_calc_reg_len(int ma
 	return strlen(buf);
 }
 
-static int regmap_open_file(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t regmap_name_read_file(struct file *file,
 				     char __user *user_buf, size_t count,
 				     loff_t *ppos)
@@ -57,7 +51,7 @@ static ssize_t regmap_name_read_file(str
 }
 
 static const struct file_operations regmap_name_fops = {
-	.open = regmap_open_file,
+	.open = simple_open,
 	.read = regmap_name_read_file,
 	.llseek = default_llseek,
 };
@@ -174,7 +168,7 @@ static ssize_t regmap_map_write_file(str
 #endif
 
 static const struct file_operations regmap_map_fops = {
-	.open = regmap_open_file,
+	.open = simple_open,
 	.read = regmap_map_read_file,
 	.write = regmap_map_write_file,
 	.llseek = default_llseek,
@@ -243,7 +237,7 @@ out:
 }
 
 static const struct file_operations regmap_access_fops = {
-	.open = regmap_open_file,
+	.open = simple_open,
 	.read = regmap_access_read_file,
 	.llseek = default_llseek,
 };
diff -puN drivers/bluetooth/btmrvl_debugfs.c~simple_open-automatically-convert-to-simple_open drivers/bluetooth/btmrvl_debugfs.c
--- a/drivers/bluetooth/btmrvl_debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/bluetooth/btmrvl_debugfs.c
@@ -45,12 +45,6 @@ struct btmrvl_debugfs_data {
 	struct dentry *txdnldready;
 };
 
-static int btmrvl_open_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t btmrvl_hscfgcmd_write(struct file *file,
 			const char __user *ubuf, size_t count, loff_t *ppos)
 {
@@ -93,7 +87,7 @@ static ssize_t btmrvl_hscfgcmd_read(stru
 static const struct file_operations btmrvl_hscfgcmd_fops = {
 	.read	= btmrvl_hscfgcmd_read,
 	.write	= btmrvl_hscfgcmd_write,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -134,7 +128,7 @@ static ssize_t btmrvl_psmode_read(struct
 static const struct file_operations btmrvl_psmode_fops = {
 	.read	= btmrvl_psmode_read,
 	.write	= btmrvl_psmode_write,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -180,7 +174,7 @@ static ssize_t btmrvl_pscmd_read(struct 
 static const struct file_operations btmrvl_pscmd_fops = {
 	.read = btmrvl_pscmd_read,
 	.write = btmrvl_pscmd_write,
-	.open = btmrvl_open_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -221,7 +215,7 @@ static ssize_t btmrvl_gpiogap_read(struc
 static const struct file_operations btmrvl_gpiogap_fops = {
 	.read	= btmrvl_gpiogap_read,
 	.write	= btmrvl_gpiogap_write,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -265,7 +259,7 @@ static ssize_t btmrvl_hscmd_read(struct 
 static const struct file_operations btmrvl_hscmd_fops = {
 	.read	= btmrvl_hscmd_read,
 	.write	= btmrvl_hscmd_write,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -305,7 +299,7 @@ static ssize_t btmrvl_hsmode_read(struct
 static const struct file_operations btmrvl_hsmode_fops = {
 	.read	= btmrvl_hsmode_read,
 	.write	= btmrvl_hsmode_write,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -323,7 +317,7 @@ static ssize_t btmrvl_curpsmode_read(str
 
 static const struct file_operations btmrvl_curpsmode_fops = {
 	.read	= btmrvl_curpsmode_read,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -341,7 +335,7 @@ static ssize_t btmrvl_psstate_read(struc
 
 static const struct file_operations btmrvl_psstate_fops = {
 	.read	= btmrvl_psstate_read,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -359,7 +353,7 @@ static ssize_t btmrvl_hsstate_read(struc
 
 static const struct file_operations btmrvl_hsstate_fops = {
 	.read	= btmrvl_hsstate_read,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -378,7 +372,7 @@ static ssize_t btmrvl_txdnldready_read(s
 
 static const struct file_operations btmrvl_txdnldready_fops = {
 	.read	= btmrvl_txdnldready_read,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
diff -puN drivers/char/virtio_console.c~simple_open-automatically-convert-to-simple_open drivers/char/virtio_console.c
--- a/drivers/char/virtio_console.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/char/virtio_console.c
@@ -1038,12 +1038,6 @@ static struct attribute_group port_attri
 	.attrs = port_sysfs_entries,
 };
 
-static int debugfs_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t debugfs_read(struct file *filp, char __user *ubuf,
 			    size_t count, loff_t *offp)
 {
@@ -1087,7 +1081,7 @@ static ssize_t debugfs_read(struct file 
 
 static const struct file_operations port_debugfs_ops = {
 	.owner = THIS_MODULE,
-	.open  = debugfs_open,
+	.open  = simple_open,
 	.read  = debugfs_read,
 };
 
diff -puN drivers/dma/coh901318.c~simple_open-automatically-convert-to-simple_open drivers/dma/coh901318.c
--- a/drivers/dma/coh901318.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/dma/coh901318.c
@@ -104,13 +104,6 @@ static void coh901318_list_print(struct 
 static struct coh901318_base *debugfs_dma_base;
 static struct dentry *dma_dentry;
 
-static int coh901318_debugfs_open(struct inode *inode, struct file *file)
-{
-
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static int coh901318_debugfs_read(struct file *file, char __user *buf,
 				  size_t count, loff_t *f_pos)
 {
@@ -158,7 +151,7 @@ static int coh901318_debugfs_read(struct
 
 static const struct file_operations coh901318_debugfs_status_operations = {
 	.owner		= THIS_MODULE,
-	.open		= coh901318_debugfs_open,
+	.open		= simple_open,
 	.read		= coh901318_debugfs_read,
 	.llseek		= default_llseek,
 };
diff -puN drivers/gpu/drm/i915/i915_debugfs.c~simple_open-automatically-convert-to-simple_open drivers/gpu/drm/i915/i915_debugfs.c
--- a/drivers/gpu/drm/i915/i915_debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/gpu/drm/i915/i915_debugfs.c
@@ -1502,14 +1502,6 @@ static int i915_ppgtt_info(struct seq_fi
 	return 0;
 }
 
-static int
-i915_debugfs_common_open(struct inode *inode,
-			 struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t
 i915_wedged_read(struct file *filp,
 		 char __user *ubuf,
@@ -1560,7 +1552,7 @@ i915_wedged_write(struct file *filp,
 
 static const struct file_operations i915_wedged_fops = {
 	.owner = THIS_MODULE,
-	.open = i915_debugfs_common_open,
+	.open = simple_open,
 	.read = i915_wedged_read,
 	.write = i915_wedged_write,
 	.llseek = default_llseek,
@@ -1622,7 +1614,7 @@ i915_max_freq_write(struct file *filp,
 
 static const struct file_operations i915_max_freq_fops = {
 	.owner = THIS_MODULE,
-	.open = i915_debugfs_common_open,
+	.open = simple_open,
 	.read = i915_max_freq_read,
 	.write = i915_max_freq_write,
 	.llseek = default_llseek,
@@ -1693,7 +1685,7 @@ i915_cache_sharing_write(struct file *fi
 
 static const struct file_operations i915_cache_sharing_fops = {
 	.owner = THIS_MODULE,
-	.open = i915_debugfs_common_open,
+	.open = simple_open,
 	.read = i915_cache_sharing_read,
 	.write = i915_cache_sharing_write,
 	.llseek = default_llseek,
diff -puN drivers/hid/hid-picolcd.c~simple_open-automatically-convert-to-simple_open drivers/hid/hid-picolcd.c
--- a/drivers/hid/hid-picolcd.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/hid/hid-picolcd.c
@@ -1525,12 +1525,6 @@ static const struct file_operations pico
 /*
  * The "eeprom" file
  */
-static int picolcd_debug_eeprom_open(struct inode *i, struct file *f)
-{
-	f->private_data = i->i_private;
-	return 0;
-}
-
 static ssize_t picolcd_debug_eeprom_read(struct file *f, char __user *u,
 		size_t s, loff_t *off)
 {
@@ -1618,7 +1612,7 @@ static ssize_t picolcd_debug_eeprom_writ
  */
 static const struct file_operations picolcd_debug_eeprom_fops = {
 	.owner    = THIS_MODULE,
-	.open     = picolcd_debug_eeprom_open,
+	.open     = simple_open,
 	.read     = picolcd_debug_eeprom_read,
 	.write    = picolcd_debug_eeprom_write,
 	.llseek   = generic_file_llseek,
@@ -1627,12 +1621,6 @@ static const struct file_operations pico
 /*
  * The "flash" file
  */
-static int picolcd_debug_flash_open(struct inode *i, struct file *f)
-{
-	f->private_data = i->i_private;
-	return 0;
-}
-
 /* record a flash address to buf (bounds check to be done by caller) */
 static int _picolcd_flash_setaddr(struct picolcd_data *data, u8 *buf, long off)
 {
@@ -1817,7 +1805,7 @@ static ssize_t picolcd_debug_flash_write
  */
 static const struct file_operations picolcd_debug_flash_fops = {
 	.owner    = THIS_MODULE,
-	.open     = picolcd_debug_flash_open,
+	.open     = simple_open,
 	.read     = picolcd_debug_flash_read,
 	.write    = picolcd_debug_flash_write,
 	.llseek   = generic_file_llseek,
diff -puN drivers/hid/hid-wiimote-debug.c~simple_open-automatically-convert-to-simple_open drivers/hid/hid-wiimote-debug.c
--- a/drivers/hid/hid-wiimote-debug.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/hid/hid-wiimote-debug.c
@@ -23,12 +23,6 @@ struct wiimote_debug {
 	struct dentry *drm;
 };
 
-static int wiidebug_eeprom_open(struct inode *i, struct file *f)
-{
-	f->private_data = i->i_private;
-	return 0;
-}
-
 static ssize_t wiidebug_eeprom_read(struct file *f, char __user *u, size_t s,
 								loff_t *off)
 {
@@ -83,7 +77,7 @@ static ssize_t wiidebug_eeprom_read(stru
 
 static const struct file_operations wiidebug_eeprom_fops = {
 	.owner = THIS_MODULE,
-	.open = wiidebug_eeprom_open,
+	.open = simple_open,
 	.read = wiidebug_eeprom_read,
 	.llseek = generic_file_llseek,
 };
diff -puN drivers/idle/i7300_idle.c~simple_open-automatically-convert-to-simple_open drivers/idle/i7300_idle.c
--- a/drivers/idle/i7300_idle.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/idle/i7300_idle.c
@@ -516,12 +516,6 @@ static struct notifier_block i7300_idle_
 
 MODULE_DEVICE_TABLE(pci, pci_tbl);
 
-int stats_open_generic(struct inode *inode, struct file *fp)
-{
-	fp->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t stats_read_ul(struct file *fp, char __user *ubuf, size_t count,
 				loff_t *off)
 {
@@ -534,7 +528,7 @@ static ssize_t stats_read_ul(struct file
 }
 
 static const struct file_operations idle_fops = {
-	.open	= stats_open_generic,
+	.open	= simple_open,
 	.read	= stats_read_ul,
 	.llseek = default_llseek,
 };
diff -puN drivers/iommu/omap-iommu-debug.c~simple_open-automatically-convert-to-simple_open drivers/iommu/omap-iommu-debug.c
--- a/drivers/iommu/omap-iommu-debug.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/iommu/omap-iommu-debug.c
@@ -323,15 +323,9 @@ err_out:
 	return count;
 }
 
-static int debug_open_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 #define DEBUG_FOPS(name)						\
 	static const struct file_operations debug_##name##_fops = {	\
-		.open = debug_open_generic,				\
+		.open = simple_open,					\
 		.read = debug_read_##name,				\
 		.write = debug_write_##name,				\
 		.llseek = generic_file_llseek,				\
@@ -339,7 +333,7 @@ static int debug_open_generic(struct ino
 
 #define DEBUG_FOPS_RO(name)						\
 	static const struct file_operations debug_##name##_fops = {	\
-		.open = debug_open_generic,				\
+		.open = simple_open,					\
 		.read = debug_read_##name,				\
 		.llseek = generic_file_llseek,				\
 	};
diff -puN drivers/mfd/aat2870-core.c~simple_open-automatically-convert-to-simple_open drivers/mfd/aat2870-core.c
--- a/drivers/mfd/aat2870-core.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/mfd/aat2870-core.c
@@ -262,13 +262,6 @@ static ssize_t aat2870_dump_reg(struct a
 	return count;
 }
 
-static int aat2870_reg_open_file(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static ssize_t aat2870_reg_read_file(struct file *file, char __user *user_buf,
 				     size_t count, loff_t *ppos)
 {
@@ -330,7 +323,7 @@ static ssize_t aat2870_reg_write_file(st
 }
 
 static const struct file_operations aat2870_reg_fops = {
-	.open = aat2870_reg_open_file,
+	.open = simple_open,
 	.read = aat2870_reg_read_file,
 	.write = aat2870_reg_write_file,
 };
diff -puN drivers/mfd/ab3100-core.c~simple_open-automatically-convert-to-simple_open drivers/mfd/ab3100-core.c
--- a/drivers/mfd/ab3100-core.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/mfd/ab3100-core.c
@@ -483,12 +483,6 @@ struct ab3100_get_set_reg_priv {
 	bool mode;
 };
 
-static int ab3100_get_set_reg_open_file(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t ab3100_get_set_reg(struct file *file,
 				  const char __user *user_buf,
 				  size_t count, loff_t *ppos)
@@ -583,7 +577,7 @@ static ssize_t ab3100_get_set_reg(struct
 }
 
 static const struct file_operations ab3100_get_set_reg_fops = {
-	.open = ab3100_get_set_reg_open_file,
+	.open = simple_open,
 	.write = ab3100_get_set_reg,
 	.llseek = noop_llseek,
 };
diff -puN drivers/misc/ibmasm/ibmasmfs.c~simple_open-automatically-convert-to-simple_open drivers/misc/ibmasm/ibmasmfs.c
--- a/drivers/misc/ibmasm/ibmasmfs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/misc/ibmasm/ibmasmfs.c
@@ -500,12 +500,6 @@ static ssize_t r_heartbeat_file_write(st
 	return 1;
 }
 
-static int remote_settings_file_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static int remote_settings_file_close(struct inode *inode, struct file *file)
 {
 	return 0;
@@ -600,7 +594,7 @@ static const struct file_operations r_he
 };
 
 static const struct file_operations remote_settings_fops = {
-	.open =		remote_settings_file_open,
+	.open =		simple_open,
 	.release =	remote_settings_file_close,
 	.read =		remote_settings_file_read,
 	.write =	remote_settings_file_write,
diff -puN drivers/mtd/ubi/debug.c~simple_open-automatically-convert-to-simple_open drivers/mtd/ubi/debug.c
--- a/drivers/mtd/ubi/debug.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/mtd/ubi/debug.c
@@ -386,19 +386,11 @@ out:
 	return count;
 }
 
-static int default_open(struct inode *inode, struct file *file)
-{
-	if (inode->i_private)
-		file->private_data = inode->i_private;
-
-	return 0;
-}
-
 /* File operations for all UBI debugfs files */
 static const struct file_operations dfs_fops = {
 	.read   = dfs_file_read,
 	.write  = dfs_file_write,
-	.open   = default_open,
+	.open	= simple_open,
 	.llseek = no_llseek,
 	.owner  = THIS_MODULE,
 };
diff -puN drivers/net/caif/caif_spi.c~simple_open-automatically-convert-to-simple_open drivers/net/caif/caif_spi.c
--- a/drivers/net/caif/caif_spi.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/caif/caif_spi.c
@@ -127,12 +127,6 @@ static inline void dev_debugfs_rem(struc
 	debugfs_remove(cfspi->dbgfs_dir);
 }
 
-static int dbgfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t dbgfs_state(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -243,13 +237,13 @@ static ssize_t dbgfs_frame(struct file *
 }
 
 static const struct file_operations dbgfs_state_fops = {
-	.open = dbgfs_open,
+	.open = simple_open,
 	.read = dbgfs_state,
 	.owner = THIS_MODULE
 };
 
 static const struct file_operations dbgfs_frame_fops = {
-	.open = dbgfs_open,
+	.open = simple_open,
 	.read = dbgfs_frame,
 	.owner = THIS_MODULE
 };
diff -puN drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~simple_open-automatically-convert-to-simple_open drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2000,13 +2000,6 @@ static const struct ethtool_ops cxgb_eth
 /*
  * debugfs support
  */
-
-static int mem_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t mem_read(struct file *file, char __user *buf, size_t count,
 			loff_t *ppos)
 {
@@ -2050,7 +2043,7 @@ static ssize_t mem_read(struct file *fil
 
 static const struct file_operations mem_debugfs_fops = {
 	.owner   = THIS_MODULE,
-	.open    = mem_open,
+	.open    = simple_open,
 	.read    = mem_read,
 	.llseek  = default_llseek,
 };
diff -puN drivers/net/wimax/i2400m/debugfs.c~simple_open-automatically-convert-to-simple_open drivers/net/wimax/i2400m/debugfs.c
--- a/drivers/net/wimax/i2400m/debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wimax/i2400m/debugfs.c
@@ -53,17 +53,6 @@ struct dentry *debugfs_create_netdev_que
 				   &fops_netdev_queue_stopped);
 }
 
-
-/*
- * inode->i_private has the @data argument to debugfs_create_file()
- */
-static
-int i2400m_stats_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
 /*
  * We don't allow partial reads of this file, as then the reader would
  * get weirdly confused data as it is updated.
@@ -117,7 +106,7 @@ ssize_t i2400m_rx_stats_write(struct fil
 static
 const struct file_operations i2400m_rx_stats_fops = {
 	.owner =	THIS_MODULE,
-	.open =		i2400m_stats_open,
+	.open =		simple_open,
 	.read =		i2400m_rx_stats_read,
 	.write =	i2400m_rx_stats_write,
 	.llseek =	default_llseek,
@@ -170,7 +159,7 @@ ssize_t i2400m_tx_stats_write(struct fil
 static
 const struct file_operations i2400m_tx_stats_fops = {
 	.owner =	THIS_MODULE,
-	.open =		i2400m_stats_open,
+	.open =		simple_open,
 	.read =		i2400m_tx_stats_read,
 	.write =	i2400m_tx_stats_write,
 	.llseek =	default_llseek,
diff -puN drivers/net/wireless/ath/ath5k/debug.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/ath/ath5k/debug.c
--- a/drivers/net/wireless/ath/ath5k/debug.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/ath/ath5k/debug.c
@@ -71,13 +71,6 @@ static unsigned int ath5k_debug;
 module_param_named(debug, ath5k_debug, uint, 0);
 
 
-static int ath5k_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
-
 /* debugfs: registers */
 
 struct reg {
@@ -265,7 +258,7 @@ static ssize_t write_file_beacon(struct 
 static const struct file_operations fops_beacon = {
 	.read = read_file_beacon,
 	.write = write_file_beacon,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -285,7 +278,7 @@ static ssize_t write_file_reset(struct f
 
 static const struct file_operations fops_reset = {
 	.write = write_file_reset,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = noop_llseek,
 };
@@ -365,7 +358,7 @@ static ssize_t write_file_debug(struct f
 static const struct file_operations fops_debug = {
 	.read = read_file_debug,
 	.write = write_file_debug,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -477,7 +470,7 @@ static ssize_t write_file_antenna(struct
 static const struct file_operations fops_antenna = {
 	.read = read_file_antenna,
 	.write = write_file_antenna,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -532,7 +525,7 @@ static ssize_t read_file_misc(struct fil
 
 static const struct file_operations fops_misc = {
 	.read = read_file_misc,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 };
 
@@ -647,7 +640,7 @@ static ssize_t write_file_frameerrors(st
 static const struct file_operations fops_frameerrors = {
 	.read = read_file_frameerrors,
 	.write = write_file_frameerrors,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -810,7 +803,7 @@ static ssize_t write_file_ani(struct fil
 static const struct file_operations fops_ani = {
 	.read = read_file_ani,
 	.write = write_file_ani,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -881,7 +874,7 @@ static ssize_t write_file_queue(struct f
 static const struct file_operations fops_queue = {
 	.read = read_file_queue,
 	.write = write_file_queue,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
diff -puN drivers/net/wireless/ath/ath6kl/debug.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/ath/ath6kl/debug.c
--- a/drivers/net/wireless/ath/ath6kl/debug.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/ath/ath6kl/debug.c
@@ -217,12 +217,6 @@ void dump_cred_dist_stats(struct htc_tar
 		   target->credit_info->cur_free_credits);
 }
 
-static int ath6kl_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 void ath6kl_debug_war(struct ath6kl *ar, enum ath6kl_war war)
 {
 	switch (war) {
@@ -263,7 +257,7 @@ static ssize_t read_file_war_stats(struc
 
 static const struct file_operations fops_war_stats = {
 	.read = read_file_war_stats,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -488,7 +482,7 @@ static ssize_t ath6kl_fwlog_mask_write(s
 }
 
 static const struct file_operations fops_fwlog_mask = {
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.read = ath6kl_fwlog_mask_read,
 	.write = ath6kl_fwlog_mask_write,
 	.owner = THIS_MODULE,
@@ -634,7 +628,7 @@ static ssize_t read_file_tgt_stats(struc
 
 static const struct file_operations fops_tgt_stats = {
 	.read = read_file_tgt_stats,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -699,7 +693,7 @@ static ssize_t read_file_credit_dist_sta
 
 static const struct file_operations fops_credit_dist_stats = {
 	.read = read_file_credit_dist_stats,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -802,7 +796,7 @@ static ssize_t ath6kl_endpoint_stats_wri
 }
 
 static const struct file_operations fops_endpoint_stats = {
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.read = ath6kl_endpoint_stats_read,
 	.write = ath6kl_endpoint_stats_write,
 	.owner = THIS_MODULE,
@@ -875,7 +869,7 @@ static ssize_t ath6kl_regread_write(stru
 static const struct file_operations fops_diag_reg_read = {
 	.read = ath6kl_regread_read,
 	.write = ath6kl_regread_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -999,7 +993,7 @@ static ssize_t ath6kl_lrssi_roam_read(st
 static const struct file_operations fops_lrssi_roam_threshold = {
 	.read = ath6kl_lrssi_roam_read,
 	.write = ath6kl_lrssi_roam_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1061,7 +1055,7 @@ static ssize_t ath6kl_regwrite_write(str
 static const struct file_operations fops_diag_reg_write = {
 	.read = ath6kl_regwrite_read,
 	.write = ath6kl_regwrite_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1166,7 +1160,7 @@ static ssize_t ath6kl_roam_table_read(st
 
 static const struct file_operations fops_roam_table = {
 	.read = ath6kl_roam_table_read,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1204,7 +1198,7 @@ static ssize_t ath6kl_force_roam_write(s
 
 static const struct file_operations fops_force_roam = {
 	.write = ath6kl_force_roam_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1244,7 +1238,7 @@ static ssize_t ath6kl_roam_mode_write(st
 
 static const struct file_operations fops_roam_mode = {
 	.write = ath6kl_roam_mode_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1286,7 +1280,7 @@ static ssize_t ath6kl_keepalive_write(st
 }
 
 static const struct file_operations fops_keepalive = {
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.read = ath6kl_keepalive_read,
 	.write = ath6kl_keepalive_write,
 	.owner = THIS_MODULE,
@@ -1331,7 +1325,7 @@ static ssize_t ath6kl_disconnect_timeout
 }
 
 static const struct file_operations fops_disconnect_timeout = {
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.read = ath6kl_disconnect_timeout_read,
 	.write = ath6kl_disconnect_timeout_write,
 	.owner = THIS_MODULE,
@@ -1512,7 +1506,7 @@ static ssize_t ath6kl_create_qos_write(s
 
 static const struct file_operations fops_create_qos = {
 	.write = ath6kl_create_qos_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1560,7 +1554,7 @@ static ssize_t ath6kl_delete_qos_write(s
 
 static const struct file_operations fops_delete_qos = {
 	.write = ath6kl_delete_qos_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1593,7 +1587,7 @@ static ssize_t ath6kl_bgscan_int_write(s
 
 static const struct file_operations fops_bgscan_int = {
 	.write = ath6kl_bgscan_int_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1651,7 +1645,7 @@ static ssize_t ath6kl_listen_int_read(st
 static const struct file_operations fops_listen_int = {
 	.read = ath6kl_listen_int_read,
 	.write = ath6kl_listen_int_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1711,7 +1705,7 @@ static ssize_t ath6kl_power_params_write
 
 static const struct file_operations fops_power_params = {
 	.write = ath6kl_power_params_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
diff -puN drivers/net/wireless/ath/ath9k/debug.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/ath/ath9k/debug.c
--- a/drivers/net/wireless/ath/ath9k/debug.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/ath/ath9k/debug.c
@@ -26,11 +26,6 @@
 #define REG_READ_D(_ah, _reg) \
 	ath9k_hw_common(_ah)->ops->read((_ah), (_reg))
 
-static int ath9k_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
 
 static ssize_t ath9k_debugfs_read_buf(struct file *file, char __user *user_buf,
 				      size_t count, loff_t *ppos)
@@ -83,7 +78,7 @@ static ssize_t write_file_debug(struct f
 static const struct file_operations fops_debug = {
 	.read = read_file_debug,
 	.write = write_file_debug,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -129,7 +124,7 @@ static ssize_t write_file_tx_chainmask(s
 static const struct file_operations fops_tx_chainmask = {
 	.read = read_file_tx_chainmask,
 	.write = write_file_tx_chainmask,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -172,7 +167,7 @@ static ssize_t write_file_rx_chainmask(s
 static const struct file_operations fops_rx_chainmask = {
 	.read = read_file_rx_chainmask,
 	.write = write_file_rx_chainmask,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -223,7 +218,7 @@ static ssize_t write_file_disable_ani(st
 static const struct file_operations fops_disable_ani = {
 	.read = read_file_disable_ani,
 	.write = write_file_disable_ani,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -324,7 +319,7 @@ static ssize_t read_file_dma(struct file
 
 static const struct file_operations fops_dma = {
 	.read = read_file_dma,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -446,7 +441,7 @@ static ssize_t read_file_interrupt(struc
 
 static const struct file_operations fops_interrupt = {
 	.read = read_file_interrupt,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -852,28 +847,28 @@ void ath_debug_stat_tx(struct ath_softc 
 
 static const struct file_operations fops_xmit = {
 	.read = read_file_xmit,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
 
 static const struct file_operations fops_stations = {
 	.read = read_file_stations,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
 
 static const struct file_operations fops_misc = {
 	.read = read_file_misc,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
 
 static const struct file_operations fops_reset = {
 	.read = read_file_reset,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1016,7 +1011,7 @@ void ath_debug_stat_rx(struct ath_softc 
 
 static const struct file_operations fops_recv = {
 	.read = read_file_recv,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1055,7 +1050,7 @@ static ssize_t write_file_regidx(struct 
 static const struct file_operations fops_regidx = {
 	.read = read_file_regidx,
 	.write = write_file_regidx,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1102,7 +1097,7 @@ static ssize_t write_file_regval(struct 
 static const struct file_operations fops_regval = {
 	.read = read_file_regval,
 	.write = write_file_regval,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1191,7 +1186,7 @@ static ssize_t read_file_dump_nfcal(stru
 
 static const struct file_operations fops_dump_nfcal = {
 	.read = read_file_dump_nfcal,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1219,7 +1214,7 @@ static ssize_t read_file_base_eeprom(str
 
 static const struct file_operations fops_base_eeprom = {
 	.read = read_file_base_eeprom,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1247,7 +1242,7 @@ static ssize_t read_file_modal_eeprom(st
 
 static const struct file_operations fops_modal_eeprom = {
 	.read = read_file_modal_eeprom,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
diff -puN drivers/net/wireless/ath/ath9k/dfs_debug.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/ath/ath9k/dfs_debug.c
--- a/drivers/net/wireless/ath/ath9k/dfs_debug.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/ath/ath9k/dfs_debug.c
@@ -60,16 +60,9 @@ static ssize_t read_file_dfs(struct file
 	return retval;
 }
 
-static int ath9k_dfs_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static const struct file_operations fops_dfs_stats = {
 	.read = read_file_dfs,
-	.open = ath9k_dfs_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
diff -puN drivers/net/wireless/ath/ath9k/htc_drv_debug.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/ath/ath9k/htc_drv_debug.c
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -16,12 +16,6 @@
 
 #include "htc.h"
 
-static int ath9k_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t read_file_tgt_int_stats(struct file *file, char __user *user_buf,
 				       size_t count, loff_t *ppos)
 {
@@ -75,7 +69,7 @@ static ssize_t read_file_tgt_int_stats(s
 
 static const struct file_operations fops_tgt_int_stats = {
 	.read = read_file_tgt_int_stats,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -145,7 +139,7 @@ static ssize_t read_file_tgt_tx_stats(st
 
 static const struct file_operations fops_tgt_tx_stats = {
 	.read = read_file_tgt_tx_stats,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -191,7 +185,7 @@ static ssize_t read_file_tgt_rx_stats(st
 
 static const struct file_operations fops_tgt_rx_stats = {
 	.read = read_file_tgt_rx_stats,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -243,7 +237,7 @@ static ssize_t read_file_xmit(struct fil
 
 static const struct file_operations fops_xmit = {
 	.read = read_file_xmit,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -364,7 +358,7 @@ static ssize_t read_file_recv(struct fil
 
 static const struct file_operations fops_recv = {
 	.read = read_file_recv,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -399,7 +393,7 @@ static ssize_t read_file_slot(struct fil
 
 static const struct file_operations fops_slot = {
 	.read = read_file_slot,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -446,7 +440,7 @@ static ssize_t read_file_queue(struct fi
 
 static const struct file_operations fops_queue = {
 	.read = read_file_queue,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -487,7 +481,7 @@ static ssize_t write_file_debug(struct f
 static const struct file_operations fops_debug = {
 	.read = read_file_debug,
 	.write = write_file_debug,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -636,7 +630,7 @@ static ssize_t read_file_base_eeprom(str
 
 static const struct file_operations fops_base_eeprom = {
 	.read = read_file_base_eeprom,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -917,7 +911,7 @@ static ssize_t read_file_modal_eeprom(st
 
 static const struct file_operations fops_modal_eeprom = {
 	.read = read_file_modal_eeprom,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
diff -puN drivers/net/wireless/ath/ath9k/rc.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/ath/ath9k/rc.c
--- a/drivers/net/wireless/ath/ath9k/rc.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/ath/ath9k/rc.c
@@ -1480,12 +1480,6 @@ static void ath_rate_update(void *priv, 
 
 #ifdef CONFIG_ATH9K_DEBUGFS
 
-static int ath9k_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
@@ -1553,7 +1547,7 @@ static ssize_t read_file_rcstat(struct f
 
 static const struct file_operations fops_rcstat = {
 	.read = read_file_rcstat,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE
 };
 
diff -puN drivers/net/wireless/ath/carl9170/debug.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/ath/carl9170/debug.c
--- a/drivers/net/wireless/ath/carl9170/debug.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/ath/carl9170/debug.c
@@ -48,11 +48,6 @@
 #define ADD(buf, off, max, fmt, args...)				\
 	off += snprintf(&buf[off], max - off, fmt, ##args);
 
-static int carl9170_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
 
 struct carl9170_debugfs_fops {
 	unsigned int read_bufsize;
@@ -178,7 +173,7 @@ static const struct carl9170_debugfs_fop
 	.attr = _attr,							\
 	.req_dev_state = _dstate,					\
 	.fops = {							\
-		.open	= carl9170_debugfs_open,			\
+		.open	= simple_open,					\
 		.read	= carl9170_debugfs_read,			\
 		.write	= carl9170_debugfs_write,			\
 		.owner	= THIS_MODULE					\
diff -puN drivers/net/wireless/b43/debugfs.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/b43/debugfs.c
--- a/drivers/net/wireless/b43/debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/b43/debugfs.c
@@ -500,12 +500,6 @@ out:
 
 #undef fappend
 
-static int b43_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t b43_debugfs_read(struct file *file, char __user *userbuf,
 				size_t count, loff_t *ppos)
 {
@@ -624,7 +618,7 @@ out_unlock:
 		.read	= _read,				\
 		.write	= _write,				\
 		.fops	= {					\
-			.open	= b43_debugfs_open,		\
+			.open	= simple_open,			\
 			.read	= b43_debugfs_read,		\
 			.write	= b43_debugfs_write,		\
 			.llseek = generic_file_llseek,		\
diff -puN drivers/net/wireless/b43legacy/debugfs.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/b43legacy/debugfs.c
--- a/drivers/net/wireless/b43legacy/debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/b43legacy/debugfs.c
@@ -197,12 +197,6 @@ static int restart_write_file(struct b43
 
 #undef fappend
 
-static int b43legacy_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
 				size_t count, loff_t *ppos)
 {
@@ -331,7 +325,7 @@ out_unlock:
 		.read	= _read,				\
 		.write	= _write,				\
 		.fops	= {					\
-			.open	= b43legacy_debugfs_open,		\
+			.open	= simple_open,				\
 			.read	= b43legacy_debugfs_read,		\
 			.write	= b43legacy_debugfs_write,		\
 			.llseek = generic_file_llseek,			\
diff -puN drivers/net/wireless/iwlegacy/3945-rs.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/iwlegacy/3945-rs.c
--- a/drivers/net/wireless/iwlegacy/3945-rs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -821,12 +821,6 @@ out:
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-static int
-il3945_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
 
 static ssize_t
 il3945_sta_dbgfs_stats_table_read(struct file *file, char __user *user_buf,
@@ -862,7 +856,7 @@ il3945_sta_dbgfs_stats_table_read(struct
 
 static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = il3945_sta_dbgfs_stats_table_read,
-	.open = il3945_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
diff -puN drivers/net/wireless/iwlegacy/4965-rs.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/iwlegacy/4965-rs.c
--- a/drivers/net/wireless/iwlegacy/4965-rs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -2518,12 +2518,6 @@ il4965_rs_free_sta(void *il_r, struct ie
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-static int
-il4965_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
 
 static void
 il4965_rs_dbgfs_set_mcs(struct il_lq_sta *lq_sta, u32 * rate_n_flags, int idx)
@@ -2695,7 +2689,7 @@ il4965_rs_sta_dbgfs_scale_table_read(str
 static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
 	.write = il4965_rs_sta_dbgfs_scale_table_write,
 	.read = il4965_rs_sta_dbgfs_scale_table_read,
-	.open = il4965_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -2740,7 +2734,7 @@ il4965_rs_sta_dbgfs_stats_table_read(str
 
 static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = il4965_rs_sta_dbgfs_stats_table_read,
-	.open = il4965_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -2768,7 +2762,7 @@ il4965_rs_sta_dbgfs_rate_scale_data_read
 
 static const struct file_operations rs_sta_dbgfs_rate_scale_data_ops = {
 	.read = il4965_rs_sta_dbgfs_rate_scale_data_read,
-	.open = il4965_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
diff -puN drivers/net/wireless/iwlegacy/debug.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/iwlegacy/debug.c
--- a/drivers/net/wireless/iwlegacy/debug.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/iwlegacy/debug.c
@@ -160,18 +160,12 @@ static ssize_t il_dbgfs_##name##_write(s
 					const char __user *user_buf,    \
 					size_t count, loff_t *ppos);
 
-static int
-il_dbgfs_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
 
 #define DEBUGFS_READ_FILE_OPS(name)				\
 	DEBUGFS_READ_FUNC(name);				\
 static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.read = il_dbgfs_##name##_read,				\
-	.open = il_dbgfs_open_file_generic,			\
+	.open = simple_open,					\
 	.llseek = generic_file_llseek,				\
 };
 
@@ -179,7 +173,7 @@ static const struct file_operations il_d
 	DEBUGFS_WRITE_FUNC(name);				\
 static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.write = il_dbgfs_##name##_write,			\
-	.open = il_dbgfs_open_file_generic,			\
+	.open = simple_open,					\
 	.llseek = generic_file_llseek,				\
 };
 
@@ -189,7 +183,7 @@ static const struct file_operations il_d
 static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.write = il_dbgfs_##name##_write,			\
 	.read = il_dbgfs_##name##_read,				\
-	.open = il_dbgfs_open_file_generic,			\
+	.open = simple_open,					\
 	.llseek = generic_file_llseek,				\
 };
 
diff -puN drivers/net/wireless/iwlwifi/iwl-agn-rs.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/iwlwifi/iwl-agn-rs.c
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -3083,11 +3083,6 @@ static void rs_free_sta(void *priv_r, st
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-static int open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
 static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
 			     u32 *rate_n_flags, int index)
 {
@@ -3226,7 +3221,7 @@ static ssize_t rs_sta_dbgfs_scale_table_
 static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
 	.write = rs_sta_dbgfs_scale_table_write,
 	.read = rs_sta_dbgfs_scale_table_read,
-	.open = open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
@@ -3269,7 +3264,7 @@ static ssize_t rs_sta_dbgfs_stats_table_
 
 static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = rs_sta_dbgfs_stats_table_read,
-	.open = open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -3295,7 +3290,7 @@ static ssize_t rs_sta_dbgfs_rate_scale_d
 
 static const struct file_operations rs_sta_dbgfs_rate_scale_data_ops = {
 	.read = rs_sta_dbgfs_rate_scale_data_read,
-	.open = open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
diff -puN drivers/net/wireless/iwlwifi/iwl-debugfs.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/iwlwifi/iwl-debugfs.c
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -84,17 +84,11 @@ static ssize_t iwl_dbgfs_##name##_write(
 					size_t count, loff_t *ppos);
 
 
-static int iwl_dbgfs_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 #define DEBUGFS_READ_FILE_OPS(name)                                     \
 	DEBUGFS_READ_FUNC(name);                                        \
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.read = iwl_dbgfs_##name##_read,                       		\
-	.open = iwl_dbgfs_open_file_generic,                    	\
+	.open = simple_open,                    			\
 	.llseek = generic_file_llseek,					\
 };
 
@@ -102,7 +96,7 @@ static const struct file_operations iwl_
 	DEBUGFS_WRITE_FUNC(name);                                       \
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.write = iwl_dbgfs_##name##_write,                              \
-	.open = iwl_dbgfs_open_file_generic,                    	\
+	.open = simple_open,                    			\
 	.llseek = generic_file_llseek,					\
 };
 
@@ -113,7 +107,7 @@ static const struct file_operations iwl_
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.write = iwl_dbgfs_##name##_write,                              \
 	.read = iwl_dbgfs_##name##_read,                                \
-	.open = iwl_dbgfs_open_file_generic,                            \
+	.open = simple_open,                            		\
 	.llseek = generic_file_llseek,					\
 };
 
diff -puN drivers/net/wireless/iwlwifi/iwl-trans-pcie.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1898,17 +1898,11 @@ static ssize_t iwl_dbgfs_##name##_write(
 					size_t count, loff_t *ppos);
 
 
-static int iwl_dbgfs_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 #define DEBUGFS_READ_FILE_OPS(name)					\
 	DEBUGFS_READ_FUNC(name);					\
 static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.read = iwl_dbgfs_##name##_read,				\
-	.open = iwl_dbgfs_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
@@ -1916,7 +1910,7 @@ static const struct file_operations iwl_
 	DEBUGFS_WRITE_FUNC(name);                                       \
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.write = iwl_dbgfs_##name##_write,                              \
-	.open = iwl_dbgfs_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
@@ -1926,7 +1920,7 @@ static const struct file_operations iwl_
 static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.write = iwl_dbgfs_##name##_write,				\
 	.read = iwl_dbgfs_##name##_read,				\
-	.open = iwl_dbgfs_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
diff -puN drivers/net/wireless/iwmc3200wifi/debugfs.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/iwmc3200wifi/debugfs.c
--- a/drivers/net/wireless/iwmc3200wifi/debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/iwmc3200wifi/debugfs.c
@@ -99,12 +99,6 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_iwm_dbg_mod
 			iwm_debugfs_u32_read, iwm_debugfs_dbg_modules_write,
 			"%llu\n");
 
-static int iwm_generic_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
 
 static ssize_t iwm_debugfs_txq_read(struct file *filp, char __user *buffer,
 				   size_t count, loff_t *ppos)
@@ -401,28 +395,28 @@ out:
 
 static const struct file_operations iwm_debugfs_txq_fops = {
 	.owner =	THIS_MODULE,
-	.open =		iwm_generic_open,
+	.open =		simple_open,
 	.read =		iwm_debugfs_txq_read,
 	.llseek =	default_llseek,
 };
 
 static const struct file_operations iwm_debugfs_tx_credit_fops = {
 	.owner =	THIS_MODULE,
-	.open =		iwm_generic_open,
+	.open =		simple_open,
 	.read =		iwm_debugfs_tx_credit_read,
 	.llseek =	default_llseek,
 };
 
 static const struct file_operations iwm_debugfs_rx_ticket_fops = {
 	.owner =	THIS_MODULE,
-	.open =		iwm_generic_open,
+	.open =		simple_open,
 	.read =		iwm_debugfs_rx_ticket_read,
 	.llseek =	default_llseek,
 };
 
 static const struct file_operations iwm_debugfs_fw_err_fops = {
 	.owner =	THIS_MODULE,
-	.open =		iwm_generic_open,
+	.open =		simple_open,
 	.read =		iwm_debugfs_fw_err_read,
 	.llseek =	default_llseek,
 };
diff -puN drivers/net/wireless/iwmc3200wifi/sdio.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/iwmc3200wifi/sdio.c
--- a/drivers/net/wireless/iwmc3200wifi/sdio.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/iwmc3200wifi/sdio.c
@@ -264,13 +264,6 @@ static int if_sdio_send_chunk(struct iwm
 	return ret;
 }
 
-/* debugfs hooks */
-static int iwm_debugfs_sdio_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t iwm_debugfs_sdio_read(struct file *filp, char __user *buffer,
 				     size_t count, loff_t *ppos)
 {
@@ -363,7 +356,7 @@ err:
 
 static const struct file_operations iwm_debugfs_sdio_fops = {
 	.owner =	THIS_MODULE,
-	.open =		iwm_debugfs_sdio_open,
+	.open =		simple_open,
 	.read =		iwm_debugfs_sdio_read,
 	.llseek =	default_llseek,
 };
diff -puN drivers/net/wireless/libertas/debugfs.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/libertas/debugfs.c
--- a/drivers/net/wireless/libertas/debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/libertas/debugfs.c
@@ -21,12 +21,6 @@ static char *szStates[] = {
 static void lbs_debug_init(struct lbs_private *priv);
 #endif
 
-static int open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t write_file_dummy(struct file *file, const char __user *buf,
                                 size_t count, loff_t *ppos)
 {
@@ -696,7 +690,7 @@ out_unlock:
 
 #define FOPS(fread, fwrite) { \
 	.owner = THIS_MODULE, \
-	.open = open_file_generic, \
+	.open = simple_open, \
 	.read = (fread), \
 	.write = (fwrite), \
 	.llseek = generic_file_llseek, \
@@ -962,7 +956,7 @@ static ssize_t lbs_debugfs_write(struct 
 
 static const struct file_operations lbs_debug_fops = {
 	.owner = THIS_MODULE,
-	.open = open_file_generic,
+	.open = simple_open,
 	.write = lbs_debugfs_write,
 	.read = lbs_debugfs_read,
 	.llseek = default_llseek,
diff -puN drivers/net/wireless/mwifiex/debugfs.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/mwifiex/debugfs.c
--- a/drivers/net/wireless/mwifiex/debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/mwifiex/debugfs.c
@@ -140,18 +140,6 @@ static struct mwifiex_debug_data items[]
 static int num_of_items = ARRAY_SIZE(items);
 
 /*
- * Generic proc file open handler.
- *
- * This function is called every time a file is accessed for read or write.
- */
-static int
-mwifiex_open_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
-/*
  * Proc info file read handler.
  *
  * This function is called when the 'info' file is opened for reading.
@@ -676,19 +664,19 @@ done:
 static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 	.read = mwifiex_##name##_read,                                  \
 	.write = mwifiex_##name##_write,                                \
-	.open = mwifiex_open_generic,                                   \
+	.open = simple_open,                                            \
 };
 
 #define MWIFIEX_DFS_FILE_READ_OPS(name)                                 \
 static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 	.read = mwifiex_##name##_read,                                  \
-	.open = mwifiex_open_generic,                                   \
+	.open = simple_open,                                            \
 };
 
 #define MWIFIEX_DFS_FILE_WRITE_OPS(name)                                \
 static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 	.write = mwifiex_##name##_write,                                \
-	.open = mwifiex_open_generic,                                   \
+	.open = simple_open,                                            \
 };
 
 
diff -puN drivers/net/wireless/wl1251/debugfs.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/wl1251/debugfs.c
--- a/drivers/net/wireless/wl1251/debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/wl1251/debugfs.c
@@ -47,7 +47,7 @@ static ssize_t name## _read(struct file 
 									\
 static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
-	.open = wl1251_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek	= generic_file_llseek,					\
 };
 
@@ -84,7 +84,7 @@ static ssize_t sub## _ ##name## _read(st
 									\
 static const struct file_operations sub## _ ##name## _ops = {		\
 	.read = sub## _ ##name## _read,					\
-	.open = wl1251_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek	= generic_file_llseek,					\
 };
 
@@ -117,12 +117,6 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
-static int wl1251_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 DEBUGFS_FWSTATS_FILE(tx, internal_desc_overflow, 20, "%u");
 
 DEBUGFS_FWSTATS_FILE(rx, out_of_mem, 20, "%u");
@@ -235,7 +229,7 @@ static ssize_t tx_queue_len_read(struct 
 
 static const struct file_operations tx_queue_len_ops = {
 	.read = tx_queue_len_read,
-	.open = wl1251_open_file_generic,
+	.open = simple_open,
 	.llseek = generic_file_llseek,
 };
 
@@ -257,7 +251,7 @@ static ssize_t tx_queue_status_read(stru
 
 static const struct file_operations tx_queue_status_ops = {
 	.read = tx_queue_status_read,
-	.open = wl1251_open_file_generic,
+	.open = simple_open,
 	.llseek = generic_file_llseek,
 };
 
diff -puN drivers/net/wireless/wl12xx/debugfs.c~simple_open-automatically-convert-to-simple_open drivers/net/wireless/wl12xx/debugfs.c
--- a/drivers/net/wireless/wl12xx/debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/net/wireless/wl12xx/debugfs.c
@@ -63,7 +63,7 @@ static ssize_t name## _read(struct file 
 									\
 static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
-	.open = wl1271_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek	= generic_file_llseek,					\
 };
 
@@ -96,7 +96,7 @@ static ssize_t sub## _ ##name## _read(st
 									\
 static const struct file_operations sub## _ ##name## _ops = {		\
 	.read = sub## _ ##name## _read,					\
-	.open = wl1271_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek	= generic_file_llseek,					\
 };
 
@@ -126,12 +126,6 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
-static int wl1271_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 DEBUGFS_FWSTATS_FILE(tx, internal_desc_overflow, "%u");
 
 DEBUGFS_FWSTATS_FILE(rx, out_of_mem, "%u");
@@ -243,7 +237,7 @@ static ssize_t tx_queue_len_read(struct 
 
 static const struct file_operations tx_queue_len_ops = {
 	.read = tx_queue_len_read,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -289,7 +283,7 @@ static ssize_t gpio_power_write(struct f
 static const struct file_operations gpio_power_ops = {
 	.read = gpio_power_read,
 	.write = gpio_power_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -308,7 +302,7 @@ static ssize_t start_recovery_write(stru
 
 static const struct file_operations start_recovery_ops = {
 	.write = start_recovery_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -372,7 +366,7 @@ out:
 static const struct file_operations dynamic_ps_timeout_ops = {
 	.read = dynamic_ps_timeout_read,
 	.write = dynamic_ps_timeout_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -441,7 +435,7 @@ out:
 static const struct file_operations forced_ps_ops = {
 	.read = forced_ps_read,
 	.write = forced_ps_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -483,7 +477,7 @@ static ssize_t split_scan_timeout_write(
 static const struct file_operations split_scan_timeout_ops = {
 	.read = split_scan_timeout_read,
 	.write = split_scan_timeout_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -566,7 +560,7 @@ static ssize_t driver_state_read(struct 
 
 static const struct file_operations driver_state_ops = {
 	.read = driver_state_read,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -675,7 +669,7 @@ static ssize_t vifs_state_read(struct fi
 
 static const struct file_operations vifs_state_ops = {
 	.read = vifs_state_read,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -733,7 +727,7 @@ static ssize_t dtim_interval_write(struc
 static const struct file_operations dtim_interval_ops = {
 	.read = dtim_interval_read,
 	.write = dtim_interval_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -791,7 +785,7 @@ static ssize_t suspend_dtim_interval_wri
 static const struct file_operations suspend_dtim_interval_ops = {
 	.read = suspend_dtim_interval_read,
 	.write = suspend_dtim_interval_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -849,7 +843,7 @@ static ssize_t beacon_interval_write(str
 static const struct file_operations beacon_interval_ops = {
 	.read = beacon_interval_read,
 	.write = beacon_interval_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -904,7 +898,7 @@ static ssize_t rx_streaming_interval_rea
 static const struct file_operations rx_streaming_interval_ops = {
 	.read = rx_streaming_interval_read,
 	.write = rx_streaming_interval_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -959,7 +953,7 @@ static ssize_t rx_streaming_always_read(
 static const struct file_operations rx_streaming_always_ops = {
 	.read = rx_streaming_always_read,
 	.write = rx_streaming_always_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -1003,7 +997,7 @@ out:
 
 static const struct file_operations beacon_filtering_ops = {
 	.write = beacon_filtering_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
diff -puN drivers/oprofile/oprofilefs.c~simple_open-automatically-convert-to-simple_open drivers/oprofile/oprofilefs.c
--- a/drivers/oprofile/oprofilefs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/oprofile/oprofilefs.c
@@ -117,25 +117,17 @@ static ssize_t ulong_write_file(struct f
 }
 
 
-static int default_open(struct inode *inode, struct file *filp)
-{
-	if (inode->i_private)
-		filp->private_data = inode->i_private;
-	return 0;
-}
-
-
 static const struct file_operations ulong_fops = {
 	.read		= ulong_read_file,
 	.write		= ulong_write_file,
-	.open		= default_open,
+	.open		= simple_open,
 	.llseek		= default_llseek,
 };
 
 
 static const struct file_operations ulong_ro_fops = {
 	.read		= ulong_read_file,
-	.open		= default_open,
+	.open		= simple_open,
 	.llseek		= default_llseek,
 };
 
@@ -187,7 +179,7 @@ static ssize_t atomic_read_file(struct f
 
 static const struct file_operations atomic_ro_fops = {
 	.read		= atomic_read_file,
-	.open		= default_open,
+	.open		= simple_open,
 	.llseek		= default_llseek,
 };
 
diff -puN drivers/remoteproc/remoteproc_debugfs.c~simple_open-automatically-convert-to-simple_open drivers/remoteproc/remoteproc_debugfs.c
--- a/drivers/remoteproc/remoteproc_debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/remoteproc/remoteproc_debugfs.c
@@ -50,16 +50,9 @@ static ssize_t rproc_trace_read(struct f
 	return simple_read_from_buffer(userbuf, count, ppos, trace->va, len);
 }
 
-static int rproc_open_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static const struct file_operations trace_rproc_ops = {
 	.read = rproc_trace_read,
-	.open = rproc_open_generic,
+	.open = simple_open,
 	.llseek	= generic_file_llseek,
 };
 
@@ -94,7 +87,7 @@ static ssize_t rproc_state_read(struct f
 
 static const struct file_operations rproc_state_ops = {
 	.read = rproc_state_read,
-	.open = rproc_open_generic,
+	.open = simple_open,
 	.llseek	= generic_file_llseek,
 };
 
@@ -114,7 +107,7 @@ static ssize_t rproc_name_read(struct fi
 
 static const struct file_operations rproc_name_ops = {
 	.read = rproc_name_read,
-	.open = rproc_open_generic,
+	.open = simple_open,
 	.llseek	= generic_file_llseek,
 };
 
diff -puN drivers/scsi/lpfc/lpfc_debugfs.c~simple_open-automatically-convert-to-simple_open drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -997,13 +997,6 @@ lpfc_debugfs_dumpDataDif_write(struct fi
 	return nbytes;
 }
 
-static int
-lpfc_debugfs_dif_err_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t
 lpfc_debugfs_dif_err_read(struct file *file, char __user *buf,
 	size_t nbytes, loff_t *ppos)
@@ -3521,7 +3514,7 @@ static const struct file_operations lpfc
 #undef lpfc_debugfs_op_dif_err
 static const struct file_operations lpfc_debugfs_op_dif_err = {
 	.owner =	THIS_MODULE,
-	.open =		lpfc_debugfs_dif_err_open,
+	.open =		simple_open,
 	.llseek =	lpfc_debugfs_lseek,
 	.read =		lpfc_debugfs_dif_err_read,
 	.write =	lpfc_debugfs_dif_err_write,
diff -puN drivers/spi/spi-dw.c~simple_open-automatically-convert-to-simple_open drivers/spi/spi-dw.c
--- a/drivers/spi/spi-dw.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/spi/spi-dw.c
@@ -63,12 +63,6 @@ struct chip_data {
 };
 
 #ifdef CONFIG_DEBUG_FS
-static int spi_show_regs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 #define SPI_REGS_BUFSIZE	1024
 static ssize_t  spi_show_regs(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
@@ -128,7 +122,7 @@ static ssize_t  spi_show_regs(struct fil
 
 static const struct file_operations mrst_spi_regs_ops = {
 	.owner		= THIS_MODULE,
-	.open		= spi_show_regs_open,
+	.open		= simple_open,
 	.read		= spi_show_regs,
 	.llseek		= default_llseek,
 };
diff -puN drivers/tty/serial/mfd.c~simple_open-automatically-convert-to-simple_open drivers/tty/serial/mfd.c
--- a/drivers/tty/serial/mfd.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/tty/serial/mfd.c
@@ -127,11 +127,6 @@ static inline void serial_out(struct uar
 
 #define HSU_REGS_BUFSIZE	1024
 
-static int hsu_show_regs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
 
 static ssize_t port_show_regs(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
@@ -231,14 +226,14 @@ static ssize_t dma_show_regs(struct file
 
 static const struct file_operations port_regs_ops = {
 	.owner		= THIS_MODULE,
-	.open		= hsu_show_regs_open,
+	.open		= simple_open,
 	.read		= port_show_regs,
 	.llseek		= default_llseek,
 };
 
 static const struct file_operations dma_regs_ops = {
 	.owner		= THIS_MODULE,
-	.open		= hsu_show_regs_open,
+	.open		= simple_open,
 	.read		= dma_show_regs,
 	.llseek		= default_llseek,
 };
diff -puN drivers/tty/serial/pch_uart.c~simple_open-automatically-convert-to-simple_open drivers/tty/serial/pch_uart.c
--- a/drivers/tty/serial/pch_uart.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/tty/serial/pch_uart.c
@@ -304,11 +304,7 @@ static const int trigger_level_1[4] = { 
 #ifdef CONFIG_DEBUG_FS
 
 #define PCH_REGS_BUFSIZE	1024
-static int pch_show_regs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
+
 
 static ssize_t port_show_regs(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
@@ -362,7 +358,7 @@ static ssize_t port_show_regs(struct fil
 
 static const struct file_operations port_regs_ops = {
 	.owner		= THIS_MODULE,
-	.open		= pch_show_regs_open,
+	.open		= simple_open,
 	.read		= port_show_regs,
 	.llseek		= default_llseek,
 };
diff -puN drivers/usb/core/inode.c~simple_open-automatically-convert-to-simple_open drivers/usb/core/inode.c
--- a/drivers/usb/core/inode.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/usb/core/inode.c
@@ -428,18 +428,10 @@ static loff_t default_file_lseek (struct
 	return retval;
 }
 
-static int default_open (struct inode *inode, struct file *file)
-{
-	if (inode->i_private)
-		file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static const struct file_operations default_file_operations = {
 	.read =		default_read_file,
 	.write =	default_write_file,
-	.open =		default_open,
+	.open =		simple_open,
 	.llseek =	default_file_lseek,
 };
 
diff -puN drivers/usb/host/ehci-dbg.c~simple_open-automatically-convert-to-simple_open drivers/usb/host/ehci-dbg.c
--- a/drivers/usb/host/ehci-dbg.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/usb/host/ehci-dbg.c
@@ -352,7 +352,6 @@ static int debug_async_open(struct inode
 static int debug_periodic_open(struct inode *, struct file *);
 static int debug_registers_open(struct inode *, struct file *);
 static int debug_async_open(struct inode *, struct file *);
-static int debug_lpm_open(struct inode *, struct file *);
 static ssize_t debug_lpm_read(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos);
 static ssize_t debug_lpm_write(struct file *file, const char __user *buffer,
@@ -385,7 +384,7 @@ static const struct file_operations debu
 };
 static const struct file_operations debug_lpm_fops = {
 	.owner		= THIS_MODULE,
-	.open		= debug_lpm_open,
+	.open		= simple_open,
 	.read		= debug_lpm_read,
 	.write		= debug_lpm_write,
 	.release	= debug_lpm_close,
@@ -970,12 +969,6 @@ static int debug_registers_open(struct i
 	return file->private_data ? 0 : -ENOMEM;
 }
 
-static int debug_lpm_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static int debug_lpm_close(struct inode *inode, struct file *file)
 {
 	return 0;
diff -puN drivers/uwb/uwb-debug.c~simple_open-automatically-convert-to-simple_open drivers/uwb/uwb-debug.c
--- a/drivers/uwb/uwb-debug.c~simple_open-automatically-convert-to-simple_open
+++ a/drivers/uwb/uwb-debug.c
@@ -159,13 +159,6 @@ static int cmd_ie_rm(struct uwb_rc *rc, 
 	return uwb_rc_ie_rm(rc, ie_to_rm->data[0]);
 }
 
-static int command_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static ssize_t command_write(struct file *file, const char __user *buf,
 			 size_t len, loff_t *off)
 {
@@ -206,7 +199,7 @@ static ssize_t command_write(struct file
 }
 
 static const struct file_operations command_fops = {
-	.open   = command_open,
+	.open	= simple_open,
 	.write  = command_write,
 	.read   = NULL,
 	.llseek = no_llseek,
diff -puN fs/debugfs/file.c~simple_open-automatically-convert-to-simple_open fs/debugfs/file.c
--- a/fs/debugfs/file.c~simple_open-automatically-convert-to-simple_open
+++ a/fs/debugfs/file.c
@@ -33,18 +33,10 @@ static ssize_t default_write_file(struct
 	return count;
 }
 
-static int default_open(struct inode *inode, struct file *file)
-{
-	if (inode->i_private)
-		file->private_data = inode->i_private;
-
-	return 0;
-}
-
 const struct file_operations debugfs_file_operations = {
 	.read =		default_read_file,
 	.write =	default_write_file,
-	.open =		default_open,
+	.open =		simple_open,
 	.llseek =	noop_llseek,
 };
 
@@ -447,7 +439,7 @@ static ssize_t write_file_bool(struct fi
 static const struct file_operations fops_bool = {
 	.read =		read_file_bool,
 	.write =	write_file_bool,
-	.open =		default_open,
+	.open =		simple_open,
 	.llseek =	default_llseek,
 };
 
@@ -492,7 +484,7 @@ static ssize_t read_file_blob(struct fil
 
 static const struct file_operations fops_blob = {
 	.read =		read_file_blob,
-	.open =		default_open,
+	.open =		simple_open,
 	.llseek =	default_llseek,
 };
 
diff -puN fs/dlm/debug_fs.c~simple_open-automatically-convert-to-simple_open fs/dlm/debug_fs.c
--- a/fs/dlm/debug_fs.c~simple_open-automatically-convert-to-simple_open
+++ a/fs/dlm/debug_fs.c
@@ -609,13 +609,6 @@ static const struct file_operations form
 /*
  * dump lkb's on the ls_waiters list
  */
-
-static int waiters_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t waiters_read(struct file *file, char __user *userbuf,
 			    size_t count, loff_t *ppos)
 {
@@ -644,7 +637,7 @@ static ssize_t waiters_read(struct file 
 
 static const struct file_operations waiters_fops = {
 	.owner   = THIS_MODULE,
-	.open    = waiters_open,
+	.open    = simple_open,
 	.read    = waiters_read,
 	.llseek  = default_llseek,
 };
diff -puN fs/pstore/inode.c~simple_open-automatically-convert-to-simple_open fs/pstore/inode.c
--- a/fs/pstore/inode.c~simple_open-automatically-convert-to-simple_open
+++ a/fs/pstore/inode.c
@@ -52,12 +52,6 @@ struct pstore_private {
 	char	data[];
 };
 
-static int pstore_file_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t pstore_file_read(struct file *file, char __user *userbuf,
 						size_t count, loff_t *ppos)
 {
@@ -67,7 +61,7 @@ static ssize_t pstore_file_read(struct f
 }
 
 static const struct file_operations pstore_file_operations = {
-	.open	= pstore_file_open,
+	.open	= simple_open,
 	.read	= pstore_file_read,
 	.llseek	= default_llseek,
 };
diff -puN kernel/trace/blktrace.c~simple_open-automatically-convert-to-simple_open kernel/trace/blktrace.c
--- a/kernel/trace/blktrace.c~simple_open-automatically-convert-to-simple_open
+++ a/kernel/trace/blktrace.c
@@ -311,13 +311,6 @@ int blk_trace_remove(struct request_queu
 }
 EXPORT_SYMBOL_GPL(blk_trace_remove);
 
-static int blk_dropped_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-
-	return 0;
-}
-
 static ssize_t blk_dropped_read(struct file *filp, char __user *buffer,
 				size_t count, loff_t *ppos)
 {
@@ -331,18 +324,11 @@ static ssize_t blk_dropped_read(struct f
 
 static const struct file_operations blk_dropped_fops = {
 	.owner =	THIS_MODULE,
-	.open =		blk_dropped_open,
+	.open =		simple_open,
 	.read =		blk_dropped_read,
 	.llseek =	default_llseek,
 };
 
-static int blk_msg_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-
-	return 0;
-}
-
 static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
 				size_t count, loff_t *ppos)
 {
@@ -371,7 +357,7 @@ static ssize_t blk_msg_write(struct file
 
 static const struct file_operations blk_msg_fops = {
 	.owner =	THIS_MODULE,
-	.open =		blk_msg_open,
+	.open =		simple_open,
 	.write =	blk_msg_write,
 	.llseek =	noop_llseek,
 };
diff -puN net/mac80211/debugfs.c~simple_open-automatically-convert-to-simple_open net/mac80211/debugfs.c
--- a/net/mac80211/debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/net/mac80211/debugfs.c
@@ -15,12 +15,6 @@
 #include "rate.h"
 #include "debugfs.h"
 
-int mac80211_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 #define DEBUGFS_FORMAT_BUFFER_SIZE 100
 
 int mac80211_format_buffer(char __user *userbuf, size_t count,
@@ -50,7 +44,7 @@ static ssize_t name## _read(struct file 
 #define DEBUGFS_READONLY_FILE_OPS(name)			\
 static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
-	.open = mac80211_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
@@ -93,7 +87,7 @@ static ssize_t reset_write(struct file *
 
 static const struct file_operations reset_ops = {
 	.write = reset_write,
-	.open = mac80211_open_file_generic,
+	.open = simple_open,
 	.llseek = noop_llseek,
 };
 
@@ -254,7 +248,7 @@ static ssize_t stats_ ##name## _read(str
 									\
 static const struct file_operations stats_ ##name## _ops = {		\
 	.read = stats_ ##name## _read,					\
-	.open = mac80211_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
diff -puN net/mac80211/debugfs.h~simple_open-automatically-convert-to-simple_open net/mac80211/debugfs.h
--- a/net/mac80211/debugfs.h~simple_open-automatically-convert-to-simple_open
+++ a/net/mac80211/debugfs.h
@@ -3,7 +3,6 @@
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 extern void debugfs_hw_add(struct ieee80211_local *local);
-extern int mac80211_open_file_generic(struct inode *inode, struct file *file);
 extern int mac80211_format_buffer(char __user *userbuf, size_t count,
 				  loff_t *ppos, char *fmt, ...);
 #else
diff -puN net/mac80211/debugfs_key.c~simple_open-automatically-convert-to-simple_open net/mac80211/debugfs_key.c
--- a/net/mac80211/debugfs_key.c~simple_open-automatically-convert-to-simple_open
+++ a/net/mac80211/debugfs_key.c
@@ -30,7 +30,7 @@ static ssize_t key_##name##_read(struct 
 #define KEY_OPS(name)							\
 static const struct file_operations key_ ##name## _ops = {		\
 	.read = key_##name##_read,					\
-	.open = mac80211_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 }
 
@@ -45,7 +45,7 @@ static const struct file_operations key_
 #define KEY_CONF_OPS(name)						\
 static const struct file_operations key_ ##name## _ops = {		\
 	.read = key_conf_##name##_read,					\
-	.open = mac80211_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 }
 
diff -puN net/mac80211/debugfs_netdev.c~simple_open-automatically-convert-to-simple_open net/mac80211/debugfs_netdev.c
--- a/net/mac80211/debugfs_netdev.c~simple_open-automatically-convert-to-simple_open
+++ a/net/mac80211/debugfs_netdev.c
@@ -135,7 +135,7 @@ static ssize_t ieee80211_if_read_##name(
 static const struct file_operations name##_ops = {			\
 	.read = ieee80211_if_read_##name,				\
 	.write = (_write),						\
-	.open = mac80211_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 }
 
diff -puN net/mac80211/debugfs_sta.c~simple_open-automatically-convert-to-simple_open net/mac80211/debugfs_sta.c
--- a/net/mac80211/debugfs_sta.c~simple_open-automatically-convert-to-simple_open
+++ a/net/mac80211/debugfs_sta.c
@@ -33,7 +33,7 @@ static ssize_t sta_ ##name## _read(struc
 #define STA_OPS(name)							\
 static const struct file_operations sta_ ##name## _ops = {		\
 	.read = sta_##name##_read,					\
-	.open = mac80211_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 }
 
@@ -41,7 +41,7 @@ static const struct file_operations sta_
 static const struct file_operations sta_ ##name## _ops = {		\
 	.read = sta_##name##_read,					\
 	.write = sta_##name##_write,					\
-	.open = mac80211_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 }
 
diff -puN net/mac80211/rate.c~simple_open-automatically-convert-to-simple_open net/mac80211/rate.c
--- a/net/mac80211/rate.c~simple_open-automatically-convert-to-simple_open
+++ a/net/mac80211/rate.c
@@ -145,7 +145,7 @@ static ssize_t rcname_read(struct file *
 
 static const struct file_operations rcname_ops = {
 	.read = rcname_read,
-	.open = mac80211_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 #endif
diff -puN net/wireless/debugfs.c~simple_open-automatically-convert-to-simple_open net/wireless/debugfs.c
--- a/net/wireless/debugfs.c~simple_open-automatically-convert-to-simple_open
+++ a/net/wireless/debugfs.c
@@ -13,12 +13,6 @@
 #include "core.h"
 #include "debugfs.h"
 
-static int cfg80211_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 #define DEBUGFS_READONLY_FILE(name, buflen, fmt, value...)		\
 static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 			    size_t count, loff_t *ppos)			\
@@ -33,7 +27,7 @@ static ssize_t name## _read(struct file 
 									\
 static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
-	.open = cfg80211_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
@@ -102,7 +96,7 @@ static ssize_t ht40allow_map_read(struct
 
 static const struct file_operations ht40allow_map_ops = {
 	.read = ht40allow_map_read,
-	.open = cfg80211_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
diff -puN sound/soc/imx/imx-audmux.c~simple_open-automatically-convert-to-simple_open sound/soc/imx/imx-audmux.c
--- a/sound/soc/imx/imx-audmux.c~simple_open-automatically-convert-to-simple_open
+++ a/sound/soc/imx/imx-audmux.c
@@ -40,12 +40,6 @@ static void __iomem *audmux_base;
 #ifdef CONFIG_DEBUG_FS
 static struct dentry *audmux_debugfs_root;
 
-static int audmux_open_file(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 /* There is an annoying discontinuity in the SSI numbering with regard
  * to the Linux number of the devices */
 static const char *audmux_port_string(int port)
@@ -142,7 +136,7 @@ static ssize_t audmux_read_file(struct f
 }
 
 static const struct file_operations audmux_debugfs_fops = {
-	.open = audmux_open_file,
+	.open = simple_open,
 	.read = audmux_read_file,
 	.llseek = default_llseek,
 };
diff -puN sound/soc/soc-core.c~simple_open-automatically-convert-to-simple_open sound/soc/soc-core.c
--- a/sound/soc/soc-core.c~simple_open-automatically-convert-to-simple_open
+++ a/sound/soc/soc-core.c
@@ -201,12 +201,6 @@ static ssize_t pmdown_time_set(struct de
 static DEVICE_ATTR(pmdown_time, 0644, pmdown_time_show, pmdown_time_set);
 
 #ifdef CONFIG_DEBUG_FS
-static int codec_reg_open_file(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t codec_reg_read_file(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
@@ -264,7 +258,7 @@ static ssize_t codec_reg_write_file(stru
 }
 
 static const struct file_operations codec_reg_fops = {
-	.open = codec_reg_open_file,
+	.open = simple_open,
 	.read = codec_reg_read_file,
 	.write = codec_reg_write_file,
 	.llseek = default_llseek,
diff -puN sound/soc/soc-dapm.c~simple_open-automatically-convert-to-simple_open sound/soc/soc-dapm.c
--- a/sound/soc/soc-dapm.c~simple_open-automatically-convert-to-simple_open
+++ a/sound/soc/soc-dapm.c
@@ -1544,12 +1544,6 @@ static int dapm_power_widgets(struct snd
 }
 
 #ifdef CONFIG_DEBUG_FS
-static int dapm_widget_power_open_file(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t dapm_widget_power_read_file(struct file *file,
 					   char __user *user_buf,
 					   size_t count, loff_t *ppos)
@@ -1613,17 +1607,11 @@ static ssize_t dapm_widget_power_read_fi
 }
 
 static const struct file_operations dapm_widget_power_fops = {
-	.open = dapm_widget_power_open_file,
+	.open = simple_open,
 	.read = dapm_widget_power_read_file,
 	.llseek = default_llseek,
 };
 
-static int dapm_bias_open_file(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
