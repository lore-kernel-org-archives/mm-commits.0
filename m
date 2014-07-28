From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-update-comments-for-get-set_pfnblock_flags_mask.patch removed from -mm
 tree
Date: Mon, 28 Jul 2014 15:29:21 -0700
Message-ID: <53d6cec1.LtS590n3GnRXV/CH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:56806 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaG1W3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jul 2014 18:29:22 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so1983250pdj.2
        for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2014 15:29:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: h.huangqiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: update comments for get/set_pfnblock_flags_mask
has been removed from the -mm tree.  Its filename was
     mm-update-comments-for-get-set_pfnblock_flags_mask.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Qiang Huang <h.huangqiang@huawei.com>
Subject: mm/page_alloc.c: update comments for get/set_pfnblock_flags_mask

These two functions changed many times and the comments are out of date.

Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-update-comments-for-get-set_pfnblock_flags_mask mm/page_alloc.c
--- a/mm/page_alloc.c~mm-update-comments-for-get-set_pfnblock_flags_mask
+++ a/mm/page_alloc.c
@@ -6059,10 +6059,11 @@ static inline int pfn_to_bitidx(struct z
 }
 
 /**
- * get_pageblock_flags_group - Return the requested group of flags for the pageblock_nr_pages block of pages
+ * get_pfnblock_flags_mask - Return the requested group of flags for the pageblock_nr_pages block of pages
  * @page: The page within the block of interest
- * @start_bitidx: The first bit of interest to retrieve
+ * @pfn: Page Number of the page
  * @end_bitidx: The last bit of interest
+ * @mask: The mask for flags
  * returns pageblock_bits flags
  */
 unsigned long get_pfnblock_flags_mask(struct page *page, unsigned long pfn,
@@ -6088,9 +6089,10 @@ unsigned long get_pfnblock_flags_mask(st
 /**
  * set_pfnblock_flags_mask - Set the requested group of flags for a pageblock_nr_pages block of pages
  * @page: The page within the block of interest
- * @start_bitidx: The first bit of interest
- * @end_bitidx: The last bit of interest
  * @flags: The flags to set
+ * @pfn: Page Number of the page
+ * @end_bitidx: The last bit of interest
+ * @mask: The mask for flags
  */
 void set_pfnblock_flags_mask(struct page *page, unsigned long flags,
 					unsigned long pfn,
_

Patches currently in -mm which might be from h.huangqiang@huawei.com are


