From: akpm@linux-foundation.org
Subject: + gpio-potential-null-dereference.patch added to -mm tree
Date: Mon, 26 Apr 2010 12:46:10 -0700
Message-ID: <201004261946.o3QJkAX7015752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754764Ab0DZTqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 15:46:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, david-b@pacbell.net


The patch titled
     gpio: potential null dereference
has been added to the -mm tree.  Its filename is
     gpio-potential-null-dereference.patch

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
Subject: gpio: potential null dereference
From: Dan Carpenter <error27@gmail.com>

Smatch found a potential null dereference in gpio_setup_irq().  The
"pdesc" variable is allocated with idr_find() that can return NULL.  If
gpio_setup_irq() is called with 0 as gpio_flags and "pdesc" is null, it
would OOPs here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/gpio/gpiolib.c~gpio-potential-null-dereference drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio-potential-null-dereference
+++ a/drivers/gpio/gpiolib.c
@@ -416,7 +416,8 @@ static int gpio_setup_irq(struct gpio_de
 	return 0;
 
 free_sd:
-	sysfs_put(pdesc->value_sd);
+	if (pdesc)
+		sysfs_put(pdesc->value_sd);
 free_id:
 	idr_remove(&pdesc_idr, id);
 	desc->flags &= GPIO_FLAGS_MASK;
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
gpio-potential-null-dereference.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
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
cx231xx-improve-error-handling.patch
backlight-backlight_device_register-return-err_ptr.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch
drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch
musb-potential-use-after-free.patch
usb-oxu210hp-release-spinlock-on-error-path.patch
mm-document-follow_page.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch
fs-sysv-dereferencing-err_ptr.patch

