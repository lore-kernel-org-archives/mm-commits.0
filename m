Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F4028DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489860; cv=none; b=e3X5cIoJnSTOXos9fVn3c9fmTInmbnBG8Aw90WCo2SEAk94xVo/yyNr0dMctKzHdAgq61Tl2XL2S4XxJQBr1qRzRanrHLFtsa+YFmlQKwyUriWP3X3NGOWBltzPFlALDaNXHReLWEWOjE5c59GDA9kn3BFr5CenFIWCD2gPhwDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489860; c=relaxed/simple;
	bh=LCs4mOEZFaGAWbdN/LYATWBMDcXQUzVUiAv3qE/9Qd0=;
	h=Date:To:From:Subject:Message-Id; b=V7/KHs+Wf36yVYQXUw3WWt2z7keJj3HRJ/ngXiiPSuX24ocxrW7cb4NCNiVZSLmETW1kopGciz3dPMW/po1NlyclirKvGGziIqQBvouG+CYbSvhB9oqUJaFJe3bX+JshRSLevX3+uKgdEbh8/UH6cijibkaUrGOIcwG77aVAjoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D+i8UR1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D+i8UR1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCAFC4CEE7;
	Sun, 21 Sep 2025 21:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489860;
	bh=LCs4mOEZFaGAWbdN/LYATWBMDcXQUzVUiAv3qE/9Qd0=;
	h=Date:To:From:Subject:From;
	b=D+i8UR1WksNWr7n9Gxm3YxPnlDnsVrslJKKvSXQi6af0lYbCoUD1aWaA5suF0FvHH
	 krzaM3jqKUc4dUYjT8vu/gZhlm9mhPnC2ZKK+IZig4BKdyEb77uHCMRpYXPmE/mtXI
	 yRF6fg7K5hx4sLBAWZmsN0ZnNvcZx17lFJ5j/mxQ=
Date: Sun, 21 Sep 2025 14:24:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-to-account_new_hugetlb_folio.patch removed from -mm tree
Message-Id: <20250921212420.3CCAFC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: convert to account_new_hugetlb_folio()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-to-account_new_hugetlb_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


