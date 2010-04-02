From: akpm@linux-foundation.org
Subject: + mxser-spin_lock-=-spin_lock_irq.patch added to -mm tree
Date: Fri, 02 Apr 2010 15:13:28 -0700
Message-ID: <201004022213.o32MDSWI008357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755238Ab0DBWNk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Apr 2010 18:13:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, jirislaby@gmail.com


The patch titled
     mxser: spin_lock() => spin_lock_irq()
has been added to the -mm tree.  Its filename is
     mxser-spin_lock-=-spin_lock_irq.patch

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
Subject: mxser: spin_lock() => spin_lock_irq()
From: Dan Carpenter <error27@gmail.com>

This should be spin_lock_irq() to match the spin_unlock_irq().  Originally
it was a lock_kernel() but we switched everything to spin_lock_irq() last
November.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mxser.c~mxser-spin_lock-=-spin_lock_irq drivers/char/mxser.c
--- a/drivers/char/mxser.c~mxser-spin_lock-=-spin_lock_irq
+++ a/drivers/char/mxser.c
@@ -1768,7 +1768,7 @@ static int mxser_ioctl(struct tty_struct
 		int len, lsr;
 
 		len = mxser_chars_in_buffer(tty);
-		spin_lock(&info->slock);
+		spin_lock_irq(&info->slock);
 		lsr = inb(info->ioaddr + UART_LSR) & UART_LSR_THRE;
 		spin_unlock_irq(&info->slock);
 		len += (lsr ? 0 : 1);
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
mxser-spin_lock-=-spin_lock_irq.patch
mxser-spin_lock-=-spin_lock_irq-fix.patch
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

