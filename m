From: akpm@linux-foundation.org
Subject: + pxa27x_udc-remove-use-of-seq_printf-return-value.patch added to -mm tree
Date: Mon, 23 Feb 2015 15:58:50 -0800
Message-ID: <54ebbeba.Er9oRZPFC40DC99p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbbBWX6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 18:58:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, balbi@ti.com, daniel@zonque.org, gregkh@linuxfoundation.org, haojian.zhuang@gmail.com, robert.jarzmik@free.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/usb/gadget/udc/pxa27x_udc.c: remove use of seq_printf return value
has been added to the -mm tree.  Its filename is
     pxa27x_udc-remove-use-of-seq_printf-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pxa27x_udc-remove-use-of-seq_printf-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pxa27x_udc-remove-use-of-seq_printf-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: drivers/usb/gadget/udc/pxa27x_udc.c: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

While there, simplify the error handler logic by returning
immediately and remove the unnecessary labels.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Daniel Mack <daniel@zonque.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/udc/pxa27x_udc.c |  132 +++++++++++---------------
 1 file changed, 60 insertions(+), 72 deletions(-)

diff -puN drivers/usb/gadget/udc/pxa27x_udc.c~pxa27x_udc-remove-use-of-seq_printf-return-value drivers/usb/gadget/udc/pxa27x_udc.c
--- a/drivers/usb/gadget/udc/pxa27x_udc.c~pxa27x_udc-remove-use-of-seq_printf-return-value
+++ a/drivers/usb/gadget/udc/pxa27x_udc.c
@@ -93,50 +93,46 @@ static void handle_ep(struct pxa_ep *ep)
 static int state_dbg_show(struct seq_file *s, void *p)
 {
 	struct pxa_udc *udc = s->private;
-	int pos = 0, ret;
 	u32 tmp;
 
-	ret = -ENODEV;
 	if (!udc->driver)
-		goto out;
+		return -ENODEV;
 
 	/* basic device status */
-	pos += seq_printf(s, DRIVER_DESC "\n"
-			 "%s version: %s\nGadget driver: %s\n",
-			 driver_name, DRIVER_VERSION,
-			 udc->driver ? udc->driver->driver.name : "(none)");
+	seq_printf(s, DRIVER_DESC "\n"
+		   "%s version: %s\n"
+		   "Gadget driver: %s\n",
+		   driver_name, DRIVER_VERSION,
+		   udc->driver ? udc->driver->driver.name : "(none)");
 
 	tmp = udc_readl(udc, UDCCR);
-	pos += seq_printf(s,
-			 "udccr=0x%0x(%s%s%s%s%s%s%s%s%s%s), "
-			 "con=%d,inter=%d,altinter=%d\n", tmp,
-			 (tmp & UDCCR_OEN) ? " oen":"",
-			 (tmp & UDCCR_AALTHNP) ? " aalthnp":"",
-			 (tmp & UDCCR_AHNP) ? " rem" : "",
-			 (tmp & UDCCR_BHNP) ? " rstir" : "",
-			 (tmp & UDCCR_DWRE) ? " dwre" : "",
-			 (tmp & UDCCR_SMAC) ? " smac" : "",
-			 (tmp & UDCCR_EMCE) ? " emce" : "",
-			 (tmp & UDCCR_UDR) ? " udr" : "",
-			 (tmp & UDCCR_UDA) ? " uda" : "",
-			 (tmp & UDCCR_UDE) ? " ude" : "",
-			 (tmp & UDCCR_ACN) >> UDCCR_ACN_S,
-			 (tmp & UDCCR_AIN) >> UDCCR_AIN_S,
-			 (tmp & UDCCR_AAISN) >> UDCCR_AAISN_S);
+	seq_printf(s,
+		   "udccr=0x%0x(%s%s%s%s%s%s%s%s%s%s), con=%d,inter=%d,altinter=%d\n",
+		   tmp,
+		   (tmp & UDCCR_OEN) ? " oen":"",
+		   (tmp & UDCCR_AALTHNP) ? " aalthnp":"",
+		   (tmp & UDCCR_AHNP) ? " rem" : "",
+		   (tmp & UDCCR_BHNP) ? " rstir" : "",
+		   (tmp & UDCCR_DWRE) ? " dwre" : "",
+		   (tmp & UDCCR_SMAC) ? " smac" : "",
+		   (tmp & UDCCR_EMCE) ? " emce" : "",
+		   (tmp & UDCCR_UDR) ? " udr" : "",
+		   (tmp & UDCCR_UDA) ? " uda" : "",
+		   (tmp & UDCCR_UDE) ? " ude" : "",
+		   (tmp & UDCCR_ACN) >> UDCCR_ACN_S,
+		   (tmp & UDCCR_AIN) >> UDCCR_AIN_S,
+		   (tmp & UDCCR_AAISN) >> UDCCR_AAISN_S);
 	/* registers for device and ep0 */
-	pos += seq_printf(s, "udcicr0=0x%08x udcicr1=0x%08x\n",
-			udc_readl(udc, UDCICR0), udc_readl(udc, UDCICR1));
-	pos += seq_printf(s, "udcisr0=0x%08x udcisr1=0x%08x\n",
-			udc_readl(udc, UDCISR0), udc_readl(udc, UDCISR1));
-	pos += seq_printf(s, "udcfnr=%d\n", udc_readl(udc, UDCFNR));
-	pos += seq_printf(s, "irqs: reset=%lu, suspend=%lu, resume=%lu, "
-			"reconfig=%lu\n",
-			udc->stats.irqs_reset, udc->stats.irqs_suspend,
-			udc->stats.irqs_resume, udc->stats.irqs_reconfig);
-
-	ret = 0;
-out:
-	return ret;
+	seq_printf(s, "udcicr0=0x%08x udcicr1=0x%08x\n",
+		   udc_readl(udc, UDCICR0), udc_readl(udc, UDCICR1));
+	seq_printf(s, "udcisr0=0x%08x udcisr1=0x%08x\n",
+		   udc_readl(udc, UDCISR0), udc_readl(udc, UDCISR1));
+	seq_printf(s, "udcfnr=%d\n", udc_readl(udc, UDCFNR));
+	seq_printf(s, "irqs: reset=%lu, suspend=%lu, resume=%lu, reconfig=%lu\n",
+		   udc->stats.irqs_reset, udc->stats.irqs_suspend,
+		   udc->stats.irqs_resume, udc->stats.irqs_reconfig);
+
+	return 0;
 }
 
 static int queues_dbg_show(struct seq_file *s, void *p)
@@ -144,75 +140,67 @@ static int queues_dbg_show(struct seq_fi
 	struct pxa_udc *udc = s->private;
 	struct pxa_ep *ep;
 	struct pxa27x_request *req;
-	int pos = 0, i, maxpkt, ret;
+	int i, maxpkt;
 
-	ret = -ENODEV;
 	if (!udc->driver)
-		goto out;
+		return -ENODEV;
 
 	/* dump endpoint queues */
 	for (i = 0; i < NR_PXA_ENDPOINTS; i++) {
 		ep = &udc->pxa_ep[i];
 		maxpkt = ep->fifo_size;
-		pos += seq_printf(s,  "%-12s max_pkt=%d %s\n",
-				EPNAME(ep), maxpkt, "pio");
+		seq_printf(s,  "%-12s max_pkt=%d %s\n",
+			   EPNAME(ep), maxpkt, "pio");
 
 		if (list_empty(&ep->queue)) {
-			pos += seq_printf(s, "\t(nothing queued)\n");
+			seq_puts(s, "\t(nothing queued)\n");
 			continue;
 		}
 
 		list_for_each_entry(req, &ep->queue, queue) {
-			pos += seq_printf(s,  "\treq %p len %d/%d buf %p\n",
-					&req->req, req->req.actual,
-					req->req.length, req->req.buf);
+			seq_printf(s,  "\treq %p len %d/%d buf %p\n",
+				   &req->req, req->req.actual,
+				   req->req.length, req->req.buf);
 		}
 	}
 
-	ret = 0;
-out:
-	return ret;
+	return 0;
 }
 
 static int eps_dbg_show(struct seq_file *s, void *p)
 {
 	struct pxa_udc *udc = s->private;
 	struct pxa_ep *ep;
-	int pos = 0, i, ret;
+	int i;
 	u32 tmp;
 
-	ret = -ENODEV;
 	if (!udc->driver)
-		goto out;
+		return -ENODEV;
 
 	ep = &udc->pxa_ep[0];
 	tmp = udc_ep_readl(ep, UDCCSR);
-	pos += seq_printf(s, "udccsr0=0x%03x(%s%s%s%s%s%s%s)\n", tmp,
-			 (tmp & UDCCSR0_SA) ? " sa" : "",
-			 (tmp & UDCCSR0_RNE) ? " rne" : "",
-			 (tmp & UDCCSR0_FST) ? " fst" : "",
-			 (tmp & UDCCSR0_SST) ? " sst" : "",
-			 (tmp & UDCCSR0_DME) ? " dme" : "",
-			 (tmp & UDCCSR0_IPR) ? " ipr" : "",
-			 (tmp & UDCCSR0_OPC) ? " opc" : "");
+	seq_printf(s, "udccsr0=0x%03x(%s%s%s%s%s%s%s)\n",
+		   tmp,
+		   (tmp & UDCCSR0_SA) ? " sa" : "",
+		   (tmp & UDCCSR0_RNE) ? " rne" : "",
+		   (tmp & UDCCSR0_FST) ? " fst" : "",
+		   (tmp & UDCCSR0_SST) ? " sst" : "",
+		   (tmp & UDCCSR0_DME) ? " dme" : "",
+		   (tmp & UDCCSR0_IPR) ? " ipr" : "",
+		   (tmp & UDCCSR0_OPC) ? " opc" : "");
 	for (i = 0; i < NR_PXA_ENDPOINTS; i++) {
 		ep = &udc->pxa_ep[i];
 		tmp = i? udc_ep_readl(ep, UDCCR) : udc_readl(udc, UDCCR);
-		pos += seq_printf(s, "%-12s: "
-				"IN %lu(%lu reqs), OUT %lu(%lu reqs), "
-				"irqs=%lu, udccr=0x%08x, udccsr=0x%03x, "
-				"udcbcr=%d\n",
-				EPNAME(ep),
-				ep->stats.in_bytes, ep->stats.in_ops,
-				ep->stats.out_bytes, ep->stats.out_ops,
-				ep->stats.irqs,
-				tmp, udc_ep_readl(ep, UDCCSR),
-				udc_ep_readl(ep, UDCBCR));
+		seq_printf(s, "%-12s: IN %lu(%lu reqs), OUT %lu(%lu reqs), irqs=%lu, udccr=0x%08x, udccsr=0x%03x, udcbcr=%d\n",
+			   EPNAME(ep),
+			   ep->stats.in_bytes, ep->stats.in_ops,
+			   ep->stats.out_bytes, ep->stats.out_ops,
+			   ep->stats.irqs,
+			   tmp, udc_ep_readl(ep, UDCCSR),
+			   udc_ep_readl(ep, UDCBCR));
 	}
 
-	ret = 0;
-out:
-	return ret;
+	return 0;
 }
 
 static int eps_dbg_open(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from joe@perches.com are

staging-lustre-convert-return-seq_printf-uses.patch
staging-lustre-convert-seq_-hash-functions-to-return-void.patch
staging-lustre-convert-uses-of-int-rc-=-seq_printf.patch
staging-lustre-convert-remaining-uses-of-=-seq_printf.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
pxa27x_udc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
staging-i2o-remove-use-of-seq_printf-return-value.patch
staging-rtl8192x-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
regulator-dbx500-remove-use-of-seq_puts-seq_printf-return-value.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
linux-next.patch

