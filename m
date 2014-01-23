From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-munlock-fix-potential-race-with-thp-page-split-fix.patch removed from
 -mm tree
Date: Thu, 23 Jan 2014 15:17:16 -0800
Message-ID: <52e1a2fc.wOxWEFVxmb+OyLu3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaAWXRR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:17:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, akpm@linux-foundation.org

Subject: [folded-merged] mm-munlock-fix-potential-race-with-thp-page-split-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:17:16 -0800


The patch titled
     Subject: mm-munlock-fix-potential-race-with-thp-page-split-fix
has been removed from the -mm tree.  Its filename was
     mm-munlock-fix-potential-race-with-thp-page-split-fix.patch

This patch was dropped because it was folded into mm-munlock-fix-potential-race-with-thp-page-split.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-munlock-fix-potential-race-with-thp-page-split-fix

avoid a coding-style ugly

Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mlock.c~mm-munlock-fix-potential-race-with-thp-page-split-fix mm/mlock.c
--- a/mm/mlock.c~mm-munlock-fix-potential-race-with-thp-page-split-fix
+++ a/mm/mlock.c
@@ -97,9 +97,9 @@ void mlock_vma_page(struct page *page)
 static bool __munlock_isolate_lru_page(struct page *page, bool getpage)
 {
 	if (PageLRU(page)) {
-		struct lruvec *lruvec = mem_cgroup_page_lruvec(page,
-				page_zone(page));
+		struct lruvec *lruvec;
 
+		lruvec = mem_cgroup_page_lruvec(page, page_zone(page));
 		if (getpage)
 			get_page(page);
 		ClearPageLRU(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-print-more-details-for-bad_page.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
mm-improve-documentation-of-page_order-v2-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch

