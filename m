From: akpm@linux-foundation.org
Subject: + fix-versus-precedence-in-various-places.patch added to -mm tree
Date: Mon, 22 Oct 2007 15:20:29 -0700
Message-ID: <200710222220.l9MMKXwE018838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33717 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbXJVWYc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 18:24:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, adaplas@pol.net, davem@davemloft.net, jeff@garzik.org, jens.axboe@oracle.com, kkeil@suse.de, linville@tuxdriver.com, mark.fasheh@oracle.com, mchehab@infradead.org, petero2@telia.com, viro@zeniv.linux.org.uk


The patch titled
     fix ! versus & precedence in various places
has been added to the -mm tree.  Its filename is
     fix-versus-precedence-in-various-places.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/pt.c                    |    2 -
 drivers/block/pktcdvd.c                      |    4 +--
 drivers/isdn/act2000/module.c                |   22 ++++++++---------
 drivers/isdn/i4l/isdn_ttyfax.c               |    2 -
 drivers/isdn/icn/icn.c                       |   22 ++++++++---------
 drivers/isdn/isdnloop/isdnloop.c             |   16 ++++++------
 drivers/media/video/pvrusb2/pvrusb2-ctrl.c   |    2 -
 drivers/net/wireless/airo.c                  |    2 -
 drivers/net/wireless/atmel.c                 |    2 -
 drivers/net/wireless/prism54/isl_ioctl.c     |    4 +--
 drivers/net/wireless/zd1211rw/zd_rf_uw2453.c |    2 -
 drivers/video/i810/i810_main.c               |    2 -
 drivers/video/sis/sis_main.c                 |    2 -
 fs/ocfs2/alloc.c                             |    2 -
 net/ieee80211/ieee80211_wx.c                 |    2 -
 15 files changed, 44 insertions(+), 44 deletions(-)

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
@@ -2200,11 +2200,11 @@ static int pkt_media_speed(struct pktcdv
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
diff -puN drivers/media/video/pvrusb2/pvrusb2-ctrl.c~fix-versus-precedence-in-various-places drivers/media/video/pvrusb2/pvrusb2-ctrl.c
--- a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c~fix-versus-precedence-in-various-places
+++ a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
@@ -410,7 +410,7 @@ static int parse_mtoken(const char *ptr,
 	int msk;
 	*valptr = 0;
 	for (idx = 0, msk = 1; valid_bits; idx++, msk <<= 1) {
-		if (!msk & valid_bits) continue;
+		if (!(msk & valid_bits)) continue;
 		valid_bits &= ~msk;
 		if (!names[idx]) continue;
 		slen = strlen(names[idx]);
diff -puN drivers/net/wireless/airo.c~fix-versus-precedence-in-various-places drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~fix-versus-precedence-in-various-places
+++ a/drivers/net/wireless/airo.c
@@ -6407,7 +6407,7 @@ static int airo_set_encode(struct net_de
 			set_wep_key(local, index, NULL, 0, perm, 1);
 		} else
 			/* Don't complain if only change the mode */
-			if(!dwrq->flags & IW_ENCODE_MODE) {
+			if(!(dwrq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 			}
 	}
diff -puN drivers/net/wireless/atmel.c~fix-versus-precedence-in-various-places drivers/net/wireless/atmel.c
--- a/drivers/net/wireless/atmel.c~fix-versus-precedence-in-various-places
+++ a/drivers/net/wireless/atmel.c
@@ -1759,7 +1759,7 @@ static int atmel_set_encode(struct net_d
 			priv->default_key = index;
 		} else
 			/* Don't complain if only change the mode */
-			if (!dwrq->flags & IW_ENCODE_MODE) {
+			if (!(dwrq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 			}
 	}
diff -puN drivers/net/wireless/prism54/isl_ioctl.c~fix-versus-precedence-in-various-places drivers/net/wireless/prism54/isl_ioctl.c
--- a/drivers/net/wireless/prism54/isl_ioctl.c~fix-versus-precedence-in-various-places
+++ a/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1118,7 +1118,7 @@ prism54_set_encode(struct net_device *nd
 			    mgt_set_request(priv, DOT11_OID_DEFKEYID, 0,
 					    &index);
 		} else {
-			if (!dwrq->flags & IW_ENCODE_MODE) {
+			if (!(dwrq->flags & IW_ENCODE_MODE)) {
 				/* we cannot do anything. Complain. */
 				return -EINVAL;
 			}
@@ -2610,7 +2610,7 @@ prism2_ioctl_set_encryption(struct net_d
 			    mgt_set_request(priv, DOT11_OID_DEFKEYID, 0,
 					    &index);
 		} else {
-			if (!param->u.crypt.flags & IW_ENCODE_MODE) {
+			if (!(param->u.crypt.flags & IW_ENCODE_MODE)) {
 				/* we cannot do anything. Complain. */
 				return -EINVAL;
 			}
diff -puN drivers/net/wireless/zd1211rw/zd_rf_uw2453.c~fix-versus-precedence-in-various-places drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
--- a/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c~fix-versus-precedence-in-various-places
+++ a/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
@@ -403,7 +403,7 @@ static int uw2453_init_hw(struct zd_rf *
 		if (r)
 			return r;
 
-		if (!intr_status & 0xf) {
+		if (!(intr_status & 0xf)) {
 			dev_dbg_f(zd_chip_dev(chip),
 				"PLL locked on configuration %d\n", i);
 			found_config = i;
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
diff -puN fs/ocfs2/alloc.c~fix-versus-precedence-in-various-places fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~fix-versus-precedence-in-various-places
+++ a/fs/ocfs2/alloc.c
@@ -3946,7 +3946,7 @@ static int __ocfs2_mark_extent_written(s
 	struct ocfs2_merge_ctxt ctxt;
 	struct ocfs2_extent_list *rightmost_el;
 
-	if (!rec->e_flags & OCFS2_EXT_UNWRITTEN) {
+	if (!(rec->e_flags & OCFS2_EXT_UNWRITTEN)) {
 		ret = -EIO;
 		mlog_errno(ret);
 		goto out;
diff -puN net/ieee80211/ieee80211_wx.c~fix-versus-precedence-in-various-places net/ieee80211/ieee80211_wx.c
--- a/net/ieee80211/ieee80211_wx.c~fix-versus-precedence-in-various-places
+++ a/net/ieee80211/ieee80211_wx.c
@@ -709,7 +709,7 @@ int ieee80211_wx_get_encodeext(struct ie
 	} else
 		idx = ieee->tx_keyidx;
 
-	if (!ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY &&
+	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) &&
 	    ext->alg != IW_ENCODE_ALG_WEP)
 		if (idx != 0 || ieee->iw_mode != IW_MODE_INFRA)
 			return -EINVAL;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
fix-versus-precedence-in-various-places.patch
