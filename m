From: akpm@linux-foundation.org
Subject: + usb-fix-paths-in-usbmon-documentation.patch added to -mm tree
Date: Mon, 24 Aug 2009 14:05:11 -0700
Message-ID: <200908242105.n7OL5B8m026567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234AbZHXVFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rbrito@ime.usp.br, greg@kroah.com, stern@rowland.harvard.edu


The patch titled
     usb: fix paths in usbmon documentation
has been added to the -mm tree.  Its filename is
     usb-fix-paths-in-usbmon-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: usb: fix paths in usbmon documentation
=46rom: Rog=E9rio Brito <rbrito@ime.usp.br>

The documentation for usbmon in the kernel 2.6.31-rc7 kernel doesn't
match what the kernel exposes in the debug fs tree. This patch fixes it=
=2E

Signed-off-by: Rog=E9rio Brito <rbrito@ime.usp.br>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/usb/usbmon.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/usb/usbmon.txt~usb-fix-paths-in-usbmon-document=
ation Documentation/usb/usbmon.txt
--- a/Documentation/usb/usbmon.txt~usb-fix-paths-in-usbmon-documentatio=
n
+++ a/Documentation/usb/usbmon.txt
@@ -33,7 +33,7 @@ if usbmon is built into the kernel.
=20
 Verify that bus sockets are present.
=20
-# ls /sys/kernel/debug/usbmon
+# ls /sys/kernel/debug/usb/usbmon
 0s  0u  1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
 #
=20
@@ -58,11 +58,11 @@ Bus=3D03 means it's bus 3.
=20
 3. Start 'cat'
=20
-# cat /sys/kernel/debug/usbmon/3u > /tmp/1.mon.out
+# cat /sys/kernel/debug/usb/usbmon/3u > /tmp/1.mon.out
=20
 to listen on a single bus, otherwise, to listen on all buses, type:
=20
-# cat /sys/kernel/debug/usbmon/0u > /tmp/1.mon.out
+# cat /sys/kernel/debug/usb/usbmon/0u > /tmp/1.mon.out
=20
 This process will be reading until killed. Naturally, the output can b=
e
 redirected to a desirable location. This is preferred, because it is g=
oing
_

Patches currently in -mm which might be from rbrito@ime.usp.br are

usb-fix-paths-in-usbmon-documentation.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
