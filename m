From: akpm@osdl.org
Subject: - hci-endianness-annotations.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:11:53 -0800
Message-ID: <200612140611.kBE6Br8o002054@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52248 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbWLNGMR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:12:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ftp.linux.org.uk, marcel@holtmann.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     hci endianness annotations
has been removed from the -mm tree.  Its filename was
     hci-endianness-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hci endianness annotations
From: Al Viro <viro@ftp.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/net/bluetooth/hci.h |    4 ++--
 net/bluetooth/hci_sock.c    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/net/bluetooth/hci.h~hci-endianness-annotations include/net/bluetooth/hci.h
--- a/include/net/bluetooth/hci.h~hci-endianness-annotations
+++ a/include/net/bluetooth/hci.h
@@ -739,13 +739,13 @@ struct sockaddr_hci {
 struct hci_filter {
 	unsigned long type_mask;
 	unsigned long event_mask[2];
-	__u16   opcode;
+	__le16   opcode;
 };
 
 struct hci_ufilter {
 	__u32   type_mask;
 	__u32   event_mask[2];
-	__u16   opcode;
+	__le16   opcode;
 };
 
 #define HCI_FLT_TYPE_BITS	31
diff -puN net/bluetooth/hci_sock.c~hci-endianness-annotations net/bluetooth/hci_sock.c
--- a/net/bluetooth/hci_sock.c~hci-endianness-annotations
+++ a/net/bluetooth/hci_sock.c
@@ -123,10 +123,10 @@ void hci_send_to_sock(struct hci_dev *hd
 			if (flt->opcode &&
 			    ((evt == HCI_EV_CMD_COMPLETE &&
 			      flt->opcode !=
-			      get_unaligned((__u16 *)(skb->data + 3))) ||
+			      get_unaligned((__le16 *)(skb->data + 3))) ||
 			     (evt == HCI_EV_CMD_STATUS &&
 			      flt->opcode !=
-			      get_unaligned((__u16 *)(skb->data + 4)))))
+			      get_unaligned((__le16 *)(skb->data + 4)))))
 				continue;
 		}
 
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

m68k-work-around-binutils-tokenizer-change.patch
slab-leaks3-default-y.patch

