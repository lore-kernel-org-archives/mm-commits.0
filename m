From: akpm@linux-foundation.org
Subject: - use-stop_machine_run-in-the-intel-rng-driver.patch removed from -mm tree
Date: Tue, 08 May 2007 19:45:27 -0700
Message-ID: <200705090245.l492jRkk008741@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031499AbXEICpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, haruo.tomita@toshiba.co.jp, jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     Use stop_machine_run in the Intel RNG driver
has been removed from the -mm tree.  Its filename was
     use-stop_machine_run-in-the-intel-rng-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use stop_machine_run in the Intel RNG driver
From: Prarit Bhargava <prarit@redhat.com>

Replace call_smp_function with stop_machine_run in the Intel RNG driver.

CPU A has done read_lock(&lock)
CPU B has done write_lock_irq(&lock) and is waiting for A to release the lock.

A third CPU calls call_smp_function and issues the IPI.  CPU A takes CPU
C's IPI.  CPU B is waiting with interrupts disabled and does not see the
IPI.  CPU C is stuck waiting for CPU B to respond to the IPI.

Deadlock.

The solution is to use stop_machine_run instead of call_smp_function
(call_smp_function should not be called in situations where the CPUs may be
suspended).

[haruo.tomita@toshiba.co.jp: fix a typo in mod_init()]
[haruo.tomita@toshiba.co.jp: fix memory leak]
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/intel-rng.c |  219 +++++++++++++++------------
 kernel/stop_machine.c              |    8 
 2 files changed, 127 insertions(+), 100 deletions(-)

diff -puN drivers/char/hw_random/intel-rng.c~use-stop_machine_run-in-the-intel-rng-driver drivers/char/hw_random/intel-rng.c
--- a/drivers/char/hw_random/intel-rng.c~use-stop_machine_run-in-the-intel-rng-driver
+++ a/drivers/char/hw_random/intel-rng.c
@@ -24,10 +24,11 @@
  * warranty of any kind, whether express or implied.
  */
 
-#include <linux/module.h>
+#include <linux/hw_random.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/hw_random.h>
+#include <linux/stop_machine.h>
 #include <asm/io.h>
 
 
@@ -217,30 +218,117 @@ static struct hwrng intel_rng = {
 	.data_read	= intel_rng_data_read,
 };
 
+struct intel_rng_hw {
+	struct pci_dev *dev;
+	void __iomem *mem;
+	u8 bios_cntl_off;
+	u8 bios_cntl_val;
+	u8 fwh_dec_en1_off;
+	u8 fwh_dec_en1_val;
+};
+
+static int __init intel_rng_hw_init(void *_intel_rng_hw)
+{
+	struct intel_rng_hw *intel_rng_hw = _intel_rng_hw;
+	u8 mfc, dvc;
+
+	/* interrupts disabled in stop_machine_run call */
 
-#ifdef CONFIG_SMP
-static char __initdata waitflag;
+	if (!(intel_rng_hw->fwh_dec_en1_val & FWH_F8_EN_MASK))
+		pci_write_config_byte(intel_rng_hw->dev,
+		                      intel_rng_hw->fwh_dec_en1_off,
+		                      intel_rng_hw->fwh_dec_en1_val |
+				      FWH_F8_EN_MASK);
+	if (!(intel_rng_hw->bios_cntl_val & BIOS_CNTL_WRITE_ENABLE_MASK))
+		pci_write_config_byte(intel_rng_hw->dev,
+		                      intel_rng_hw->bios_cntl_off,
+		                      intel_rng_hw->bios_cntl_val |
+				      BIOS_CNTL_WRITE_ENABLE_MASK);
+
+	writeb(INTEL_FWH_RESET_CMD, intel_rng_hw->mem);
+	writeb(INTEL_FWH_READ_ID_CMD, intel_rng_hw->mem);
+	mfc = readb(intel_rng_hw->mem + INTEL_FWH_MANUFACTURER_CODE_ADDRESS);
+	dvc = readb(intel_rng_hw->mem + INTEL_FWH_DEVICE_CODE_ADDRESS);
+	writeb(INTEL_FWH_RESET_CMD, intel_rng_hw->mem);
 
-static void __init intel_init_wait(void *unused)
+	if (!(intel_rng_hw->bios_cntl_val &
+	      (BIOS_CNTL_LOCK_ENABLE_MASK|BIOS_CNTL_WRITE_ENABLE_MASK)))
+		pci_write_config_byte(intel_rng_hw->dev,
+				      intel_rng_hw->bios_cntl_off,
+				      intel_rng_hw->bios_cntl_val);
+	if (!(intel_rng_hw->fwh_dec_en1_val & FWH_F8_EN_MASK))
+		pci_write_config_byte(intel_rng_hw->dev,
+				      intel_rng_hw->fwh_dec_en1_off,
+				      intel_rng_hw->fwh_dec_en1_val);
+
+	if (mfc != INTEL_FWH_MANUFACTURER_CODE ||
+	    (dvc != INTEL_FWH_DEVICE_CODE_8M &&
+	     dvc != INTEL_FWH_DEVICE_CODE_4M)) {
+		printk(KERN_ERR PFX "FWH not detected\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int __init intel_init_hw_struct(struct intel_rng_hw *intel_rng_hw,
+					struct pci_dev *dev)
 {
-	while (waitflag)
-		cpu_relax();
+	intel_rng_hw->bios_cntl_val = 0xff;
+	intel_rng_hw->fwh_dec_en1_val = 0xff;
+	intel_rng_hw->dev = dev;
+
+	/* Check for Intel 82802 */
+	if (dev->device < 0x2640) {
+		intel_rng_hw->fwh_dec_en1_off = FWH_DEC_EN1_REG_OLD;
+		intel_rng_hw->bios_cntl_off = BIOS_CNTL_REG_OLD;
+	} else {
+		intel_rng_hw->fwh_dec_en1_off = FWH_DEC_EN1_REG_NEW;
+		intel_rng_hw->bios_cntl_off = BIOS_CNTL_REG_NEW;
+	}
+
+	pci_read_config_byte(dev, intel_rng_hw->fwh_dec_en1_off,
+			     &intel_rng_hw->fwh_dec_en1_val);
+	pci_read_config_byte(dev, intel_rng_hw->bios_cntl_off,
+			     &intel_rng_hw->bios_cntl_val);
+
+	if ((intel_rng_hw->bios_cntl_val &
+	     (BIOS_CNTL_LOCK_ENABLE_MASK|BIOS_CNTL_WRITE_ENABLE_MASK))
+	    == BIOS_CNTL_LOCK_ENABLE_MASK) {
+		static __initdata /*const*/ char warning[] =
+			KERN_WARNING PFX "Firmware space is locked read-only. "
+			KERN_WARNING PFX "If you can't or\n don't want to "
+			KERN_WARNING PFX "disable this in firmware setup, and "
+			KERN_WARNING PFX "if\n you are certain that your "
+			KERN_WARNING PFX "system has a functional\n RNG, try"
+			KERN_WARNING PFX "using the 'no_fwh_detect' option.\n";
+
+		if (no_fwh_detect)
+			return -ENODEV;
+		printk(warning);
+		return -EBUSY;
+	}
+
+	intel_rng_hw->mem = ioremap_nocache(INTEL_FWH_ADDR, INTEL_FWH_ADDR_LEN);
+	if (intel_rng_hw->mem == NULL)
+		return -EBUSY;
+
+	return 0;
 }
-#endif
+
 
 static int __init mod_init(void)
 {
 	int err = -ENODEV;
-	unsigned i;
+	int i;
 	struct pci_dev *dev = NULL;
-	void __iomem *mem;
-	unsigned long flags;
-	u8 bios_cntl_off, fwh_dec_en1_off;
-	u8 bios_cntl_val = 0xff, fwh_dec_en1_val = 0xff;
-	u8 hw_status, mfc, dvc;
+	void __iomem *mem = mem;
+	u8 hw_status;
+	struct intel_rng_hw *intel_rng_hw;
 
 	for (i = 0; !dev && pci_tbl[i].vendor; ++i)
-		dev = pci_get_device(pci_tbl[i].vendor, pci_tbl[i].device, NULL);
+		dev = pci_get_device(pci_tbl[i].vendor, pci_tbl[i].device,
+				     NULL);
 
 	if (!dev)
 		goto out; /* Device not found. */
@@ -250,39 +338,18 @@ static int __init mod_init(void)
 		goto fwh_done;
 	}
 
-	/* Check for Intel 82802 */
-	if (dev->device < 0x2640) {
-		fwh_dec_en1_off = FWH_DEC_EN1_REG_OLD;
-		bios_cntl_off = BIOS_CNTL_REG_OLD;
-	} else {
-		fwh_dec_en1_off = FWH_DEC_EN1_REG_NEW;
-		bios_cntl_off = BIOS_CNTL_REG_NEW;
-	}
-
-	pci_read_config_byte(dev, fwh_dec_en1_off, &fwh_dec_en1_val);
-	pci_read_config_byte(dev, bios_cntl_off, &bios_cntl_val);
-
-	if ((bios_cntl_val &
-	     (BIOS_CNTL_LOCK_ENABLE_MASK|BIOS_CNTL_WRITE_ENABLE_MASK))
-	    == BIOS_CNTL_LOCK_ENABLE_MASK) {
-		static __initdata /*const*/ char warning[] =
-			KERN_WARNING PFX "Firmware space is locked read-only. If you can't or\n"
-			KERN_WARNING PFX "don't want to disable this in firmware setup, and if\n"
-			KERN_WARNING PFX "you are certain that your system has a functional\n"
-			KERN_WARNING PFX "RNG, try using the 'no_fwh_detect' option.\n";
-
+	intel_rng_hw = kmalloc(sizeof(*intel_rng_hw), GFP_KERNEL);
+	if (!intel_rng_hw) {
 		pci_dev_put(dev);
-		if (no_fwh_detect)
-			goto fwh_done;
-		printk(warning);
-		err = -EBUSY;
 		goto out;
 	}
 
-	mem = ioremap_nocache(INTEL_FWH_ADDR, INTEL_FWH_ADDR_LEN);
-	if (mem == NULL) {
+	err = intel_init_hw_struct(intel_rng_hw, dev);
+	if (err) {
 		pci_dev_put(dev);
-		err = -EBUSY;
+		kfree(intel_rng_hw);
+		if (err == -ENODEV)
+			goto fwh_done;
 		goto out;
 	}
 
@@ -290,59 +357,18 @@ static int __init mod_init(void)
 	 * Since the BIOS code/data is going to disappear from its normal
 	 * location with the Read ID command, all activity on the system
 	 * must be stopped until the state is back to normal.
+	 *
+	 * Use stop_machine_run because IPIs can be blocked by disabling
+	 * interrupts.
 	 */
-#ifdef CONFIG_SMP
-	set_mb(waitflag, 1);
-	if (smp_call_function(intel_init_wait, NULL, 1, 0) != 0) {
-		set_mb(waitflag, 0);
-		pci_dev_put(dev);
-		printk(KERN_ERR PFX "cannot run on all processors\n");
-		err = -EAGAIN;
-		goto err_unmap;
-	}
-#endif
-	local_irq_save(flags);
-
-	if (!(fwh_dec_en1_val & FWH_F8_EN_MASK))
-		pci_write_config_byte(dev,
-		                      fwh_dec_en1_off,
-		                      fwh_dec_en1_val | FWH_F8_EN_MASK);
-	if (!(bios_cntl_val & BIOS_CNTL_WRITE_ENABLE_MASK))
-		pci_write_config_byte(dev,
-		                      bios_cntl_off,
-		                      bios_cntl_val | BIOS_CNTL_WRITE_ENABLE_MASK);
-
-	writeb(INTEL_FWH_RESET_CMD, mem);
-	writeb(INTEL_FWH_READ_ID_CMD, mem);
-	mfc = readb(mem + INTEL_FWH_MANUFACTURER_CODE_ADDRESS);
-	dvc = readb(mem + INTEL_FWH_DEVICE_CODE_ADDRESS);
-	writeb(INTEL_FWH_RESET_CMD, mem);
-
-	if (!(bios_cntl_val &
-	      (BIOS_CNTL_LOCK_ENABLE_MASK|BIOS_CNTL_WRITE_ENABLE_MASK)))
-		pci_write_config_byte(dev, bios_cntl_off, bios_cntl_val);
-	if (!(fwh_dec_en1_val & FWH_F8_EN_MASK))
-		pci_write_config_byte(dev, fwh_dec_en1_off, fwh_dec_en1_val);
-
-	local_irq_restore(flags);
-#ifdef CONFIG_SMP
-	/* Tell other CPUs to resume. */
-	set_mb(waitflag, 0);
-#endif
-
-	iounmap(mem);
+	err = stop_machine_run(intel_rng_hw_init, intel_rng_hw, NR_CPUS);
 	pci_dev_put(dev);
-
-	if (mfc != INTEL_FWH_MANUFACTURER_CODE ||
-	    (dvc != INTEL_FWH_DEVICE_CODE_8M &&
-	     dvc != INTEL_FWH_DEVICE_CODE_4M)) {
-		printk(KERN_ERR PFX "FWH not detected\n");
-		err = -ENODEV;
+	iounmap(intel_rng_hw->mem);
+	kfree(intel_rng_hw);
+	if (err)
 		goto out;
-	}
 
 fwh_done:
-
 	err = -ENOMEM;
 	mem = ioremap(INTEL_RNG_ADDR, INTEL_RNG_ADDR_LEN);
 	if (!mem)
@@ -352,22 +378,21 @@ fwh_done:
 	/* Check for Random Number Generator */
 	err = -ENODEV;
 	hw_status = hwstatus_get(mem);
-	if ((hw_status & INTEL_RNG_PRESENT) == 0)
-		goto err_unmap;
+	if ((hw_status & INTEL_RNG_PRESENT) == 0) {
+		iounmap(mem);
+		goto out;
+	}
 
 	printk(KERN_INFO "Intel 82802 RNG detected\n");
 	err = hwrng_register(&intel_rng);
 	if (err) {
 		printk(KERN_ERR PFX "RNG registering failed (%d)\n",
 		       err);
-		goto err_unmap;
+		iounmap(mem);
 	}
 out:
 	return err;
 
-err_unmap:
-	iounmap(mem);
-	goto out;
 }
 
 static void __exit mod_exit(void)
diff -puN kernel/stop_machine.c~use-stop_machine_run-in-the-intel-rng-driver kernel/stop_machine.c
--- a/kernel/stop_machine.c~use-stop_machine_run-in-the-intel-rng-driver
+++ a/kernel/stop_machine.c
@@ -1,11 +1,12 @@
 /* Copyright 2005 Rusty Russell rusty@rustcorp.com.au IBM Corporation.
  * GPL v2 and any later version.
  */
-#include <linux/stop_machine.h>
-#include <linux/kthread.h>
-#include <linux/sched.h>
 #include <linux/cpu.h>
 #include <linux/err.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/stop_machine.h>
 #include <linux/syscalls.h>
 #include <asm/atomic.h>
 #include <asm/semaphore.h>
@@ -208,3 +209,4 @@ int stop_machine_run(int (*fn)(void *), 
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(stop_machine_run);
_

Patches currently in -mm which might be from prarit@redhat.com are

origin.patch
