From: akpm@linux-foundation.org
Subject: + input-ad7879-touchscreen-driver-dont-use-bus_id.patch added to -mm tree
Date: Mon, 02 Feb 2009 14:13:18 -0800
Message-ID: <200902022213.n12MDI1U029183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbZBBWOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 17:14:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, cooloney@kernel.org, dmitry.torokhov@gmail.com, michael.hennerich@analog.com


The patch titled
     touchscreen/ad787x: don't use bus_id
has been added to the -mm tree.  Its filename is
     input-ad7879-touchscreen-driver-dont-use-bus_id.patch

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

origin.patch
maintainers-general-listsopenfabricsorg-is-moderated.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver-dont-use-bus_id.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-fix.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

