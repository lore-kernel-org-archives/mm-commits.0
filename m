Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21E6522F
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 23:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757547225; cv=none; b=tm3bFrYOcWyuM3X0zKr1q7XZO0he4OH1xBfQl+kmxuOWlfce9y3HL82UpaQHLJK9hhUDt0gydEe55SkLYeP1gYh5jD611oPe+pJtLqrLO3BzKDqUdKUuFGQ5nfVPMwOgXTGm7J+ZCwayXgYngGgU+xc/aoyjSffResGzOFl+rE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757547225; c=relaxed/simple;
	bh=s8XpTmydMc7hVNmk9osN6DSmvppDIcxz1UlJMrUoBKE=;
	h=Date:To:From:Subject:Message-Id; b=hYJ5RqZ96EzcwRyZMu/bKbJOw9d9X8Pw07p9AcKiwwpXeDKFo5OQn5As/PtQ6XCgCJICO5/MGujkv2K4eh7MDuxeUBQM/LnYazRNoLK/7/kjl9xtBfh7rvNrQxcPyt4TM213HcFCbhLpdUK49WWuBdlDvkjZYPGs+G/V8igjusc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wPEn7hPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wPEn7hPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE39C4CEEB;
	Wed, 10 Sep 2025 23:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757547224;
	bh=s8XpTmydMc7hVNmk9osN6DSmvppDIcxz1UlJMrUoBKE=;
	h=Date:To:From:Subject:From;
	b=wPEn7hPnYZ7cyO0CvKoKZb6XkxgyVdREHA6b4kzztFrEpGOcV7OZsuPiY1Hlz2FiE
	 DLrRpybWKnaYxGYIkr+QDxpqNakCWuQjZ02l5rEorNZDstMNmlYlycxhk9qgK+yxTA
	 Br7uDVZXifzaHI1WEIg+oHhbZqf0eFOM1r1+1Iz0=
Date: Wed, 10 Sep 2025 16:33:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-to-account_new_hugetlb_folio.patch added to mm-unstable branch
Message-Id: <20250910233344.4FE39C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: convert to account_new_hugetlb_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-to-account_new_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-to-account_new_hugetlb_folio.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb: convert to account_new_hugetlb_folio()
Date: Wed, 10 Sep 2025 21:39:55 +0800

In order to avoid the wrong nid passed into the account, and we did make
such mistake before, so it's better to move folio_nid() into
account_new_hugetlb_folio().

Link: https://lkml.kernel.org/r/20250910133958.301467-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-to-account_new_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -1890,11 +1890,11 @@ void free_huge_folio(struct folio *folio
 /*
  * Must be called with the hugetlb lock held
  */
-static void __prep_account_new_huge_page(struct hstate *h, int nid)
+static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
 	lockdep_assert_held(&hugetlb_lock);
 	h->nr_huge_pages++;
-	h->nr_huge_pages_node[nid]++;
+	h->nr_huge_pages_node[folio_nid(folio)]++;
 }
 
 static void init_new_hugetlb_folio(struct hstate *h, struct folio *folio)
@@ -2020,7 +2020,7 @@ static void prep_and_add_allocated_folio
 	/* Add all new pool pages to free lists in one lock cycle */
 	spin_lock_irqsave(&hugetlb_lock, flags);
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
-		__prep_account_new_huge_page(h, folio_nid(folio));
+		account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
 	}
 	spin_unlock_irqrestore(&hugetlb_lock, flags);
@@ -2232,7 +2232,7 @@ static struct folio *alloc_surplus_huget
 	 * as surplus_pages, otherwise it might confuse
 	 * persistent_huge_pages() momentarily.
 	 */
-	__prep_account_new_huge_page(h, folio_nid(folio));
+	account_new_hugetlb_folio(h, folio);
 
 	/*
 	 * We could have raced with the pool size change.
@@ -2270,7 +2270,7 @@ static struct folio *alloc_migrate_huget
 		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
-	__prep_account_new_huge_page(h, folio_nid(folio));
+	account_new_hugetlb_folio(h, folio);
 	spin_unlock_irq(&hugetlb_lock);
 
 	/* fresh huge pages are frozen */
@@ -2829,7 +2829,7 @@ retry:
 		/*
 		 * Ok, old_folio is still a genuine free hugepage. Remove it from
 		 * the freelist and decrease the counters. These will be
-		 * incremented again when calling __prep_account_new_huge_page()
+		 * incremented again when calling account_new_hugetlb_folio()
 		 * and enqueue_hugetlb_folio() for new_folio. The counters will
 		 * remain stable since this happens under the lock.
 		 */
@@ -2839,7 +2839,7 @@ retry:
 		 * Ref count on new_folio is already zero as it was dropped
 		 * earlier.  It can be directly added to the pool free list.
 		 */
-		__prep_account_new_huge_page(h, nid);
+		account_new_hugetlb_folio(h, new_folio);
 		enqueue_hugetlb_folio(h, new_folio);
 
 		/*
@@ -3313,7 +3313,7 @@ static void __init prep_and_add_bootmem_
 		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
-		__prep_account_new_huge_page(h, folio_nid(folio));
+		account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 	}
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch
mm-hugetlb-convert-to-account_new_hugetlb_folio.patch
mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch
mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio.patch
mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch

