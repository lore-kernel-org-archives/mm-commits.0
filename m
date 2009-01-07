From: akpm@linux-foundation.org
Subject: - i2o-remove-extraneous-kernel-doc.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:15 -0800
Message-ID: <200901072218.n07MIF3k017763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758737AbZAGWdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:33:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     i2o: remove extraneous kernel-doc
has been removed from the -mm tree.  Its filename was
     i2o-remove-extraneous-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2o: remove extraneous kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Remove excess kernel-doc function parameter notation from i2o/.

Warning(drivers/message/i2o/iop.c:64): Excess function parameter 'msg' description in 'i2o_msg_get_wait'
Warning(drivers/message/i2o/device.c:62): Excess function parameter 'drv' description in 'i2o_device_claim'
Warning(drivers/message/i2o/device.c:95): Excess function parameter 'drv' description in 'i2o_device_claim_release'
Warning(drivers/message/i2o/driver.c:186): Excess function parameter 'msg' description in 'i2o_driver_dispatch'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/device.c |    2 --
 drivers/message/i2o/driver.c |    1 -
 2 files changed, 3 deletions(-)

diff -puN drivers/message/i2o/device.c~i2o-remove-extraneous-kernel-doc drivers/message/i2o/device.c
--- a/drivers/message/i2o/device.c~i2o-remove-extraneous-kernel-doc
+++ a/drivers/message/i2o/device.c
@@ -52,7 +52,6 @@ static inline int i2o_device_issue_claim
 /**
  *	i2o_device_claim - claim a device for use by an OSM
  *	@dev: I2O device to claim
- *	@drv: I2O driver which wants to claim the device
  *
  *	Do the leg work to assign a device to a given OSM. If the claim succeeds,
  *	the owner is the primary. If the attempt fails a negative errno code
@@ -80,7 +79,6 @@ int i2o_device_claim(struct i2o_device *
 /**
  *	i2o_device_claim_release - release a device that the OSM is using
  *	@dev: device to release
- *	@drv: driver which claimed the device
  *
  *	Drop a claim by an OSM on a given I2O device.
  *
diff -puN drivers/message/i2o/driver.c~i2o-remove-extraneous-kernel-doc drivers/message/i2o/driver.c
--- a/drivers/message/i2o/driver.c~i2o-remove-extraneous-kernel-doc
+++ a/drivers/message/i2o/driver.c
@@ -173,7 +173,6 @@ void i2o_driver_unregister(struct i2o_dr
  *	i2o_driver_dispatch - dispatch an I2O reply message
  *	@c: I2O controller of the message
  *	@m: I2O message number
- *	@msg: I2O message to be delivered
  *
  *	The reply is delivered to the driver from which the original message
  *	was. This function is only called from interrupt context.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
leds-add-a-dac124s085-spi-led-driver-fix.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver-select-serial_core.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
jbd-remove-excess-kernel-doc-notation.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch

