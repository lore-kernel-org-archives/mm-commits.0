From: akpm@linux-foundation.org
Subject: + amd5536udc-fixed-shared-interrupt-bug-and-warning-oops.patch added to -mm tree
Date: Tue, 13 Oct 2009 18:58:28 -0700
Message-ID: <200910140158.n9E1wSiV028559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759327AbZJNCAQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 22:00:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dahlmann.thomas@arcor.de, david-b@pacbell.net, greg@kroah.com, robert.richter@amd.com, stable@kernel.org


The patch titled
     usb: amd5536udc: fixed shared interrupt bug and warning oops
has been added to the -mm tree.  Its filename is
     amd5536udc-fixed-shared-interrupt-bug-and-warning-oops.patch

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
Subject: usb: amd5536udc: fixed shared interrupt bug and warning oops
From: Thomas Dahlmann <dahlmann.thomas@arcor.de>

 - fixed shared interrupt bug reported by Vadim Lobanov
 - fixed possible warning oops on driver unload when connected
 - prevent interrupt flood in PIO mode ("modprobe amd5536udc use_dma=0")
   when using gadget ether

Signed-off-by: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Cc: Robert Richter <robert.richter@amd.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/amd5536udc.c |   49 ++++++++++++++++++------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff -puN drivers/usb/gadget/amd5536udc.c~amd5536udc-fixed-shared-interrupt-bug-and-warning-oops drivers/usb/gadget/amd5536udc.c
--- a/drivers/usb/gadget/amd5536udc.c~amd5536udc-fixed-shared-interrupt-bug-and-warning-oops
+++ a/drivers/usb/gadget/amd5536udc.c
@@ -1213,7 +1213,12 @@ udc_queue(struct usb_ep *usbep, struct u
 				tmp &= AMD_UNMASK_BIT(ep->num);
 				writel(tmp, &dev->regs->ep_irqmsk);
 			}
-		}
+		} else if (ep->in) {
+				/* enable ep irq */
+				tmp = readl(&dev->regs->ep_irqmsk);
+				tmp &= AMD_UNMASK_BIT(ep->num);
+				writel(tmp, &dev->regs->ep_irqmsk);
+			}
 
 	} else if (ep->dma) {
 
@@ -2005,18 +2010,17 @@ __acquires(dev->lock)
 {
 	int tmp;
 
-	/* empty queues and init hardware */
-	udc_basic_init(dev);
-	for (tmp = 0; tmp < UDC_EP_NUM; tmp++) {
-		empty_req_queue(&dev->ep[tmp]);
-	}
-
 	if (dev->gadget.speed != USB_SPEED_UNKNOWN) {
 		spin_unlock(&dev->lock);
 		driver->disconnect(&dev->gadget);
 		spin_lock(&dev->lock);
 	}
-	/* init */
+
+	/* empty queues and init hardware */
+	udc_basic_init(dev);
+	for (tmp = 0; tmp < UDC_EP_NUM; tmp++)
+		empty_req_queue(&dev->ep[tmp]);
+
 	udc_setup_endpoints(dev);
 }
 
@@ -2472,6 +2476,13 @@ static irqreturn_t udc_data_in_isr(struc
 				}
 			}
 
+		} else if (!use_dma && ep->in) {
+			/* disable interrupt */
+			tmp = readl(
+				&dev->regs->ep_irqmsk);
+			tmp |= AMD_BIT(ep->num);
+			writel(tmp,
+				&dev->regs->ep_irqmsk);
 		}
 	}
 	/* clear status bits */
@@ -3279,6 +3290,17 @@ static int udc_pci_probe(
 		goto finished;
 	}
 
+	spin_lock_init(&dev->lock);
+	/* udc csr registers base */
+	dev->csr = dev->virt_addr + UDC_CSR_ADDR;
+	/* dev registers base */
+	dev->regs = dev->virt_addr + UDC_DEVCFG_ADDR;
+	/* ep registers base */
+	dev->ep_regs = dev->virt_addr + UDC_EPREGS_ADDR;
+	/* fifo's base */
+	dev->rxfifo = (u32 __iomem *)(dev->virt_addr + UDC_RXFIFO_ADDR);
+	dev->txfifo = (u32 __iomem *)(dev->virt_addr + UDC_TXFIFO_ADDR);
+
 	if (request_irq(pdev->irq, udc_irq, IRQF_SHARED, name, dev) != 0) {
 		dev_dbg(&dev->pdev->dev, "request_irq(%d) fail\n", pdev->irq);
 		kfree(dev);
@@ -3331,7 +3353,6 @@ static int udc_probe(struct udc *dev)
 	udc_pollstall_timer.data = 0;
 
 	/* device struct setup */
-	spin_lock_init(&dev->lock);
 	dev->gadget.ops = &udc_ops;
 
 	dev_set_name(&dev->gadget.dev, "gadget");
@@ -3340,16 +3361,6 @@ static int udc_probe(struct udc *dev)
 	dev->gadget.name = name;
 	dev->gadget.is_dualspeed = 1;
 
-	/* udc csr registers base */
-	dev->csr = dev->virt_addr + UDC_CSR_ADDR;
-	/* dev registers base */
-	dev->regs = dev->virt_addr + UDC_DEVCFG_ADDR;
-	/* ep registers base */
-	dev->ep_regs = dev->virt_addr + UDC_EPREGS_ADDR;
-	/* fifo's base */
-	dev->rxfifo = (u32 __iomem *)(dev->virt_addr + UDC_RXFIFO_ADDR);
-	dev->txfifo = (u32 __iomem *)(dev->virt_addr + UDC_TXFIFO_ADDR);
