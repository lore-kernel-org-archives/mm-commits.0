From: akpm@linux-foundation.org
Subject: + acpi-pm-traverse-video_device_list-for-backlight-restoration.patch added to -mm tree
Date: Wed, 04 Aug 2010 12:57:29 -0700
Message-ID: <201008041957.o74JvUfv006459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756958Ab0HDT57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Aug 2010 15:57:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhopf@suse.de, julia@diku.dk, lenb@kernel.org, mjg@redhat.com, oneukum@suse.de, rui.zhang@intel.com


The patch titled
     acpi/pm: traverse video_device_list for backlight restoration
has been added to the -mm tree.  Its filename is
     acpi-pm-traverse-video_device_list-for-backlight-restoration.patch

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
Subject: acpi/pm: traverse video_device_list for backlight restoration
From: Matthias Hopf <mhopf@suse.de>

acpi_video_bus_get_devices() explicitly calls
acpi_video_device_enumerate() before acpi_video_bus_get_one_device(),
which does acpi_video_device_bind().

In _enumerate(), active_list[] is created, with .bind_info explicitly set
to NULL, while the related .bind_info entry in video_device_list is set to
the acpi_video_device ptr in _bind().

The .bind_info is later used in acpi_video_resume() to re-set the
backlight - but it's only evaluated on the active_list[], on which all
.bind_info are NULL by construction.  This results in backlight not being
restored, if the BIOS doesn't do this by itself already.


The patch resolves this by replacing the active_list[] traversal by a
video_device_list traversal, but due to the nature of the issue I'm unsure
whether the original issue isn't of more principal quality.  I don't understand
why the list is (partially) transformed into an array in the first place,
especially as both the array *and* the list are used in the code...


.bind_info in active_list[] is NULL by construction - and used to
determine the acpi_video_device pointer during backlight restoration
during resume.

Using the list instead fixes backlight restoration for systems where the
BIOS doesn't do this by itself already.

Signed-off-by: Matthias Hopf <mhopf@suse.de>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Julia Lawall <julia@diku.dk>
Cc: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/video.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/video.c~acpi-pm-traverse-video_device_list-for-backlight-restoration drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-pm-traverse-video_device_list-for-backlight-restoration
+++ a/drivers/acpi/video.c
@@ -2346,7 +2346,6 @@ static int acpi_video_resume(struct noti
 {
 	struct acpi_video_bus *video;
 	struct acpi_video_device *video_device;
-	int i;
 
 	switch (val) {
 	case PM_HIBERNATION_PREPARE:
@@ -2359,11 +2358,12 @@ static int acpi_video_resume(struct noti
 
 	dev_info(&video->device->dev, "Restoring backlight state\n");
 
-	for (i = 0; i < video->attached_count; i++) {
-		video_device = video->attached_array[i].bind_info;
+	mutex_lock(&video->device_list_lock);
+	list_for_each_entry(video_device, &video->video_device_list, entry) {
 		if (video_device && video_device->backlight)
 			acpi_video_set_brightness(video_device->backlight);
 	}
+	mutex_unlock(&video->device_list_lock);
 
 	return NOTIFY_OK;
 }
_

Patches currently in -mm which might be from mhopf@suse.de are

acpi-pm-traverse-video_device_list-for-backlight-restoration.patch

