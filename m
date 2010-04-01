From: akpm@linux-foundation.org
Subject: + s390-potential-buffer-overflow.patch added to -mm tree
Date: Thu, 01 Apr 2010 13:54:47 -0700
Message-ID: <201004012054.o31Ksl2c008627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233Ab0DAUy5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 16:54:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, ebiederm@xmission.com, hans@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     s390: potential buffer overflow
has been added to the -mm tree.  Its filename is
     s390-potential-buffer-overflow.patch

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
Subject: s390: potential buffer overflow
From: Dan Carpenter <error27@gmail.com>

"len" hasn't been properly range checked so we shouldn't use it as an
array offset.  This can only be written to by root but it would still be
annoying to accidentally write more than 3 characters and corrupt your
memory.

Signed-off-by: Dan Carpenter <error27@gmail.com>
"Eric W. Biederman" <ebiederm@xmission.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hans-Joachim Picht <hans@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/sclp_async.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/s390/char/sclp_async.c~s390-potential-buffer-overflow drivers/s390/char/sclp_async.c
--- a/drivers/s390/char/sclp_async.c~s390-potential-buffer-overflow
+++ a/drivers/s390/char/sclp_async.c
@@ -85,7 +85,7 @@ static int proc_handler_callhome(struct 
 		rc = copy_from_user(buf, buffer, sizeof(buf));
 		if (rc != 0)
 			return -EFAULT;
-		buf[len - 1] = '\0';
+		buf[sizeof(buf) - 1] = '\0';
 		if (strict_strtoul(buf, 0, &val) != 0)
 			return -EINVAL;
 		if (val != 0 && val != 1)
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
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

