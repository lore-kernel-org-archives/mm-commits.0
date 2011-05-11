From: akpm@linux-foundation.org
Subject: + dma-debug-print-information-about-leaked-entry.patch added to -mm tree
Date: Tue, 10 May 2011 17:13:26 -0700
Message-ID: <201105110013.p4B0DQWO031209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746Ab1EKANc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 May 2011 20:13:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, joerg.roedel@amd.com


The patch titled
     dma-debug: print information about leaked entry
has been added to the -mm tree.  Its filename is
     dma-debug-print-information-about-leaked-entry.patch

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
Subject: dma-debug: print information about leaked entry
From: Stanislaw Gruszka <sgruszka@redhat.com>

When a driver leaks a dma mapping, print additional information about one
of the leaked entries to help investigation.  The patch should be useful
for debugging drivers, which map many different class of buffers.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-print-information-about-leaked-entry lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-print-information-about-leaked-entry
+++ a/lib/dma-debug.c
@@ -649,7 +649,7 @@ out_err:
 	return -ENOMEM;
 }
 
-static int device_dma_allocations(struct device *dev)
+static int device_dma_allocations(struct device *dev, struct dma_debug_entry **out_entry)
 {
 	struct dma_debug_entry *entry;
 	unsigned long flags;
@@ -660,8 +660,10 @@ static int device_dma_allocations(struct
 	for (i = 0; i < HASH_SIZE; ++i) {
 		spin_lock(&dma_entry_hash[i].lock);
 		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
-			if (entry->dev == dev)
+			if (entry->dev == dev) {
 				count += 1;
+				*out_entry = entry;
+			}
 		}
 		spin_unlock(&dma_entry_hash[i].lock);
 	}
@@ -674,6 +676,7 @@ static int device_dma_allocations(struct
 static int dma_debug_device_change(struct notifier_block *nb, unsigned long action, void *data)
 {
 	struct device *dev = data;
+	struct dma_debug_entry *uninitialized_var(entry);
 	int count;
 
 	if (global_disable)
@@ -681,12 +684,17 @@ static int dma_debug_device_change(struc
 
 	switch (action) {
 	case BUS_NOTIFY_UNBOUND_DRIVER:
-		count = device_dma_allocations(dev);
+		count = device_dma_allocations(dev, &entry);
 		if (count == 0)
 			break;
-		err_printk(dev, NULL, "DMA-API: device driver has pending "
+		err_printk(dev, entry, "DMA-API: device driver has pending "
 				"DMA allocations while released from device "
-				"[count=%d]\n", count);
+				"[count=%d]\n"
+				"One of leaked entries details: "
+				"[device address=0x%016llx] [size=%llu bytes] "
+				"[mapped with %s] [mapped as %s]\n",
+			count, entry->dev_addr, entry->size,
+			dir2name[entry->direction], type2name[entry->type]);
 		break;
 	default:
 		break;
_

Patches currently in -mm which might be from sgruszka@redhat.com are

linux-next.patch
dma-debug-print-information-about-leaked-entry.patch

