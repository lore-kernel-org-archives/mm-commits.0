From: akpm@linux-foundation.org
Subject: + acpi-video-fix-acpi_backlight=video.patch added to -mm tree
Date: Tue, 04 May 2010 14:37:47 -0700
Message-ID: <201005042137.o44LblTZ020256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932152Ab0EDViY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 17:38:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamal@canonical.com, bjorn.helgaas@hp.com, jkosina@suse.cz, lenb@kernel.org, rui.zhang@intel.com, stable@kernel.org


The patch titled
     acpi: video: fix acpi_backlight=video
has been added to the -mm tree.  Its filename is
     acpi-video-fix-acpi_backlight=video.patch

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
Subject: acpi: video: fix acpi_backlight=video
From: Kamal Mostafa <kamal@canonical.com>

Make "acpi_backlight=video" param enable ACPI_VIDEO_BACKLIGHT_FORCE_VIDEO
as intended, instead of incorrectly enabling video output switching.

Addresses http://bugs.launchpad.net/bugs/573120

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/video_detect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/video_detect.c~acpi-video-fix-acpi_backlight=video drivers/acpi/video_detect.c
--- a/drivers/acpi/video_detect.c~acpi-video-fix-acpi_backlight=video
+++ a/drivers/acpi/video_detect.c
@@ -250,7 +250,7 @@ static int __init acpi_backlight(char *s
 				ACPI_VIDEO_BACKLIGHT_FORCE_VENDOR;
 		if (!strcmp("video", str))
 			acpi_video_support |=
-				ACPI_VIDEO_OUTPUT_SWITCHING_FORCE_VIDEO;
+				ACPI_VIDEO_BACKLIGHT_FORCE_VIDEO;
 	}
 	return 1;
 }
_

Patches currently in -mm which might be from kamal@canonical.com are

acpi-sleep-init_set_sci_en_on_resume-for-dell-studio-155x.patch
acpi-video-fix-acpi_backlight=video.patch

