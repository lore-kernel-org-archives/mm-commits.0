From: akpm@linux-foundation.org
Subject: + eeepc-laptopc-dont-enable-camera-at-startup-if-its-already-on.patch added to -mm tree
Date: Tue, 13 Oct 2009 11:28:00 -0700
Message-ID: <200910131828.n9DIS04K027004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760125AbZJMS26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 14:28:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lultimouomo@gmail.com, alan-jenkins@tuffmail.co.uk, corentincj@iksaif.net, len.brown@intel.com, mjg@redhat.com


The patch titled
     eeepc-laptop.c: don't enable camera at startup if it's already on.
has been added to the -mm tree.  Its filename is
     eeepc-laptopc-dont-enable-camera-at-startup-if-its-already-on.patch

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
Subject: eeepc-laptop.c: don't enable camera at startup if it's already on.
From: Luca Niccoli <lultimouomo@gmail.com>

Switching the camera takes 500ms, checking if it's on is almost free... 
The BIOS remembers the setting through reboots, so there's good chance the
camera is already enabled.

Signed-off-by: Luca Niccoli <lultimouomo@gmail.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Len Brown <len.brown@intel.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/platform/x86/eeepc-laptop.c~eeepc-laptopc-dont-enable-camera-at-startup-if-its-already-on drivers/platform/x86/eeepc-laptop.c
--- a/drivers/platform/x86/eeepc-laptop.c~eeepc-laptopc-dont-enable-camera-at-startup-if-its-already-on
+++ a/drivers/platform/x86/eeepc-laptop.c
@@ -356,7 +356,8 @@ static void __devinit eeepc_enable_camer
 	 * If the following call to set_acpi() fails, it's because there's no
 	 * camera so we can ignore the error.
 	 */
-	set_acpi(CM_ASL_CAMERA, 1);
+	if (get_acpi(CM_ASL_CAMERA) == 0)
+		set_acpi(CM_ASL_CAMERA, 1);
 }
 
 /*
_

Patches currently in -mm which might be from lultimouomo@gmail.com are

eeepc-laptopc-dont-enable-camera-at-startup-if-its-already-on.patch

