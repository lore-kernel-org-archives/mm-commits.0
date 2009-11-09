From: akpm@linux-foundation.org
Subject: [merged] eeepc-laptopc-dont-enable-camera-at-startup-if-its-already-on.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:54:45 -0800
Message-ID: <200911091954.nA9JsjJM022196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774AbZKITyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:54:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lultimouomo@gmail.com, alan-jenkins@tuffmail.co.uk, corentincj@iksaif.net, len.brown@intel.com, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     eeepc-laptop.c: don't enable camera at startup if it's already on.
has been removed from the -mm tree.  Its filename was
     eeepc-laptopc-dont-enable-camera-at-startup-if-its-already-on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

