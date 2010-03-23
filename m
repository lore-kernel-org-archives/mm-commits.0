From: akpm@linux-foundation.org
Subject: + backlight-backlight_device_register-return-err_ptr.patch added to -mm tree
Date: Mon, 22 Mar 2010 20:51:36 -0400
Message-ID: <201003230352.o2N3qRbM012085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358Ab0CWDwi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 23:52:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, rpurdie@rpsys.net


The patch titled
     backlight: backlight_device_register() return ERR_PTR()
has been added to the -mm tree.  Its filename is
     backlight-backlight_device_register-return-err_ptr.patch

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
Subject: backlight: backlight_device_register() return ERR_PTR()
From: Dan Carpenter <error27@gmail.com>

backlight_device_register() returns a valid pointer or ERR_PTR() never
NULL.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adx_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/adx_bl.c~backlight-backlight_device_register-return-err_ptr drivers/video/backlight/adx_bl.c
--- a/drivers/video/backlight/adx_bl.c~backlight-backlight_device_register-return-err_ptr
+++ a/drivers/video/backlight/adx_bl.c
@@ -106,8 +106,8 @@ static int __devinit adx_backlight_probe
 	props.max_brightness = 0xff;
 	bldev = backlight_device_register(dev_name(&pdev->dev), &pdev->dev,
 					  bl, &adx_backlight_ops, &props);
-	if (!bldev) {
-		ret = -ENOMEM;
+	if (IS_ERR(bldev)) {
+		ret = PTR_ERR(bldev);
 		goto out;
 	}
 
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
memcontrol-fix-potential-null-deref.patch
rtc-mc13783-fix-use-after-free-bug.patch
linux-next.patch
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
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
proc-cleanup-remove-unused-assignments.patch

