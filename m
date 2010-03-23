From: akpm@linux-foundation.org
Subject: + sis-strcpy-=-strlcpy.patch added to -mm tree
Date: Mon, 22 Mar 2010 23:32:10 -0400
Message-ID: <201003230633.o2N6X1dU018451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826Ab0CWGdE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 02:33:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, thomas@winischhofer.net


The patch titled
     sis: strcpy() => strlcpy()
has been added to the -mm tree.  Its filename is
     sis-strcpy-=-strlcpy.patch

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
Subject: sis: strcpy() => strlcpy()
From: Dan Carpenter <error27@gmail.com>

These are different size buffers (40 chars vs 16), we may as well be
cautious.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sis/sis_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/sis/sis_main.c~sis-strcpy-=-strlcpy drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~sis-strcpy-=-strlcpy
+++ a/drivers/video/sis/sis_main.c
@@ -1845,7 +1845,7 @@ sisfb_get_fix(struct fb_fix_screeninfo *
 
 	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
 
-	strcpy(fix->id, ivideo->myid);
+	strlcpy(fix->id, ivideo->myid, sizeof(fix->id));
 
 	mutex_lock(&info->mm_lock);
 	fix->smem_start  = ivideo->video_base + ivideo->video_offset;
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
memcontrol-fix-potential-null-deref.patch
rtc-mc13783-fix-use-after-free-bug.patch
linux-next.patch
kcore-fix-test-for-end-of-list.patch
acpi_pad-processor_aggregator-name-too-long.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
em28xx-empia-em28xx-audio-too-long.patch
cx231xx-card-driver-conexant-cx231xx-audio-too-long.patch
dpt_i20-several-use-after-free-issues.patch
sbshc-acpi_device_class-smbus_host_controller-too-long.patch
i915-fix-small-leak-on-error-path.patch
backlight-backlight_device_register-return-err_ptr.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
musb-potential-use-after-free.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
proc-cleanup-remove-unused-assignments.patch
sis-strcpy-=-strlcpy.patch

