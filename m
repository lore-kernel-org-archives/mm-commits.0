Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66268C46CA1
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 23:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbjIOX1l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 19:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238132AbjIOX1h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 19:27:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0112119
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 16:27:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97D3C433CA;
        Fri, 15 Sep 2023 23:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694820447;
        bh=d9nZVQL7Ke67eTGd6fn76TcKl0HLCLjlcWm9CJ6yLhY=;
        h=Date:To:From:Subject:From;
        b=BgiEoZpdvKdgKJ/CF5WxsaCOfao8wEK6/sh56nw2zh3neMCEIRzitjUhNuNyY93xY
         i+jtfeHTEh8wsGuwrO6v2rrJ2K4tSpzTACDNIzq7PTyEiQq6s17lO7jRtdUucVFGO9
         bN+GUDCrH26Dc4Cv8b1959eSMipjpEqYX9TJt03U=
Date:   Fri, 15 Sep 2023 16:27:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, sidhartha.kumar@oracle.com,
        rientjes@google.com, osalvador@suse.de, naoya.horiguchi@linux.dev,
        mhocko@suse.com, linmiaohe@huawei.com, jthoughton@google.com,
        joao.m.martins@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, anshuman.khandual@arm.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-optimize-update_and_free_pages_bulk-to-avoid-lock-cycles.patch added to mm-unstable branch
Message-Id: <20230915232727.D97D3C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: optimize update_and_free_pages_bulk to avoid lock cycles
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-optimize-update_and_free_pages_bulk-to-avoid-lock-cycles.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-optimize-update_and_free_pages_bulk-to-avoid-lock-cycles.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: optimize update_and_free_pages_bulk to avoid lock cycles
Date: Fri, 15 Sep 2023 15:15:38 -0700

update_and_free_pages_bulk is designed to free a list of hugetlb pages
back to their associated lower level allocators.  This may require
allocating vmemmmap pages associated with each hugetlb page.  The
hugetlb page destructor must be changed before pages are freed to lower
level allocators.  However, the destructor must be changed under the
hugetlb lock.  This means there is potentially one lock cycle per page.

Minimize the number of lock cycles in update_and_free_pages_bulk by:
1) allocating necessary vmemmap for all hugetlb pages on the list
2) take hugetlb lock and clear destructor for all pages on the list
3) free all pages on list back to low level allocators

Link: https://lkml.kernel.org/r/20230915221548.552084-6-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: James Houghton <jthoughton@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/mm/hugetlb.c~hugetlb-optimize-update_and_free_pages_bulk-to-avoid-lock-cycles
+++ a/mm/hugetlb.c
@@ -1830,7 +1830,46 @@ static void update_and_free_hugetlb_foli
 static void update_and_free_pages_bulk(struct hstate *h, struct list_head *list)
 {
 	struct folio *folio, *t_folio;
+	bool clear_dtor = false;
 
+	/*
+	 * First allocate required vmemmmap (if necessary) for all folios on
+	 * list.  If vmemmap can not be allocated, we can not free folio to
+	 * lower level allocator, so add back as hugetlb surplus page.
+	 * add_hugetlb_folio() removes the page from THIS list.
+	 * Use clear_dtor to note if vmemmap was successfully allocated for
+	 * ANY page on the list.
+	 */
+	list_for_each_entry_safe(folio, t_folio, list, lru) {
+		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
+			if (hugetlb_vmemmap_restore(h, &folio->page)) {
+				spin_lock_irq(&hugetlb_lock);
+				add_hugetlb_folio(h, folio, true);
+				spin_unlock_irq(&hugetlb_lock);
+			} else
+				clear_dtor = true;
+		}
+	}
+
+	/*
+	 * If vmemmmap allocation was performed on any folio above, take lock
+	 * to clear destructor of all folios on list.  This avoids the need to
+	 * lock/unlock for each individual folio.
+	 * The assumption is vmemmap allocation was performed on all or none
+	 * of the folios on the list.  This is true expect in VERY rare cases.
+	 */
+	if (clear_dtor) {
+		spin_lock_irq(&hugetlb_lock);
+		list_for_each_entry(folio, list, lru)
+			__clear_hugetlb_destructor(h, folio);
+		spin_unlock_irq(&hugetlb_lock);
+	}
+
+	/*
+	 * Free folios back to low level allocators.  vmemmap and destructors
+	 * were taken care of above, so update_and_free_hugetlb_folio will
+	 * not need to take hugetlb lock.
+	 */
 	list_for_each_entry_safe(folio, t_folio, list, lru) {
 		update_and_free_hugetlb_folio(h, folio, false);
 		cond_resched();
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-set-hugetlb-page-flag-before-optimizing-vmemmap.patch
hugetlb-optimize-update_and_free_pages_bulk-to-avoid-lock-cycles.patch
hugetlb-restructure-pool-allocations.patch
hugetlb-perform-vmemmap-optimization-on-a-list-of-pages.patch
hugetlb-perform-vmemmap-restoration-on-a-list-of-pages.patch
hugetlb-batch-freeing-of-vmemmap-pages.patch
hugetlb-batch-tlb-flushes-when-restoring-vmemmap.patch

