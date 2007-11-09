From: akpm@linux-foundation.org
Subject: + dmaengine-fix-broken-device-refcounting.patch added to -mm tree
Date: Fri, 09 Nov 2007 13:54:27 -0800
Message-ID: <200711092154.lA9LsRT7001242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754740AbXKIVyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 16:54:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, dan.j.williams@intel.com, shannon.nelson@intel.com, stable@kernel.org


The patch titled
     dmaengine: fix broken device refcounting
has been added to the -mm tree.  Its filename is
     dmaengine-fix-broken-device-refcounting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dmaengine: fix broken device refcounting
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

When a DMA device is unregistered, its reference count is decremented twice
for each channel: Once dma_class_dev_release() and once in
dma_chan_cleanup().  This may result in the DMA device driver's remove()
function completing before all channels have been cleaned up, causing lots
of use-after-free fun.

Fix it by incrementing the device's reference count twice for each
channel during registration.

[dan.j.williams@intel.com: kill unnecessary client refcounting]
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmaengine.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff -puN drivers/dma/dmaengine.c~dmaengine-fix-broken-device-refcounting drivers/dma/dmaengine.c
--- a/drivers/dma/dmaengine.c~dmaengine-fix-broken-device-refcounting
+++ a/drivers/dma/dmaengine.c
@@ -183,10 +183,9 @@ static void dma_client_chan_alloc(struct
 				/* we are done once this client rejects
 				 * an available resource
 				 */
-				if (ack == DMA_ACK) {
+				if (ack == DMA_ACK)
 					dma_chan_get(chan);
-					kref_get(&device->refcount);
-				} else if (ack == DMA_NAK)
+				else if (ack == DMA_NAK)
 					return;
 			}
 		}
@@ -273,11 +272,8 @@ static void dma_clients_notify_removed(s
 		/* client was holding resources for this channel so
 		 * free it
 		 */
-		if (ack == DMA_ACK) {
+		if (ack == DMA_ACK)
 			dma_chan_put(chan);
-			kref_put(&chan->device->refcount,
-				dma_async_device_cleanup);
-		}
 	}
 
 	mutex_unlock(&dma_list_mutex);
@@ -317,11 +313,8 @@ void dma_async_client_unregister(struct 
 			ack = client->event_callback(client, chan,
 				DMA_RESOURCE_REMOVED);
 
-			if (ack == DMA_ACK) {
+			if (ack == DMA_ACK)
 				dma_chan_put(chan);
-				kref_put(&chan->device->refcount,
-					dma_async_device_cleanup);
-			}
 		}
 
 	list_del(&client->global_node);
@@ -398,6 +391,8 @@ int dma_async_device_register(struct dma
 			goto err_out;
 		}
 
+		/* One for the channel, one of the class device */
+		kref_get(&device->refcount);
 		kref_get(&device->refcount);
 		kref_init(&chan->refcount);
 		chan->slow_ref = 0;
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

dmaengine-fix-broken-device-refcounting.patch
git-avr32.patch
git-mtd.patch
read_current_time-cleanups.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-avr32.patch
