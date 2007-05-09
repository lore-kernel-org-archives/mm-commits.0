From: akpm@linux-foundation.org
Subject: + bt_hidp-kconfig-fixes.patch added to -mm tree
Date: Wed, 09 May 2007 16:48:48 -0700
Message-ID: <200705092348.l49NmmPd006152@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756215AbXEIXtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 19:49:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam.sharma@gmail.com, chris@pcburn.com, marcel@holtmann.org, ssatyam@cse.iitk.ac.in


The patch titled
     BT_HIDP Kconfig fixes
has been added to the -mm tree.  Its filename is
     bt_hidp-kconfig-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: BT_HIDP Kconfig fixes
From: "Satyam Sharma" <satyam.sharma@gmail.com>

Chris Bergeron <chris@pcburn.com> reported:

  On trying to build a 2.6.21.1 kernel using the configuration at
  http://pcburn.com/files/kernel/breaks.2.6.21.1.config I'm getting the
  following error with Networking Support -> Bluetooth Subsystem Support ->
  HIDP protocol support set to built-in:

   CC      init/version.o
   LD      init/built-in.o
   LD      .tmp_vmlinux1
  net/built-in.o: In function `hidp_add_connection':
  (.text+0x8bb08): undefined reference to `hid_ff_init'

Make CONFIG_BT_HIDP depend on CONFIG_USB_HID and CONFIG_HID_FF.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/hidp/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN net/bluetooth/hidp/Kconfig~bt_hidp-kconfig-fixes net/bluetooth/hidp/Kconfig
--- a/net/bluetooth/hidp/Kconfig~bt_hidp-kconfig-fixes
+++ a/net/bluetooth/hidp/Kconfig
@@ -1,6 +1,6 @@
 config BT_HIDP
 	tristate "HIDP protocol support"
-	depends on BT && BT_L2CAP && INPUT
+	depends on BT && BT_L2CAP && INPUT && USB_HID && HID_FF
 	select HID
 	help
 	  HIDP (Human Interface Device Protocol) is a transport layer
_

Patches currently in -mm which might be from satyam.sharma@gmail.com are

origin.patch
git-ubi.patch
bt_hidp-kconfig-fixes.patch
