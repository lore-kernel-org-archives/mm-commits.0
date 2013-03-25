From: akpm@linux-foundation.org
Subject: [merged] dma-debug-update-dma-debug-api-to-better-handle-multiple-mappings-of-a-buffer.patch removed from -mm tree
Date: Mon, 25 Mar 2013 12:45:22 -0700
Message-ID: <20130325194522.92F3431C1E1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:56433 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab3CYTpX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 15:45:23 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so653386vcb.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 12:45:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, joro@8bytes.org, konrad.wilk@oracle.com, kubakici@wp.pl, shuah.khan@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: update DMA debug API to better handle multiple mappings of a buffer
has been removed from the -mm tree.  Its filename was
     dma-debug-update-dma-debug-api-to-better-handle-multiple-mappings-of-a-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: dma-debug: update DMA debug API to better handle multiple mappings of a buffer

There were reports of the igb driver unmapping buffers without calling
dma_mapping_error.  On closer inspection issues were found in the DMA
debug API and how it handled multiple mappings of the same buffer.

The issue I found is the fact that the debug_dma_mapping_error would only
set the map_err_type to MAP_ERR_CHECKED in the case that the was only one
match for device and device address.  However in the case of non-IOMMU,
multiple addresses existed and as a result it was not setting this field
once a second mapping was instantiated.  I have resolved this by changing
the search so that it instead will now set MAP_ERR_CHECKED on the first
buffer that matches the device and DMA address that is currently in the
state MAP_ERR_NOT_CHECKED.

A secondary side effect of this patch is that in the case of multiple
buffers using the same address only the last mapping will have a valid
map_err_type.  The previous mappings will all end up with map_err_type set
to MAP_ERR_CHECKED because of the dma_mapping_error call in
debug_dma_map_page.  However this behavior may be preferable as it means
you will likely only see one real error per multi-mapped buffer, versus
the current behavior of multiple false errors mer multi-mapped buffer.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Reviewed-by: Shuah Khan <shuah.khan@hp.com>
Tested-by: Shuah Khan <shuah.khan@hp.com>
Cc: Jakub Kicinski <kubakici@wp.pl>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-update-dma-debug-api-to-better-handle-multiple-mappings-of-a-buffer lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-update-dma-debug-api-to-better-handle-multiple-mappings-of-a-buffer
+++ a/lib/dma-debug.c
@@ -1085,13 +1085,27 @@ void debug_dma_mapping_error(struct devi
 	ref.dev = dev;
 	ref.dev_addr = dma_addr;
 	bucket = get_hash_bucket(&ref, &flags);
-	entry = bucket_find_exact(bucket, &ref);
 
-	if (!entry)
-		goto out;
+	list_for_each_entry(entry, &bucket->list, list) {
+		if (!exact_match(&ref, entry))
+			continue;
+
+		/*
+		 * The same physical address can be mapped multiple
+		 * times. Without a hardware IOMMU this results in the
+		 * same device addresses being put into the dma-debug
+		 * hash multiple times too. This can result in false
+		 * positives being reported. Therefore we implement a
+		 * best-fit algorithm here which updates the first entry
+		 * from the hash which fits the reference value and is
+		 * not currently listed as being checked.
+		 */
+		if (entry->map_err_type == MAP_ERR_NOT_CHECKED) {
+			entry->map_err_type = MAP_ERR_CHECKED;
+			break;
+		}
+	}
 
-	entry->map_err_type = MAP_ERR_CHECKED;
-out:
 	put_hash_bucket(bucket, &flags);
 }
 EXPORT_SYMBOL(debug_dma_mapping_error);
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are

linux-next.patch

