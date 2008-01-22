From: akpm@linux-foundation.org
Subject: + usb-dma-bounce-buffer-support-v3.patch added to -mm tree
Date: Mon, 21 Jan 2008 21:03:35 -0800
Message-ID: <200801220503.m0M53FY7005552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59667 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbYAVFD1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 00:03:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, damm@igel.co.jp, greg@kroah.com, stern@rowland.harvard.edu


The patch titled
     usb: dma bounce buffer support
has been added to the -mm tree.  Its filename is
     usb-dma-bounce-buffer-support-v3.patch

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
Subject: usb: dma bounce buffer support
From: Magnus Damm <magnus.damm@gmail.com>

Add dma bounce buffer support to the usb core.  These buffers can be
enabled with the HCD_LOCAL_MEM flag, and they make sure that all data
passed to the host controller is allocated using dma_alloc_coherent().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/buffer.c |    9 +-
 drivers/usb/core/hcd.c    |  134 ++++++++++++++++++++++++++++++------
 drivers/usb/core/hcd.h    |    1 
 3 files changed, 122 insertions(+), 22 deletions(-)

diff -puN drivers/usb/core/buffer.c~usb-dma-bounce-buffer-support-v3 drivers/usb/core/buffer.c
--- a/drivers/usb/core/buffer.c~usb-dma-bounce-buffer-support-v3
+++ a/drivers/usb/core/buffer.c
@@ -53,7 +53,8 @@ int hcd_buffer_create(struct usb_hcd *hc
 	char		name[16];
 	int 		i, size;
 
-	if (!hcd->self.controller->dma_mask)
+	if (!hcd->self.controller->dma_mask &&
+	    !(hcd->driver->flags & HCD_LOCAL_MEM))
 		return 0;
 
 	for (i = 0; i < HCD_BUFFER_POOLS; i++) { 
@@ -107,7 +108,8 @@ void *hcd_buffer_alloc(
 	int 			i;
 
 	/* some USB hosts just use PIO */
-	if (!bus->controller->dma_mask) {
+	if (!bus->controller->dma_mask &&
+	    !(hcd->driver->flags & HCD_LOCAL_MEM)) {
 		*dma = ~(dma_addr_t) 0;
 		return kmalloc(size, mem_flags);
 	}
@@ -132,7 +134,8 @@ void hcd_buffer_free(
 	if (!addr)
 		return;
 
-	if (!bus->controller->dma_mask) {
+	if (!bus->controller->dma_mask &&
+	    !(hcd->driver->flags & HCD_LOCAL_MEM)) {
 		kfree(addr);
 		return;
 	}
diff -puN drivers/usb/core/hcd.c~usb-dma-bounce-buffer-support-v3 drivers/usb/core/hcd.c
--- a/drivers/usb/core/hcd.c~usb-dma-bounce-buffer-support-v3
+++ a/drivers/usb/core/hcd.c
@@ -35,6 +35,7 @@
 #include <linux/mutex.h>
 #include <asm/irq.h>
 #include <asm/byteorder.h>
+#include <asm/unaligned.h>
 #include <linux/platform_device.h>
 #include <linux/workqueue.h>
 
@@ -1112,48 +1113,137 @@ void usb_hcd_unlink_urb_from_ep(struct u
 }
 EXPORT_SYMBOL_GPL(usb_hcd_unlink_urb_from_ep);
 
-static void map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
+static int hcd_alloc_coherent(struct usb_bus *bus,
+			      gfp_t mem_flags, dma_addr_t *dma_handle,
+			      void **vaddr_handle, size_t size,
+			      enum dma_data_direction dir)
 {
+	unsigned char *vaddr;
+
+	vaddr = hcd_buffer_alloc(bus, size + sizeof(vaddr),
+				 mem_flags, dma_handle);
+	if (!vaddr)
+		return -ENOMEM;
+
+	put_unaligned((unsigned long)*vaddr_handle,
+		      (unsigned long *)(vaddr + size));
+
+	if (dir == DMA_TO_DEVICE)
+		memcpy(vaddr, *vaddr_handle, size);
+
+	*vaddr_handle = vaddr;
+	return 0;
+}
+
+static void hcd_free_coherent(struct usb_bus *bus, dma_addr_t *dma_handle,
+			      void **vaddr_handle, size_t size,
+			      enum dma_data_direction dir)
+{
+	unsigned char *vaddr = *vaddr_handle;
+
+	vaddr = (void *)get_unaligned((unsigned long *)(vaddr + size));
+
+	if (dir == DMA_FROM_DEVICE)
+		memcpy(vaddr, *vaddr_handle, size);
+
+	hcd_buffer_free(bus, size + sizeof(vaddr), *vaddr_handle, *dma_handle);
+
+	*vaddr_handle = vaddr;
+	*dma_handle = 0;
+}
+
+static int map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
+			   gfp_t mem_flags)
+{
+	enum dma_data_direction dir;
+	int ret = 0;
+
 	/* Map the URB's buffers for DMA access.
 	 * Lower level HCD code should use *_dma exclusively,
 	 * unless it uses pio or talks to another transport.
 	 */
-	if (hcd->self.uses_dma && !is_root_hub(urb->dev)) {
-		if (usb_endpoint_xfer_control(&urb->ep->desc)
-			&& !(urb->transfer_flags & URB_NO_SETUP_DMA_MAP))
-			urb->setup_dma = dma_map_single (
+	if (is_root_hub(urb->dev))
+		return 0;
+
+	if (usb_endpoint_xfer_control(&urb->ep->desc)
+	    && !(urb->transfer_flags & URB_NO_SETUP_DMA_MAP)) {
+		if (hcd->self.uses_dma)
+			urb->setup_dma = dma_map_single(
 					hcd->self.controller,
 					urb->setup_packet,
 					sizeof (struct usb_ctrlrequest),
 					DMA_TO_DEVICE);
-		if (urb->transfer_buffer_length != 0
-			&& !(urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP))
+		else if (hcd->driver->flags & HCD_LOCAL_MEM)
+			ret = hcd_alloc_coherent(
+					urb->dev->bus, mem_flags,
+					&urb->setup_dma,
+					(void **)&urb->setup_packet,
+					sizeof (struct usb_ctrlrequest),
+					DMA_TO_DEVICE);
+	}
+
+	dir = usb_urb_dir_in(urb) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	if (ret == 0 && urb->transfer_buffer_length != 0
+	    && !(urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP)) {
+		if (hcd->self.uses_dma)
 			urb->transfer_dma = dma_map_single (
 					hcd->self.controller,
 					urb->transfer_buffer,
 					urb->transfer_buffer_length,
-					usb_urb_dir_in(urb)
-					    ? DMA_FROM_DEVICE
-					    : DMA_TO_DEVICE);
+					dir);
+		else if (hcd->driver->flags & HCD_LOCAL_MEM) {
+			ret = hcd_alloc_coherent(
+					urb->dev->bus, mem_flags,
+					&urb->transfer_dma,
+					&urb->transfer_buffer,
+					urb->transfer_buffer_length,
+					dir);
+
+			if (ret && usb_endpoint_xfer_control(&urb->ep->desc)
+			    && !(urb->transfer_flags & URB_NO_SETUP_DMA_MAP))
+				hcd_free_coherent(urb->dev->bus,
+					&urb->setup_dma,
+					(void **)&urb->setup_packet,
+					sizeof (struct usb_ctrlrequest),
+					DMA_TO_DEVICE);
+		}
 	}
+	return ret;
 }
 
 static void unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
 {
-	if (hcd->self.uses_dma && !is_root_hub(urb->dev)) {
-		if (usb_endpoint_xfer_control(&urb->ep->desc)
-			&& !(urb->transfer_flags & URB_NO_SETUP_DMA_MAP))
+	enum dma_data_direction dir;
+
+	if (is_root_hub(urb->dev))
+		return;
+
+	if (usb_endpoint_xfer_control(&urb->ep->desc)
+	    && !(urb->transfer_flags & URB_NO_SETUP_DMA_MAP)) {
+		if (hcd->self.uses_dma)
 			dma_unmap_single(hcd->self.controller, urb->setup_dma,
 					sizeof(struct usb_ctrlrequest),
 					DMA_TO_DEVICE);
-		if (urb->transfer_buffer_length != 0
-			&& !(urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP))
+		else if (hcd->driver->flags & HCD_LOCAL_MEM)
+			hcd_free_coherent(urb->dev->bus, &urb->setup_dma,
+					(void **)&urb->setup_packet,
+					sizeof (struct usb_ctrlrequest),
+					DMA_TO_DEVICE);
+	}
+
+	dir = usb_urb_dir_in(urb) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	if (urb->transfer_buffer_length != 0
+	    && !(urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP)) {
+		if (hcd->self.uses_dma)
 			dma_unmap_single(hcd->self.controller,
 					urb->transfer_dma,
 					urb->transfer_buffer_length,
-					usb_urb_dir_in(urb)
-					    ? DMA_FROM_DEVICE
-					    : DMA_TO_DEVICE);
+					dir);
+		else if (hcd->driver->flags & HCD_LOCAL_MEM)
+			hcd_free_coherent(urb->dev->bus, &urb->transfer_dma,
+					&urb->transfer_buffer,
+					urb->transfer_buffer_length,
+					dir);
 	}
 }
 
@@ -1185,7 +1275,12 @@ int usb_hcd_submit_urb (struct urb *urb,
 	 * URBs must be submitted in process context with interrupts
 	 * enabled.
 	 */
-	map_urb_for_dma(hcd, urb);
+	status = map_urb_for_dma(hcd, urb, mem_flags);
+	if (unlikely(status)) {
+		usbmon_urb_submit_error(&hcd->self, urb, status);
+		goto error;
+	}
+
 	if (is_root_hub(urb->dev))
 		status = rh_urb_enqueue(hcd, urb);
 	else
@@ -1194,6 +1289,7 @@ int usb_hcd_submit_urb (struct urb *urb,
 	if (unlikely(status)) {
 		usbmon_urb_submit_error(&hcd->self, urb, status);
 		unmap_urb_for_dma(hcd, urb);
+ error:
 		urb->hcpriv = NULL;
 		INIT_LIST_HEAD(&urb->urb_list);
 		atomic_dec(&urb->use_count);
diff -puN drivers/usb/core/hcd.h~usb-dma-bounce-buffer-support-v3 drivers/usb/core/hcd.h
--- a/drivers/usb/core/hcd.h~usb-dma-bounce-buffer-support-v3
+++ a/drivers/usb/core/hcd.h
@@ -165,6 +165,7 @@ struct hc_driver {
 
 	int	flags;
 #define	HCD_MEMORY	0x0001		/* HC regs use memory (else I/O) */
+#define	HCD_LOCAL_MEM	0x0002		/* HC needs dma_alloc_coherent() */
 #define	HCD_USB11	0x0010		/* USB 1.1 */
 #define	HCD_USB2	0x0020		/* USB 2.0 */
 
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

usb-dma-bounce-buffer-support-v3.patch
usb-ohci-sm501-driver-v2.patch
sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
sm501fb-clear-framebuffer-memory-and-palette.patch
