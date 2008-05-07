From: akpm@linux-foundation.org
Subject: + rename-warn-to-warning-to-clear-the-namespace.patch added to -mm tree
Date: Wed, 07 May 2008 14:44:30 -0700
Message-ID: <200805072144.m47LiU0k017960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754386AbYEGVpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 17:45:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, greg@kroah.com, kkeil@suse.de


The patch titled
     ] Rename WARN() to WARNING() to clear the namespace
has been added to the -mm tree.  Its filename is
     rename-warn-to-warning-to-clear-the-namespace.patch

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
Subject: ] Rename WARN() to WARNING() to clear the namespace
From: Arjan van de Ven <arjan@linux.intel.com>

We want to use WARN() as a variant of WARN_ON(), however a few drivers are
using WARN() internally.  This patch renames these to WARNING() to avoid the
namespace clash.  A few cases were defining but not using the thing, for those
cases I just deleted the definition.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/st5481.h       |    4 ++--
 drivers/isdn/hisax/st5481_b.c     |    4 ++--
 drivers/isdn/hisax/st5481_d.c     |    6 +++---
 drivers/isdn/hisax/st5481_usb.c   |   18 +++++++++---------
 drivers/usb/gadget/ether.c        |    2 --
 drivers/usb/gadget/file_storage.c |   14 +++++++-------
 drivers/usb/gadget/fsl_usb2_udc.c |    2 +-
 drivers/usb/gadget/fsl_usb2_udc.h |    2 +-
 drivers/usb/gadget/gmidi.c        |    2 --
 drivers/usb/gadget/goku_udc.c     |    2 +-
 drivers/usb/gadget/goku_udc.h     |    2 +-
 drivers/usb/gadget/inode.c        |    2 --
 drivers/usb/gadget/net2280.c      |    2 +-
 drivers/usb/gadget/net2280.h      |    2 +-
 drivers/usb/gadget/omap_udc.c     |    6 +++---
 drivers/usb/gadget/omap_udc.h     |    2 +-
 drivers/usb/gadget/pxa2xx_udc.c   |    4 ++--
 drivers/usb/gadget/pxa2xx_udc.h   |    2 +-
 drivers/usb/gadget/zero.c         |    2 --
 drivers/usb/host/isp116x-hcd.c    |    2 +-
 drivers/usb/host/isp116x.h        |    2 +-
 drivers/usb/host/sl811-hcd.c      |    2 +-
 drivers/usb/host/sl811.h          |    2 +-
 drivers/usb/misc/usbtest.c        |    4 ++--
 24 files changed, 42 insertions(+), 50 deletions(-)

diff -puN drivers/isdn/hisax/st5481.h~rename-warn-to-warning-to-clear-the-namespace drivers/isdn/hisax/st5481.h
--- a/drivers/isdn/hisax/st5481.h~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/isdn/hisax/st5481.h
@@ -220,7 +220,7 @@ enum {
 #define ERR(format, arg...) \
 printk(KERN_ERR "%s:%s: " format "\n" , __FILE__,  __func__ , ## arg)
 
-#define WARN(format, arg...) \
+#define WARNING(format, arg...) \
 printk(KERN_WARNING "%s:%s: " format "\n" , __FILE__,  __func__ , ## arg)
 
 #define INFO(format, arg...) \
@@ -412,7 +412,7 @@ struct st5481_adapter {
 ({ \
 	int status; \
 	if ((status = usb_submit_urb(urb, mem_flags)) < 0) { \
-		WARN("usb_submit_urb failed,status=%d", status); \
+		WARNING("usb_submit_urb failed,status=%d", status); \
 	} \
         status; \
 })
diff -puN drivers/isdn/hisax/st5481_b.c~rename-warn-to-warning-to-clear-the-namespace drivers/isdn/hisax/st5481_b.c
--- a/drivers/isdn/hisax/st5481_b.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/isdn/hisax/st5481_b.c
@@ -180,7 +180,7 @@ static void usb_b_out_complete(struct ur
 				DBG(4,"urb killed status %d", urb->status);
 				return; // Give up
 			default: 
-				WARN("urb status %d",urb->status);
+				WARNING("urb status %d",urb->status);
 				if (b_out->busy == 0) {
 					st5481_usb_pipe_reset(adapter, (bcs->channel+1)*2 | USB_DIR_OUT, NULL, NULL);
 				}
@@ -372,6 +372,6 @@ void st5481_b_l2l1(struct hisax_if *ifc,
 		B_L1L2(bcs, PH_DEACTIVATE | INDICATION, NULL);
 		break;
 	default:
-		WARN("pr %#x\n", pr);
+		WARNING("pr %#x\n", pr);
 	}
 }
diff -puN drivers/isdn/hisax/st5481_d.c~rename-warn-to-warning-to-clear-the-namespace drivers/isdn/hisax/st5481_d.c
--- a/drivers/isdn/hisax/st5481_d.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/isdn/hisax/st5481_d.c
@@ -389,7 +389,7 @@ static void usb_d_out_complete(struct ur
 				DBG(1,"urb killed status %d", urb->status);
 				break;
 			default: 
-				WARN("urb status %d",urb->status);
+				WARNING("urb status %d",urb->status);
 				if (d_out->busy == 0) {
 					st5481_usb_pipe_reset(adapter, EP_D_OUT | USB_DIR_OUT, fifo_reseted, adapter);
 				}
@@ -420,7 +420,7 @@ static void dout_start_xmit(struct FsmIn
 	isdnhdlc_out_init(&d_out->hdlc_state, 1, 0);
 
 	if (test_and_set_bit(buf_nr, &d_out->busy)) {
-		WARN("ep %d urb %d busy %#lx", EP_D_OUT, buf_nr, d_out->busy);
+		WARNING("ep %d urb %d busy %#lx", EP_D_OUT, buf_nr, d_out->busy);
 		return;
 	}
 	urb = d_out->urb[buf_nr];
@@ -601,7 +601,7 @@ void st5481_d_l2l1(struct hisax_if *hisa
 		FsmEvent(&adapter->d_out.fsm, EV_DOUT_START_XMIT, NULL);
 		break;
 	default:
-		WARN("pr %#x\n", pr);
+		WARNING("pr %#x\n", pr);
 		break;
 	}
 }
diff -puN drivers/isdn/hisax/st5481_usb.c~rename-warn-to-warning-to-clear-the-namespace drivers/isdn/hisax/st5481_usb.c
--- a/drivers/isdn/hisax/st5481_usb.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/isdn/hisax/st5481_usb.c
@@ -66,7 +66,7 @@ static void usb_ctrl_msg(struct st5481_a
 	struct ctrl_msg *ctrl_msg;
 	
 	if ((w_index = fifo_add(&ctrl->msg_fifo.f)) < 0) {
-		WARN("control msg FIFO full");
+		WARNING("control msg FIFO full");
 		return;
 	}
 	ctrl_msg = &ctrl->msg_fifo.data[w_index]; 
@@ -139,7 +139,7 @@ static void usb_ctrl_complete(struct urb
 				DBG(1,"urb killed status %d", urb->status);
 				return; // Give up
 			default: 
-				WARN("urb status %d",urb->status);
+				WARNING("urb status %d",urb->status);
 				break;
 		}
 	}
@@ -198,7 +198,7 @@ static void usb_int_complete(struct urb 
 			DBG(2, "urb shutting down with status: %d", urb->status);
 			return;
 		default:
-			WARN("nonzero urb status received: %d", urb->status);
+			WARNING("nonzero urb status received: %d", urb->status);
 			goto exit;
 	}
 
@@ -235,7 +235,7 @@ static void usb_int_complete(struct urb 
 exit:
 	status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status)
-		WARN("usb_submit_urb failed with result %d", status);
+		WARNING("usb_submit_urb failed with result %d", status);
 }
 
 /* ======================================================================
@@ -257,7 +257,7 @@ int st5481_setup_usb(struct st5481_adapt
 	DBG(2,"");
 	
 	if ((status = usb_reset_configuration (dev)) < 0) {
-		WARN("reset_configuration failed,status=%d",status);
+		WARNING("reset_configuration failed,status=%d",status);
 		return status;
 	}
 
@@ -269,7 +269,7 @@ int st5481_setup_usb(struct st5481_adapt
 
 	// Check if the config is sane
 	if ( altsetting->desc.bNumEndpoints != 7 ) {
-		WARN("expecting 7 got %d endpoints!", altsetting->desc.bNumEndpoints);
+		WARNING("expecting 7 got %d endpoints!", altsetting->desc.bNumEndpoints);
 		return -EINVAL;
 	}
 
@@ -279,7 +279,7 @@ int st5481_setup_usb(struct st5481_adapt
 
 	// Use alternative setting 3 on interface 0 to have 2B+D
 	if ((status = usb_set_interface (dev, 0, 3)) < 0) {
-		WARN("usb_set_interface failed,status=%d",status);
+		WARNING("usb_set_interface failed,status=%d",status);
 		return status;
 	}
 
@@ -497,7 +497,7 @@ static void usb_in_complete(struct urb *
 				DBG(1,"urb killed status %d", urb->status);
 				return; // Give up
 			default: 
-				WARN("urb status %d",urb->status);
+				WARNING("urb status %d",urb->status);
 				break;
 		}
 	}
@@ -523,7 +523,7 @@ static void usb_in_complete(struct urb *
 			DBG(4,"count=%d",status);
 			DBG_PACKET(0x400, in->rcvbuf, status);
 			if (!(skb = dev_alloc_skb(status))) {
-				WARN("receive out of memory\n");
+				WARNING("receive out of memory\n");
 				break;
 			}
 			memcpy(skb_put(skb, status), in->rcvbuf, status);
diff -puN drivers/usb/gadget/ether.c~rename-warn-to-warning-to-clear-the-namespace drivers/usb/gadget/ether.c
--- a/drivers/usb/gadget/ether.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/gadget/ether.c
@@ -377,8 +377,6 @@ static inline int BITRATE(struct usb_gad
 
 #define ERROR(dev,fmt,args...) \
 	xprintk(dev , KERN_ERR , fmt , ## args)
-#define WARN(dev,fmt,args...) \
-	xprintk(dev , KERN_WARNING , fmt , ## args)
 #define INFO(dev,fmt,args...) \
 	xprintk(dev , KERN_INFO , fmt , ## args)
 
diff -puN drivers/usb/gadget/file_storage.c~rename-warn-to-warning-to-clear-the-namespace drivers/usb/gadget/file_storage.c
--- a/drivers/usb/gadget/file_storage.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/gadget/file_storage.c
@@ -308,7 +308,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 	dev_vdbg(&(d)->gadget->dev , fmt , ## args)
 #define ERROR(d, fmt, args...) \
 	dev_err(&(d)->gadget->dev , fmt , ## args)
-#define WARN(d, fmt, args...) \
+#define WARNING(d, fmt, args...) \
 	dev_warn(&(d)->gadget->dev , fmt , ## args)
 #define INFO(d, fmt, args...) \
 	dev_info(&(d)->gadget->dev , fmt , ## args)
@@ -1091,7 +1091,7 @@ static int ep0_queue(struct fsg_dev *fsg
 	if (rc != 0 && rc != -ESHUTDOWN) {
 
 		/* We can't do much more than wait for a reset */
-		WARN(fsg, "error in submission: %s --> %d\n",
+		WARNING(fsg, "error in submission: %s --> %d\n",
 				fsg->ep0->name, rc);
 	}
 	return rc;
@@ -1227,7 +1227,7 @@ static void received_cbi_adsc(struct fsg
 
 	/* Save the command for later */
 	if (fsg->cbbuf_cmnd_size)
-		WARN(fsg, "CB[I] overwriting previous command\n");
+		WARNING(fsg, "CB[I] overwriting previous command\n");
 	fsg->cbbuf_cmnd_size = req->actual;
 	memcpy(fsg->cbbuf_cmnd, req->buf, fsg->cbbuf_cmnd_size);
 
@@ -1506,7 +1506,7 @@ static void start_transfer(struct fsg_de
 		 * submissions if DMA is enabled. */
 		if (rc != -ESHUTDOWN && !(rc == -EOPNOTSUPP &&
 						req->length == 0))
-			WARN(fsg, "error in submission: %s --> %d\n",
+			WARNING(fsg, "error in submission: %s --> %d\n",
 					ep->name, rc);
 	}
 }
@@ -2294,7 +2294,7 @@ static int halt_bulk_in_endpoint(struct 
 		VDBG(fsg, "delayed bulk-in endpoint halt\n");
 	while (rc != 0) {
 		if (rc != -EAGAIN) {
-			WARN(fsg, "usb_ep_set_halt -> %d\n", rc);
+			WARNING(fsg, "usb_ep_set_halt -> %d\n", rc);
 			rc = 0;
 			break;
 		}
@@ -2317,7 +2317,7 @@ static int wedge_bulk_in_endpoint(struct
 		VDBG(fsg, "delayed bulk-in endpoint wedge\n");
 	while (rc != 0) {
 		if (rc != -EAGAIN) {
-			WARN(fsg, "usb_ep_set_wedge -> %d\n", rc);
+			WARNING(fsg, "usb_ep_set_wedge -> %d\n", rc);
 			rc = 0;
 			break;
 		}
@@ -3755,7 +3755,7 @@ static int __init check_parameters(struc
 		if (gcnum >= 0)
 			mod_data.release = 0x0300 + gcnum;
 		else {
-			WARN(fsg, "controller '%s' not recognized\n",
+			WARNING(fsg, "controller '%s' not recognized\n",
 				fsg->gadget->name);
 			mod_data.release = 0x0399;
 		}
diff -puN drivers/usb/gadget/fsl_usb2_udc.c~rename-warn-to-warning-to-clear-the-namespace drivers/usb/gadget/fsl_usb2_udc.c
--- a/drivers/usb/gadget/fsl_usb2_udc.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/gadget/fsl_usb2_udc.c
@@ -1538,7 +1538,7 @@ static void dtd_complete_irq(struct fsl_
 
 		/* If the ep is configured */
 		if (curr_ep->name == NULL) {
-			WARN("Invalid EP?");
+			WARNING("Invalid EP?");
 			continue;
 		}
 
diff -puN drivers/usb/gadget/fsl_usb2_udc.h~rename-warn-to-warning-to-clear-the-namespace drivers/usb/gadget/fsl_usb2_udc.h
--- a/drivers/usb/gadget/fsl_usb2_udc.h~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/gadget/fsl_usb2_udc.h
@@ -552,7 +552,7 @@ static void dump_msg(const char *label, 
 #endif
 
 #define ERR(stuff...)		pr_err("udc: " stuff)
-#define WARN(stuff...)		pr_warning("udc: " stuff)
+#define WARNING(stuff...)		pr_warning("udc: " stuff)
 #define INFO(stuff...)		pr_info("udc: " stuff)
 
 /*-------------------------------------------------------------------------*/
diff -puN drivers/usb/gadget/gmidi.c~rename-warn-to-warning-to-clear-the-namespace drivers/usb/gadget/gmidi.c
--- a/drivers/usb/gadget/gmidi.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/gadget/gmidi.c
@@ -138,8 +138,6 @@ static void gmidi_transmit(struct gmidi_
 	dev_vdbg(&(d)->gadget->dev , fmt , ## args)
 #define ERROR(d, fmt, args...) \
 	dev_err(&(d)->gadget->dev , fmt , ## args)
-#define WARN(d, fmt, args...) \
-	dev_warn(&(d)->gadget->dev , fmt , ## args)
 #define INFO(d, fmt, args...) \
 	dev_info(&(d)->gadget->dev , fmt , ## args)
 
diff -puN drivers/usb/gadget/goku_udc.c~rename-warn-to-warning-to-clear-the-namespace drivers/usb/gadget/goku_udc.c
--- a/drivers/usb/gadget/goku_udc.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/gadget/goku_udc.c
@@ -1768,7 +1768,7 @@ static int goku_probe(struct pci_dev *pd
 	 * usb_gadget_driver_{register,unregister}() must change.
 	 */
 	if (the_controller) {
-		WARN(dev, "ignoring %s\n", pci_name(pdev));
+		WARNING(dev, "ignoring %s\n", pci_name(pdev));
 		return -EBUSY;
 	}
 	if (!pdev->irq) {
diff -puN drivers/usb/gadget/goku_udc.h~rename-warn-to-warning-to-clear-the-namespace drivers/usb/gadget/goku_udc.h
--- a/drivers/usb/gadget/goku_udc.h~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/gadget/goku_udc.h
@@ -285,7 +285,7 @@ struct goku_udc {
 
 #define ERROR(dev,fmt,args...) \
 	xprintk(dev , KERN_ERR , fmt , ## args)
-#define WARN(dev,fmt,args...) \
+#define WARNING(dev,fmt,args...) \
 	xprintk(dev , KERN_WARNING , fmt , ## args)
 #define INFO(dev,fmt,args...) \
 	xprintk(dev , KERN_INFO , fmt , ## args)
diff -puN drivers/usb/gadget/inode.c~rename-warn-to-warning-to-clear-the-namespace drivers/usb/gadget/inode.c
--- a/drivers/usb/gadget/inode.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/gadget/inode.c
@@ -261,8 +261,6 @@ static const char *CHIP;
 
 #define ERROR(dev,fmt,args...) \
 	xprintk(dev , KERN_ERR , fmt , ## args)
-#define WARN(dev,fmt,args...) \
-	xprintk(dev , KERN_WARNING , fmt , ## args)
 #define INFO(dev,fmt,args...) \
 	xprintk(dev , KERN_INFO , fmt , ## args)
 
diff -puN drivers/usb/gadget/net2280.c~rename-warn-to-warning-to-clear-the-namespace drivers/usb/gadget/net2280.c
--- a/drivers/usb/gadget/net2280.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/gadget/net2280.c
@@ -1007,7 +1007,7 @@ static void scan_dma_completions (struct
 			 * 0122, and 0124; not all cases trigger the warning.
 			 */
 			if ((tmp & (1 << NAK_OUT_PACKETS)) == 0) {
-				WARN (ep->dev, "%s lost packet sync!\n",
+				WARNING (ep->dev, "%s lost packet sync!\n",
 						ep->ep.name);
 				req->req.status = -EOVERFLOW;
 			} else if ((tmp = readl (&ep->regs->ep_avail)) != 0) {
diff -puN drivers/usb/gadget/net2280.h~rename-warn-to-warning-to-clear-the-namespace drivers/usb/gadget/net2280.h
--- a/drivers/usb/gadget/net2280.h~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/gadget/net2280.h
@@ -272,7 +272,7 @@ static inline void net2280_led_shutdown 
 
 #define ERROR(dev,fmt,args...) \
 	xprintk(dev , KERN_ERR , fmt , ## args)
-#define WARN(dev,fmt,args...) \
+#define WARNING(dev,fmt,args...) \
 	xprintk(dev , KERN_WARNING , fmt , ## args)
 #define INFO(dev,fmt,args...) \
 	xprintk(dev , KERN_INFO , fmt , ## args)
diff -puN drivers/usb/gadget/omap_udc.c~rename-warn-to-warning-to-clear-the-namespace drivers/usb/gadget/omap_udc.c
--- a/drivers/usb/gadget/omap_udc.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/gadget/omap_udc.c
@@ -1129,7 +1129,7 @@ static int omap_ep_set_halt(struct usb_e
 			status = -EINVAL;
 		else if (value) {
 			if (ep->udc->ep0_set_config) {
-				WARN("error changing config?\n");
+				WARNING("error changing config?\n");
 				UDC_SYSCON2_REG = UDC_CLR_CFG;
 			}
 			UDC_SYSCON2_REG = UDC_STALL_CMD;
@@ -1746,7 +1746,7 @@ do_stall:
 					u.r.bRequestType, u.r.bRequest, status);
 			if (udc->ep0_set_config) {
 				if (udc->ep0_reset_config)
-					WARN("error resetting config?\n");
+					WARNING("error resetting config?\n");
 				else
 					UDC_SYSCON2_REG = UDC_CLR_CFG;
 			}
@@ -3052,7 +3052,7 @@ static int omap_udc_suspend(struct platf
 	 * which would prevent entry to deep sleep...
 	 */
 	if ((devstat & UDC_ATT) != 0 && (devstat & UDC_SUS) == 0) {
-		WARN("session active; suspend requires disconnect\n");
+		WARNING("session active; suspend requires disconnect\n");
 		omap_pullup(&udc->gadget, 0);
 	}
 
diff -puN drivers/usb/gadget/omap_udc.h~rename-warn-to-warning-to-clear-the-namespace drivers/usb/gadget/omap_udc.h
--- a/drivers/usb/gadget/omap_udc.h~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/gadget/omap_udc.h
@@ -189,7 +189,7 @@ struct omap_udc {
 #endif
 
 #define ERR(stuff...)		pr_err("udc: " stuff)
-#define WARN(stuff...)		pr_warning("udc: " stuff)
+#define WARNING(stuff...)	pr_warning("udc: " stuff)
 #define INFO(stuff...)		pr_info("udc: " stuff)
 #define DBG(stuff...)		pr_debug("udc: " stuff)
 
diff -puN drivers/usb/gadget/pxa2xx_udc.c~rename-warn-to-warning-to-clear-the-namespace drivers/usb/gadget/pxa2xx_udc.c
--- a/drivers/usb/gadget/pxa2xx_udc.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/gadget/pxa2xx_udc.c
@@ -1555,7 +1555,7 @@ config_change:
 					 * tell us about config change events,
 					 * so later ones may fail...
 					 */
-					WARN("config change %02x fail %d?\n",
+					WARNING("config change %02x fail %d?\n",
 						u.r.bRequest, i);
 					return;
 					/* TODO experiment:  if has_cfr,
@@ -2329,7 +2329,7 @@ static int pxa2xx_udc_suspend(struct pla
 	unsigned long flags;
 
 	if (!udc->mach->gpio_pullup && !udc->mach->udc_command)
-		WARN("USB host won't detect disconnect!\n");
+		WARNING("USB host won't detect disconnect!\n");
 	udc->suspended = 1;
 
 	local_irq_save(flags);
diff -puN drivers/usb/gadget/pxa2xx_udc.h~rename-warn-to-warning-to-clear-the-namespace drivers/usb/gadget/pxa2xx_udc.h
--- a/drivers/usb/gadget/pxa2xx_udc.h~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/gadget/pxa2xx_udc.h
@@ -260,7 +260,7 @@ dump_state(struct pxa2xx_udc *dev)
 #define DBG(lvl, stuff...) do{if ((lvl) <= UDC_DEBUG) DMSG(stuff);}while(0)
 
 #define ERR(stuff...)		pr_err("udc: " stuff)
-#define WARN(stuff...)		pr_warning("udc: " stuff)
+#define WARNING(stuff...)	pr_warning("udc: " stuff)
 #define INFO(stuff...)		pr_info("udc: " stuff)
 
 
diff -puN drivers/usb/gadget/zero.c~rename-warn-to-warning-to-clear-the-namespace drivers/usb/gadget/zero.c
--- a/drivers/usb/gadget/zero.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/gadget/zero.c
@@ -108,8 +108,6 @@ struct zero_dev {
 	dev_vdbg(&(d)->gadget->dev , fmt , ## args)
 #define ERROR(d, fmt, args...) \
 	dev_err(&(d)->gadget->dev , fmt , ## args)
-#define WARN(d, fmt, args...) \
-	dev_warn(&(d)->gadget->dev , fmt , ## args)
 #define INFO(d, fmt, args...) \
 	dev_info(&(d)->gadget->dev , fmt , ## args)
 
diff -puN drivers/usb/host/isp116x-hcd.c~rename-warn-to-warning-to-clear-the-namespace drivers/usb/host/isp116x-hcd.c
--- a/drivers/usb/host/isp116x-hcd.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/host/isp116x-hcd.c
@@ -867,7 +867,7 @@ static void isp116x_endpoint_disable(str
 	for (i = 0; i < 100 && !list_empty(&hep->urb_list); i++)
 		msleep(3);
 	if (!list_empty(&hep->urb_list))
-		WARN("ep %p not empty?\n", ep);
+		WARNING("ep %p not empty?\n", ep);
 
 	kfree(ep);
 	hep->hcpriv = NULL;
diff -puN drivers/usb/host/isp116x.h~rename-warn-to-warning-to-clear-the-namespace drivers/usb/host/isp116x.h
--- a/drivers/usb/host/isp116x.h~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/host/isp116x.h
@@ -338,7 +338,7 @@ struct isp116x_ep {
 #endif
 
 #define ERR(stuff...)		printk(KERN_ERR "116x: " stuff)
-#define WARN(stuff...)		printk(KERN_WARNING "116x: " stuff)
+#define WARNING(stuff...)	printk(KERN_WARNING "116x: " stuff)
 #define INFO(stuff...)		printk(KERN_INFO "116x: " stuff)
 
 /* ------------------------------------------------- */
diff -puN drivers/usb/host/sl811-hcd.c~rename-warn-to-warning-to-clear-the-namespace drivers/usb/host/sl811-hcd.c
--- a/drivers/usb/host/sl811-hcd.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/host/sl811-hcd.c
@@ -1026,7 +1026,7 @@ sl811h_endpoint_disable(struct usb_hcd *
 	if (!list_empty(&hep->urb_list))
 		msleep(3);
 	if (!list_empty(&hep->urb_list))
-		WARN("ep %p not empty?\n", ep);
+		WARNING("ep %p not empty?\n", ep);
 
 	kfree(ep);
 	hep->hcpriv = NULL;
diff -puN drivers/usb/host/sl811.h~rename-warn-to-warning-to-clear-the-namespace drivers/usb/host/sl811.h
--- a/drivers/usb/host/sl811.h~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/host/sl811.h
@@ -261,6 +261,6 @@ sl811_read_buf(struct sl811 *sl811, int 
 #endif
 
 #define ERR(stuff...)		printk(KERN_ERR "sl811: " stuff)
-#define WARN(stuff...)		printk(KERN_WARNING "sl811: " stuff)
+#define WARNING(stuff...)	printk(KERN_WARNING "sl811: " stuff)
 #define INFO(stuff...)		printk(KERN_INFO "sl811: " stuff)
 
diff -puN drivers/usb/misc/usbtest.c~rename-warn-to-warning-to-clear-the-namespace drivers/usb/misc/usbtest.c
--- a/drivers/usb/misc/usbtest.c~rename-warn-to-warning-to-clear-the-namespace
+++ a/drivers/usb/misc/usbtest.c
@@ -81,7 +81,7 @@ static struct usb_device *testdev_to_usb
 
 #define ERROR(tdev, fmt, args...) \
 	dev_err(&(tdev)->intf->dev , fmt , ## args)
-#define WARN(tdev, fmt, args...) \
+#define WARNING(tdev, fmt, args...) \
 	dev_warn(&(tdev)->intf->dev , fmt , ## args)
 
 /*-------------------------------------------------------------------------*/
@@ -1941,7 +1941,7 @@ usbtest_probe (struct usb_interface *int
 
 			status = get_endpoints (dev, intf);
 			if (status < 0) {
-				WARN(dev, "couldn't get endpoints, %d\n",
+				WARNING(dev, "couldn't get endpoints, %d\n",
 						status);
 				return status;
 			}
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
rename-warn-to-warning-to-clear-the-namespace.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
example-use-of-warn.patch

