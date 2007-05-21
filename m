From: akpm@linux-foundation.org
Subject: + hisax-fix-error-checking-for-hisax_register.patch added to -mm tree
Date: Mon, 21 May 2007 14:18:53 -0700
Message-ID: <200705212118.l4LLIrOo020268@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51046 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757602AbXEUVUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:20:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, kkeil@suse.de


The patch titled
     HiSax: fix error checking for hisax_register()]
has been added to the -mm tree.  Its filename is
     hisax-fix-error-checking-for-hisax_register.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: HiSax: fix error checking for hisax_register()]
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as875) adds error-checking to the callers of hisax_register(). 
It also changes an error pathway in that routine, making it return an error
code rather than 0.

This fixes Bugzilla #7960.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/config.c         |    2 -
 drivers/isdn/hisax/hfc_usb.c        |   43 ++++++++++----------------
 drivers/isdn/hisax/hisax_fcpcipnp.c |    6 +++
 drivers/isdn/hisax/st5481_init.c    |    7 +++-
 drivers/isdn/hisax/st5481_usb.c     |    1 
 5 files changed, 30 insertions(+), 29 deletions(-)

diff -puN drivers/isdn/hisax/config.c~hisax-fix-error-checking-for-hisax_register drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c~hisax-fix-error-checking-for-hisax_register
+++ a/drivers/isdn/hisax/config.c
@@ -1551,7 +1551,7 @@ int hisax_register(struct hisax_d_if *hi
 	if (retval == 0) { // yuck
 		cards[i].typ = 0;
 		nrcards--;
-		return retval;
+		return -EINVAL;
 	}
 	cs = cards[i].cs;
 	hisax_d_if->cs = cs;
diff -puN drivers/isdn/hisax/hfc_usb.c~hisax-fix-error-checking-for-hisax_register drivers/isdn/hisax/hfc_usb.c
--- a/drivers/isdn/hisax/hfc_usb.c~hisax-fix-error-checking-for-hisax_register
+++ a/drivers/isdn/hisax/hfc_usb.c
@@ -485,7 +485,6 @@ fill_isoc_urb(struct urb *urb, struct us
 {
 	int k;
 
-	spin_lock_init(&urb->lock);
 	urb->dev = dev;
 	urb->pipe = pipe;
 	urb->complete = complete;
@@ -578,16 +577,14 @@ stop_isoc_chain(usb_fifo * fifo)
 			    "HFC-S USB: Stopping iso chain for fifo %i.%i",
 			    fifo->fifonum, i);
 #endif
-			usb_unlink_urb(fifo->iso[i].purb);
+			usb_kill_urb(fifo->iso[i].purb);
 			usb_free_urb(fifo->iso[i].purb);
 			fifo->iso[i].purb = NULL;
 		}
 	}
-	if (fifo->urb) {
-		usb_unlink_urb(fifo->urb);
-		usb_free_urb(fifo->urb);
-		fifo->urb = NULL;
-	}
+	usb_kill_urb(fifo->urb);
+	usb_free_urb(fifo->urb);
+	fifo->urb = NULL;
 	fifo->active = 0;
 }
 
@@ -1305,7 +1302,11 @@ usb_init(hfcusb_data * hfc)
 	}
 	/* default Prot: EURO ISDN, should be a module_param */
 	hfc->protocol = 2;
-	hisax_register(&hfc->d_if, p_b_if, "hfc_usb", hfc->protocol);
+	i = hisax_register(&hfc->d_if, p_b_if, "hfc_usb", hfc->protocol);
+	if (i) {
+		printk(KERN_INFO "HFC-S USB: hisax_register -> %d\n", i);
+		return i;
+	}
 
 #ifdef CONFIG_HISAX_DEBUG
 	hfc_debug = debug;
@@ -1626,11 +1627,9 @@ hfc_usb_probe(struct usb_interface *intf
 #endif
 			/* init the chip and register the driver */
 			if (usb_init(context)) {
-				if (context->ctrl_urb) {
-					usb_unlink_urb(context->ctrl_urb);
-					usb_free_urb(context->ctrl_urb);
-					context->ctrl_urb = NULL;
-				}
+				usb_kill_urb(context->ctrl_urb);
+				usb_free_urb(context->ctrl_urb);
+				context->ctrl_urb = NULL;
 				kfree(context);
 				return (-EIO);
 			}
@@ -1682,21 +1681,15 @@ hfc_usb_disconnect(struct usb_interface
 				    i);
 #endif
 			}
-			if (context->fifos[i].urb) {
-				usb_unlink_urb(context->fifos[i].urb);
-				usb_free_urb(context->fifos[i].urb);
-				context->fifos[i].urb = NULL;
-			}
+			usb_kill_urb(context->fifos[i].urb);
+			usb_free_urb(context->fifos[i].urb);
+			context->fifos[i].urb = NULL;
 		}
 		context->fifos[i].active = 0;
 	}
-	/* wait for all URBS to terminate */
-	mdelay(10);
-	if (context->ctrl_urb) {
-		usb_unlink_urb(context->ctrl_urb);
-		usb_free_urb(context->ctrl_urb);
-		context->ctrl_urb = NULL;
-	}
+	usb_kill_urb(context->ctrl_urb);
+	usb_free_urb(context->ctrl_urb);
+	context->ctrl_urb = NULL;
 	hisax_unregister(&context->d_if);
 	kfree(context);		/* free our structure again */
 }				/* hfc_usb_disconnect */
diff -puN drivers/isdn/hisax/hisax_fcpcipnp.c~hisax-fix-error-checking-for-hisax_register drivers/isdn/hisax/hisax_fcpcipnp.c
--- a/drivers/isdn/hisax/hisax_fcpcipnp.c~hisax-fix-error-checking-for-hisax_register
+++ a/drivers/isdn/hisax/hisax_fcpcipnp.c
@@ -859,7 +859,11 @@ new_adapter(void)
 	for (i = 0; i < 2; i++)
 		b_if[i] = &adapter->bcs[i].b_if;
 
-	hisax_register(&adapter->isac.hisax_d_if, b_if, "fcpcipnp", protocol);
+	if (hisax_register(&adapter->isac.hisax_d_if, b_if, "fcpcipnp",
+			protocol) != 0) {
+		kfree(adapter);
+		adapter = NULL;
+	}
 
 	return adapter;
 }
diff -puN drivers/isdn/hisax/st5481_init.c~hisax-fix-error-checking-for-hisax_register drivers/isdn/hisax/st5481_init.c
--- a/drivers/isdn/hisax/st5481_init.c~hisax-fix-error-checking-for-hisax_register
+++ a/drivers/isdn/hisax/st5481_init.c
@@ -107,12 +107,17 @@ static int probe_st5481(struct usb_inter
 	for (i = 0; i < 2; i++)
 		b_if[i] = &adapter->bcs[i].b_if;
 
-	hisax_register(&adapter->hisax_d_if, b_if, "st5481_usb", protocol);
+	if (hisax_register(&adapter->hisax_d_if, b_if, "st5481_usb",
+			protocol) != 0)
+		goto err_b1;
+
 	st5481_start(adapter);
 
 	usb_set_intfdata(intf, adapter);
 	return 0;
 
+ err_b1:
+	st5481_release_b(&adapter->bcs[1]);
  err_b:
 	st5481_release_b(&adapter->bcs[0]);
  err_d:
diff -puN drivers/isdn/hisax/st5481_usb.c~hisax-fix-error-checking-for-hisax_register drivers/isdn/hisax/st5481_usb.c
--- a/drivers/isdn/hisax/st5481_usb.c~hisax-fix-error-checking-for-hisax_register
+++ a/drivers/isdn/hisax/st5481_usb.c
@@ -407,7 +407,6 @@ fill_isoc_urb(struct urb *urb, struct us
 {
 	int k;
 
-	spin_lock_init(&urb->lock);
 	urb->dev=dev;
 	urb->pipe=pipe;
 	urb->interval = 1;
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

usb-dont-try-to-kzalloc-0-bytes.patch
fix-usb-ohci-subvendor-for-toshiba-portege-4000.patch
hisax-fix-error-checking-for-hisax_register.patch
