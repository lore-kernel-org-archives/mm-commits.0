From: akpm@linux-foundation.org
Subject: + drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue.patch added to -mm tree
Date: Wed, 31 Mar 2010 15:57:20 -0700
Message-ID: <201003312257.o2VMvK7c013792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758362Ab0CaW6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 18:58:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, airlied@linux.ie


The patch titled
     drivers/gpu/drm/via/via_video.c: fix off by one issue
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue.patch

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
Subject: drivers/gpu/drm/via/via_video.c: fix off by one issue
From: Dan Carpenter <error27@gmail.com>

"fx->lock" is used as the index in "dev_priv->decoder_queue[fx->lock]"
which is an array of "VIA_NR_XVMC_LOCKS" elements.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/via/via_video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/via/via_video.c~drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue drivers/gpu/drm/via/via_video.c
--- a/drivers/gpu/drm/via/via_video.c~drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue
+++ a/drivers/gpu/drm/via/via_video.c
@@ -75,7 +75,7 @@ int via_decoder_futex(struct drm_device 
 
 	DRM_DEBUG("\n");
 
-	if (fx->lock > VIA_NR_XVMC_LOCKS)
+	if (fx->lock >= VIA_NR_XVMC_LOCKS)
 		return -EFAULT;
 
 	lock = (volatile int *)XVMCLOCKPTR(sAPriv, fx->lock);
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

