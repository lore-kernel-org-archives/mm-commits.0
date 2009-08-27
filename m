From: akpm@linux-foundation.org
Subject: [merged] staging-iio-fix-duplicate-dev_attr_name.patch removed from -mm tree
Date: Thu, 27 Aug 2009 12:18:44 -0700
Message-ID: <200908271918.n7RJIiLj010754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbZH0TSy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 15:18:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, greg@kroah.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     staging/iio: fix duplicate dev_attr_name
has been removed from the -mm tree.  Its filename was
     staging-iio-fix-duplicate-dev_attr_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: staging/iio: fix duplicate dev_attr_name
From: Randy Dunlap <randy.dunlap@oracle.com>

device attr's should be static, otherwise duplicate identifiers are
created:

drivers/staging/iio/trigger/iio-trig-gpio.o:(.data+0x1c): multiple definition of `dev_attr_name'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/iio/accel/lis3l02dq_ring.c          |    2 +-
 drivers/staging/iio/trigger/iio-trig-gpio.c         |    2 +-
 drivers/staging/iio/trigger/iio-trig-periodic-rtc.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/staging/iio/accel/lis3l02dq_ring.c~staging-iio-fix-duplicate-dev_attr_name drivers/staging/iio/accel/lis3l02dq_ring.c
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c~staging-iio-fix-duplicate-dev_attr_name
+++ a/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -441,7 +441,7 @@ static int lis3l02dq_data_rdy_trigger_se
 				 &t);
 	return ret;
 }
-DEVICE_ATTR(name, S_IRUGO, iio_trigger_read_name, NULL);
+static DEVICE_ATTR(name, S_IRUGO, iio_trigger_read_name, NULL);
 
 static struct attribute *lis3l02dq_trigger_attrs[] = {
 	&dev_attr_name.attr,
diff -puN drivers/staging/iio/trigger/iio-trig-gpio.c~staging-iio-fix-duplicate-dev_attr_name drivers/staging/iio/trigger/iio-trig-gpio.c
--- a/drivers/staging/iio/trigger/iio-trig-gpio.c~staging-iio-fix-duplicate-dev_attr_name
+++ a/drivers/staging/iio/trigger/iio-trig-gpio.c
@@ -46,7 +46,7 @@ static irqreturn_t iio_gpio_trigger_poll
 	return IRQ_HANDLED;
 }
 
-DEVICE_ATTR(name, S_IRUGO, iio_trigger_read_name, NULL);
+static DEVICE_ATTR(name, S_IRUGO, iio_trigger_read_name, NULL);
 
 static struct attribute *iio_gpio_trigger_attrs[] = {
 	&dev_attr_name.attr,
diff -puN drivers/staging/iio/trigger/iio-trig-periodic-rtc.c~staging-iio-fix-duplicate-dev_attr_name drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
--- a/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c~staging-iio-fix-duplicate-dev_attr_name
+++ a/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
@@ -81,10 +81,10 @@ static ssize_t iio_trig_periodic_read_na
 	return sprintf(buf, "%s\n", trig_info->name);
 }
 
-DEVICE_ATTR(name, S_IRUGO,
+static DEVICE_ATTR(name, S_IRUGO,
 	    iio_trig_periodic_read_name,
 	    NULL);
-DEVICE_ATTR(frequency, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(frequency, S_IRUGO | S_IWUSR,
 	    iio_trig_periodic_read_freq,
 	    iio_trig_periodic_write_freq);
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
gspca-fix-sn9c20x-build-errors.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
mtd-make-onenand-genericc-more-generic-fix.patch
isdn-fix-netjet-build-errors.patch
scsi-fix-func-names-in-kernel-doc.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
reiser4-export-remove_from_page_cache-fix.patch

