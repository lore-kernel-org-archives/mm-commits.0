From: akpm@linux-foundation.org
Subject: + sony-laptop-ignore-missing-_dis-method-on-pic-device.patch added to -mm tree
Date: Sun, 26 Oct 2008 20:42:44 -0700
Message-ID: <200810270342.m9R3givr031356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbYJ0DnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 26 Oct 2008 23:43:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg59@srcf.ucam.org, ajax@redhat.com, lenb@kernel.org, malattia@linux.it


The patch titled
     sony-laptop: ignore missing _DIS method on pic device
has been added to the -mm tree.  Its filename is
     sony-laptop-ignore-missing-_dis-method-on-pic-device.patch

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
Subject: sony-laptop: ignore missing _DIS method on pic device
From: Matthew Garrett <mjg59@srcf.ucam.org>

At least the Vaio VGN-Z540N doesn't have this method, so let's not fail
to suspend just because it doesn't exist.

Signed-off-by: Adam Jackson <ajax@redhat.com>
Acked-by: Mattia Dongili <malattia@linux.it>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sony-laptop.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/misc/sony-laptop.c~sony-laptop-ignore-missing-_dis-method-on-pic-device drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~sony-laptop-ignore-missing-_dis-method-on-pic-device
+++ a/drivers/misc/sony-laptop.c
@@ -2315,8 +2315,10 @@ end:
  */
 static int sony_pic_disable(struct acpi_device *device)
 {
-	if (ACPI_FAILURE(acpi_evaluate_object(device->handle,
-			"_DIS", NULL, NULL)))
+	acpi_status ret = acpi_evaluate_object(device->handle, "_DIS", NULL,
+					       NULL);
+
+	if (ACPI_FAILURE(ret) && ret != AE_NOT_FOUND)
 		return -ENXIO;
 
 	dprintk("Device disabled\n");
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

sony-laptop-ignore-missing-_dis-method-on-pic-device.patch
linux-next.patch

