From: akpm@linux-foundation.org
Subject: + usb-storage-include-prolific-technology-usb-drive-in-unusual_devs-list.patch added to -mm tree
Date: Mon, 03 Aug 2009 16:25:17 -0700
Message-ID: <200908032325.n73NPHtd020313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932267AbZHCXZx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 19:25:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rbrito@ime.usp.br, greg@kroah.com, hancockrwd@gmail.com, phil@ipom.com, stern@rowland.harvard.edu


The patch titled
     usb-storage: include Prolific Technology USB drive in unusual_devs list
has been added to the -mm tree.  Its filename is
     usb-storage-include-prolific-technology-usb-drive-in-unusual_devs-list.patch

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
Subject: usb-storage: include Prolific Technology USB drive in unusual_devs list
From: Rogerio Brito <rbrito@ime.usp.br>

Add a quirk entry for the Leading Driver UD-11 usb flash drive.

As Alan Stern told me, the device doesn't deal correctly with the
locking media feature of the device, and this patch incorporates it.

Compiled, tested, working.

Signed-off-by: Rogerio Brito <rbrito@ime.usp.br>
Cc: Phil Dibowitz <phil@ipom.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Robert Hancock <hancockrwd@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/usb/storage/unusual_devs.h~usb-storage-include-prolific-technology-usb-drive-in-unusual_devs-list drivers/usb/storage/unusual_devs.h
--- a/drivers/usb/storage/unusual_devs.h~usb-storage-include-prolific-technology-usb-drive-in-unusual_devs-list
+++ a/drivers/usb/storage/unusual_devs.h
@@ -838,6 +838,13 @@ UNUSUAL_DEV( 0x066f, 0x8000, 0x0001, 0x0
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
+/* Reported by Rogerio Brito <rbrito@ime.usp.br> */
+UNUSUAL_DEV( 0x067b, 0x2317, 0x0001, 0x001,
+		"Prolific Technology, Inc.",
+		"Mass Storage Device",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_NOT_LOCKABLE ),
+
 /* Reported by Richard -=[]=- <micro_flyer@hotmail.com> */
 /* Change to bcdDeviceMin (0x0100 to 0x0001) reported by
  * Thomas Bartosik <tbartdev@gmx-topmail.de> */
_

Patches currently in -mm which might be from rbrito@ime.usp.br are

usb-storage-include-prolific-technology-usb-drive-in-unusual_devs-list.patch

