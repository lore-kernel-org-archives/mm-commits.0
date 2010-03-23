From: akpm@linux-foundation.org
Subject: + musb-potential-use-after-free.patch added to -mm tree
Date: Mon, 22 Mar 2010 20:55:00 -0400
Message-ID: <201003230355.o2N3tpNj012153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754319Ab0CWDz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 23:55:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, felipe.balbi@nokia.com, greg@kroah.com


The patch titled
     musb: potential use after free
has been added to the -mm tree.  Its filename is
     musb-potential-use-after-free.patch

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
Subject: musb: potential use after free
From: Dan Carpenter <error27@gmail.com>

We assign "urb->hcpriv = qh;" a few lines down.  I'm pretty sure we want
it "urb->hcpriv" to be NULL not a freed value.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/musb/musb_host.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/usb/musb/musb_host.c~musb-potential-use-after-free drivers/usb/musb/musb_host.c
--- a/drivers/usb/musb/musb_host.c~musb-potential-use-after-free
+++ a/drivers/usb/musb/musb_host.c
@@ -2042,6 +2042,7 @@ static int musb_urb_enqueue(
 		 * odd, rare, error prone, but legal.
 		 */
 		kfree(qh);
+		qh = NULL;
 		ret = 0;
 	} else
 		ret = musb_schedule(musb, qh,
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
musb-potential-use-after-free.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
proc-cleanup-remove-unused-assignments.patch

