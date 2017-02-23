From: akpm@linux-foundation.org
Subject: [merged]
 dma-debug-add-comment-for-failed-to-check-map-error.patch removed from -mm
 tree
Date: Thu, 23 Feb 2017 13:11:30 -0800
Message-ID: <58af5002.B1EV8ACjKNW6s03S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38294 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdBWVLb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:11:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miles.chen@mediatek.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: add comment for failed to check map error
has been removed from the -mm tree.  Its filename was
     dma-debug-add-comment-for-failed-to-check-map-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: dma-debug: add comment for failed to check map error

Add comment for failure to check a map error to help driver developers.

Link: http://lkml.kernel.org/r/1484622289-22085-1-git-send-email-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN lib/dma-debug.c~dma-debug-add-comment-for-failed-to-check-map-error lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-add-comment-for-failed-to-check-map-error
+++ a/lib/dma-debug.c
@@ -1155,6 +1155,11 @@ static void check_unmap(struct dma_debug
 			   dir2name[ref->direction]);
 	}
 
+	/*
+	 * Drivers should use dma_mapping_error() to check the returned
+	 * addresses of dma_map_single() and dma_map_page().
+	 * If not, print this warning message. See Documentation/DMA-API.txt.
+	 */
 	if (entry->map_err_type == MAP_ERR_NOT_CHECKED) {
 		err_printk(ref->dev, entry,
 			   "DMA-API: device driver failed to check map error"
_

Patches currently in -mm which might be from miles.chen@mediatek.com are

mm-cleanups-for-printing-phys_addr_t-and-dma_addr_t.patch
checkpatch-update-logfunctions.patch

