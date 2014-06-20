From: akpm@linux-foundation.org
Subject: + mm-update-comments-for-get-set_pfnblock_flags_mask.patch added
 to -mm tree
Date: Fri, 20 Jun 2014 15:15:35 -0700
Message-ID: <53a4b287.6MY6rSzEbY5OHjmk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965046AbaFTWPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:15:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, h.huangqiang@huawei.com


The patch titled
     Subject: mm/page_alloc.c: update comments for get/set_pfnblock_flags_mask
has been added to the -mm tree.  Its filename is
     mm-update-comments-for-get-set_pfnblock_flags_mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-update-comments-for-get-set_pfnblock_flags_mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-update-comments-for-get-set_pfnblock_flags_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -6045,10 +6045,11 @@ static inline int pfn_to_bitidx(struct z
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
@@ -6074,9 +6075,10 @@ unsigned long get_pfnblock_flags_mask(st
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

mm-update-comments-for-get-set_pfnblock_flags_mask.patch

