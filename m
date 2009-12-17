From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 17 Dec 2009 12:22:26 -0800
Message-ID: <200912172022.nBHKMQPf016705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763338AbZLQUWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Dec 2009 15:22:31 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id nBHKMTen019588
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 17 Dec 2009 12:22:30 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/unwind.c                 |    4 --
 drivers/media/IR/Makefile                   |    4 --
 drivers/media/IR/ir-functions.c             |    4 --
 drivers/media/IR/ir-keytable.c              |   29 ------------------
 drivers/media/dvb/dm1105/dm1105.c           |    4 --
 drivers/media/dvb/frontends/dib0090.h       |    3 -
 drivers/media/dvb/ttpci/budget-ci.c         |    4 --
 drivers/media/video/bt8xx/bttv-input.c      |    4 --
 drivers/media/video/cx231xx/cx231xx-input.c |    4 --
 drivers/media/video/cx23885/cx23885-input.c |    4 --
 drivers/media/video/cx88/cx88-input.c       |    4 --
 drivers/media/video/em28xx/em28xx-input.c   |   22 -------------
 drivers/media/video/ir-kbd-i2c.c            |    4 --
 drivers/media/video/saa7134/saa7134-input.c |    4 --
 include/media/ir-common.h                   |    8 ----
 include/media/ir-core.h                     |   27 ----------------
 kernel/printk.c                             |    5 ---
 17 files changed, 138 deletions(-)

diff -puN arch/parisc/kernel/unwind.c~linux-next-git-rejects arch/parisc/kernel/unwind.c
--- a/arch/parisc/kernel/unwind.c~linux-next-git-rejects
+++ a/arch/parisc/kernel/unwind.c
@@ -439,7 +439,3 @@ unsigned long return_address(unsigned in
 
 	return info.ip;
 }
-<<<<<<< HEAD:arch/parisc/kernel/unwind.c
-=======
-
->>>>>>> FETCH_HEAD:arch/parisc/kernel/unwind.c
diff -puN drivers/media/IR/Makefile~linux-next-git-rejects drivers/media/IR/Makefile
--- a/drivers/media/IR/Makefile~linux-next-git-rejects
+++ a/drivers/media/IR/Makefile
@@ -1,9 +1,5 @@
 ir-common-objs  := ir-functions.o ir-keymaps.o
-<<<<<<< HEAD:drivers/media/IR/Makefile
-ir-core-objs	:= ir-keytable.o
-=======
 ir-core-objs	:= ir-keytable.o ir-sysfs.o
->>>>>>> FETCH_HEAD:drivers/media/IR/Makefile
 
 obj-$(CONFIG_IR_CORE) += ir-core.o
 obj-$(CONFIG_VIDEO_IR) += ir-common.o
diff -puN drivers/media/IR/ir-functions.c~linux-next-git-rejects drivers/media/IR/ir-functions.c
--- a/drivers/media/IR/ir-functions.c~linux-next-git-rejects
+++ a/drivers/media/IR/ir-functions.c
@@ -52,11 +52,7 @@ static void ir_input_key_event(struct in
 /* -------------------------------------------------------------------------- */
 
 int ir_input_init(struct input_dev *dev, struct ir_input_state *ir,
-<<<<<<< HEAD:drivers/media/IR/ir-functions.c
-		   int ir_type)
-=======
 		  const u64 ir_type)
->>>>>>> FETCH_HEAD:drivers/media/IR/ir-functions.c
 {
 	ir->ir_type = ir_type;
 
diff -puN drivers/media/IR/ir-keytable.c~linux-next-git-rejects drivers/media/IR/ir-keytable.c
--- a/drivers/media/IR/ir-keytable.c~linux-next-git-rejects
+++ a/drivers/media/IR/ir-keytable.c
@@ -408,12 +408,8 @@ EXPORT_SYMBOL_GPL(ir_g_keycode_from_tabl
  * register the syfs code for IR class
  */
 int ir_input_register(struct input_dev *input_dev,
-<<<<<<< HEAD:drivers/media/IR/ir-keytable.c
-		      struct ir_scancode_table *rc_tab)
-=======
 		      const struct ir_scancode_table *rc_tab,
 		      const struct ir_dev_props *props)
->>>>>>> FETCH_HEAD:drivers/media/IR/ir-keytable.c
 {
 	struct ir_input_dev *ir_dev;
 	struct ir_scancode  *keymap    = rc_tab->scan;
@@ -426,11 +422,7 @@ int ir_input_register(struct input_dev *
 	if (!ir_dev)
 		return -ENOMEM;
 
-<<<<<<< HEAD:drivers/media/IR/ir-keytable.c
-	spin_lock_init(&rc_tab->lock);
-=======
 	spin_lock_init(&ir_dev->rc_tab.lock);
->>>>>>> FETCH_HEAD:drivers/media/IR/ir-keytable.c
 
 	ir_dev->rc_tab.size = ir_roundup_tablesize(rc_tab->size);
 	ir_dev->rc_tab.scan = kzalloc(ir_dev->rc_tab.size *
@@ -443,10 +435,7 @@ int ir_input_register(struct input_dev *
 		ir_dev->rc_tab.size * sizeof(ir_dev->rc_tab.scan));
 
 	ir_copy_table(&ir_dev->rc_tab, rc_tab);
-<<<<<<< HEAD:drivers/media/IR/ir-keytable.c
-=======
 	ir_dev->props = props;
->>>>>>> FETCH_HEAD:drivers/media/IR/ir-keytable.c
 
 	/* set the bits for the keys */
 	IR_dprintk(1, "key map size: %d\n", rc_tab->size);
@@ -462,20 +451,6 @@ int ir_input_register(struct input_dev *
 	input_dev->getkeycode = ir_getkeycode;
 	input_dev->setkeycode = ir_setkeycode;
 	input_set_drvdata(input_dev, ir_dev);
-<<<<<<< HEAD:drivers/media/IR/ir-keytable.c
-
-	rc = input_register_device(input_dev);
-	if (rc < 0) {
-		kfree(rc_tab->scan);
-		kfree(ir_dev);
-		input_set_drvdata(input_dev, NULL);
-	}
-
-	return rc;
-}
-EXPORT_SYMBOL_GPL(ir_input_register);
-
-=======
 
 	rc = input_register_device(input_dev);
 	if (rc < 0)
@@ -503,7 +478,6 @@ EXPORT_SYMBOL_GPL(ir_input_register);
 
  * This routine is used to free memory and de-register interfaces.
  */
->>>>>>> FETCH_HEAD:drivers/media/IR/ir-keytable.c
 void ir_input_unregister(struct input_dev *dev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
@@ -519,11 +493,8 @@ void ir_input_unregister(struct input_de
 	kfree(rc_tab->scan);
 	rc_tab->scan = NULL;
 
-<<<<<<< HEAD:drivers/media/IR/ir-keytable.c
-=======
 	ir_unregister_class(dev);
 
->>>>>>> FETCH_HEAD:drivers/media/IR/ir-keytable.c
 	kfree(ir_dev);
 	input_unregister_device(dev);
 }
diff -puN drivers/media/dvb/dm1105/dm1105.c~linux-next-git-rejects drivers/media/dvb/dm1105/dm1105.c
--- a/drivers/media/dvb/dm1105/dm1105.c~linux-next-git-rejects
+++ a/drivers/media/dvb/dm1105/dm1105.c
@@ -611,11 +611,7 @@ int __devinit dm1105_ir_init(struct dm11
 
 	INIT_WORK(&dm1105->ir.work, dm1105_emit_key);
 
-<<<<<<< HEAD:drivers/media/dvb/dm1105/dm1105.c
-	err = ir_input_register(input_dev, ir_codes);
-=======
 	err = ir_input_register(input_dev, ir_codes, NULL);
->>>>>>> FETCH_HEAD:drivers/media/dvb/dm1105/dm1105.c
 
 	return err;
 }
diff -puN drivers/media/dvb/frontends/dib0090.h~linux-next-git-rejects drivers/media/dvb/frontends/dib0090.h
--- a/drivers/media/dvb/frontends/dib0090.h~linux-next-git-rejects
+++ a/drivers/media/dvb/frontends/dib0090.h
@@ -57,10 +57,7 @@ extern u16 dib0090_get_wbd_offset(struct
 extern int dib0090_gain_control(struct dvb_frontend *fe);
 extern enum frontend_tune_state dib0090_get_tune_state(struct dvb_frontend *fe);
 extern int dib0090_set_tune_state(struct dvb_frontend *fe, enum frontend_tune_state tune_state);
-<<<<<<< HEAD:drivers/media/dvb/frontends/dib0090.h
-=======
 extern enum frontend_tune_state dib0090_get_tune_state(struct dvb_frontend *fe);
->>>>>>> FETCH_HEAD:drivers/media/dvb/frontends/dib0090.h
 extern void dib0090_get_current_gain(struct dvb_frontend *fe, u16 * rf, u16 * bb, u16 * rf_gain_limit, u16 * rflt);
 #else
 static inline struct dvb_frontend *dib0090_register(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct dib0090_config *config)
diff -puN drivers/media/dvb/ttpci/budget-ci.c~linux-next-git-rejects drivers/media/dvb/ttpci/budget-ci.c
--- a/drivers/media/dvb/ttpci/budget-ci.c~linux-next-git-rejects
+++ a/drivers/media/dvb/ttpci/budget-ci.c
@@ -254,11 +254,7 @@ static int msp430_ir_init(struct budget_
 	budget_ci->ir.timer_keyup.function = msp430_ir_keyup;
 	budget_ci->ir.timer_keyup.data = (unsigned long) &budget_ci->ir;
 	budget_ci->ir.last_raw = 0xffff; /* An impossible value */
-<<<<<<< HEAD:drivers/media/dvb/ttpci/budget-ci.c
-	error = ir_input_register(input_dev, ir_codes);
-=======
 	error = ir_input_register(input_dev, ir_codes, NULL);
->>>>>>> FETCH_HEAD:drivers/media/dvb/ttpci/budget-ci.c
 	if (error) {
 		printk(KERN_ERR "budget_ci: could not init driver for IR device (code %d)\n", error);
 		return error;
diff -puN drivers/media/video/bt8xx/bttv-input.c~linux-next-git-rejects drivers/media/video/bt8xx/bttv-input.c
--- a/drivers/media/video/bt8xx/bttv-input.c~linux-next-git-rejects
+++ a/drivers/media/video/bt8xx/bttv-input.c
@@ -389,11 +389,7 @@ int bttv_input_init(struct bttv *btv)
 	bttv_ir_start(btv, ir);
 
 	/* all done */
-<<<<<<< HEAD:drivers/media/video/bt8xx/bttv-input.c
-	err = ir_input_register(btv->remote->dev, ir_codes);
-=======
 	err = ir_input_register(btv->remote->dev, ir_codes, NULL);
->>>>>>> FETCH_HEAD:drivers/media/video/bt8xx/bttv-input.c
 	if (err)
 		goto err_out_stop;
 
diff -puN drivers/media/video/cx231xx/cx231xx-input.c~linux-next-git-rejects drivers/media/video/cx231xx/cx231xx-input.c
--- a/drivers/media/video/cx231xx/cx231xx-input.c~linux-next-git-rejects
+++ a/drivers/media/video/cx231xx/cx231xx-input.c
@@ -216,11 +216,7 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	cx231xx_ir_start(ir);
 
 	/* all done */
-<<<<<<< HEAD:drivers/media/video/cx231xx/cx231xx-input.c
-	err = ir_input_register(ir->input, dev->board.ir_codes);
-=======
 	err = ir_input_register(ir->input, dev->board.ir_codes, NULL);
->>>>>>> FETCH_HEAD:drivers/media/video/cx231xx/cx231xx-input.c
 	if (err)
 		goto err_out_stop;
 
diff -puN drivers/media/video/cx23885/cx23885-input.c~linux-next-git-rejects drivers/media/video/cx23885/cx23885-input.c
--- a/drivers/media/video/cx23885/cx23885-input.c~linux-next-git-rejects
+++ a/drivers/media/video/cx23885/cx23885-input.c
@@ -397,11 +397,7 @@ int cx23885_input_init(struct cx23885_de
 	dev->ir_input = ir;
 	cx23885_input_ir_start(dev);
 
-<<<<<<< HEAD:drivers/media/video/cx23885/cx23885-input.c
-	ret = ir_input_register(ir->dev, ir_codes);
-=======
 	ret = ir_input_register(ir->dev, ir_codes, NULL);
->>>>>>> FETCH_HEAD:drivers/media/video/cx23885/cx23885-input.c
 	if (ret)
 		goto err_out_stop;
 
diff -puN drivers/media/video/cx88/cx88-input.c~linux-next-git-rejects drivers/media/video/cx88/cx88-input.c
--- a/drivers/media/video/cx88/cx88-input.c~linux-next-git-rejects
+++ a/drivers/media/video/cx88/cx88-input.c
@@ -383,11 +383,7 @@ int cx88_ir_init(struct cx88_core *core,
 	cx88_ir_start(core, ir);
 
 	/* all done */
-<<<<<<< HEAD:drivers/media/video/cx88/cx88-input.c
-	err = ir_input_register(ir->input, ir_codes);
-=======
 	err = ir_input_register(ir->input, ir_codes, NULL);
->>>>>>> FETCH_HEAD:drivers/media/video/cx88/cx88-input.c
 	if (err)
 		goto err_out_stop;
 
diff -puN drivers/media/video/em28xx/em28xx-input.c~linux-next-git-rejects drivers/media/video/em28xx/em28xx-input.c
--- a/drivers/media/video/em28xx/em28xx-input.c~linux-next-git-rejects
+++ a/drivers/media/video/em28xx/em28xx-input.c
@@ -360,23 +360,8 @@ int em28xx_ir_change_protocol(void *priv
 	} else
 		rc = -EINVAL;
 
-<<<<<<< HEAD:drivers/media/video/em28xx/em28xx-input.c
-	ir->input = input_dev;
-	ir_config = EM2874_IR_RC5;
-
-	/* Adjust xclk based o IR table for RC5/NEC tables */
-	if (dev->board.ir_codes->ir_type == IR_TYPE_RC5) {
-		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
-		ir->full_code = 1;
-	} else  if (dev->board.ir_codes->ir_type == IR_TYPE_NEC) {
-		dev->board.xclk &= ~EM28XX_XCLK_IR_RC5_MODE;
-		ir_config = EM2874_IR_NEC;
-		ir->full_code = 1;
-	}
-=======
 	dev->board.ir_codes->ir_type = ir_type;
 
->>>>>>> FETCH_HEAD:drivers/media/video/em28xx/em28xx-input.c
 	em28xx_write_reg_bits(dev, EM28XX_R0F_XCLK, dev->board.xclk,
 			      EM28XX_XCLK_IR_RC5_MODE);
 
@@ -438,11 +423,8 @@ int em28xx_ir_init(struct em28xx *dev)
 	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
 
-<<<<<<< HEAD:drivers/media/video/em28xx/em28xx-input.c
-=======
 	/* Set IR protocol */
 	em28xx_ir_change_protocol(ir, dev->board.ir_codes->ir_type);
->>>>>>> FETCH_HEAD:drivers/media/video/em28xx/em28xx-input.c
 	err = ir_input_init(input_dev, &ir->ir, IR_TYPE_OTHER);
 	if (err < 0)
 		goto err_out_free;
@@ -460,12 +442,8 @@ int em28xx_ir_init(struct em28xx *dev)
 	em28xx_ir_start(ir);
 
 	/* all done */
-<<<<<<< HEAD:drivers/media/video/em28xx/em28xx-input.c
-	err = ir_input_register(ir->input, dev->board.ir_codes);
-=======
 	err = ir_input_register(ir->input, dev->board.ir_codes,
 				&ir->props);
->>>>>>> FETCH_HEAD:drivers/media/video/em28xx/em28xx-input.c
 	if (err)
 		goto err_out_stop;
 
diff -puN drivers/media/video/ir-kbd-i2c.c~linux-next-git-rejects drivers/media/video/ir-kbd-i2c.c
--- a/drivers/media/video/ir-kbd-i2c.c~linux-next-git-rejects
+++ a/drivers/media/video/ir-kbd-i2c.c
@@ -446,11 +446,7 @@ static int ir_probe(struct i2c_client *c
 	input_dev->name       = ir->name;
 	input_dev->phys       = ir->phys;
 
-<<<<<<< HEAD:drivers/media/video/ir-kbd-i2c.c
-	err = ir_input_register(ir->input, ir->ir_codes);
-=======
 	err = ir_input_register(ir->input, ir->ir_codes, NULL);
->>>>>>> FETCH_HEAD:drivers/media/video/ir-kbd-i2c.c
 	if (err)
 		goto err_out_free;
 
diff -puN drivers/media/video/saa7134/saa7134-input.c~linux-next-git-rejects drivers/media/video/saa7134/saa7134-input.c
--- a/drivers/media/video/saa7134/saa7134-input.c~linux-next-git-rejects
+++ a/drivers/media/video/saa7134/saa7134-input.c
@@ -728,11 +728,7 @@ int saa7134_input_init1(struct saa7134_d
 	dev->remote = ir;
 	saa7134_ir_start(dev, ir);
 
-<<<<<<< HEAD:drivers/media/video/saa7134/saa7134-input.c
-	err = ir_input_register(ir->dev, ir_codes);
-=======
 	err = ir_input_register(ir->dev, ir_codes, NULL);
->>>>>>> FETCH_HEAD:drivers/media/video/saa7134/saa7134-input.c
 	if (err)
 		goto err_out_stop;
 
diff -puN include/media/ir-common.h~linux-next-git-rejects include/media/ir-common.h
--- a/include/media/ir-common.h~linux-next-git-rejects
+++ a/include/media/ir-common.h
@@ -35,11 +35,7 @@
 
 struct ir_input_state {
 	/* configuration */
-<<<<<<< HEAD:include/media/ir-common.h
-	int                ir_type;
-=======
 	u64      ir_type;
->>>>>>> FETCH_HEAD:include/media/ir-common.h
 
 	/* key info */
 	u32                ir_key;      /* ir scancode */
@@ -88,11 +84,7 @@ struct card_ir {
 /* Routines from ir-functions.c */
 
 int ir_input_init(struct input_dev *dev, struct ir_input_state *ir,
-<<<<<<< HEAD:include/media/ir-common.h
-		   int ir_type);
-=======
 		   const u64 ir_type);
->>>>>>> FETCH_HEAD:include/media/ir-common.h
 void ir_input_nokey(struct input_dev *dev, struct ir_input_state *ir);
 void ir_input_keydown(struct input_dev *dev, struct ir_input_state *ir,
 		      u32 ir_key);
diff -puN include/media/ir-core.h~linux-next-git-rejects include/media/ir-core.h
--- a/include/media/ir-core.h~linux-next-git-rejects
+++ a/include/media/ir-core.h
@@ -21,21 +21,11 @@ extern int ir_core_debug;
 #define IR_dprintk(level, fmt, arg...)	if (ir_core_debug >= level) \
 	printk(KERN_DEBUG "%s: " fmt , __func__, ## arg)
 
-<<<<<<< HEAD:include/media/ir-core.h
-enum ir_type {
-	IR_TYPE_UNKNOWN	= 0,
-	IR_TYPE_RC5	= 1,
-	IR_TYPE_PD	= 2,		 /* Pulse distance encoded IR */
-	IR_TYPE_NEC	= 3,
-	IR_TYPE_OTHER	= 99,
-};
-=======
 #define IR_TYPE_UNKNOWN	0
 #define IR_TYPE_RC5	(1  << 0)	/* Philips RC5 protocol */
 #define IR_TYPE_PD	(1  << 1)	/* Pulse distance encoded IR */
 #define IR_TYPE_NEC	(1  << 2)
 #define IR_TYPE_OTHER	(((u64)1) << 63l)
->>>>>>> FETCH_HEAD:include/media/ir-core.h
 
 struct ir_scancode {
 	u16	scancode;
@@ -45,16 +35,6 @@ struct ir_scancode {
 struct ir_scancode_table {
 	struct ir_scancode	*scan;
 	int			size;
-<<<<<<< HEAD:include/media/ir-core.h
-	enum			ir_type ir_type;
-	spinlock_t		lock;
-};
-
-struct ir_input_dev {
-	struct input_dev		*dev;
-	struct ir_scancode_table	rc_tab;
-};
-=======
 	u64		ir_type;
 	spinlock_t		lock;
 };
@@ -75,7 +55,6 @@ struct ir_input_dev {
 	const struct ir_dev_props	*props;		/* Device properties */
 };
 #define to_ir_input_dev(_attr) container_of(_attr, struct ir_input_dev, attr)
->>>>>>> FETCH_HEAD:include/media/ir-core.h
 
 /* Routines from ir-keytable.c */
 
@@ -87,11 +66,6 @@ int ir_set_keycode_table(struct input_de
 
 int ir_roundup_tablesize(int n_elems);
 int ir_input_register(struct input_dev *dev,
-<<<<<<< HEAD:include/media/ir-core.h
-		      struct ir_scancode_table *ir_codes);
-void ir_input_unregister(struct input_dev *input_dev);
-
-=======
 		      const struct ir_scancode_table *ir_codes,
 		      const struct ir_dev_props *props);
 void ir_input_unregister(struct input_dev *input_dev);
@@ -101,5 +75,4 @@ void ir_input_unregister(struct input_de
 int ir_register_class(struct input_dev *input_dev);
 void ir_unregister_class(struct input_dev *input_dev);
 
->>>>>>> FETCH_HEAD:include/media/ir-core.h
 #endif
diff -puN kernel/printk.c~linux-next-git-rejects kernel/printk.c
--- a/kernel/printk.c~linux-next-git-rejects
+++ a/kernel/printk.c
@@ -33,13 +33,8 @@
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/kexec.h>
-<<<<<<< HEAD:kernel/printk.c
-#include <linux/ratelimit.h>
-#include <linux/kmsg_dump.h>
-=======
 #include <linux/kmsg_dump.h>
 #include <linux/ratelimit.h>
->>>>>>> FETCH_HEAD:kernel/printk.c
 
 #include <asm/uaccess.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-fixup.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
readahead-add-blk_run_backing_dev.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
kfifo-move-struct-kfifo-in-place-fix.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
acpi-remove-nid_inval.patch
drivers-acpi-acpi_padc-squish-warning.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
net-sctp-socketc-fix-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
fs-ext4-superc-fix-printk-warning.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-aacraid-fix-memory-leak-checkpatch-fixes.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
fs-improve-remountro-vs-buffercache-coherency.patch
drivers-net-wireless-iwlwifi-iwl-txc-fix-gcc-345-warning.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array.patch
char-cyclades-fix-compiler-warning.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

