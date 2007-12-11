From: akpm@linux-foundation.org
Subject: - esp_scsi-fix-reset-cleanup-spinlock-recursion.patch removed from -mm tree
Date: Tue, 11 Dec 2007 14:42:02 -0800
Message-ID: <200712112242.lBBMg2bg012582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758942AbXLKWvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 17:51:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, James.Bottomley@steeleye.com, davem@davemloft.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     esp_scsi: fix reset cleanup spinlock recursion
has been removed from the -mm tree.  Its filename was
     esp_scsi-fix-reset-cleanup-spinlock-recursion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: esp_scsi: fix reset cleanup spinlock recursion
From: "Maciej W. Rozycki" <macro@linux-mips.org>

The esp_reset_cleanup() function is called with the host lock held and
invokes starget_for_each_device() which wants to take it too.  Here is a
fix along the lines of shost_for_each_device()/__shost_for_each_device()
adding a __starget_for_each_device() counterpart which assumes the lock
has already been taken.

Eventually, I think the driver should get modified so that more work is
done as a softirq rather than in the interrupt context, but for now it
fixes a bug that causes the spinlock debugger to fire.

While at it, it fixes a small number of cosmetic problems with
starget_for_each_device() too.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/esp_scsi.c    |    4 ++--
 drivers/scsi/scsi.c        |   31 +++++++++++++++++++++++++++++--
 include/scsi/scsi_device.h |    3 +++
 3 files changed, 34 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/esp_scsi.c~esp_scsi-fix-reset-cleanup-spinlock-recursion drivers/scsi/esp_scsi.c
--- a/drivers/scsi/esp_scsi.c~esp_scsi-fix-reset-cleanup-spinlock-recursion
+++ a/drivers/scsi/esp_scsi.c
@@ -2026,8 +2026,8 @@ static void esp_reset_cleanup(struct esp
 		tp->flags |= ESP_TGT_CHECK_NEGO;
 
 		if (tp->starget)
-			starget_for_each_device(tp->starget, NULL,
-						esp_clear_hold);
+			__starget_for_each_device(tp->starget, NULL,
+						  esp_clear_hold);
 	}
 	esp->flags &= ~ESP_FLAG_RESETTING;
 }
diff -puN drivers/scsi/scsi.c~esp_scsi-fix-reset-cleanup-spinlock-recursion drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c~esp_scsi-fix-reset-cleanup-spinlock-recursion
+++ a/drivers/scsi/scsi.c
@@ -896,11 +896,11 @@ EXPORT_SYMBOL(__scsi_iterate_devices);
  * starget_for_each_device  -  helper to walk all devices of a target
  * @starget:	target whose devices we want to iterate over.
  *
- * This traverses over each devices of @shost.  The devices have
+ * This traverses over each device of @starget.  The devices have
  * a reference that must be released by scsi_host_put when breaking
  * out of the loop.
  */
-void starget_for_each_device(struct scsi_target *starget, void * data,
+void starget_for_each_device(struct scsi_target *starget, void *data,
 		     void (*fn)(struct scsi_device *, void *))
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -915,6 +915,33 @@ void starget_for_each_device(struct scsi
 EXPORT_SYMBOL(starget_for_each_device);
 
 /**
+ * __starget_for_each_device  -  helper to walk all devices of a target
+ *				 (UNLOCKED)
+ * @starget:	target whose devices we want to iterate over.
+ *
+ * This traverses over each device of @starget.  It does _not_
+ * take a reference on the scsi_device, so the whole loop must be
+ * protected by shost->host_lock.
+ *
+ * Note:  The only reason why drivers would want to use this is because
+ * they need to access the device list in irq context.  Otherwise you
+ * really want to use starget_for_each_device instead.
+ **/
+void __starget_for_each_device(struct scsi_target *starget, void *data,
+			       void (*fn)(struct scsi_device *, void *))
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct scsi_device *sdev;
+
+	__shost_for_each_device(sdev, shost) {
+		if ((sdev->channel == starget->channel) &&
+		    (sdev->id == starget->id))
+			fn(sdev, data);
+	}
+}
+EXPORT_SYMBOL(__starget_for_each_device);
+
+/**
  * __scsi_device_lookup_by_target - find a device given the target (UNLOCKED)
  * @starget:	SCSI target pointer
  * @lun:	SCSI Logical Unit Number
diff -puN include/scsi/scsi_device.h~esp_scsi-fix-reset-cleanup-spinlock-recursion include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h~esp_scsi-fix-reset-cleanup-spinlock-recursion
+++ a/include/scsi/scsi_device.h
@@ -242,6 +242,9 @@ extern struct scsi_device *__scsi_device
 							  uint);
 extern void starget_for_each_device(struct scsi_target *, void *,
 		     void (*fn)(struct scsi_device *, void *));
+extern void __starget_for_each_device(struct scsi_target *, void *,
+				      void (*fn)(struct scsi_device *,
+						 void *));
 
 /* only exposed to implement shost_for_each_device */
 extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
_

Patches currently in -mm which might be from macro@linux-mips.org are

git-mips.patch
kernel-printkc-concerns-about-the-console-handover.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
dzc-use-a-helper-to-cast-from-struct-uart_port.patch
dzc-resource-management.patch
