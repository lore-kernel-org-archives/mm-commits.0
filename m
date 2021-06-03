Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C00C47096
	for <mm-commits@archiver.kernel.org>; Thu,  3 Jun 2021 22:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADA5C613FF
	for <mm-commits@archiver.kernel.org>; Thu,  3 Jun 2021 22:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhFCWrg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Jun 2021 18:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229610AbhFCWrg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Jun 2021 18:47:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DEA1613D8;
        Thu,  3 Jun 2021 22:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622760343;
        bh=wPYv/Ng6te9kn7/WWVnC0gUhdi4wYJOF1uKe+/XFMes=;
        h=Date:From:To:Subject:From;
        b=Su1p0Js45qp7P66u7KdOA0HgRnK7TZjlrfnonNJt+TcGmP/TLQwDk5en5nQkirokU
         ooWvoT0iVmnNAc5SKJqKysw+SFu08Byy5v08HQmfxNZ2mlxmw2znOvVHeQBI6ZhAQy
         sIsUzp3+Kju87cXHk4MF+HvknI0Yx1uivKQRHc2c=
Date:   Thu, 03 Jun 2021 15:45:42 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com, ziy@nvidia.com
Subject:  [to-be-updated]
 mm-thp-replace-debug_vm-bug-with-vm_warn-when-unmap-fails-for-split.patch
 removed from -mm tree
Message-ID: <20210603224542.IGOBfyAMq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split
has been removed from the -mm tree.  Its filename was
     mm-thp-replace-debug_vm-bug-with-vm_warn-when-unmap-fails-for-split.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split

When debugging the bug reported by Wang Yugui [1], try_to_unmap() may
fail, but the first VM_BUG_ON_PAGE() just checks page_mapcount() however
it may miss the failure when head page is unmapped but other subpage is
mapped.  Then the second DEBUG_VM BUG() that check total mapcount would
catch it.  This may incur some confusion.  And this is not a fatal issue,
so consolidate the two DEBUG_VM checks into one VM_WARN_ON_ONCE_PAGE().

[1] https://lore.kernel.org/linux-mm/20210412180659.B9E3.409509F4@e16-tech.com/

Link: https://lkml.kernel.org/r/20210526201239.3351-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

--- a/mm/huge_memory.c~mm-thp-replace-debug_vm-bug-with-vm_warn-when-unmap-fails-for-split
+++ a/mm/huge_memory.c
@@ -2298,21 +2298,20 @@ void vma_adjust_trans_huge(struct vm_are
 static void unmap_page(struct page *page)
 {
 	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD;
-	bool unmap_success;
 
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
-	if (PageAnon(page))
-		unmap_success = try_to_migrate(page, ttu_flags);
-	else
+	if (PageAnon(page)) {
+		try_to_migrate(page, ttu_flags);
+	} else {
 		/*
 		 * Don't install migration entries for file backed pages. This
 		 * helps handle cases when i_size is in the middle of the page
 		 * as there is no need to unmap pages beyond i_size manually.
 		 */
-		unmap_success = try_to_unmap(page, ttu_flags |
-						TTU_IGNORE_MLOCK);
-	VM_BUG_ON_PAGE(!unmap_success, page);
+		try_to_unmap(page, ttu_flags | TTU_IGNORE_MLOCK);
+	}
+	VM_WARN_ON_ONCE_PAGE(page_mapped(page), page);
 }
 
 static void remap_page(struct page *page, unsigned int nr)
@@ -2623,7 +2622,7 @@ int split_huge_page_to_list(struct page
 	struct deferred_split *ds_queue = get_deferred_split_queue(head);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
-	int count, mapcount, extra_pins, ret;
+	int extra_pins, ret;
 	pgoff_t end;
 
 	VM_BUG_ON_PAGE(is_huge_zero_page(head), head);
@@ -2682,7 +2681,6 @@ int split_huge_page_to_list(struct page
 	}
 
 	unmap_page(head);
-	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
@@ -2700,9 +2698,7 @@ int split_huge_page_to_list(struct page
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&ds_queue->split_queue_lock);
-	count = page_count(head);
-	mapcount = total_mapcount(head);
-	if (!mapcount && page_ref_freeze(head, 1 + extra_pins)) {
+	if (page_ref_freeze(head, 1 + extra_pins)) {
 		if (!list_empty(page_deferred_list(head))) {
 			ds_queue->split_queue_len--;
 			list_del(page_deferred_list(head));
@@ -2722,16 +2718,9 @@ int split_huge_page_to_list(struct page
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
-fail:		if (mapping)
+fail:
+		if (mapping)
 			xa_unlock(&mapping->i_pages);
 		local_irq_enable();
 		remap_page(head, thp_nr_pages(head));
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

