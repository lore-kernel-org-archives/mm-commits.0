From: akpm@linux-foundation.org
Subject: + usb-net-asix-does-not-really-need-10-100mbit.patch added to -mm tree
Date: Thu, 14 Feb 2008 14:53:30 -0800
Message-ID: <200802142253.m1EMrUEO007297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290AbYBNWxo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 17:53:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, david-b@pacbell.net, greg@kroah.com, jeff@garzik.org


The patch titled
     usb net: asix does not really need 10/100mbit
has been added to the -mm tree.  Its filename is
     usb-net-asix-does-not-really-need-10-100mbit.patch

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
flat-binaries-drop-binfmt_flat-bad-header-magic-warning.patch
mtd-maps-document-mtd_physmap-module-name-in-kconfig.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
