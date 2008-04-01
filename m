From: akpm@linux-foundation.org
Subject: + hci_usb-do-not-initialize-static-variables-to-0.patch added to -mm tree
Date: Tue, 01 Apr 2008 15:29:27 -0700
Message-ID: <200804012229.m31MTV0r016884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756722AbYDAWaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 18:30:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, hidave.darkstar@gmail.com, marcel@holtmann.org, pavel@suse.cz


The patch titled
     hci_usb: do not initialize static variables to 0
has been added to the -mm tree.  Its filename is
     hci_usb-do-not-initialize-static-variables-to-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hci_usb: do not initialize static variables to 0
From: Pavel Machek <pavel@ucw.cz>

hci_usb: do not initialize static variables to 0.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_usb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/bluetooth/hci_usb.c~hci_usb-do-not-initialize-static-variables-to-0 drivers/bluetooth/hci_usb.c
--- a/drivers/bluetooth/hci_usb.c~hci_usb-do-not-initialize-static-variables-to-0
+++ a/drivers/bluetooth/hci_usb.c
@@ -62,13 +62,13 @@
 #define URB_ZERO_PACKET 0
 #endif
 
-static int ignore = 0;
-static int ignore_dga = 0;
-static int ignore_csr = 0;
-static int ignore_sniffer = 0;
-static int disable_scofix = 0;
-static int force_scofix = 0;
-static int reset = 0;
+static int ignore;
+static int ignore_dga;
+static int ignore_csr;
+static int ignore_sniffer;
+static int disable_scofix;
+static int force_scofix;
+static int reset;
 
 #ifdef CONFIG_BT_HCIUSB_SCO
 static int isoc = 2;
_

Patches currently in -mm which might be from pavel@ucw.cz are

git-x86.patch
git-acpi.patch
pm-remove-destroy_suspended_device.patch
git-hrt.patch
hci_usb-do-not-initialize-static-variables-to-0.patch
hci_usb-remove-code-obfuscation.patch
hci_usbh-fix-hard-to-trigger-race.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch

