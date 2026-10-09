Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A757A3FC5B7
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525443; cv=none; b=dbHJUeC8+ixjUo4toHvVnfa8C360p9lkVK9O7slXSe262BAy34UI7UvGt5OkBZhL+G5A8D8C+NquyD20jss16S4q1HYnk70EtO7T92KDK8OKeNoxaPqAyVUtKTSPtt6UVoprWpWZ0mbfGer5EnSwLv+0Ede6oqEOQQBCnIQVoGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525443; c=relaxed/simple;
	bh=yQIECsqwtGt0DhPH5ZuG5MaNBfyOf8Am9ttOpf9dyX8=;
	h=Date:To:From:Subject:Message-Id; b=rpTVHJfwjr2Jl38xwwg2lH4+1M3GWAb91ROwF9GsuKpiBtZvA51J1v/GhjChvE7xlrF8ZGQ2xmWsUAN/hLEOSogzIwKEcQCvuPrL9Ic6M2cgrDwG1p25XzR9/km5dCSFZV7SmCqQoFokWZSsq49ZTCwGKxXpb7P7GMGtf98I+Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BXr/ezqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BXr/ezqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788221F000FF;
	Fri,  9 Oct 2026 05:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525442;
	bh=3Ys3uVYCwIAbJsYHY2h6GUgk5lMoKgigE01FD/P5BMc=;
	h=Date:To:From:Subject;
	b=BXr/ezqfZpCHJ7EZ3oul8dKnSfR90pMcOWDcoya9DQpSqC7FuwFVJpdYBnhSecLGk
	 gNVNCzqR+hVJcKGZbQRJSR4FBAY8KU3IDjzDEs8nmB5JEadkU0DDckGtwVnm864crL
	 ODK05O0iB4PxdMMoVhJ2PR9O9LKu+TTMRJpw8QkE=
Date: Thu, 08 Oct 2026 22:57:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,vbabka@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,riel@surriel.com,nphamcs@gmail.com,mark.rutland@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-page_swap_entry.patch removed from -mm tree
Message-Id: <20261009055722.788221F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: remove page_swap_entry()
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-page_swap_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/swap: remove page_swap_entry()
Date: Tue, 08 Sep 2026 11:16:38 -0400

All callers have been converted to folio_swap_entry() and
folio_page_swap_entry(), so remove it.

Link: https://lore.kernel.org/20260908-folio_swap_entry-v2-8-ee6d01dfa5e1@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 include/linux/swap.h |    9 ---------
 1 file changed, 9 deletions(-)

--- a/include/linux/swap.h~mm-swap-remove-page_swap_entry
+++ a/include/linux/swap.h
@@ -305,15 +305,6 @@ static inline swp_entry_t folio_page_swa
 	return folio_swap_entry(folio, folio_page_idx(folio, page));
 }
 
-static inline swp_entry_t page_swap_entry(struct page *page)
-{
-	struct folio *folio = page_folio(page);
-	swp_entry_t entry = folio->swap;
-
-	entry.val += folio_page_idx(folio, page);
-	return entry;
-}
-
 /* linux/mm/page_alloc.c */
 extern unsigned long totalreserve_pages;
 
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch
mm-memcontrol-constify-obj_cgroup_memcg-and-friends.patch
mm-memcontrol-constify-the-lruvec-helpers.patch
mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch
mm-memcontrol-constify-the-mem_cgroup-accessors.patch
mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch
mm-memcontrol-constify-the-reclaim-protection-helpers.patch
mm-memcontrol-constify-the-memcg-and-lruvec-stat-readers.patch
mm-memcontrol-constify-the-swap-accounting-helpers.patch
mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch
mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch
vmcore-convert-mmap_vmcore_fault-to-use-folios.patch

