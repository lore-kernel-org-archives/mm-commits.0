From: akpm@linux-foundation.org
Subject: - usb-unusual-devs-patch-for-nokia-5310-music-xpress.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:52:14 -0700
Message-ID: <200810012152.m91LqEeD006042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877AbYJAVwU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:52:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dalmaroad@gmail.com, greg@kroah.com, mdharm-usb@one-eyed-alien.net, mm-commits@vger.kernel.org


The patch titled
     usb: unusual devs patch for Nokia 5310 Music Xpress
has been removed from the -mm tree.  Its filename was
     usb-unusual-devs-patch-for-nokia-5310-music-xpress.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: unusual devs patch for Nokia 5310 Music Xpress
From: David Almaroad <dalmaroad@gmail.com>

The Nokia 5310 Music Xpress phone reports one too many sectors in
usb-storage mode.  This patch resolves that.

Signed-off-by: David Almaroad <dalmaroad@gmail.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/usb/storage/unusual_devs.h~usb-unusual-devs-patch-for-nokia-5310-music-xpress drivers/usb/storage/unusual_devs.h
--- a/drivers/usb/storage/unusual_devs.h~usb-unusual-devs-patch-for-nokia-5310-music-xpress
+++ a/drivers/usb/storage/unusual_devs.h
@@ -246,6 +246,13 @@ UNUSUAL_DEV(  0x0421, 0x04fa, 0x0601, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
+/* Patch for Nokia 5310 capacity */
+UNUSUAL_DEV(  0x0421, 0x006a, 0x0000, 0x0591,
+	"Nokia",
+	"5310",
+	US_SC_DEVICE, US_PR_DEVICE, NULL,
+	US_FL_FIX_CAPACITY ),
+
 /* Reported by Olaf Hering <olh@suse.de> from novell bug #105878 */
 UNUSUAL_DEV(  0x0424, 0x0fdc, 0x0210, 0x0210,
 		"SMSC",
_

Patches currently in -mm which might be from dalmaroad@gmail.com are


