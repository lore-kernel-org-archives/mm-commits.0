From: akpm@linux-foundation.org
Subject: + dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix.patch added to -mm tree
Date: Tue, 23 Oct 2012 16:06:40 -0700
Message-ID: <20121023230641.225411E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:52362 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933464Ab2JWXGm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 19:06:42 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so552837ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 16:06:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shuah.khan@hp.com, jj@chaosbits.net, konrad.wilk@oracle.com


The patch titled
     Subject: Documentation/DMA-API-HOWTO.txt: add dma mapping error check usage examples
has been added to the -mm tree.  Its filename is
     dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shuah Khan <shuah.khan@hp.com>
Subject: Documentation/DMA-API-HOWTO.txt: add dma mapping error check usage examples

Enhance the document to discuss the importance of dma mapping error checks
after dma_map_single() and dma_map_page() calls.  Also added usage
examples that include unmap examples in error paths when dma mapping error
is returned.  Includes correct and incorrect usages to high light some
common mistakes in error paths especially when dma mapping fails when more
than one dma mapping call is made.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API-HOWTO.txt |  126 ++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff -puN Documentation/DMA-API-HOWTO.txt~dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix Documentation/DMA-API-HOWTO.txt
--- a/Documentation/DMA-API-HOWTO.txt~dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix
+++ a/Documentation/DMA-API-HOWTO.txt
@@ -468,11 +468,46 @@ To map a single region, you do:
 	size_t size = buffer->len;
 
 	dma_handle = dma_map_single(dev, addr, size, direction);
+	if (dma_mapping_error(dma_handle)) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+		goto map_error_handling;
+	}
 
 and to unmap it:
 
 	dma_unmap_single(dev, dma_handle, size, direction);
 
+You should call dma_mapping_error() as dma_map_single() could fail and return
+error. Not all dma implementations support dma_mapping_error() interface.
+However, it is a good practice to call dma_mapping_error() interface, which
+will invoke the generic mapping error check interface. Doing so will ensure
+that the mapping code will work correctly on all dma implementations without
+any dependency on the specifics of the underlying implementation. Using the
+returned address without checking for errors could result in failures ranging
+from panics to silent data corruption. Couple of example of incorrect ways to
+check for errors that make assumptions about the underlying dma implementation
+are as follows and these are applicable to dma_map_page() as well.
+
+Incorrect example 1:
+	dma_addr_t dma_handle;
+
+	dma_handle = dma_map_single(dev, addr, size, direction);
+	if ((dma_handle & 0xffff != 0) || (dma_handle >= 0x1000000)) {
+		goto map_error;
+	}
+
+Incorrect example 2:
+	dma_addr_t dma_handle;
+
+	dma_handle = dma_map_single(dev, addr, size, direction);
+	if (dma_handle == DMA_ERROR_CODE) {
+		goto map_error;
+	}
+
 You should call dma_unmap_single when the DMA activity is finished, e.g.
 from the interrupt which told you that the DMA transfer is done.
 
@@ -489,6 +524,14 @@ Specifically:
 	size_t size = buffer->len;
 
 	dma_handle = dma_map_page(dev, page, offset, size, direction);
+	if (dma_mapping_error(dma_handle)) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+		goto map_error_handling;
+	}
 
 	...
 
@@ -496,6 +539,12 @@ Specifically:
 
 Here, "offset" means byte offset within the given page.
 
+You should call dma_mapping_error() as dma_map_page() could fail and return
+error as outlined under the dma_map_single() discussion.
+
+You should call dma_unmap_page when the DMA activity is finished, e.g.
+from the interrupt which told you that the DMA transfer is done.
+
 With scatterlists, you map a region gathered from several regions by:
 
 	int i, count = dma_map_sg(dev, sglist, nents, direction);
@@ -578,6 +627,14 @@ to use the dma_sync_*() interfaces.
 		dma_addr_t mapping;
 
 		mapping = dma_map_single(cp->dev, buffer, len, DMA_FROM_DEVICE);
+		if (dma_mapping_error(dma_handle)) {
+			/*
+			 * reduce current DMA mapping usage,
+			 * delay and try again later or
+			 * reset driver.
+			 */
+			goto map_error_handling;
+		}
 
 		cp->rx_buf = buffer;
 		cp->rx_len = len;
@@ -658,6 +715,75 @@ failure can be determined by:
 		 * delay and try again later or
 		 * reset driver.
 		 */
+		goto map_error_handling;
+	}
+
+- unmap pages that are already mapped, when mapping error occurs in the middle
+  of a multiple page mapping attempt. These example are applicable to
+  dma_map_page() as well.
+
+Example 1:
+	dma_addr_t dma_handle1;
+	dma_addr_t dma_handle2;
+
+	dma_handle1 = dma_map_single(dev, addr, size, direction);
+	if (dma_mapping_error(dev, dma_handle1)) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+		goto map_error_handling1;
+	}
+	dma_handle2 = dma_map_single(dev, addr, size, direction);
+	if (dma_mapping_error(dev, dma_handle2)) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+		goto map_error_handling2;
+	}
+
+	...
+
+	map_error_handling2:
+		dma_unmap_single(dma_handle1);
+	map_error_handling1:
+
+Example 2: (if buffers are allocated a loop, unmap all mapped buffers when
+	    mapping error is detected in the middle)
+
+	dma_addr_t dma_addr;
+	dma_addr_t array[DMA_BUFFERS];
+	int save_index = 0;
+
+	for (i = 0; i < DMA_BUFFERS; i++) {
+
+		...
+
+		dma_addr = dma_map_single(dev, addr, size, direction);
+		if (dma_mapping_error(dev, dma_addr)) {
+			/*
+			 * reduce current DMA mapping usage,
+			 * delay and try again later or
+			 * reset driver.
+			 */
+			goto map_error_handling;
+		}
+		array[i].dma_addr = dma_addr;
+		save_index++;
+	}
+
+	...
+
+	map_error_handling:
+
+	for (i = 0; i < save_index; i++) {
+
+		...
+
+		dma_unmap_single(array[i].dma_addr);
 	}
 
 Networking drivers must call dev_kfree_skb to free the socket buffer
_

Patches currently in -mm which might be from shuah.khan@hp.com are

linux-next.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch

