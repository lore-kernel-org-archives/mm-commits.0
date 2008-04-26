From: akpm@linux-foundation.org
Subject: - hci_usb-remove-code-obfuscation.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:41:35 -0700
Message-ID: <200804261641.m3QGfZUl031136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757421AbYDZQmf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:42:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, hidave.darkstar@gmail.com, marcel@holtmann.org, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     hci_usb: remove code obfuscation
has been removed from the -mm tree.  Its filename was
     hci_usb-remove-code-obfuscation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hci_usb: remove code obfuscation
From: Pavel Machek <pavel@ucw.cz>

_urb_free is an alias for kfree... making code longer & harder to
read. Remove it.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_usb.c |   10 +++++-----
 drivers/bluetooth/hci_usb.h |    5 -----
 2 files changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/bluetooth/hci_usb.c~hci_usb-remove-code-obfuscation drivers/bluetooth/hci_usb.c
--- a/drivers/bluetooth/hci_usb.c~hci_usb-remove-code-obfuscation
+++ a/drivers/bluetooth/hci_usb.c
@@ -265,7 +265,7 @@ static int hci_usb_intr_rx_submit(struct
 		BT_ERR("%s intr rx submit failed urb %p err %d",
 				husb->hdev->name, urb, err);
 		_urb_unlink(_urb);
-		_urb_free(_urb);
+		kfree(_urb);
 		kfree(buf);
 	}
 	return err;
@@ -302,7 +302,7 @@ static int hci_usb_bulk_rx_submit(struct
 		BT_ERR("%s bulk rx submit failed urb %p err %d",
 				husb->hdev->name, urb, err);
 		_urb_unlink(_urb);
-		_urb_free(_urb);
+		kfree(_urb);
 		kfree(buf);
 	}
 	return err;
@@ -353,7 +353,7 @@ static int hci_usb_isoc_rx_submit(struct
 		BT_ERR("%s isoc rx submit failed urb %p err %d",
 				husb->hdev->name, urb, err);
 		_urb_unlink(_urb);
-		_urb_free(_urb);
+		kfree(_urb);
 		kfree(buf);
 	}
 	return err;
@@ -431,7 +431,7 @@ static void hci_usb_unlink_urbs(struct h
 					husb->hdev->name, _urb, _urb->type, urb);
 			kfree(urb->setup_packet);
 			kfree(urb->transfer_buffer);
-			_urb_free(_urb);
+			kfree(_urb);
 		}
 	}
 }
@@ -490,7 +490,7 @@ static inline int hci_usb_send_ctrl(stru
 
 		dr = kmalloc(sizeof(*dr), GFP_ATOMIC);
 		if (!dr) {
-			_urb_free(_urb);
+			kfree(_urb);
 			return -ENOMEM;
 		}
 	} else
diff -puN drivers/bluetooth/hci_usb.h~hci_usb-remove-code-obfuscation drivers/bluetooth/hci_usb.h
--- a/drivers/bluetooth/hci_usb.h~hci_usb-remove-code-obfuscation
+++ a/drivers/bluetooth/hci_usb.h
@@ -60,11 +60,6 @@ struct _urb {
 	struct urb        urb;
 };
 
-static inline void _urb_free(struct _urb *_urb)
-{
-	kfree(_urb);
-}
