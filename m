From: akpm@linux-foundation.org
Subject: - usbhid-fix.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:53:09 -0700
Message-ID: <200708060753.l767r9d3016313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59831 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754726AbXHFHx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:53:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jikos@jikos.cz, mm-commits@vger.kernel.org


The patch titled
     usbhid fix
has been removed from the -mm tree.  Its filename was
     usbhid-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usbhid fix
From: Jiri Kosina <jikos@jikos.cz>

(CCs adjusted)

On Wed, 1 Aug 2007, Andrew Morton wrote:

> > usb 2-1: USB disconnect, address 2
> > BUG: atomic counter underflow at:
> >  [<c010456a>] show_trace_log_lvl+0x1a/0x30
> >  [<c010508d>] show_trace+0x12/0x14
> >  [<c01051e0>] dump_stack+0x15/0x17
> >  [<c01418cf>] __free_pages+0x50/0x52
> >  [<c01418f0>] free_pages+0x1f/0x21
> >  [<c010783d>] dma_free_coherent+0x43/0x9c
> >  [<c0315067>] hcd_buffer_free+0x43/0x6a
> >  [<c030b2b4>] usb_buffer_free+0x23/0x29
> >  [<c0346db4>] hid_free_buffers+0x23/0x71
> >  [<c0346eb2>] hid_disconnect+0xb0/0xc8
> >  [<c0313676>] usb_unbind_interface+0x30/0x72
> >  [<c02c6df0>] __device_release_driver+0x6a/0x92
> >  [<c02c71c3>] device_release_driver+0x20/0x36
> >  [<c02c6736>] bus_remove_device+0x62/0x85
> >  [<c02c49f8>] device_del+0x16d/0x27c
> >  [<c0310f25>] usb_disable_device+0x7a/0xe2
> >  [<c030d0bc>] usb_disconnect+0x94/0xde
> >  [<c030e030>] hub_thread+0x2fe/0xc1b
> >  [<c0128aee>] kthread+0x36/0x58
> >  [<c0104233>] kernel_thread_helper+0x7/0x14
> >  =======================
> > uhci_hcd 0000:00:0c.0: dma_pool_free buffer-32, 6b6b6b6b/6b6b6b6b (bad dma)

Mariusz,

I guess the patch below (which I have just added to my tree) fixes that,
right? Thanks.

index 6e73934..0a1f2b5 100644

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/hid-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/hid/usbhid/hid-core.c~usbhid-fix drivers/hid/usbhid/hid-core.c
--- a/drivers/hid/usbhid/hid-core.c~usbhid-fix
+++ a/drivers/hid/usbhid/hid-core.c
@@ -912,9 +912,9 @@ fail:
 	usb_free_urb(usbhid->urbin);
 	usb_free_urb(usbhid->urbout);
 	usb_free_urb(usbhid->urbctrl);
+	hid_free_buffers(dev, hid);
 	kfree(usbhid);
 fail_no_usbhid:
-	hid_free_buffers(dev, hid);
 	hid_free_device(hid);
 
 	return NULL;
@@ -950,9 +950,9 @@ static void hid_disconnect(struct usb_in
 	usb_free_urb(usbhid->urbin);
 	usb_free_urb(usbhid->urbctrl);
 	usb_free_urb(usbhid->urbout);
-	kfree(usbhid);
 
 	hid_free_buffers(hid_to_usb_dev(hid), hid);
+	kfree(usbhid);
 	hid_free_device(hid);
 }
 
_

Patches currently in -mm which might be from jikos@jikos.cz are
