From: akpm@linux-foundation.org
Subject: [merged] mm-update-the-comment-in-__isolate_free_page.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:54:10 -0700
Message-ID: <579ba652.5mxEstSBlJi4VZ8O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbcG2SyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:54:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update the comment in __isolate_free_page
has been removed from the -mm tree.  Its filename was
     mm-update-the-comment-in-__isolate_free_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: mm: update the comment in __isolate_free_page

We need to assure the comment is consistent with the code.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/1466171914-21027-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-update-the-comment-in-__isolate_free_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-update-the-comment-in-__isolate_free_page
+++ a/mm/page_alloc.c
@@ -2517,7 +2517,10 @@ int __isolate_free_page(struct page *pag
 	zone->free_area[order].nr_free--;
 	rmv_page_order(page);
 
-	/* Set the pageblock if the isolated page is at least a pageblock */
+	/*
+	 * Set the pageblock if the isolated page is at least half of a
+	 * pageblock
+	 */
 	if (order >= pageblock_order - 1) {
 		struct page *endpage = page + (1 << order) - 1;
 		for (; page < endpage; page += pageblock_nr_pages) {
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch
kexec-add-restriction-on-kexec_load-segment-sizes.patch

