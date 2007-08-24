From: akpm@linux-foundation.org
Subject: + usbmon-doc-update-mention-new-wildcard-0-bus.patch added to -mm tree
Date: Fri, 24 Aug 2007 16:26:03 -0700
Message-ID: <200708242326.l7ONQ3fF020113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544AbXHXX0Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 19:26:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, greg@kroah.com, stern@rowland.harvard.edu, zaitcev@redhat.com


The patch titled
     usbmon doc update": mention new wildcard ('0') bus
has been added to the -mm tree.  Its filename is
     usbmon-doc-update-mention-new-wildcard-0-bus.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usbmon doc update": mention new wildcard ('0') bus
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>

Update usbmon documentation, mentioning the "zero" (wildcard) bus. 
Possibly, in my first hunk, the 'either ...  or ...' should be rephrased a
bit to be expressed better.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/usb/usbmon.txt |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletion(-)

diff -puN Documentation/usb/usbmon.txt~usbmon-doc-update-mention-new-wildcard-0-bus Documentation/usb/usbmon.txt
--- a/Documentation/usb/usbmon.txt~usbmon-doc-update-mention-new-wildcard-0-bus
+++ a/Documentation/usb/usbmon.txt
@@ -34,9 +34,12 @@ if usbmon is built into the kernel.
 Verify that bus sockets are present.
 
 # ls /sys/kernel/debug/usbmon
-1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
+0s  0t  0u  1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
 #
 
+Now you can choose to either use the sockets numbered '0' (to capture packets on
+all buses), and skip to step #3, or find the bus used by your device with step #2.
+
 2. Find which bus connects to the desired device
 
 Run "cat /proc/bus/usb/devices", and find the T-line which corresponds to
@@ -56,6 +59,10 @@ Bus=03 means it's bus 3.
 
 # cat /sys/kernel/debug/usbmon/3u > /tmp/1.mon.out
 
+to listen on a single bus, otherwise, to listen on all buses, type:
+
+# cat /sys/kernel/debug/usbmon/0u > /tmp/1.mon.out
+
 This process will be reading until killed. Naturally, the output can be
 redirected to a desirable location. This is preferred, because it is going
 to be quite long.
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

usbmon-doc-update-mention-new-wildcard-0-bus.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
