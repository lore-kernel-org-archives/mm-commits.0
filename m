From: akpm@linux-foundation.org
Subject: - usb-net-asix-does-not-really-need-10-100mbit.patch removed from -mm tree
Date: Wed, 02 Apr 2008 12:20:18 -0700
Message-ID: <200804021920.m32JKIKI030257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757701AbYDBT1a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2008 15:27:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, david-b@pacbell.net, greg@kroah.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     usb net: asix does not really need 10/100mbit
has been removed from the -mm tree.  Its filename was
     usb-net-asix-does-not-really-need-10-100mbit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb net: asix does not really need 10/100mbit
From: Mike Frysinger <vapier@gentoo.org>

The asix usb driver currently depends on NET_ETHERNET which means you
cannot enable this driver if you only have 1000mbit enabled in your kernel.
Since there is no real dependency between the NET_ETHERNET portion and the
asix driver, simply drop it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/usb/Kconfig~usb-net-asix-does-not-really-need-10-100mbit drivers/net/usb/Kconfig
--- a/drivers/net/usb/Kconfig~usb-net-asix-does-not-really-need-10-100mbit
+++ a/drivers/net/usb/Kconfig
@@ -129,7 +129,7 @@ config USB_USBNET
 
 config USB_NET_AX8817X
 	tristate "ASIX AX88xxx Based USB 2.0 Ethernet Adapters"
-	depends on USB_USBNET && NET_ETHERNET
+	depends on USB_USBNET
 	select CRC32
 	default y
 	help
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch
mtd-maps-document-mtd_physmap-module-name-in-kconfig.patch
remove-duplicated-unlikely-in-is_err.patch

