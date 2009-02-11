From: akpm@linux-foundation.org
Subject: [folded] input-ad7879-touchscreen-driver-dont-use-bus_id.patch removed from -mm tree
Date: Wed, 11 Feb 2009 13:22:33 -0800
Message-ID: <200902112122.n1BLMXWl024820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567AbZBKVWv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 16:22:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, cooloney@kernel.org, dmitry.torokhov@gmail.com, michael.hennerich@analog.com, mm-commits@vger.kernel.org


The patch titled
     touchscreen/ad787x: don't use bus_id
has been removed from the -mm tree.  Its filename was
     input-ad7879-touchscreen-driver-dont-use-bus_id.patch

This patch was dropped because it was folded into input-ad7879-touchscreen-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: touchscreen/ad787x: don't use bus_id
From: Randy Dunlap <randy.dunlap@oracle.com>

drivers/input/touchscreen/ad7879.c:421: error: 'struct device' has no member named 'bus_id'
drivers/input/touchscreen/ad7877.c:716: error: 'struct device' has no member named 'bus_id'
drivers/input/touchscreen/ad7877.c:743: error: 'struct device' has no member named 'bus_id'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ad7877.c |    6 +++---
 drivers/input/touchscreen/ad7879.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/input/touchscreen/ad7877.c~input-ad7879-touchscreen-driver-dont-use-bus_id drivers/input/touchscreen/ad7877.c
--- a/drivers/input/touchscreen/ad7877.c~input-ad7879-touchscreen-driver-dont-use-bus_id
+++ a/drivers/input/touchscreen/ad7877.c
@@ -713,7 +713,7 @@ static int __devinit ad7877_probe(struct
 	ts->averaging = pdata->averaging;
 	ts->pen_down_acc_interval = pdata->pen_down_acc_interval;
 
-	snprintf(ts->phys, sizeof(ts->phys), "%s/inputX", spi->dev.bus_id);
+	snprintf(ts->phys, sizeof(ts->phys), "%s/inputX", dev_name(&spi->dev));
 
 	input_dev->name = "AD7877 Touchscreen";
 	input_dev->phys = ts->phys;
@@ -740,8 +740,8 @@ static int __devinit ad7877_probe(struct
 	verify = ad7877_read(spi, AD7877_REG_SEQ1);
 
 	if (verify != AD7877_MM_SEQUENCE){
-		dev_err(&spi->dev, "%s: Failed to probe %s\n", spi->dev.bus_id,
-			 input_dev->name);
+		dev_err(&spi->dev, "%s: Failed to probe %s\n",
+			dev_name(&spi->dev), input_dev->name);
 		err = -ENODEV;
 		goto err_free_mem;
 	}
diff -puN drivers/input/touchscreen/ad7879.c~input-ad7879-touchscreen-driver-dont-use-bus_id drivers/input/touchscreen/ad7879.c
--- a/drivers/input/touchscreen/ad7879.c~input-ad7879-touchscreen-driver-dont-use-bus_id
+++ a/drivers/input/touchscreen/ad7879.c
@@ -418,7 +418,7 @@ static int __devinit ad7879_construct(bu
 	else
 		ts->gpio_init = AD7879_GPIO_EN | AD7879_GPIODIR;
 
-	snprintf(ts->phys, sizeof(ts->phys), "%s/inputX", bus->dev.bus_id);
+	snprintf(ts->phys, sizeof(ts->phys), "%s/inputX", dev_name(&bus->dev));
 
 	input_dev->name = "AD7879 Touchscreen";
 	input_dev->phys = ts->phys;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

kernel-doc-preferred-ending-marker-and-examples.patch
kernel-doc-fix-syscall-wrapper-processing.patch
linux-next.patch
uv-fix-header-struct-usage.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver.patch
input-ad7879-touchscreen-driver-dont-use-bus_id.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pci-fix-romc-kernel-doc-warning.patch
esp-fix-section-mismatch-warning.patch
cciss-pci-power-management-reset-for-kexec.patch
cciss-pci-power-management-reset-for-kexec-cleanup.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch

