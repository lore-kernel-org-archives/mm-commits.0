From: akpm@linux-foundation.org
Subject: + ir-keytable-avoid-double-lock.patch added to -mm tree
Date: Mon, 05 Apr 2010 12:42:56 -0700
Message-ID: <201004051942.o35Jgu2X005183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756138Ab0DETnY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 15:43:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, dtor@mail.ru, mchehab@infradead.org


The patch titled
     ir-keytable: avoid double lock
has been added to the -mm tree.  Its filename is
     ir-keytable-avoid-double-lock.patch

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
Subject: ir-keytable: avoid double lock
From: Dan Carpenter <error27@gmail.com>

It's possible that we wanted to resize to a smaller size but we didn't
have enough memory to create the new table.  We need to test for that here
so we don't try to lock twice and dead lock.  Also we free the "oldkeymap"
on that path and that would be bad.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/IR/ir-keytable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/IR/ir-keytable.c~ir-keytable-avoid-double-lock drivers/media/IR/ir-keytable.c
--- a/drivers/media/IR/ir-keytable.c~ir-keytable-avoid-double-lock
+++ a/drivers/media/IR/ir-keytable.c
@@ -217,7 +217,7 @@ static void ir_delete_key(struct ir_scan
 		memcpy(&newkeymap[elem], &oldkeymap[elem + 1],
 		       (newsize - elem) * sizeof(*newkeymap));
 
-	if (resize) {
+	if (resize && newkeymap != oldkeymap) {
 		/*
 		 * As the copy happened to a temporary table, only here
 		 * it needs to lock while replacing the table pointers
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
mxser-spin_lock-=-spin_lock_irq.patch
mxser-spin_lock-=-spin_lock_irq-fix.patch
cciss-unlock-on-error-path.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
dpt_i20-several-use-after-free-issues.patch
sbshc-acpi_device_class-smbus_host_controller-too-long.patch
acpi_pad-processor_aggregator-name-too-long.patch
drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue.patch
drivers-gpu-drm-radeon-radeon_atombiosc-range-check-issues.patch
drivers-gpu-drm-drm_sysfsc-sysfs-files-error-handling.patch
drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop.patch
drivers-media-video-au0828-au0828-videoc-off-by-one-bug.patch
drivers-media-video-zc0301-zc0301_corec-improve-error-handling.patch
drivers-media-video-et61x251-et61x251_corec-improve-error-handling.patch
drivers-media-video-sn9c102-sn9c102_corec-improve-error-handling.patch
cx88-improve-error-handling.patch
ir-keytable-avoid-double-lock.patch
drivers-mfd-pcf50633-corec-off-by-one-issue.patch
backlight-backlight_device_register-return-err_ptr.patch
s390-potential-buffer-overflow.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch
drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch
musb-potential-use-after-free.patch
usb-oxu210hp-release-spinlock-on-error-path.patch
9p-return-on-mutex_lock_interruptible.patch
9p-saving-negative-to-unsigned-char.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch
wd7000-typo-spin_unlock_irq-=-spin_lock_irq.patch

