From: akpm@linux-foundation.org
Subject: + dma-debug-update-dma-debug-api-to-better-handle-multiple-mappings-of-a-buffer.patch added to -mm tree
Date: Tue, 19 Mar 2013 13:19:34 -0700
Message-ID: <20130319201934.DFF145A4251@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:61987 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab3CSUTg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 16:19:36 -0400
Received: by mail-vb0-f73.google.com with SMTP id fj18so86726vbb.4
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 13:19:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexander.h.duyck@intel.com, joro@8bytes.org, konrad.wilk@oracle.com, kubakici@wp.pl, shuah.khan@hp.com


The patch titled
     Subject: dma-debug: update DMA debug API to better handle multiple mappings of a buffer
has been added to the -mm tree.  Its filename is
     dma-debug-update-dma-debug-api-to-better-handle-multiple-mappings-of-a-buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Shuah Khan <shuah.khan@hp.com>
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
dma-debug-fix-locking-bug-in-check_unmap.patch
dma-debug-fix-locking-bug-in-check_unmap-fix.patch
dma-debug-update-dma-debug-api-to-better-handle-multiple-mappings-of-a-buffer.patch

