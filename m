From: akpm@linux-foundation.org
Subject: + drivers-acpi-videoc-remove-unneeded-memsets.patch added to -mm tree
Date: Tue, 14 Jul 2009 15:15:33 -0700
Message-ID: <200907142215.n6EMFX7w008422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756210AbZGNWQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 18:16:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rui.zhang@intel.com, lenb@kernel.org


The patch titled
     drivers/acpi/video.c: remove unneeded memsets
has been added to the -mm tree.  Its filename is
     drivers-acpi-videoc-remove-unneeded-memsets.patch

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
Subject: drivers/acpi/video.c: remove unneeded memsets
From: Zhang Rui <rui.zhang@intel.com>

device->cap and video->cap are zeroed initially so we don't need to clear
them again.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/video.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/acpi/video.c~acpi-dont-free-non-existant-backlight-in-acpi-video-module drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-dont-free-non-existant-backlight-in-acpi-video-module
+++ a/drivers/acpi/video.c
@@ -934,9 +934,6 @@ static void acpi_video_device_find_cap(s
 {
 	acpi_handle h_dummy1;
 
-
-	memset(&device->cap, 0, sizeof(device->cap));
