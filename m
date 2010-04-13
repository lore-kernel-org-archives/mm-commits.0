From: akpm@linux-foundation.org
Subject: + input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better.patch added to -mm tree
Date: Tue, 13 Apr 2010 12:20:41 -0700
Message-ID: <201004131920.o3DJKhLN019757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857Ab0DMTUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Apr 2010 15:20:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damjan.jov@gmail.com, dtor@mail.ru, rubini@cvml.unipv.it


The patch titled
     input: handle bad parity PS/2 packets in mouse drivers better
has been added to the -mm tree.  Its filename is
     input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: handle bad parity PS/2 packets in mouse drivers better
From: Damjan Jovanovic <damjan.jov@gmail.com>

This fixes a regression introduced in Linux 2.6.2 where mice that
sporadically produce bad parity go crazy and start jumping around and
clicking randomly, which never happens in any version of Windows running
on the same hardware.  The bugzilla bug is
https://bugzilla.kernel.org/show_bug.cgi?id=6105

The patch works by always accumulating a full PS/2 packet, then ignoring
the packet if any byte had a bad checksum.  A month of testing it against
an affected mouse has revealed it works perfectly in practice.

Signed-off-by: Damjan Jovanovic <damjan.jov@gmail.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/alps.c         |   15 ++++++++++++---
 drivers/input/mouse/elantech.c     |    3 +++
 drivers/input/mouse/hgpk.c         |    3 ++-
 drivers/input/mouse/lifebook.c     |    6 ++++++
 drivers/input/mouse/logips2pp.c    |    3 +++
 drivers/input/mouse/psmouse-base.c |   15 +++++++++++++--
 drivers/input/mouse/psmouse.h      |    1 +
 drivers/input/mouse/sentelic.c     |    3 +++
 drivers/input/mouse/synaptics.c    |    3 +++
 drivers/input/mouse/touchkit_ps2.c |    3 +++
 10 files changed, 49 insertions(+), 6 deletions(-)

diff -puN drivers/input/mouse/alps.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better drivers/input/mouse/alps.c
--- a/drivers/input/mouse/alps.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better
+++ a/drivers/input/mouse/alps.c
@@ -380,10 +380,16 @@ static psmouse_ret_t alps_process_byte(s
 	struct alps_data *priv = psmouse->private;
 	const struct alps_model_info *model = priv->i;
 
+	if (psmouse->pktcnt == 1 && psmouse->badparity)
+		return PSMOUSE_BAD_DATA;
+
 	if ((psmouse->packet[0] & 0xc8) == 0x08) { /* PS/2 packet */
 		if (psmouse->pktcnt == 3) {
-			alps_report_bare_ps2_packet(psmouse, psmouse->packet,
-						    true);
+			if (psmouse->badparity) {
+				alps_report_bare_ps2_packet(psmouse,
+							    psmouse->packet,
+							    true);
+			}
 			return PSMOUSE_FULL_PACKET;
 		}
 		return PSMOUSE_GOOD_DATA;
@@ -393,6 +399,8 @@ static psmouse_ret_t alps_process_byte(s
 
 	if ((model->flags & ALPS_PS2_INTERLEAVED) &&
 	    psmouse->pktcnt >= 4 && (psmouse->packet[3] & 0x0f) == 0x0f) {
+		if (psmouse->badparity)
+			return PSMOUSE_BAD_DATA;
 		return alps_handle_interleaved_ps2(psmouse);
 	}
 
@@ -411,7 +419,8 @@ static psmouse_ret_t alps_process_byte(s
 	}
 
 	if (psmouse->pktcnt == 6) {
-		alps_process_packet(psmouse);
+		if (!psmouse->badparity)
+			alps_process_packet(psmouse);
 		return PSMOUSE_FULL_PACKET;
 	}
 
diff -puN drivers/input/mouse/elantech.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better drivers/input/mouse/elantech.c
--- a/drivers/input/mouse/elantech.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better
+++ a/drivers/input/mouse/elantech.c
@@ -325,6 +325,9 @@ static psmouse_ret_t elantech_process_by
 	if (psmouse->pktcnt < psmouse->pktsize)
 		return PSMOUSE_GOOD_DATA;
 
+	if (psmouse->pktcnt == psmouse->pktsize && psmouse->badparity)
+		return PSMOUSE_FULL_PACKET;
+
 	if (etd->debug > 1)
 		elantech_packet_dump(psmouse->packet, psmouse->pktsize);
 
diff -puN drivers/input/mouse/hgpk.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better drivers/input/mouse/hgpk.c
--- a/drivers/input/mouse/hgpk.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better
+++ a/drivers/input/mouse/hgpk.c
@@ -188,7 +188,8 @@ static psmouse_ret_t hgpk_process_byte(s
 	}
 
 	if (psmouse->pktcnt >= psmouse->pktsize) {
-		hgpk_process_packet(psmouse);
+		if (!psmouse->badparity)
+			hgpk_process_packet(psmouse);
 		return PSMOUSE_FULL_PACKET;
 	}
 
diff -puN drivers/input/mouse/lifebook.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better drivers/input/mouse/lifebook.c
--- a/drivers/input/mouse/lifebook.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better
+++ a/drivers/input/mouse/lifebook.c
@@ -139,6 +139,9 @@ static psmouse_ret_t lifebook_process_by
 	unsigned char *packet = psmouse->packet;
 	bool relative_packet = packet[0] & 0x08;
 
+	if (psmouse->pktcnt == 1 && psmouse->badparity)
+		return PSMOUSE_BAD_DATA;
+
 	if (relative_packet || !lifebook_use_6byte_proto) {
 		if (psmouse->pktcnt != 3)
 			return PSMOUSE_GOOD_DATA;
@@ -167,6 +170,9 @@ static psmouse_ret_t lifebook_process_by
 		}
 	}
 
+	if (psmouse->badparity)
+		return PSMOUSE_FULL_PACKET;
+
 	if (relative_packet) {
 		if (!dev2)
 			printk(KERN_WARNING "lifebook.c: got relative packet "
diff -puN drivers/input/mouse/logips2pp.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better drivers/input/mouse/logips2pp.c
--- a/drivers/input/mouse/logips2pp.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better
+++ a/drivers/input/mouse/logips2pp.c
@@ -51,6 +51,9 @@ static psmouse_ret_t ps2pp_process_byte(
  * Full packet accumulated, process it
  */
 
+	if (psmouse->badparity)
+		return PSMOUSE_FULL_PACKET;
+
 	if ((packet[0] & 0x48) == 0x48 && (packet[1] & 0x02) == 0x02) {
 
 		/* Logitech extended packet */
diff -puN drivers/input/mouse/psmouse-base.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better drivers/input/mouse/psmouse-base.c
--- a/drivers/input/mouse/psmouse-base.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better
+++ a/drivers/input/mouse/psmouse-base.c
@@ -133,6 +133,9 @@ static psmouse_ret_t psmouse_process_byt
  * Full packet accumulated, process it
  */
 
+	if (psmouse->badparity)
+		return PSMOUSE_FULL_PACKET;
+
 /*
  * Scroll wheel on IntelliMice, scroll buttons on NetMice
  */
@@ -217,6 +220,7 @@ void psmouse_queue_work(struct psmouse *
 static inline void __psmouse_set_state(struct psmouse *psmouse, enum psmouse_state new_state)
 {
 	psmouse->state = new_state;
+	psmouse->badparity = 0;
 	psmouse->pktcnt = psmouse->out_of_sync_cnt = 0;
 	psmouse->ps2dev.flags = 0;
 	psmouse->last = jiffies;
@@ -257,10 +261,12 @@ static int psmouse_handle_byte(struct ps
 					return -1;
 				}
 			}
+			psmouse->badparity = 0;
 			psmouse->pktcnt = 0;
 			break;
 
 		case PSMOUSE_FULL_PACKET:
+			psmouse->badparity = 0;
 			psmouse->pktcnt = 0;
 			if (psmouse->out_of_sync_cnt) {
 				psmouse->out_of_sync_cnt = 0;
@@ -270,6 +276,7 @@ static int psmouse_handle_byte(struct ps
 			break;
 
 		case PSMOUSE_GOOD_DATA:
+			psmouse->badparity = 0;
 			break;
 	}
 	return 0;
@@ -293,8 +300,12 @@ static irqreturn_t psmouse_interrupt(str
 			printk(KERN_WARNING "psmouse.c: bad data from KBC -%s%s\n",
 				flags & SERIO_TIMEOUT ? " timeout" : "",
 				flags & SERIO_PARITY ? " bad parity" : "");
-		ps2_cmd_aborted(&psmouse->ps2dev);
-		goto out;
+		if (flags & SERIO_TIMEOUT) {
+			ps2_cmd_aborted(&psmouse->ps2dev);
+			goto out;
+		} else {
+			psmouse->badparity = 1;
+		}
 	}
 
 	if (unlikely(psmouse->ps2dev.flags & PS2_FLAG_ACK))
diff -puN drivers/input/mouse/psmouse.h~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better drivers/input/mouse/psmouse.h
--- a/drivers/input/mouse/psmouse.h~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better
+++ a/drivers/input/mouse/psmouse.h
@@ -43,6 +43,7 @@ struct psmouse {
 	char *vendor;
 	char *name;
 	unsigned char packet[8];
+	int badparity;
 	unsigned char badbyte;
 	unsigned char pktcnt;
 	unsigned char pktsize;
diff -puN drivers/input/mouse/sentelic.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better drivers/input/mouse/sentelic.c
--- a/drivers/input/mouse/sentelic.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better
+++ a/drivers/input/mouse/sentelic.c
@@ -638,6 +638,9 @@ static psmouse_ret_t fsp_process_byte(st
 	 * Full packet accumulated, process it
 	 */
 
+	if (psmouse->badparity)
+		return PSMOUSE_FULL_PACKET;
+
 	switch (psmouse->packet[0] >> FSP_PKT_TYPE_SHIFT) {
 	case FSP_PKT_TYPE_ABS:
 		dev_warn(&psmouse->ps2dev.serio->dev,
diff -puN drivers/input/mouse/synaptics.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better drivers/input/mouse/synaptics.c
--- a/drivers/input/mouse/synaptics.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better
+++ a/drivers/input/mouse/synaptics.c
@@ -535,6 +535,9 @@ static psmouse_ret_t synaptics_process_b
 	struct synaptics_data *priv = psmouse->private;
 
 	if (psmouse->pktcnt >= 6) { /* Full packet received */
+		if (psmouse->badparity)
+			return PSMOUSE_FULL_PACKET;
+
 		if (unlikely(priv->pkt_type == SYN_NEWABS))
 			priv->pkt_type = synaptics_detect_pkt_type(psmouse);
 
diff -puN drivers/input/mouse/touchkit_ps2.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better drivers/input/mouse/touchkit_ps2.c
--- a/drivers/input/mouse/touchkit_ps2.c~input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better
+++ a/drivers/input/mouse/touchkit_ps2.c
@@ -58,6 +58,9 @@ static psmouse_ret_t touchkit_ps2_proces
 	if (psmouse->pktcnt != 5)
 		return PSMOUSE_GOOD_DATA;
 
+	if (psmouse->badparity)
+		return PSMOUSE_FULL_PACKET;
+
 	input_report_abs(dev, ABS_X, TOUCHKIT_GET_X(packet));
 	input_report_abs(dev, ABS_Y, TOUCHKIT_GET_Y(packet));
 	input_report_key(dev, BTN_TOUCH, TOUCHKIT_GET_TOUCHED(packet));
_

Patches currently in -mm which might be from damjan.jov@gmail.com are

input-handle-bad-parity-ps-2-packets-in-mouse-drivers-better.patch

