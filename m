Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E77EEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjFSXUw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjFSXUp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19146E73
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A225C60F4F
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DEAC433C0;
        Mon, 19 Jun 2023 23:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216838;
        bh=RzYGDZgLtvVmz2JlivTxnfziwbUySLMqkJbGYKVMVwU=;
        h=Date:To:From:Subject:From;
        b=KEs8bQGigS356ikIFB3MB32zbtx54RSxShlIdamtWDCRPgvZu+0Dp4earSfhFQZQf
         kSjjIXGhbaV6FlaRQr6l9SoquPjXuBxzTLKIls53YrWsMtR6qQxX1AWxtqx4xA5ufU
         KRLg8I40/gsfR0e6KllF9/LAkeQWAPaNLUkaaBaQ=
Date:   Mon, 19 Jun 2023 16:20:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        sunnanyong@huawei.com, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, mike.kravetz@oracle.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-a-folio-in-hugetlb_wp.patch removed from -mm tree
Message-Id: <20230619232038.09DEAC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: use a folio in hugetlb_wp()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-a-folio-in-hugetlb_wp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/hugetlb: use a folio in hugetlb_wp()
Date: Tue, 6 Jun 2023 14:20:12 +0800

We can replace nine implict calls to compound_head() with one by using
old_folio.  The page we get back is always a head page, so we just convert
old_page to old_folio.

Link: https://lkml.kernel.org/r/20230606062013.2947002-3-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-a-folio-in-hugetlb_wp
+++ a/mm/hugetlb.c
@@ -5540,7 +5540,7 @@ static vm_fault_t hugetlb_wp(struct mm_s
 	const bool unshare = flags & FAULT_FLAG_UNSHARE;
 	pte_t pte = huge_ptep_get(ptep);
 	struct hstate *h = hstate_vma(vma);
-	struct page *old_page;
+	struct folio *old_folio;
 	struct folio *new_folio;
 	int outside_reserve = 0;
 	vm_fault_t ret = 0;
@@ -5571,7 +5571,7 @@ static vm_fault_t hugetlb_wp(struct mm_s
 		return 0;
 	}
 
-	old_page = pte_page(pte);
+	old_folio = page_folio(pte_page(pte));
 
 	delayacct_wpcopy_start();
 
@@ -5580,17 +5580,17 @@ retry_avoidcopy:
 	 * If no-one else is actually using this page, we're the exclusive
 	 * owner and can reuse this page.
 	 */
-	if (page_mapcount(old_page) == 1 && PageAnon(old_page)) {
-		if (!PageAnonExclusive(old_page))
-			page_move_anon_rmap(old_page, vma);
+	if (folio_mapcount(old_folio) == 1 && folio_test_anon(old_folio)) {
+		if (!PageAnonExclusive(&old_folio->page))
+			page_move_anon_rmap(&old_folio->page, vma);
 		if (likely(!unshare))
 			set_huge_ptep_writable(vma, haddr, ptep);
 
 		delayacct_wpcopy_end();
 		return 0;
 	}
-	VM_BUG_ON_PAGE(PageAnon(old_page) && PageAnonExclusive(old_page),
-		       old_page);
+	VM_BUG_ON_PAGE(folio_test_anon(old_folio) &&
+		       PageAnonExclusive(&old_folio->page), &old_folio->page);
 
 	/*
 	 * If the process that created a MAP_PRIVATE mapping is about to
@@ -5602,10 +5602,10 @@ retry_avoidcopy:
 	 * of the full address range.
 	 */
 	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER) &&
-			page_folio(old_page) != pagecache_folio)
+			old_folio != pagecache_folio)
 		outside_reserve = 1;
 
-	get_page(old_page);
+	folio_get(old_folio);
 
 	/*
 	 * Drop page table lock as buddy allocator may be called. It will
@@ -5627,7 +5627,7 @@ retry_avoidcopy:
 			pgoff_t idx;
 			u32 hash;
 
-			put_page(old_page);
+			folio_put(old_folio);
 			/*
 			 * Drop hugetlb_fault_mutex and vma_lock before
 			 * unmapping.  unmapping needs to hold vma_lock
@@ -5642,7 +5642,7 @@ retry_avoidcopy:
 			hugetlb_vma_unlock_read(vma);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
-			unmap_ref_private(mm, vma, old_page, haddr);
+			unmap_ref_private(mm, vma, &old_folio->page, haddr);
 
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 			hugetlb_vma_lock_read(vma);
@@ -5672,7 +5672,7 @@ retry_avoidcopy:
 		goto out_release_all;
 	}
 
-	if (copy_user_large_folio(new_folio, page_folio(old_page), address, vma)) {
+	if (copy_user_large_folio(new_folio, old_folio, address, vma)) {
 		ret = VM_FAULT_HWPOISON_LARGE;
 		goto out_release_all;
 	}
@@ -5694,14 +5694,14 @@ retry_avoidcopy:
 		/* Break COW or unshare */
 		huge_ptep_clear_flush(vma, haddr, ptep);
 		mmu_notifier_invalidate_range(mm, range.start, range.end);
-		page_remove_rmap(old_page, vma, true);
+		page_remove_rmap(&old_folio->page, vma, true);
 		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
 		if (huge_pte_uffd_wp(pte))
 			newpte = huge_pte_mkuffd_wp(newpte);
 		set_huge_pte_at(mm, haddr, ptep, newpte);
 		folio_set_hugetlb_migratable(new_folio);
 		/* Make the old page be freed below */
-		new_folio = page_folio(old_page);
+		new_folio = old_folio;
 	}
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(&range);
@@ -5710,11 +5710,11 @@ out_release_all:
 	 * No restore in case of successful pagetable update (Break COW or
 	 * unshare)
 	 */
-	if (new_folio != page_folio(old_page))
+	if (new_folio != old_folio)
 		restore_reserve_on_error(h, vma, haddr, new_folio);
 	folio_put(new_folio);
 out_release_old:
-	put_page(old_page);
+	folio_put(old_folio);
 
 	spin_lock(ptl); /* Caller expects lock to be held */
 
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


