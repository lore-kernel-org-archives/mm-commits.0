From: akpm@linux-foundation.org
Subject: - bluetooth-use-get-put_unaligned_-helpers.patch removed from -mm tree
Date: Mon, 05 May 2008 12:16:47 -0700
Message-ID: <200805051916.m45JGldY000327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759071AbYEETQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:16:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, hidave.darkstar@gmail.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     bluetooth: use get/put_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     bluetooth-use-get-put_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bluetooth: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/bnep/core.c |    8 ++++----
 net/bluetooth/hci_event.c |    9 ++++-----
 net/bluetooth/hci_sock.c  |    2 +-
 net/bluetooth/l2cap.c     |    2 +-
 4 files changed, 10 insertions(+), 11 deletions(-)

diff -puN net/bluetooth/bnep/core.c~bluetooth-use-get-put_unaligned_-helpers net/bluetooth/bnep/core.c
--- a/net/bluetooth/bnep/core.c~bluetooth-use-get-put_unaligned_-helpers
+++ a/net/bluetooth/bnep/core.c
@@ -135,7 +135,7 @@ static int bnep_ctrl_set_netfilter(struc
 	if (len < 2)
 		return -EILSEQ;
 
-	n = ntohs(get_unaligned(data));
+	n = get_unaligned_be16(data);
 	data++; len -= 2;
 
 	if (len < n)
@@ -150,8 +150,8 @@ static int bnep_ctrl_set_netfilter(struc
 		int i;
 
 		for (i = 0; i < n; i++) {
-			f[i].start = ntohs(get_unaligned(data++));
-			f[i].end   = ntohs(get_unaligned(data++));
+			f[i].start = get_unaligned_be16(data++);
+			f[i].end   = get_unaligned_be16(data++);
 
 			BT_DBG("proto filter start %d end %d",
 				f[i].start, f[i].end);
@@ -180,7 +180,7 @@ static int bnep_ctrl_set_mcfilter(struct
 	if (len < 2)
 		return -EILSEQ;
 
-	n = ntohs(get_unaligned((__be16 *) data));
+	n = get_unaligned_be16(data);
 	data += 2; len -= 2;
 
 	if (len < n)
diff -puN net/bluetooth/hci_event.c~bluetooth-use-get-put_unaligned_-helpers net/bluetooth/hci_event.c
--- a/net/bluetooth/hci_event.c~bluetooth-use-get-put_unaligned_-helpers
+++ a/net/bluetooth/hci_event.c
@@ -129,8 +129,7 @@ static void hci_cc_write_link_policy(str
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(rp->handle));
 	if (conn) {
-		__le16 policy = get_unaligned((__le16 *) (sent + 2));
-		conn->link_policy = __le16_to_cpu(policy);
+		conn->link_policy = get_unaligned_le16(sent + 2);
 	}
 
 	hci_dev_unlock(hdev);
@@ -313,7 +312,7 @@ static void hci_cc_write_voice_setting(s
 		return;
 
 	if (!status) {
-		__u16 setting = __le16_to_cpu(get_unaligned((__le16 *) sent));
+		__u16 setting = get_unaligned_le16(sent);
 
 		if (hdev->voice_setting != setting) {
 			hdev->voice_setting = setting;
@@ -1152,8 +1151,8 @@ static inline void hci_num_comp_pkts_evt
 		struct hci_conn *conn;
 		__u16  handle, count;
 
-		handle = __le16_to_cpu(get_unaligned(ptr++));
-		count  = __le16_to_cpu(get_unaligned(ptr++));
+		handle = get_unaligned_le16(ptr++);
+		count  = get_unaligned_le16(ptr++);
 
 		conn = hci_conn_hash_lookup_handle(hdev, handle);
 		if (conn) {
diff -puN net/bluetooth/hci_sock.c~bluetooth-use-get-put_unaligned_-helpers net/bluetooth/hci_sock.c
--- a/net/bluetooth/hci_sock.c~bluetooth-use-get-put_unaligned_-helpers
+++ a/net/bluetooth/hci_sock.c
@@ -440,7 +440,7 @@ static int hci_sock_sendmsg(struct kiocb
 	skb->dev = (void *) hdev;
 
 	if (bt_cb(skb)->pkt_type == HCI_COMMAND_PKT) {
-		u16 opcode = __le16_to_cpu(get_unaligned((__le16 *) skb->data));
+		u16 opcode = get_unaligned_le16(skb->data);
 		u16 ogf = hci_opcode_ogf(opcode);
 		u16 ocf = hci_opcode_ocf(opcode);
 
diff -puN net/bluetooth/l2cap.c~bluetooth-use-get-put_unaligned_-helpers net/bluetooth/l2cap.c
--- a/net/bluetooth/l2cap.c~bluetooth-use-get-put_unaligned_-helpers
+++ a/net/bluetooth/l2cap.c
@@ -1827,7 +1827,7 @@ static inline int l2cap_information_rsp(
 	del_timer(&conn->info_timer);
 
 	if (type == L2CAP_IT_FEAT_MASK)
-		conn->feat_mask = __le32_to_cpu(get_unaligned((__le32 *) rsp->data));
+		conn->feat_mask = get_unaligned_le32(rsp->data);
 
 	l2cap_conn_start(conn);
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
misc-fix-integer-as-null-pointer-warnings.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
block-use-get_unaligned_-helpers.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
usb-use-get_unaligned_-helpers.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
wireless-use-get-put_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch

