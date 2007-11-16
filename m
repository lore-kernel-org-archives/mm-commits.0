From: akpm@linux-foundation.org
Subject: - usb-power-managementtxt-disconnect-clarification.patch removed from -mm tree
Date: Fri, 16 Nov 2007 13:58:04 -0800
Message-ID: <200711162158.lAGLw4rx005675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58428 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757446AbXKPV6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Nov 2007 16:58:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tilman@imap.cc, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb: power-management.txt - disconnect clarification
has been removed from the -mm tree.  Its filename was
     usb-power-managementtxt-disconnect-clarification.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: usb: power-management.txt - disconnect clarification
From: Tilman Schmidt <tilman@imap.cc>

Add a paragraph to Documentation/usb/power-management.txt about the
interaction between suspend and disconnect.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
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
gigaset-clean-up-urb-status-usage.patch
gigaset-code-cleanups.patch
bas_gigaset-suspend-support-v2.patch
usb_gigaset-suspend-support-v3.patch
