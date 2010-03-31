From: akpm@linux-foundation.org
Subject: + drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop.patch added to -mm tree
Date: Wed, 31 Mar 2010 16:05:19 -0700
Message-ID: <201003312305.o2VN5JRM014257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932509Ab0CaXGH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 19:06:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, airlied@linux.ie, eric@anholt.net


The patch titled
     drivers/gpu/drm/drm_memory.c: fix check for end of loop
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop.patch

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
Subject: drivers/gpu/drm/drm_memory.c: fix check for end of loop
From: Dan Carpenter <error27@gmail.com>

"agpmem" is never NULL here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/drm_memory.c~drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop drivers/gpu/drm/drm_memory.c
--- a/drivers/gpu/drm/drm_memory.c~drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop
+++ a/drivers/gpu/drm/drm_memory.c
@@ -77,7 +77,7 @@ static void *agp_remap(unsigned long off
 		    && (agpmem->bound + (agpmem->pages << PAGE_SHIFT)) >=
 		    (offset + size))
 			break;
-	if (!agpmem)
+	if (&agpmem->head == &dev->agp->memory)
 		return NULL;
 
 	/*
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
dpt_i20-several-use-after-free-issues.patch
sbshc-acpi_device_class-smbus_host_controller-too-long.patch
acpi_pad-processor_aggregator-name-too-long.patch
drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue.patch
backlight-backlight_device_register-return-err_ptr.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
drbd-potential-null-dereference.patch
musb-potential-use-after-free.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch
drivers-media-video-au0828-au0828-videoc-off-by-one-bug.patch
drivers-gpu-drm-radeon-radeon_atombiosc-range-check-issues.patch
drivers-gpu-drm-drm_sysfsc-sysfs-files-error-handling.patch
drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop.patch
drivers-mfd-pcf50633-corec-off-by-one-issue.patch
drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch
drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch
drivers-media-video-zc0301-zc0301_corec-improve-error-handling.patch
drivers-media-video-et61x251-et61x251_corec-improve-error-handling.patch
drivers-media-video-sn9c102-sn9c102_corec-improve-error-handling.patch

