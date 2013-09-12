From: akpm@linux-foundation.org
Subject: [merged] swap-clean-up-ifdef-in-page_mapping.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:43:27 -0700
Message-ID: <5232195f.KBf1vaatZp4+FKfv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716Ab3ILTn2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, minchan@kernel.org, mgorman@suse.de, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com

Subject: [merged] swap-clean-up-ifdef-in-page_mapping.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,mgorman@suse.de,minchan@kernel.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:27 -0700


The patch titled
     Subject: swap: clean-up #ifdef in page_mapping()
has been removed from the -mm tree.  Its filename was
     swap-clean-up-ifdef-in-page_mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: swap: clean-up #ifdef in page_mapping()

PageSwapCache() is always false when !CONFIG_SWAP, so compiler
properly discard related code. Therefore, we don't need #ifdef explicitly.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 +
 mm/util.c            |    5 +----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/swap.h~swap-clean-up-ifdef-in-page_mapping include/linux/swap.h
--- a/include/linux/swap.h~swap-clean-up-ifdef-in-page_mapping
+++ a/include/linux/swap.h
@@ -447,6 +447,7 @@ mem_cgroup_uncharge_swapcache(struct pag
 
 #else /* CONFIG_SWAP */
 
+#define swap_address_space(entry)		(NULL)
 #define get_nr_swap_pages()			0L
 #define total_swap_pages			0L
 #define total_swapcache_pages()			0UL
diff -puN mm/util.c~swap-clean-up-ifdef-in-page_mapping mm/util.c
--- a/mm/util.c~swap-clean-up-ifdef-in-page_mapping
+++ a/mm/util.c
@@ -388,15 +388,12 @@ struct address_space *page_mapping(struc
 	struct address_space *mapping = page->mapping;
 
 	VM_BUG_ON(PageSlab(page));
-#ifdef CONFIG_SWAP
 	if (unlikely(PageSwapCache(page))) {
 		swp_entry_t entry;
 
 		entry.val = page_private(page);
 		mapping = swap_address_space(entry);
-	} else
-#endif
-	if ((unsigned long)mapping & PAGE_MAPPING_ANON)
+	} else if ((unsigned long)mapping & PAGE_MAPPING_ANON)
 		mapping = NULL;
 	return mapping;
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

