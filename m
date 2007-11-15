From: akpm@linux-foundation.org
Subject: - dmaengine-fix-broken-device-refcounting.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:09:25 -0800
Message-ID: <200711152109.lAFL9PJJ015442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46805 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932444AbXKOVSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:18:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, dan.j.williams@intel.com, shannon.nelson@intel.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     dmaengine: fix broken device refcounting
has been removed from the -mm tree.  Its filename was
     dmaengine-fix-broken-device-refcounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -182,10 +182,9 @@ static void dma_client_chan_alloc(struct
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
@@ -272,11 +271,8 @@ static void dma_clients_notify_removed(s
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
@@ -316,11 +312,8 @@ void dma_async_client_unregister(struct 
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
@@ -397,6 +390,8 @@ int dma_async_device_register(struct dma
 			goto err_out;
 		}
 
+		/* One for the channel, one of the class device */
+		kref_get(&device->refcount);
 		kref_get(&device->refcount);
 		kref_init(&chan->refcount);
 		chan->slow_ref = 0;
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
git-avr32.patch
git-mtd.patch
read_current_time-cleanups.patch
generic-gpio-gpio_chip-support.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-avr32.patch
