From: akpm@linux-foundation.org
Subject: + i2o-remove-extraneous-kernel-doc.patch added to -mm tree
Date: Fri, 21 Nov 2008 16:38:19 -0800
Message-ID: <200811220038.mAM0cJ6e029091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669AbYKVAiZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 19:38:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     i2o: remove extraneous kernel-doc
has been added to the -mm tree.  Its filename is
     i2o-remove-extraneous-kernel-doc.patch

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
 drivers/message/i2o/iop.c    |    1 -
 3 files changed, 4 deletions(-)

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
diff -puN drivers/message/i2o/iop.c~i2o-remove-extraneous-kernel-doc drivers/message/i2o/iop.c
--- a/drivers/message/i2o/iop.c~i2o-remove-extraneous-kernel-doc
+++ a/drivers/message/i2o/iop.c
@@ -49,7 +49,6 @@ static int i2o_hrt_get(struct i2o_contro
 /**
  *	i2o_msg_get_wait - obtain an I2O message from the IOP
  *	@c: I2O controller
- *	@msg: pointer to a I2O message pointer
  *	@wait: how long to wait until timeout
  *
  *	This function waits up to wait seconds for a message slot to be
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
scripts-extract-ikconfig-remove-bashisms.patch
drivers-ata-pata_radisysc-cleanup-kernel-doc.patch
drivers-ata-libata-corec-cleanup-kernel-doc.patch
drivers-ata-pata_oldpiixc-cleanup-kernel-doc.patch
drivers-ata-pata_pdc2027xc-cleanup-kernel-doc.patch
drivers-ata-pata_legacyc-cleanup-kernel-doc.patch
drivers-ata-pata_sisc-cleanup-kernel-doc.patch
drivers-ata-pata_c-the-rest-remove-redundant-comments.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
net-hp-plus-fix-link-errors.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-message-i2o-iopc-cleanup-kerneldoc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
profile-likely-unlikely-macros.patch

