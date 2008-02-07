From: akpm@linux-foundation.org
Subject: - fix-versus-precedence-in-various-places.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:20:21 -0800
Message-ID: <200802070020.m170K2dW006087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36658 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762140AbYBGAVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:21:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, adaplas@pol.net, davem@davemloft.net, jeff@garzik.org, jens.axboe@oracle.com, kkeil@suse.de, mark.fasheh@oracle.com, mchehab@infradead.org, petero2@telia.com, vir


The patch titled
     fix ! versus & precedence in various places
has been removed from the -mm tree.  Its filename was
     fix-versus-precedence-in-various-places.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix ! versus & precedence in various places
From: Alexey Dobriyan <adobriyan@gmail.com>

Fix various instances of

	if (!expr & mask)

which should probably have been

	if (!(expr & mask))

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Osterlund <petero2@telia.com>
Cc: Karsten Keil <kkeil@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/pt.c        |    2 +-
 drivers/block/pktcdvd.c          |    4 ++--
 drivers/isdn/act2000/module.c    |   22 +++++++++++-----------
 drivers/isdn/i4l/isdn_ttyfax.c   |    2 +-
 drivers/isdn/icn/icn.c           |   22 +++++++++++-----------
 drivers/isdn/isdnloop/isdnloop.c |   16 ++++++++--------
 drivers/video/i810/i810_main.c   |    2 +-
 drivers/video/sis/sis_main.c     |    2 +-
 8 files changed, 36 insertions(+), 36 deletions(-)

diff -puN drivers/block/paride/pt.c~fix-versus-precedence-in-various-places drivers/block/paride/pt.c
--- a/drivers/block/paride/pt.c~fix-versus-precedence-in-various-places
+++ a/drivers/block/paride/pt.c
@@ -660,7 +660,7 @@ static int pt_open(struct inode *inode, 
 	pt_identify(tape);
 
 	err = -ENODEV;
-	if (!tape->flags & PT_MEDIA)
+	if (!(tape->flags & PT_MEDIA))
 		goto out;
 
 	err = -EROFS;
diff -puN drivers/block/pktcdvd.c~fix-versus-precedence-in-various-places drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~fix-versus-precedence-in-various-places
+++ a/drivers/block/pktcdvd.c
@@ -2212,11 +2212,11 @@ static int pkt_media_speed(struct pktcdv
 		return ret;
 	}
 
-	if (!buf[6] & 0x40) {
+	if (!(buf[6] & 0x40)) {
 		printk(DRIVER_NAME": Disc type is not CD-RW\n");
 		return 1;
 	}
-	if (!buf[6] & 0x4) {
+	if (!(buf[6] & 0x4)) {
 		printk(DRIVER_NAME": A1 values on media are not valid, maybe not CDRW?\n");
 		return 1;
 	}
diff -puN drivers/isdn/act2000/module.c~fix-versus-precedence-in-various-places drivers/isdn/act2000/module.c
--- a/drivers/isdn/act2000/module.c~fix-versus-precedence-in-various-places
+++ a/drivers/isdn/act2000/module.c
@@ -310,7 +310,7 @@ act2000_command(act2000_card * card, isd
 			}
 			break;
 		case ISDN_CMD_DIAL:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			if (!(chan = find_channel(card, c->arg & 0x0f)))
 				break;
@@ -339,7 +339,7 @@ act2000_command(act2000_card * card, isd
 			}
 			return ret;
 		case ISDN_CMD_ACCEPTD:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			if (!(chan = find_channel(card, c->arg & 0x0f)))
 				break;
@@ -347,11 +347,11 @@ act2000_command(act2000_card * card, isd
 				actcapi_select_b2_protocol_req(card, chan);
 			return 0;
 		case ISDN_CMD_ACCEPTB:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			return 0;
 		case ISDN_CMD_HANGUP:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			if (!(chan = find_channel(card, c->arg & 0x0f)))
 				break;
@@ -366,7 +366,7 @@ act2000_command(act2000_card * card, isd
 			}
 			return 0;
 		case ISDN_CMD_SETEAZ:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			if (!(chan = find_channel(card, c->arg & 0x0f)))
 				break;
@@ -386,7 +386,7 @@ act2000_command(act2000_card * card, isd
 			actcapi_listen_req(card);
 			return 0;
 		case ISDN_CMD_CLREAZ:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			if (!(chan = find_channel(card, c->arg & 0x0f)))
 				break;
@@ -394,14 +394,14 @@ act2000_command(act2000_card * card, isd
 			actcapi_listen_req(card);
 			return 0;
 		case ISDN_CMD_SETL2:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			if (!(chan = find_channel(card, c->arg & 0x0f)))
 				break;
 			chan->l2prot = (c->arg >> 8);
 			return 0;
 		case ISDN_CMD_SETL3:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			if ((c->arg >> 8) != ISDN_PROTO_L3_TRANS) {
 				printk(KERN_WARNING "L3 protocol unknown\n");
@@ -524,7 +524,7 @@ if_writecmd(const u_char __user *buf, in
         act2000_card *card = act2000_findcard(id);
 
         if (card) {
-                if (!card->flags & ACT2000_FLAGS_RUNNING)
+                if (!(card->flags & ACT2000_FLAGS_RUNNING))
                         return -ENODEV;
                 return (len);
         }
@@ -539,7 +539,7 @@ if_readstatus(u_char __user * buf, int l
         act2000_card *card = act2000_findcard(id);
 	
         if (card) {
-                if (!card->flags & ACT2000_FLAGS_RUNNING)
+                if (!(card->flags & ACT2000_FLAGS_RUNNING))
                         return -ENODEV;
                 return (act2000_readstatus(buf, len, card));
         }
@@ -554,7 +554,7 @@ if_sendbuf(int id, int channel, int ack,
         act2000_card *card = act2000_findcard(id);
 	
         if (card) {
-                if (!card->flags & ACT2000_FLAGS_RUNNING)
+                if (!(card->flags & ACT2000_FLAGS_RUNNING))
                         return -ENODEV;
 		return (act2000_sendbuf(card, channel, ack, skb));
         }
diff -puN drivers/isdn/i4l/isdn_ttyfax.c~fix-versus-precedence-in-various-places drivers/isdn/i4l/isdn_ttyfax.c
--- a/drivers/isdn/i4l/isdn_ttyfax.c~fix-versus-precedence-in-various-places
+++ a/drivers/isdn/i4l/isdn_ttyfax.c
@@ -834,7 +834,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_inf
 		char *rp = &f->resolution;
 
 		p[0] += 2;
-		if (!info->faxonline & 1)	/* not outgoing connection */
+		if (!(info->faxonline & 1))	/* not outgoing connection */
 			PARSE_ERROR1;
 
 		for (i = 0; (((*p[0] >= '0') && (*p[0] <= '9')) || (*p[0] == ',')) && (i < 4); i++) {
diff -puN drivers/isdn/icn/icn.c~fix-versus-precedence-in-various-places drivers/isdn/icn/icn.c
--- a/drivers/isdn/icn/icn.c~fix-versus-precedence-in-various-places
+++ a/drivers/isdn/icn/icn.c
@@ -1302,7 +1302,7 @@ icn_command(isdn_ctrl * c, icn_card * ca
 			}
 			break;
 		case ISDN_CMD_DIAL:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			if (card->leased)
 				break;
@@ -1328,7 +1328,7 @@ icn_command(isdn_ctrl * c, icn_card * ca
 			}
 			break;
 		case ISDN_CMD_ACCEPTD:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			if (c->arg < ICN_BCH) {
 				a = c->arg + 1;
@@ -1348,7 +1348,7 @@ icn_command(isdn_ctrl * c, icn_card * ca
 			}
 			break;
 		case ISDN_CMD_ACCEPTB:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			if (c->arg < ICN_BCH) {
 				a = c->arg + 1;
@@ -1366,7 +1366,7 @@ icn_command(isdn_ctrl * c, icn_card * ca
 			}
 			break;
 		case ISDN_CMD_HANGUP:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			if (c->arg < ICN_BCH) {
 				a = c->arg + 1;
@@ -1375,7 +1375,7 @@ icn_command(isdn_ctrl * c, icn_card * ca
 			}
 			break;
 		case ISDN_CMD_SETEAZ:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			if (card->leased)
 				break;
@@ -1391,7 +1391,7 @@ icn_command(isdn_ctrl * c, icn_card * ca
 			}
 			break;
 		case ISDN_CMD_CLREAZ:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			if (card->leased)
 				break;
@@ -1405,7 +1405,7 @@ icn_command(isdn_ctrl * c, icn_card * ca
 			}
 			break;
 		case ISDN_CMD_SETL2:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			if ((c->arg & 255) < ICN_BCH) {
 				a = c->arg;
@@ -1424,7 +1424,7 @@ icn_command(isdn_ctrl * c, icn_card * ca
 			}
 			break;
 		case ISDN_CMD_SETL3:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			return 0;
 		default:
@@ -1471,7 +1471,7 @@ if_writecmd(const u_char __user *buf, in
 	icn_card *card = icn_findcard(id);
 
 	if (card) {
-		if (!card->flags & ICN_FLAGS_RUNNING)
+		if (!(card->flags & ICN_FLAGS_RUNNING))
 			return -ENODEV;
 		return (icn_writecmd(buf, len, 1, card));
 	}
@@ -1486,7 +1486,7 @@ if_readstatus(u_char __user *buf, int le
 	icn_card *card = icn_findcard(id);
 
 	if (card) {
-		if (!card->flags & ICN_FLAGS_RUNNING)
+		if (!(card->flags & ICN_FLAGS_RUNNING))
 			return -ENODEV;
 		return (icn_readstatus(buf, len, card));
 	}
@@ -1501,7 +1501,7 @@ if_sendbuf(int id, int channel, int ack,
 	icn_card *card = icn_findcard(id);
 
 	if (card) {
-		if (!card->flags & ICN_FLAGS_RUNNING)
+		if (!(card->flags & ICN_FLAGS_RUNNING))
 			return -ENODEV;
 		return (icn_sendbuf(channel, ack, skb, card));
 	}
diff -puN drivers/isdn/isdnloop/isdnloop.c~fix-versus-precedence-in-various-places drivers/isdn/isdnloop/isdnloop.c
--- a/drivers/isdn/isdnloop/isdnloop.c~fix-versus-precedence-in-various-places
+++ a/drivers/isdn/isdnloop/isdnloop.c
@@ -1184,7 +1184,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop
 			}
 			break;
 		case ISDN_CMD_DIAL:
-			if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+			if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 				return -ENODEV;
 			if (card->leased)
 				break;
@@ -1210,7 +1210,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop
 			}
 			break;
 		case ISDN_CMD_ACCEPTD:
-			if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+			if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 				return -ENODEV;
 			if (c->arg < ISDNLOOP_BCH) {
 				a = c->arg + 1;
@@ -1238,7 +1238,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop
 			}
 			break;
 		case ISDN_CMD_ACCEPTB:
-			if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+			if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 				return -ENODEV;
 			if (c->arg < ISDNLOOP_BCH) {
 				a = c->arg + 1;
@@ -1264,7 +1264,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop
 				i = isdnloop_writecmd(cbuf, strlen(cbuf), 0, card);
 				break;
 		case ISDN_CMD_HANGUP:
-				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+				if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 					return -ENODEV;
 				if (c->arg < ISDNLOOP_BCH) {
 					a = c->arg + 1;
@@ -1273,7 +1273,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop
 				}
 				break;
 		case ISDN_CMD_SETEAZ:
-				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+				if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 					return -ENODEV;
 				if (card->leased)
 					break;
@@ -1303,7 +1303,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop
 				}
 				break;
 		case ISDN_CMD_SETL2:
-				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+				if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 					return -ENODEV;
 				if ((c->arg & 255) < ISDNLOOP_BCH) {
 					a = c->arg;
@@ -1395,7 +1395,7 @@ if_readstatus(u_char __user *buf, int le
 	isdnloop_card *card = isdnloop_findcard(id);
 
 	if (card) {
-		if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+		if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 			return -ENODEV;
 		return (isdnloop_readstatus(buf, len, card));
 	}
@@ -1410,7 +1410,7 @@ if_sendbuf(int id, int channel, int ack,
 	isdnloop_card *card = isdnloop_findcard(id);
 
 	if (card) {
-		if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+		if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 			return -ENODEV;
 		/* ack request stored in skb scratch area */
 		*(skb->head) = ack;
diff -puN drivers/video/i810/i810_main.c~fix-versus-precedence-in-various-places drivers/video/i810/i810_main.c
--- a/drivers/video/i810/i810_main.c~fix-versus-precedence-in-various-places
+++ a/drivers/video/i810/i810_main.c
@@ -1476,7 +1476,7 @@ static int i810fb_cursor(struct fb_info 
 	struct i810fb_par *par = info->par;
 	u8 __iomem *mmio = par->mmio_start_virtual;
 
-	if (!par->dev_flags & LOCKUP)
+	if (!(par->dev_flags & LOCKUP))
 		return -ENXIO;
 
 	if (cursor->image.width > 64 || cursor->image.height > 64)
diff -puN drivers/video/sis/sis_main.c~fix-versus-precedence-in-various-places drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~fix-versus-precedence-in-various-places
+++ a/drivers/video/sis/sis_main.c
@@ -427,7 +427,7 @@ sisfb_interpret_edid(struct sisfb_monito
 
 	monitor->feature = buffer[0x18];
 
-	if(!buffer[0x14] & 0x80) {
+	if(!(buffer[0x14] & 0x80)) {
 		if(!(buffer[0x14] & 0x08)) {
 			printk(KERN_INFO
 				"sisfb: WARNING: Monitor does not support separate syncs\n");
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
