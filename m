From: akpm@linux-foundation.org
Subject: + usb-power-managementtxt-disconnect-clarification.patch added to -mm tree
Date: Mon, 12 Nov 2007 17:47:38 -0800
Message-ID: <200711130147.lAD1lcqQ020587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49259 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755011AbXKMBrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 20:47:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, greg@kroah.com


The patch titled
     usb: power-management.txt - disconnect clarification
has been added to the -mm tree.  Its filename is
     usb-power-managementtxt-disconnect-clarification.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb: power-management.txt - disconnect clarification
From: Tilman Schmidt <tilman@imap.cc>

Add a paragraph to Documentation/usb/power-management.txt about the
interaction between suspend and disconnect.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/usb/power-management.txt |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN Documentation/usb/power-management.txt~usb-power-managementtxt-disconnect-clarification Documentation/usb/power-management.txt
--- a/Documentation/usb/power-management.txt~usb-power-managementtxt-disconnect-clarification
+++ a/Documentation/usb/power-management.txt
@@ -278,6 +278,12 @@ optional.  The methods' jobs are quite s
 	(although the interfaces will be in the same altsettings as
 	before the suspend).
 
+If the device is disconnected or powered down while it is suspended,
+the disconnect method will be called instead of the resume or
+reset_resume method.  This will also happen if the system is resumed
+from hibernation, as the device could have been disconnected without
+the system being able to detect it.
+
 The reset_resume method is used by the USB Persist facility (see
 Documentation/usb/persist.txt) and it can also be used under certain
 circumstances when CONFIG_USB_PERSIST is not enabled.  Currently, if a
_

Patches currently in -mm which might be from tilman@imap.cc are

usb-power-managementtxt-disconnect-clarification.patch
