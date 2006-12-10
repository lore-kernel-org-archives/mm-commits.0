From: akpm@osdl.org
Subject: + hci-endianness-annotations.patch added to -mm tree
Date: Sun, 10 Dec 2006 12:01:12 -0800
Message-ID: <200612102001.kBAK1Cjl001658@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56355 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762482AbWLJUBW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 15:01:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, marcel@holtmann.org, viro@zeniv.linux.org.uk


The patch titled
     hci endianness annotations
has been added to the -mm tree.  Its filename is
     hci-endianness-annotations.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
config_computone-should-depend-on-isaeisapci.patch
appldata_mem-dependes-on-vm-counters.patch
uml-problems-with-linux-ioh.patch
missing-includes-in-hilkbd.patch
hci-endianness-annotations.patch
lockd-endianness-annotations-rebased.patch
slab-leaks3-default-y.patch

