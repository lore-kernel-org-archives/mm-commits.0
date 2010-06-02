From: akpm@linux-foundation.org
Subject: + cdc-acm-fix-resource-reclaim-in-error-path-of-acm_probe.patch added to -mm tree
Date: Wed, 02 Jun 2010 14:15:32 -0700
Message-ID: <201006022115.o52LFWiK017371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166Ab0FBVPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 17:15:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, greg@kroah.com, oneukum@suse.de


The patch titled
     cdc-acm: fix resource reclaim in error path of acm_probe
has been added to the -mm tree.  Its filename is
     cdc-acm-fix-resource-reclaim-in-error-path-of-acm_probe.patch

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
Subject: cdc-acm: fix resource reclaim in error path of acm_probe
From: Axel Lin <axel.lin@gmail.com>

Fix resource reclaim in the error path of acm_probe:

1. In the case of "out of memory (read urbs usb_alloc_urb)\n")", there
   is no need to call acm_read_buffers_free(acm) here.

   Fix it by goto alloc_fail6 instead of alloc_fail7.

2. In the case of "out of memory (write urbs usb_alloc_urb)",
   usb_alloc_urb may fail in any iteration of the for loop.  Current
   implementation does not properly free allocated snd->urb.

   Fix it by goto alloc_fail8 instead of alloc_fail7.

3. In the case of
   device_create_file(&intf->dev,&dev_attr_iCountryCodeRelDate) fail,
   acm->country_codes is kfreed.  As a result, device_remove_file for
   dev_attr_wCountryCodes will not be executed in acm_disconnect.

   Fix it by calling device_remove_file for dev_attr_wCountryCodes
   before goto skip_countries.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/class/cdc-acm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/usb/class/cdc-acm.c~cdc-acm-fix-resource-reclaim-in-error-path-of-acm_probe drivers/usb/class/cdc-acm.c
--- a/drivers/usb/class/cdc-acm.c~cdc-acm-fix-resource-reclaim-in-error-path-of-acm_probe
+++ a/drivers/usb/class/cdc-acm.c
@@ -1201,7 +1201,7 @@ made_compressed_probe:
 		if (rcv->urb == NULL) {
 			dev_dbg(&intf->dev,
 				"out of memory (read urbs usb_alloc_urb)\n");
-			goto alloc_fail7;
+			goto alloc_fail6;
 		}
 
 		rcv->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -1225,7 +1225,7 @@ made_compressed_probe:
 		if (snd->urb == NULL) {
 			dev_dbg(&intf->dev,
 				"out of memory (write urbs usb_alloc_urb)");
-			goto alloc_fail7;
+			goto alloc_fail8;
 		}
 
 		if (usb_endpoint_xfer_int(epwrite))
@@ -1264,6 +1264,7 @@ made_compressed_probe:
 		i = device_create_file(&intf->dev,
 						&dev_attr_iCountryCodeRelDate);
 		if (i < 0) {
+			device_remove_file(&intf->dev, &dev_attr_wCountryCodes);
 			kfree(acm->country_codes);
 			goto skip_countries;
 		}
@@ -1300,6 +1301,7 @@ alloc_fail8:
 		usb_free_urb(acm->wb[i].urb);
 alloc_fail7:
 	acm_read_buffers_free(acm);
+alloc_fail6:
 	for (i = 0; i < num_rx_buf; i++)
 		usb_free_urb(acm->ru[i].urb);
 	usb_free_urb(acm->ctrlurb);
_

Patches currently in -mm which might be from axel.lin@gmail.com are

intel_menlow-fix-memory-leaks-in-error-path.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
cdc-acm-fix-resource-reclaim-in-error-path-of-acm_probe.patch

