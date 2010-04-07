From: akpm@linux-foundation.org
Subject: [merged] mxser-spin_lock-=-spin_lock_irq.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:49:44 -0400
Message-ID: <201004071851.o37IpAoa001272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756503Ab0DGSvV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:51:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mxser: spin_lock() => spin_lock_irq()
has been removed from the -mm tree.  Its filename was
     mxser-spin_lock-=-spin_lock_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mxser: spin_lock() => spin_lock_irq()
From: Dan Carpenter <error27@gmail.com>

This should be spin_lock_irq() to match the spin_unlock_irq().  Originally
it was a lock_kernel() but we switched everything to spin_lock_irq() last
November.

[akpm@linux-foundation.org: fix the MOXA_ASPP_MON case too (per Jiri)]
Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
@@ -1778,12 +1778,12 @@ static int mxser_ioctl(struct tty_struct
 	case MOXA_ASPP_MON: {
 		int mcr, status;
 
-		spin_lock(&info->slock);
+		spin_lock_irq(&info->slock);
 		status = mxser_get_msr(info->ioaddr, 1, tty->index);
 		mxser_check_modem_status(tty, info, status);
 
 		mcr = inb(info->ioaddr + UART_MCR);
-		spin_unlock(&info->slock);
+		spin_unlock_irq(&info->slock);
 
 		if (mcr & MOXA_MUST_MCR_XON_FLAG)
 			info->mon_data.hold_reason &= ~NPPI_NOTIFY_XOFFHOLD;
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
dpt_i20-several-use-after-free-issues.patch
sbshc-acpi_device_class-smbus_host_controller-too-long.patch
acpi_pad-processor_aggregator-name-too-long.patch
acpi_pad-processor_aggregator-name-too-long-fix.patch
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
wd7000-typo-spin_unlock_irq-=-spin_lock_irq.patch
drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch
drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch
musb-potential-use-after-free.patch
usb-oxu210hp-release-spinlock-on-error-path.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch

