From: akpm@linux-foundation.org
Subject: + cciss-unlock-on-error-path.patch added to -mm tree
Date: Fri, 02 Apr 2010 15:14:36 -0700
Message-ID: <201004022214.o32MEaGJ008402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755238Ab0DBWOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Apr 2010 18:14:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, jens.axboe@oracle.com, scameron@beardog.cce.hp.com


The patch titled
     cciss: unlock on error path
has been added to the -mm tree.  Its filename is
     cciss-unlock-on-error-path.patch

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
Subject: cciss: unlock on error path
From: Dan Carpenter <error27@gmail.com>

We take the spin_lock again in fail_all_cmds() so we need to unlock here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Steve Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/cciss.c~cciss-unlock-on-error-path drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-unlock-on-error-path
+++ a/drivers/block/cciss.c
@@ -3341,6 +3341,7 @@ static irqreturn_t do_cciss_intr(int irq
 					printk(KERN_WARNING
 					       "cciss: controller cciss%d failed, stopping.\n",
 					       h->ctlr);
+					spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 					fail_all_cmds(h->ctlr);
 					return IRQ_HANDLED;
 				}
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
mxser-spin_lock-=-spin_lock_irq.patch
mxser-spin_lock-=-spin_lock_irq-fix.patch
cciss-unlock-on-error-path.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
thermal-make-lockdep-happy.patch
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

