From: akpm@linux-foundation.org
Subject: + dma-debug-add-comment-for-failed-to-check-map-error.patch added to -mm tree
Date: Tue, 17 Jan 2017 14:37:10 -0800
Message-ID: <587e9c96.TzT7Z4kZRtptoglE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47134 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdAQWhh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 17:37:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miles.chen@mediatek.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: add comment for failed to check map error
has been added to the -mm tree.  Its filename is
     dma-debug-add-comment-for-failed-to-check-map-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-add-comment-for-failed-to-check-map-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-add-comment-for-failed-to-check-map-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

dma-debug-add-comment-for-failed-to-check-map-error.patch

