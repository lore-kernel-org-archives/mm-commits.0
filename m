Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB483C47088
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 22:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 924AB613D4
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 22:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhEZWjX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 18:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231419AbhEZWjX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 18:39:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 898AA613D2;
        Wed, 26 May 2021 22:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622068670;
        bh=3JG7IGnke1YWsHX1uLwC4mCkoXCcUD3+OfDaoPAmUAQ=;
        h=Date:From:To:Subject:From;
        b=lOtCYJf2ewYmvAzdvLjqh9rt0m+7Bi9OGIH8ONzaEGHat26JseYVPJkivTNctCULY
         k0M4NSMQYGiGOwr1bBqSwPR+jnxO/X8u0ZzX9dNVUpGTgmjcB6+sctg48aI1UwOnyH
         5SJIQ4uO+CWfrhnBbaT2Ae7wd/KD0vcUWyZHNBlc=
Date:   Wed, 26 May 2021 15:37:49 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, wangyugui@e16-tech.com, ziy@nvidia.com
Subject:  [alternative-merged]
 mm-thp-check-total_mapcount-instead-of-page_mapcount.patch removed from -mm
 tree
Message-ID: <20210526223749.Jygo8BM56%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: check total_mapcount instead of page_mapcount
has been removed from the -mm tree.  Its filename was
     mm-thp-check-total_mapcount-instead-of-page_mapcount.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: thp: check total_mapcount instead of page_mapcount

When debugging the bug reported by Wang Yugui [1], try_to_unmap() may
return false positive for PTE-mapped THP since page_mapcount() is used to
check if the THP is unmapped, but it just checks compound mapcount and
head page's mapcount.  If the THP is PTE-mapped and head page is not
mapped, it may return a false positive.

Use total_mapcount() instead of page_mapcount() for try_to_unmap() and do
so for the VM_BUG_ON_PAGE in split_huge_page_to_list as well.

This changes the semantics of try_to_unmap(), but I don't see there is any
use case that expects try_to_unmap() to just unmap one subpage of a huge
page.  So using page_mapcount() seems like a bug.

[1] https://lore.kernel.org/linux-mm/20210412180659.B9E3.409509F4@e16-tech.com/

Link: https://lkml.kernel.org/r/20210513212334.217424-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   11 +----------
 mm/rmap.c        |   10 ++++++----
 2 files changed, 7 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c~mm-thp-check-total_mapcount-instead-of-page_mapcount
+++ a/mm/huge_memory.c
@@ -2362,7 +2362,6 @@ static void unmap_page(struct page *page
 		 */
 		unmap_success = try_to_unmap(page, ttu_flags |
 						TTU_IGNORE_MLOCK);
-	VM_BUG_ON_PAGE(!unmap_success, page);
 }
 
 static void remap_page(struct page *page, unsigned int nr)
@@ -2732,7 +2731,7 @@ int split_huge_page_to_list(struct page
 	}
 
 	unmap_page(head);
-	VM_BUG_ON_PAGE(compound_mapcount(head), head);
+	VM_BUG_ON_PAGE(total_mapcount(head), head);
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
@@ -2772,14 +2771,6 @@ int split_huge_page_to_list(struct page
 		__split_huge_page(page, list, end);
 		ret = 0;
 	} else {
-		if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount) {
-			pr_alert("total_mapcount: %u, page_count(): %u\n",
-					mapcount, count);
-			if (PageTail(page))
-				dump_page(head, NULL);
-			dump_page(page, "total_mapcount(head) > 0");
-			BUG();
-		}
 		spin_unlock(&ds_queue->split_queue_lock);
 fail:		if (mapping)
 			xa_unlock(&mapping->i_pages);
--- a/mm/rmap.c~mm-thp-check-total_mapcount-instead-of-page_mapcount
+++ a/mm/rmap.c
@@ -1651,12 +1651,14 @@ static int page_not_mapped(struct page *
 }
 
 /**
- * try_to_unmap - try to remove all page table mappings to a page
- * @page: the page to get unmapped
+ * try_to_unmap - try to remove all page table mappings to a page and the
+ *                compound page it belongs to
+ * @page: the page or the subpages of compound page to get unmapped
  * @flags: action and flags
  *
  * Tries to remove all the page table entries which are mapping this
- * page, used in the pageout path.  Caller must hold the page lock.
+ * page and the compound page it belongs to, used in the pageout path.
+ * Caller must hold the page lock.
  *
  * If unmap is successful, return true. Otherwise, false.
  */
@@ -1674,7 +1676,7 @@ bool try_to_unmap(struct page *page, enu
 	else
 		rmap_walk(page, &rwc);
 
-	return !page_mapcount(page) ? true : false;
+	return !total_mapcount(page) ? true : false;
 }
 
 /*
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-memory-add-orig_pmd-to-struct-vm_fault.patch
mm-memory-make-numa_migrate_prep-non-static.patch
mm-thp-refactor-numa-fault-handling.patch
mm-migrate-account-thp-numa-migration-counters-correctly.patch
mm-migrate-dont-split-thp-for-misplaced-numa-page.patch
mm-migrate-check-mapcount-for-thp-instead-of-refcount.patch
mm-thp-skip-make-pmd-prot_none-if-thp-migration-is-not-supported.patch
mm-rmap-make-try_to_unmap-void-function.patch

