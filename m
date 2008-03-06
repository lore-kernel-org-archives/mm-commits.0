From: akpm@linux-foundation.org
Subject: - bluetooth-conwise-technology-based-adapters-with-buggy-sco-support-bugzilla-9027.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:22:53 -0800
Message-ID: <200803062222.m26MMr3b020843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764010AbYCFWXc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:23:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sdiz@sdiz.net, davem@davemloft.net, hidave.darkstar@gmail.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     bluetooth: CONWISE Technology based adapters with buggy SCO support (bugzilla #9027)
has been removed from the -mm tree.  Its filename was
     bluetooth-conwise-technology-based-adapters-with-buggy-sco-support-bugzilla-9027.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bluetooth: CONWISE Technology based adapters with buggy SCO support (bugzilla #9027)
From: SDiZ <sdiz@sdiz.net>

Fix the CONWISE Technology based adapters with buggy SCO support issue
(bugzilla #9027)

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_usb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/bluetooth/hci_usb.c~bluetooth-conwise-technology-based-adapters-with-buggy-sco-support-bugzilla-9027 drivers/bluetooth/hci_usb.c
--- a/drivers/bluetooth/hci_usb.c~bluetooth-conwise-technology-based-adapters-with-buggy-sco-support-bugzilla-9027
+++ a/drivers/bluetooth/hci_usb.c
@@ -148,6 +148,9 @@ static struct usb_device_id blacklist_id
 	{ USB_DEVICE(0x0400, 0x0807), .driver_info = HCI_BROKEN_ISOC },
 	{ USB_DEVICE(0x0400, 0x080a), .driver_info = HCI_BROKEN_ISOC },
 
+	/* CONWISE Technology based adapters with buggy SCO support */
+	{ USB_DEVICE(0x0e5e, 0x6622), .driver_info = HCI_BROKEN_ISOC },
+
 	/* Belkin F8T012 and F8T013 devices */
 	{ USB_DEVICE(0x050d, 0x0012), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x050d, 0x0013), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
_

Patches currently in -mm which might be from sdiz@sdiz.net are

git-net.patch

