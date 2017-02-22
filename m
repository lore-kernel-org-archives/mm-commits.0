From: akpm@linux-foundation.org
Subject: [patch 008/142] dma-debug: add comment for failed to check map
 error
Date: Wed, 22 Feb 2017 15:40:09 -0800
Message-ID: <58ae2159.RnjWGstE0lAB/Q89%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49898 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932880AbdBVXux (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:50:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, miles.chen@mediatek.com

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
