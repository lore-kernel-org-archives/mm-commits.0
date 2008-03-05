From: akpm@linux-foundation.org
Subject: + isdn-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 14:38:17 -0800
Message-ID: <200803052238.m25McIu3024843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755689AbYCEWjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 17:39:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, kkeil@suse.de


The patch titled
     isdn: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     isdn-replace-remaining-__function__-occurrences.patch

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
Subject: isdn: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capidrv.c         |    4 +--
 drivers/isdn/capi/capilib.c         |    2 -
 drivers/isdn/capi/kcapi.c           |    4 +--
 drivers/isdn/capi/kcapi.h           |    2 -
 drivers/isdn/hisax/asuscom.c        |    2 -
 drivers/isdn/hisax/avm_pci.c        |    2 -
 drivers/isdn/hisax/diva.c           |    2 -
 drivers/isdn/hisax/elsa.c           |    2 -
 drivers/isdn/hisax/hfc_sx.c         |    2 -
 drivers/isdn/hisax/hfc_usb.c        |    6 ++--
 drivers/isdn/hisax/hfcscard.c       |    2 -
 drivers/isdn/hisax/hisax_debug.h    |    6 ++--
 drivers/isdn/hisax/hisax_fcpcipnp.c |    2 -
 drivers/isdn/hisax/ix1_micro.c      |    2 -
 drivers/isdn/hisax/niccy.c          |    2 -
 drivers/isdn/hisax/sedlbauer.c      |    2 -
 drivers/isdn/hisax/st5481.h         |   10 ++++----
 drivers/isdn/hisax/teles3.c         |    2 -
 drivers/isdn/i4l/isdn_common.c      |    2 -
 drivers/isdn/i4l/isdn_net.h         |    6 ++--
 drivers/isdn/i4l/isdn_ppp.c         |   32 +++++++++++++-------------
 drivers/isdn/i4l/isdn_tty.c         |    6 ++--
 22 files changed, 51 insertions(+), 51 deletions(-)

diff -puN drivers/isdn/capi/capidrv.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/capi/capidrv.c
--- a/drivers/isdn/capi/capidrv.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/capi/capidrv.c
@@ -1388,12 +1388,12 @@ static void capidrv_recv_message(struct 
 		_cdebbuf *cdb = capi_cmsg2str(&s_cmsg);
 
 		if (cdb) {
-			printk(KERN_DEBUG "%s: applid=%d %s\n", __FUNCTION__,
+			printk(KERN_DEBUG "%s: applid=%d %s\n", __func__,
 				ap->applid, cdb->buf);
 			cdebbuf_free(cdb);
 		} else
 			printk(KERN_DEBUG "%s: applid=%d %s not traced\n",
-				__FUNCTION__, ap->applid,
+				__func__, ap->applid,
 				capi_cmd2str(s_cmsg.Command, s_cmsg.Subcommand));
 	}
 	if (s_cmsg.Command == CAPI_DATA_B3
diff -puN drivers/isdn/capi/capilib.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/capi/capilib.c
--- a/drivers/isdn/capi/capilib.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/capi/capilib.c
@@ -4,7 +4,7 @@
 #include <linux/isdn/capilli.h>
 
 #define DBG(format, arg...) do { \
-printk(KERN_DEBUG "%s: " format "\n" , __FUNCTION__ , ## arg); \
+printk(KERN_DEBUG "%s: " format "\n" , __func__ , ## arg); \
 } while (0)
 
 struct capilib_msgidqueue {
diff -puN drivers/isdn/capi/kcapi.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/capi/kcapi.c
--- a/drivers/isdn/capi/kcapi.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/capi/kcapi.c
@@ -154,7 +154,7 @@ static void register_appl(struct capi_ct
 	if (card)
 		card->register_appl(card, applid, rparam);
 	else
-		printk(KERN_WARNING "%s: cannot get card resources\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: cannot get card resources\n", __func__);
 }
 
 
@@ -178,7 +178,7 @@ static void notify_up(u32 contr)
 	        printk(KERN_DEBUG "kcapi: notify up contr %d\n", contr);
 	}
 	if (!card) {
-		printk(KERN_WARNING "%s: invalid contr %d\n", __FUNCTION__, contr);
+		printk(KERN_WARNING "%s: invalid contr %d\n", __func__, contr);
 		return;
 	}
 	for (applid = 1; applid <= CAPI_MAXAPPL; applid++) {
diff -puN drivers/isdn/capi/kcapi.h~isdn-replace-remaining-__function__-occurrences drivers/isdn/capi/kcapi.h
--- a/drivers/isdn/capi/kcapi.h~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/capi/kcapi.h
@@ -17,7 +17,7 @@
 
 #ifdef KCAPI_DEBUG
 #define DBG(format, arg...) do { \
-printk(KERN_DEBUG "%s: " format "\n" , __FUNCTION__ , ## arg); \
+printk(KERN_DEBUG "%s: " format "\n" , __func__ , ## arg); \
 } while (0)
 #else
 #define DBG(format, arg...) /* */
diff -puN drivers/isdn/hisax/asuscom.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/hisax/asuscom.c
--- a/drivers/isdn/hisax/asuscom.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/hisax/asuscom.c
@@ -346,7 +346,7 @@ setup_asuscom(struct IsdnCard *card)
 					err = pnp_activate_dev(pnp_d);
 					if (err<0) {
 						printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-							__FUNCTION__, err);
+							__func__, err);
 						return(0);
 					}
 					card->para[1] = pnp_port_start(pnp_d, 0);
diff -puN drivers/isdn/hisax/avm_pci.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/hisax/avm_pci.c
--- a/drivers/isdn/hisax/avm_pci.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/hisax/avm_pci.c
@@ -797,7 +797,7 @@ static int __devinit avm_pnp_setup(struc
 			err = pnp_activate_dev(pnp_avm_d);
 			if (err<0) {
 				printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-					__FUNCTION__, err);
+					__func__, err);
 				return(0);
 			}
 			cs->hw.avm.cfg_reg =
diff -puN drivers/isdn/hisax/diva.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/hisax/diva.c
--- a/drivers/isdn/hisax/diva.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/hisax/diva.c
@@ -1088,7 +1088,7 @@ static int __devinit setup_diva_isapnp(s
 				err = pnp_activate_dev(pnp_d);
 				if (err<0) {
 					printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-						__FUNCTION__, err);
+						__func__, err);
 					return(0);
 				}
 				card->para[1] = pnp_port_start(pnp_d, 0);
diff -puN drivers/isdn/hisax/elsa.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/hisax/elsa.c
--- a/drivers/isdn/hisax/elsa.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/hisax/elsa.c
@@ -937,7 +937,7 @@ setup_elsa_isapnp(struct IsdnCard *card)
 					err = pnp_activate_dev(pnp_d);
 					if (err<0) {
 						printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-							__FUNCTION__, err);
+							__func__, err);
 						return(0);
 					}
 					card->para[1] = pnp_port_start(pnp_d, 0);
diff -puN drivers/isdn/hisax/hfc_sx.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/hisax/hfc_sx.c
--- a/drivers/isdn/hisax/hfc_sx.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/hisax/hfc_sx.c
@@ -1419,7 +1419,7 @@ setup_hfcsx(struct IsdnCard *card)
 					err = pnp_activate_dev(pnp_d);
 					if (err<0) {
 						printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-							__FUNCTION__, err);
+							__func__, err);
 						return(0);
 					}
 					card->para[1] = pnp_port_start(pnp_d, 0);
diff -puN drivers/isdn/hisax/hfc_usb.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/hisax/hfc_usb.c
--- a/drivers/isdn/hisax/hfc_usb.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/hisax/hfc_usb.c
@@ -905,7 +905,7 @@ rx_int_complete(struct urb *urb)
 	if (status) {
 		printk(KERN_INFO
 		       "HFC-S USB: %s error resubmitting URB fifo(%d)\n",
-		       __FUNCTION__, fifon);
+		       __func__, fifon);
 	}
 }
 
@@ -1543,14 +1543,14 @@ hfc_usb_disconnect(struct usb_interface 
 				stop_isoc_chain(&context->fifos[i]);
 				DBG(HFCUSB_DBG_INIT,
 				    "HFC-S USB: %s stopping ISOC chain Fifo(%i)",
-				    __FUNCTION__, i);
+				    __func__, i);
 			}
 		} else {
 			if (context->fifos[i].active > 0) {
 				context->fifos[i].active = 0;
 				DBG(HFCUSB_DBG_INIT,
 				    "HFC-S USB: %s unlinking URB for Fifo(%i)",
-				    __FUNCTION__, i);
+				    __func__, i);
 			}
 			usb_kill_urb(context->fifos[i].urb);
 			usb_free_urb(context->fifos[i].urb);
diff -puN drivers/isdn/hisax/hfcscard.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/hisax/hfcscard.c
--- a/drivers/isdn/hisax/hfcscard.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/hisax/hfcscard.c
@@ -193,7 +193,7 @@ setup_hfcs(struct IsdnCard *card)
 					err = pnp_activate_dev(pnp_d);
 					if (err<0) {
 						printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-							__FUNCTION__, err);
+							__func__, err);
 						return(0);
 					}
 					card->para[1] = pnp_port_start(pnp_d, 0);
diff -puN drivers/isdn/hisax/hisax_debug.h~isdn-replace-remaining-__function__-occurrences drivers/isdn/hisax/hisax_debug.h
--- a/drivers/isdn/hisax/hisax_debug.h~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/hisax/hisax_debug.h
@@ -27,14 +27,14 @@
 
 #define DBG(level, format, arg...) do { \
 if (level & __debug_variable) \
-printk(KERN_DEBUG "%s: " format "\n" , __FUNCTION__ , ## arg); \
+printk(KERN_DEBUG "%s: " format "\n" , __func__ , ## arg); \
 } while (0)
 
 #define DBG_PACKET(level,data,count) \
-  if (level & __debug_variable) dump_packet(__FUNCTION__,data,count)
+  if (level & __debug_variable) dump_packet(__func__,data,count)
 
 #define DBG_SKB(level,skb) \
-  if ((level & __debug_variable) && skb) dump_packet(__FUNCTION__,skb->data,skb->len)
+  if ((level & __debug_variable) && skb) dump_packet(__func__,skb->data,skb->len)
 
 
 static void __attribute__((unused))
diff -puN drivers/isdn/hisax/hisax_fcpcipnp.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/hisax/hisax_fcpcipnp.c
--- a/drivers/isdn/hisax/hisax_fcpcipnp.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/hisax/hisax_fcpcipnp.c
@@ -935,7 +935,7 @@ static int __devinit fcpnp_probe(struct 
 	pnp_disable_dev(pdev);
 	retval = pnp_activate_dev(pdev);
 	if (retval < 0) {
-		printk(KERN_WARNING "%s: pnp_activate_dev(%s) ret(%d)\n", __FUNCTION__,
+		printk(KERN_WARNING "%s: pnp_activate_dev(%s) ret(%d)\n", __func__,
 			(char *)dev_id->driver_data, retval);
 		goto err_free;
 	}
diff -puN drivers/isdn/hisax/ix1_micro.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/hisax/ix1_micro.c
--- a/drivers/isdn/hisax/ix1_micro.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/hisax/ix1_micro.c
@@ -253,7 +253,7 @@ setup_ix1micro(struct IsdnCard *card)
 					err = pnp_activate_dev(pnp_d);
 					if (err<0) {
 						printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-							__FUNCTION__, err);
+							__func__, err);
 						return(0);
 					}
 					card->para[1] = pnp_port_start(pnp_d, 0);
diff -puN drivers/isdn/hisax/niccy.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/hisax/niccy.c
--- a/drivers/isdn/hisax/niccy.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/hisax/niccy.c
@@ -256,7 +256,7 @@ int __devinit setup_niccy(struct IsdnCar
 			err = pnp_activate_dev(pnp_d);
 			if (err < 0) {
 				printk(KERN_WARNING "%s: pnp_activate_dev "
-					"ret(%d)\n", __FUNCTION__, err);
+					"ret(%d)\n", __func__, err);
 				return 0;
 			}
 			card->para[1] = pnp_port_start(pnp_d, 0);
diff -puN drivers/isdn/hisax/sedlbauer.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/hisax/sedlbauer.c
--- a/drivers/isdn/hisax/sedlbauer.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/hisax/sedlbauer.c
@@ -555,7 +555,7 @@ setup_sedlbauer_isapnp(struct IsdnCard *
 				err = pnp_activate_dev(pnp_d);
 				if (err<0) {
 					printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-						__FUNCTION__, err);
+						__func__, err);
 					return(0);
 				}
 				card->para[1] = pnp_port_start(pnp_d, 0);
diff -puN drivers/isdn/hisax/st5481.h~isdn-replace-remaining-__function__-occurrences drivers/isdn/hisax/st5481.h
--- a/drivers/isdn/hisax/st5481.h~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/hisax/st5481.h
@@ -218,13 +218,13 @@ enum {
 #define L1_EVENT_COUNT (EV_TIMER3 + 1)
 
 #define ERR(format, arg...) \
-printk(KERN_ERR "%s:%s: " format "\n" , __FILE__,  __FUNCTION__ , ## arg)
+printk(KERN_ERR "%s:%s: " format "\n" , __FILE__,  __func__ , ## arg)
 
 #define WARN(format, arg...) \
-printk(KERN_WARNING "%s:%s: " format "\n" , __FILE__,  __FUNCTION__ , ## arg)
+printk(KERN_WARNING "%s:%s: " format "\n" , __FILE__,  __func__ , ## arg)
 
 #define INFO(format, arg...) \
-printk(KERN_INFO "%s:%s: " format "\n" , __FILE__,  __FUNCTION__ , ## arg)
+printk(KERN_INFO "%s:%s: " format "\n" , __FILE__,  __func__ , ## arg)
 
 #include "isdnhdlc.h"
 #include "fsm.h"
@@ -406,7 +406,7 @@ struct st5481_adapter {
 
 /*
  * Submit an URB with error reporting. This is a macro so
- * the __FUNCTION__ returns the caller function name.
+ * the __func__ returns the caller function name.
  */
 #define SUBMIT_URB(urb, mem_flags) \
 ({ \
@@ -470,7 +470,7 @@ extern int st5481_debug;
 #ifdef CONFIG_HISAX_DEBUG
 
 #define DBG_ISO_PACKET(level,urb) \
-  if (level & __debug_variable) dump_iso_packet(__FUNCTION__,urb)
+  if (level & __debug_variable) dump_iso_packet(__func__,urb)
 
 static void __attribute__((unused))
 dump_iso_packet(const char *name, struct urb *urb)
diff -puN drivers/isdn/hisax/teles3.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/hisax/teles3.c
--- a/drivers/isdn/hisax/teles3.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/hisax/teles3.c
@@ -301,7 +301,7 @@ setup_teles3(struct IsdnCard *card)
 					err = pnp_activate_dev(pnp_d);
 					if (err<0) {
 						printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-							__FUNCTION__, err);
+							__func__, err);
 						return(0);
 					}
 					card->para[3] = pnp_port_start(pnp_d, 2);
diff -puN drivers/isdn/i4l/isdn_common.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/i4l/isdn_common.c
--- a/drivers/isdn/i4l/isdn_common.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/i4l/isdn_common.c
@@ -1924,7 +1924,7 @@ isdn_free_channel(int di, int ch, int us
 
 	if ((di < 0) || (ch < 0)) {
 		printk(KERN_WARNING "%s: called with invalid drv(%d) or channel(%d)\n",
-			__FUNCTION__, di, ch);
+			__func__, di, ch);
 		return;
 	}
 	for (i = 0; i < ISDN_MAX_CHANNELS; i++)
diff -puN drivers/isdn/i4l/isdn_net.h~isdn-replace-remaining-__function__-occurrences drivers/isdn/i4l/isdn_net.h
--- a/drivers/isdn/i4l/isdn_net.h~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/i4l/isdn_net.h
@@ -108,7 +108,7 @@ static __inline__ void isdn_net_add_to_b
 
 	lp = nd->queue;
 //	printk(KERN_DEBUG "%s: lp:%s(%p) nlp:%s(%p) last(%p)\n",
-//		__FUNCTION__, lp->name, lp, nlp->name, nlp, lp->last);
+//		__func__, lp->name, lp, nlp->name, nlp, lp->last);
 	nlp->last = lp->last;
 	lp->last->next = nlp;
 	lp->last = nlp;
@@ -129,7 +129,7 @@ static __inline__ void isdn_net_rm_from_
 		master_lp = (isdn_net_local *) lp->master->priv;
 
 //	printk(KERN_DEBUG "%s: lp:%s(%p) mlp:%s(%p) last(%p) next(%p) mndq(%p)\n",
-//		__FUNCTION__, lp->name, lp, master_lp->name, master_lp, lp->last, lp->next, master_lp->netdev->queue);
+//		__func__, lp->name, lp, master_lp->name, master_lp, lp->last, lp->next, master_lp->netdev->queue);
 	spin_lock_irqsave(&master_lp->netdev->queue_lock, flags);
 	lp->last->next = lp->next;
 	lp->next->last = lp->last;
@@ -141,7 +141,7 @@ static __inline__ void isdn_net_rm_from_
 	}
 	lp->next = lp->last = lp;	/* (re)set own pointers */
 //	printk(KERN_DEBUG "%s: mndq(%p)\n",
-//		__FUNCTION__, master_lp->netdev->queue);
+//		__func__, master_lp->netdev->queue);
 	spin_unlock_irqrestore(&master_lp->netdev->queue_lock, flags);
 }
 
diff -puN drivers/isdn/i4l/isdn_ppp.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/i4l/isdn_ppp.c
--- a/drivers/isdn/i4l/isdn_ppp.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/i4l/isdn_ppp.c
@@ -110,7 +110,7 @@ isdn_ppp_free(isdn_net_local * lp)
 
 	if (lp->ppp_slot < 0 || lp->ppp_slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: ppp_slot(%d) out of range\n",
-			__FUNCTION__, lp->ppp_slot);
+			__func__, lp->ppp_slot);
 		return 0;
 	}
 
@@ -127,7 +127,7 @@ isdn_ppp_free(isdn_net_local * lp)
 #endif /* CONFIG_ISDN_MPP */
 	if (lp->ppp_slot < 0 || lp->ppp_slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: ppp_slot(%d) now invalid\n",
-			__FUNCTION__, lp->ppp_slot);
+			__func__, lp->ppp_slot);
 		return 0;
 	}
 	is = ippp_table[lp->ppp_slot];
@@ -226,7 +226,7 @@ isdn_ppp_wakeup_daemon(isdn_net_local * 
 {
 	if (lp->ppp_slot < 0 || lp->ppp_slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: ppp_slot(%d) out of range\n",
-			__FUNCTION__, lp->ppp_slot);
+			__func__, lp->ppp_slot);
 		return;
 	}
 	ippp_table[lp->ppp_slot]->state = IPPP_OPEN | IPPP_CONNECT | IPPP_NOBLOCK;
@@ -245,7 +245,7 @@ isdn_ppp_closewait(int slot)
 
 	if (slot < 0 || slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: slot(%d) out of range\n",
-			__FUNCTION__, slot);
+			__func__, slot);
 		return 0;
 	}
 	is = ippp_table[slot];
@@ -343,7 +343,7 @@ isdn_ppp_release(int min, struct file *f
 	is = file->private_data;
 
 	if (!is) {
-		printk(KERN_ERR "%s: no file->private_data\n", __FUNCTION__);
+		printk(KERN_ERR "%s: no file->private_data\n", __func__);
 		return;
 	}
 	if (is->debug & 0x1)
@@ -353,7 +353,7 @@ isdn_ppp_release(int min, struct file *f
 		isdn_net_dev *p = is->lp->netdev;
 
 		if (!p) {
-			printk(KERN_ERR "%s: no lp->netdev\n", __FUNCTION__);
+			printk(KERN_ERR "%s: no lp->netdev\n", __func__);
 			return;
 		}
 		is->state &= ~IPPP_CONNECT;	/* -> effect: no call of wakeup */
@@ -1080,7 +1080,7 @@ isdn_ppp_push_higher(isdn_net_dev * net_
 				printk(KERN_DEBUG "isdn_ppp: VJC_UNCOMP\n");
 			if (net_dev->local->ppp_slot < 0) {
 				printk(KERN_ERR "%s: net_dev->local->ppp_slot(%d) out of range\n",
-					__FUNCTION__, net_dev->local->ppp_slot);
+					__func__, net_dev->local->ppp_slot);
 				goto drop_packet;
 			}
 			if (slhc_remember(ippp_table[net_dev->local->ppp_slot]->slcomp, skb->data, skb->len) <= 0) {
@@ -1107,7 +1107,7 @@ isdn_ppp_push_higher(isdn_net_dev * net_
 							  skb_old->len);
 				if (net_dev->local->ppp_slot < 0) {
 					printk(KERN_ERR "%s: net_dev->local->ppp_slot(%d) out of range\n",
-						__FUNCTION__, net_dev->local->ppp_slot);
+						__func__, net_dev->local->ppp_slot);
 					goto drop_packet;
 				}
 				pkt_len = slhc_uncompress(ippp_table[net_dev->local->ppp_slot]->slcomp,
@@ -1553,7 +1553,7 @@ static int isdn_ppp_mp_init( isdn_net_lo
 
 	if (lp->ppp_slot < 0) {
 		printk(KERN_ERR "%s: lp->ppp_slot(%d) out of range\n",
-			__FUNCTION__, lp->ppp_slot);
+			__func__, lp->ppp_slot);
 		return(-EINVAL);
 	}
 
@@ -1604,7 +1604,7 @@ static void isdn_ppp_mp_receive(isdn_net
 	slot = lp->ppp_slot;
 	if (slot < 0 || slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: lp->ppp_slot(%d)\n",
-			__FUNCTION__, lp->ppp_slot);
+			__func__, lp->ppp_slot);
 		stats->frame_drops++;
 		dev_kfree_skb(skb);
 		spin_unlock_irqrestore(&mp->lock, flags);
@@ -1641,7 +1641,7 @@ static void isdn_ppp_mp_receive(isdn_net
 		slot = lpq->ppp_slot;
 		if (slot < 0 || slot >= ISDN_MAX_CHANNELS) {
 			printk(KERN_ERR "%s: lpq->ppp_slot(%d)\n",
-				__FUNCTION__, lpq->ppp_slot);
+				__func__, lpq->ppp_slot);
 		} else {
 			u32 lls = ippp_table[slot]->last_link_seqno;
 			if (MP_LT(lls, minseq))
@@ -1875,7 +1875,7 @@ void isdn_ppp_mp_reassembly( isdn_net_de
 
 	if (lp->ppp_slot < 0 || lp->ppp_slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: lp->ppp_slot(%d) out of range\n",
-			__FUNCTION__, lp->ppp_slot);
+			__func__, lp->ppp_slot);
 		return;
 	}
 	if( MP_FLAGS(from) == (MP_BEGIN_FRAG | MP_END_FRAG) ) {
@@ -2655,7 +2655,7 @@ static void isdn_ppp_receive_ccp(isdn_ne
 		lp->ppp_slot);
 	if (lp->ppp_slot < 0 || lp->ppp_slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: lp->ppp_slot(%d) out of range\n",
-			__FUNCTION__, lp->ppp_slot);
+			__func__, lp->ppp_slot);
 		return;
 	}
 	is = ippp_table[lp->ppp_slot];
@@ -2665,7 +2665,7 @@ static void isdn_ppp_receive_ccp(isdn_ne
 		int slot = ((isdn_net_local *) (lp->master->priv))->ppp_slot;
 		if (slot < 0 || slot >= ISDN_MAX_CHANNELS) {
 			printk(KERN_ERR "%s: slot(%d) out of range\n",
-				__FUNCTION__, slot);
+				__func__, slot);
 			return;
 		}	
 		mis = ippp_table[slot];
@@ -2829,7 +2829,7 @@ static void isdn_ppp_send_ccp(isdn_net_d
 		return;
 	if (slot < 0 || slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: lp->ppp_slot(%d) out of range\n",
-			__FUNCTION__, slot);
+			__func__, slot);
 		return;
 	}	
 	is = ippp_table[slot];
@@ -2852,7 +2852,7 @@ static void isdn_ppp_send_ccp(isdn_net_d
 		slot = ((isdn_net_local *) (lp->master->priv))->ppp_slot;
 		if (slot < 0 || slot >= ISDN_MAX_CHANNELS) {
 			printk(KERN_ERR "%s: slot(%d) out of range\n",
-				__FUNCTION__, slot);
+				__func__, slot);
 			return;
 		}	
 		mis = ippp_table[slot];
diff -puN drivers/isdn/i4l/isdn_tty.c~isdn-replace-remaining-__function__-occurrences drivers/isdn/i4l/isdn_tty.c
--- a/drivers/isdn/i4l/isdn_tty.c~isdn-replace-remaining-__function__-occurrences
+++ a/drivers/isdn/i4l/isdn_tty.c
@@ -1347,7 +1347,7 @@ isdn_tty_tiocmget(struct tty_struct *tty
 	modem_info *info = (modem_info *) tty->driver_data;
 	u_char control, status;
 
-	if (isdn_tty_paranoia_check(info, tty->name, __FUNCTION__))
+	if (isdn_tty_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 	if (tty->flags & (1 << TTY_IO_ERROR))
 		return -EIO;
@@ -1374,7 +1374,7 @@ isdn_tty_tiocmset(struct tty_struct *tty
 {
 	modem_info *info = (modem_info *) tty->driver_data;
 
-	if (isdn_tty_paranoia_check(info, tty->name, __FUNCTION__))
+	if (isdn_tty_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 	if (tty->flags & (1 << TTY_IO_ERROR))
 		return -EIO;
@@ -1598,7 +1598,7 @@ isdn_tty_open(struct tty_struct *tty, st
 	if (isdn_tty_paranoia_check(info, tty->name, "isdn_tty_open"))
 		return -ENODEV;
 	if (!try_module_get(info->owner)) {
-		printk(KERN_WARNING "%s: cannot reserve module\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: cannot reserve module\n", __func__);
 		return -ENODEV;
 	}
 #ifdef ISDN_DEBUG_MODEM_OPEN
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
cifs-replace-remaining-__function__-occurrences.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
sh-replace-remaining-__function__-occurences.patch
xfs-replace-remaining-__function__-occurrences.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
ext2-replace-remaining-__function__-occurrences.patch
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
infiniband-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
isdn-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
video-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch

