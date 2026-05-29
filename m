Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE1935957
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 03:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780026508; cv=none; b=PEyKcMSaPX7+/cygjuNg3ZWn0p7AQuMwcIbyRmAnh5iN1fUEH4h40Pexf9+Z/wfFWwvktJ0KKg2gX4Jb4TX0xeViEwHChQ8p0NODt9Ld8Tm07Qa7d4QHIlgXKSihgp2mc3vujt1q8WoysAJ+Fxcvb57UwaIZPIKVNuoCNfaudR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780026508; c=relaxed/simple;
	bh=5LBOpro72YXDGWv10xQeKL+7efg6fM0s/vs2TpxqmZE=;
	h=Date:To:From:Subject:Message-Id; b=XVcFIWdXppWsoNsxRzOlDXw8GUAeirkV51cierf5byjVd7xcjLKlOit4WDDHaLqG8/0CXe/b8qEgJW4rG7gSjbCjljiqJR3RqVCQ6+EB3Rqlb7KJfLatNJ6tP2eUvtxU3PpSTu6za+/ExPCHffsQmJ9KG8lNVsWhozkySEMs+Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QGVCynye; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QGVCynye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2A51F000E9;
	Fri, 29 May 2026 03:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780026507;
	bh=rV6r4XTbWd8jrV0QnguAxbLQUdhEF41LrxIdVU2Mnjg=;
	h=Date:To:From:Subject;
	b=QGVCynyeoGbkEJaoa0d8U6p15SaVaPW3Ms+KisPrhVb6RoY029WvwSEp8exolDrf5
	 m+SgeNUTYV/1E7raNtUoi+Lm2wmP7XtNdcrMOYLqzTtdXVa60sb7D/Z6rESx0btDMi
	 7oLpby9nc3Z3AaKyOIfDVeFvP4oE8pcVkc537xXM=
Date: Thu, 28 May 2026 20:48:26 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,osalvador@kernel.org,nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@suse.com,mawupeng1@huawei.com,ljs@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix.patch removed from -mm tree
Message-Id: <20260529034827.4A2A51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix.patch

This patch was dropped because it was folded into mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix
Date: Fri May 22 08:44:25 PM PDT 2026

- address possible race identified by Sashiko

- s/out/out_unlock/, per Miaohe

Link: https://sashiko.dev/#/patchset/20260522010305.4099834-1-mawupeng1@huawei.com
Link: https://lore.kernel.org/f39f405e-4b4b-8f79-70fe-a2b5b62114eb@huawei.com
Cc: David Hildenbrand <david@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wupeng Ma <mawupeng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix
+++ a/mm/memory-failure.c
@@ -1970,14 +1970,15 @@ static int get_huge_page_for_hwpoison(un
 				 bool *migratable_cleared)
 {
 	struct page *page = pfn_to_page(pfn);
-	struct folio *folio = page_folio(page);
+	struct folio *folio;
 	bool count_increased = false;
 	int ret, rc;
 
 	spin_lock_irq(&hugetlb_lock);
+	folio = page_folio(page);
 	if (!folio_test_hugetlb(folio)) {
 		ret = MF_HUGETLB_NON_HUGEPAGE;
-		goto out;
+		goto out_unlock;
 	} else if (flags & MF_COUNT_INCREASED) {
 		ret = MF_HUGETLB_IN_USED;
 		count_increased = true;
@@ -1993,13 +1994,13 @@ static int get_huge_page_for_hwpoison(un
 	} else {
 		ret = MF_HUGETLB_RETRY;
 		if (!(flags & MF_NO_RETRY))
-			goto out;
+			goto out_unlock;
 	}
 
 	rc = hugetlb_update_hwpoison(folio, page);
 	if (rc >= MF_HUGETLB_FOLIO_PRE_POISONED) {
 		ret = rc;
-		goto out;
+		goto out_unlock;
 	}
 
 	/*
@@ -2013,7 +2014,7 @@ static int get_huge_page_for_hwpoison(un
 
 	spin_unlock_irq(&hugetlb_lock);
 	return ret;
-out:
+out_unlock:
 	spin_unlock_irq(&hugetlb_lock);
 	if (count_increased)
 		folio_put(folio);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison.patch
memcgv1-dont-compile-swap-functions-when-config_swap=n.patch
mm-switch-deferred-split-shrinker-to-list_lru-fix.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch
lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

