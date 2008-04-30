From: akpm@linux-foundation.org
Subject: - usb-use-get-put_unaligned_-helpers.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:30 -0700
Message-ID: <200804300549.m3U5nUCe030008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758958AbYD3FuY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dbrownell@users.sourceforge.net, gregkh@suse.de, stern@rowland.harvard.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     usb: use get/put_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     usb-use-get-put_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/ueagle-atm.c   |   48 ++++++++++++++-----------------
 drivers/usb/class/cdc-acm.c    |    2 -
 drivers/usb/gadget/goku_udc.c  |    2 -
 drivers/usb/gadget/rndis.c     |   40 +++++++++----------------
 drivers/usb/gadget/usbstring.c |    2 -
 drivers/usb/host/ehci-hub.c    |    2 -
 drivers/usb/host/ohci-hub.c    |    4 +-
 7 files changed, 44 insertions(+), 56 deletions(-)

diff -puN drivers/usb/atm/ueagle-atm.c~usb-use-get-put_unaligned_-helpers drivers/usb/atm/ueagle-atm.c
--- a/drivers/usb/atm/ueagle-atm.c~usb-use-get-put_unaligned_-helpers
+++ a/drivers/usb/atm/ueagle-atm.c
@@ -305,8 +305,6 @@ enum {
  */
 
 #define FW_GET_BYTE(p)	*((__u8 *) (p))
-#define FW_GET_WORD(p)	le16_to_cpu(get_unaligned((__le16 *) (p)))
-#define FW_GET_LONG(p)	le32_to_cpu(get_unaligned((__le32 *) (p)))
 
 #define FW_DIR "ueagle-atm/"
 #define NB_MODEM 4
@@ -621,7 +619,7 @@ static void uea_upload_pre_firmware(cons
 	if (size < 4)
 		goto err_fw_corrupted;
 
-	crc = FW_GET_LONG(pfw);
+	crc = get_unaligned_le32(pfw);
 	pfw += 4;
 	size -= 4;
 	if (crc32_be(0, pfw, size) != crc)
@@ -640,7 +638,7 @@ static void uea_upload_pre_firmware(cons
 
 	while (size > 3) {
 		u8 len = FW_GET_BYTE(pfw);
-		u16 add = FW_GET_WORD(pfw + 1);
+		u16 add = get_unaligned_le16(pfw + 1);
 
 		size -= len + 3;
 		if (size < 0)
@@ -738,7 +736,7 @@ static int check_dsp_e1(u8 *dsp, unsigne
 
 	for (i = 0; i < pagecount; i++) {
 
-		pageoffset = FW_GET_LONG(dsp + p);
+		pageoffset = get_unaligned_le32(dsp + p);
 		p += 4;
 
 		if (pageoffset == 0)
@@ -759,7 +757,7 @@ static int check_dsp_e1(u8 *dsp, unsigne
 				return 1;
 
 			pp += 2;	/* skip blockaddr */
-			blocksize = FW_GET_WORD(dsp + pp);
+			blocksize = get_unaligned_le16(dsp + pp);
 			pp += 2;
 
 			/* enough space for block data? */
@@ -928,7 +926,7 @@ static void uea_load_page_e1(struct work
 		goto bad1;
 
 	p += 4 * pageno;
-	pageoffset = FW_GET_LONG(p);
+	pageoffset = get_unaligned_le32(p);
 
 	if (pageoffset == 0)
 		goto bad1;
@@ -945,10 +943,10 @@ static void uea_load_page_e1(struct work
 	bi.wOvlOffset = cpu_to_le16(ovl | 0x8000);
 
 	for (i = 0; i < blockcount; i++) {
-		blockaddr = FW_GET_WORD(p);
+		blockaddr = get_unaligned_le16(p);
 		p += 2;
 
-		blocksize = FW_GET_WORD(p);
+		blocksize = get_unaligned_le16(p);
 		p += 2;
 
 		bi.wSize = cpu_to_le16(blocksize);
@@ -1152,9 +1150,9 @@ static int uea_cmv_e1(struct uea_softc *
 	cmv.bDirection = E1_HOSTTOMODEM;
 	cmv.bFunction = function;
 	cmv.wIndex = cpu_to_le16(sc->cmv_dsc.e1.idx);
-	put_unaligned(cpu_to_le32(address), &cmv.dwSymbolicAddress);
+	put_unaligned_le32(address, &cmv.dwSymbolicAddress);
 	cmv.wOffsetAddress = cpu_to_le16(offset);
-	put_unaligned(cpu_to_le32(data >> 16 | data << 16), &cmv.dwData);
+	put_unaligned_le32(data >> 16 | data << 16, &cmv.dwData);
 
 	ret = uea_request(sc, UEA_E1_SET_BLOCK, UEA_MPTX_START, sizeof(cmv), &cmv);
 	if (ret < 0)
@@ -1646,7 +1644,7 @@ static int request_cmvs(struct uea_softc
 	if (size < 5)
 		goto err_fw_corrupted;
 
-	crc = FW_GET_LONG(data);
+	crc = get_unaligned_le32(data);
 	data += 4;
 	size -= 4;
 	if (crc32_be(0, data, size) != crc)
@@ -1696,9 +1694,9 @@ static int uea_send_cmvs_e1(struct uea_s
 			"please update your firmware\n");
 
 		for (i = 0; i < len; i++) {
-			ret = uea_write_cmv_e1(sc, FW_GET_LONG(&cmvs_v1[i].address),
-						FW_GET_WORD(&cmvs_v1[i].offset),
-						FW_GET_LONG(&cmvs_v1[i].data));
+			ret = uea_write_cmv_e1(sc, get_unaligned_le32(&cmvs_v1[i].address),
+						get_unaligned_le16(&cmvs_v1[i].offset),
+						get_unaligned_le32(&cmvs_v1[i].data));
 			if (ret < 0)
 				goto out;
 		}
@@ -1706,9 +1704,9 @@ static int uea_send_cmvs_e1(struct uea_s
 		struct uea_cmvs_v2 *cmvs_v2 = cmvs_ptr;
 
 		for (i = 0; i < len; i++) {
-			ret = uea_write_cmv_e1(sc, FW_GET_LONG(&cmvs_v2[i].address),
-						(u16) FW_GET_LONG(&cmvs_v2[i].offset),
-						FW_GET_LONG(&cmvs_v2[i].data));
+			ret = uea_write_cmv_e1(sc, get_unaligned_le32(&cmvs_v2[i].address),
+						(u16) get_unaligned_le32(&cmvs_v2[i].offset),
+						get_unaligned_le32(&cmvs_v2[i].data));
 			if (ret < 0)
 				goto out;
 		}
@@ -1759,10 +1757,10 @@ static int uea_send_cmvs_e4(struct uea_s
 
 		for (i = 0; i < len; i++) {
 			ret = uea_write_cmv_e4(sc, 1,
-						FW_GET_LONG(&cmvs_v2[i].group),
-						FW_GET_LONG(&cmvs_v2[i].address),
-						FW_GET_LONG(&cmvs_v2[i].offset),
-						FW_GET_LONG(&cmvs_v2[i].data));
+						get_unaligned_le32(&cmvs_v2[i].group),
+						get_unaligned_le32(&cmvs_v2[i].address),
+						get_unaligned_le32(&cmvs_v2[i].offset),
+						get_unaligned_le32(&cmvs_v2[i].data));
 			if (ret < 0)
 				goto out;
 		}
@@ -1964,7 +1962,7 @@ static void uea_dispatch_cmv_e1(struct u
 		if (UEA_CHIP_VERSION(sc) == ADI930
 				&& cmv->bFunction ==  E1_MAKEFUNCTION(2, 2)) {
 			cmv->wIndex = cpu_to_le16(dsc->idx);
-			put_unaligned(cpu_to_le32(dsc->address), &cmv->dwSymbolicAddress);
+			put_unaligned_le32(dsc->address, &cmv->dwSymbolicAddress);
 			cmv->wOffsetAddress = cpu_to_le16(dsc->offset);
 		} else
 			goto bad2;
@@ -1978,11 +1976,11 @@ static void uea_dispatch_cmv_e1(struct u
 
 	/* in case of MEMACCESS */
 	if (le16_to_cpu(cmv->wIndex) != dsc->idx ||
-	    le32_to_cpu(get_unaligned(&cmv->dwSymbolicAddress)) != dsc->address ||
+	    get_unaligned_le32(&cmv->dwSymbolicAddress) != dsc->address ||
 	    le16_to_cpu(cmv->wOffsetAddress) != dsc->offset)
 		goto bad2;
 
-	sc->data = le32_to_cpu(get_unaligned(&cmv->dwData));
+	sc->data = get_unaligned_le32(&cmv->dwData);
 	sc->data = sc->data << 16 | sc->data >> 16;
 
 	wake_up_cmv_ack(sc);
diff -puN drivers/usb/class/cdc-acm.c~usb-use-get-put_unaligned_-helpers drivers/usb/class/cdc-acm.c
--- a/drivers/usb/class/cdc-acm.c~usb-use-get-put_unaligned_-helpers
+++ a/drivers/usb/class/cdc-acm.c
@@ -280,7 +280,7 @@ static void acm_ctrl_irq(struct urb *urb
 
 		case USB_CDC_NOTIFY_SERIAL_STATE:
 
-			newctrl = le16_to_cpu(get_unaligned((__le16 *) data));
+			newctrl = get_unaligned_le16(data);
 
 			if (acm->tty && !acm->clocal && (acm->ctrlin & ~newctrl & ACM_CTRL_DCD)) {
 				dbg("calling hangup");
diff -puN drivers/usb/gadget/goku_udc.c~usb-use-get-put_unaligned_-helpers drivers/usb/gadget/goku_udc.c
--- a/drivers/usb/gadget/goku_udc.c~usb-use-get-put_unaligned_-helpers
+++ a/drivers/usb/gadget/goku_udc.c
@@ -127,7 +127,7 @@ goku_ep_enable(struct usb_ep *_ep, const
 
 	/* enabling the no-toggle interrupt mode would need an api hook */
 	mode = 0;
-	max = le16_to_cpu(get_unaligned(&desc->wMaxPacketSize));
+	max = get_unaligned_le16(&desc->wMaxPacketSize);
 	switch (max) {
 	case 64:	mode++;
 	case 32:	mode++;
diff -puN drivers/usb/gadget/rndis.c~usb-use-get-put_unaligned_-helpers drivers/usb/gadget/rndis.c
--- a/drivers/usb/gadget/rndis.c~usb-use-get-put_unaligned_-helpers
+++ a/drivers/usb/gadget/rndis.c
@@ -183,14 +183,10 @@ gen_ndis_query_resp (int configNr, u32 O
 		DBG("query OID %08x value, len %d:\n", OID, buf_len);
 		for (i = 0; i < buf_len; i += 16) {
 			DBG("%03d: %08x %08x %08x %08x\n", i,
-				le32_to_cpu(get_unaligned((__le32 *)
-					&buf[i])),
-				le32_to_cpu(get_unaligned((__le32 *)
-					&buf[i + 4])),
-				le32_to_cpu(get_unaligned((__le32 *)
-					&buf[i + 8])),
-				le32_to_cpu(get_unaligned((__le32 *)
-					&buf[i + 12])));
+				get_unaligned_le32(&buf[i]),
+				get_unaligned_le32(&buf[i + 4]),
+				get_unaligned_le32(&buf[i + 8]),
+				get_unaligned_le32(&buf[i + 12]));
 		}
 	}
 
@@ -666,7 +662,7 @@ gen_ndis_query_resp (int configNr, u32 O
 		break;
 	case OID_PNP_QUERY_POWER:
 		DBG("%s: OID_PNP_QUERY_POWER D%d\n", __func__,
-				le32_to_cpu(get_unaligned((__le32 *)buf)) - 1);
+				get_unaligned_le32(buf) - 1);
 		/* only suspend is a real power state, and
 		 * it can't be entered by OID_PNP_SET_POWER...
 		 */
@@ -705,14 +701,10 @@ static int gen_ndis_set_resp (u8 configN
 		DBG("set OID %08x value, len %d:\n", OID, buf_len);
 		for (i = 0; i < buf_len; i += 16) {
 			DBG("%03d: %08x %08x %08x %08x\n", i,
-				le32_to_cpu(get_unaligned((__le32 *)
-					&buf[i])),
-				le32_to_cpu(get_unaligned((__le32 *)
-					&buf[i + 4])),
-				le32_to_cpu(get_unaligned((__le32 *)
-					&buf[i + 8])),
-				le32_to_cpu(get_unaligned((__le32 *)
-					&buf[i + 12])));
+				get_unaligned_le32(&buf[i]),
+				get_unaligned_le32(&buf[i + 4]),
+				get_unaligned_le32(&buf[i + 8]),
+				get_unaligned_le32(&buf[i + 12]));
 		}
 	}
 
@@ -726,8 +718,7 @@ static int gen_ndis_set_resp (u8 configN
 		 *	PROMISCUOUS, DIRECTED,
 		 *	MULTICAST, ALL_MULTICAST, BROADCAST
 		 */
-		*params->filter = (u16) le32_to_cpu(get_unaligned(
-				(__le32 *)buf));
+		*params->filter = (u16)get_unaligned_le32(buf);
 		DBG("%s: OID_GEN_CURRENT_PACKET_FILTER %08x\n",
 			__func__, *params->filter);
 
@@ -777,7 +768,7 @@ update_linkstate:
 		 * resuming, Windows forces a reset, and then SET_POWER D0.
 		 * FIXME ... then things go batty; Windows wedges itself.
 		 */
-		i = le32_to_cpu(get_unaligned((__le32 *)buf));
+		i = get_unaligned_le32(buf);
 		DBG("%s: OID_PNP_SET_POWER D%d\n", __func__, i - 1);
 		switch (i) {
 		case NdisDeviceStateD0:
@@ -1064,8 +1055,8 @@ int rndis_msg_parser (u8 configNr, u8 *b
 		return -ENOMEM;
 
 	tmp = (__le32 *) buf;
-	MsgType   = le32_to_cpu(get_unaligned(tmp++));
-	MsgLength = le32_to_cpu(get_unaligned(tmp++));
+	MsgType   = get_unaligned_le32(tmp++);
+	MsgLength = get_unaligned_le32(tmp++);
 
 	if (configNr >= RNDIS_MAX_CONFIGS)
 		return -ENOTSUPP;
@@ -1296,10 +1287,9 @@ int rndis_rm_hdr(struct sk_buff *skb)
 	tmp++;
 
 	/* DataOffset, DataLength */
-	if (!skb_pull(skb, le32_to_cpu(get_unaligned(tmp++))
-			+ 8 /* offset of DataOffset */))
+	if (!skb_pull(skb, get_unaligned_le32(tmp++) + 8))
 		return -EOVERFLOW;
-	skb_trim(skb, le32_to_cpu(get_unaligned(tmp++)));
+	skb_trim(skb, get_unaligned_le32(tmp++));
 
 	return 0;
 }
diff -puN drivers/usb/gadget/usbstring.c~usb-use-get-put_unaligned_-helpers drivers/usb/gadget/usbstring.c
--- a/drivers/usb/gadget/usbstring.c~usb-use-get-put_unaligned_-helpers
+++ a/drivers/usb/gadget/usbstring.c
@@ -74,7 +74,7 @@ static int utf8_to_utf16le(const char *s
 				goto fail;
 		} else
 			uchar = c;
-		put_unaligned (cpu_to_le16 (uchar), cp++);
+		put_unaligned_le16(uchar, cp++);
 		count++;
 		len--;
 	}
diff -puN drivers/usb/host/ehci-hub.c~usb-use-get-put_unaligned_-helpers drivers/usb/host/ehci-hub.c
--- a/drivers/usb/host/ehci-hub.c~usb-use-get-put_unaligned_-helpers
+++ a/drivers/usb/host/ehci-hub.c
@@ -770,7 +770,7 @@ static int ehci_hub_control (
 	if (status & ~0xffff)	/* only if wPortChange is interesting */
 #endif
 		dbg_port (ehci, "GetStatus", wIndex + 1, temp);
-		put_unaligned(cpu_to_le32 (status), (__le32 *) buf);
+		put_unaligned_le32(status, buf);
 		break;
 	case SetHubFeature:
 		switch (wValue) {
diff -puN drivers/usb/host/ohci-hub.c~usb-use-get-put_unaligned_-helpers drivers/usb/host/ohci-hub.c
--- a/drivers/usb/host/ohci-hub.c~usb-use-get-put_unaligned_-helpers
+++ a/drivers/usb/host/ohci-hub.c
@@ -736,14 +736,14 @@ static int ohci_hub_control (
 		break;
 	case GetHubStatus:
 		temp = roothub_status (ohci) & ~(RH_HS_CRWE | RH_HS_DRWE);
-		put_unaligned(cpu_to_le32 (temp), (__le32 *) buf);
+		put_unaligned_le32(temp, buf);
 		break;
 	case GetPortStatus:
 		if (!wIndex || wIndex > ports)
 			goto error;
 		wIndex--;
 		temp = roothub_portstatus (ohci, wIndex);
-		put_unaligned(cpu_to_le32 (temp), (__le32 *) buf);
+		put_unaligned_le32(temp, buf);
 
 #ifndef	OHCI_VERBOSE_DEBUG
 	if (*(u16*)(buf+2))	/* only if wPortChange is interesting */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

