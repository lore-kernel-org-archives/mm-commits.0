Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313C9547058
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334153; cv=none; b=U87cSx1MgWak5+uiCZUG02oOczBO1d1+O9Nx0eZOu85g4d0ELbc275IJ3PZ9Oceo1xbun3Rcdw+W/cabskAMhoZytfXhCmrb3KkHEU4NpfMzN7+s8DJF+E6CSU6IQVhWL89URyIwrjM585bl8TSHLqo1WPkYq+mJTurd6Jt3Z0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334153; c=relaxed/simple;
	bh=oghwlF/OCWWQDPsYiMYueSdWXxB0QKTZWDovGE6MV6w=;
	h=Date:To:From:Subject:Message-Id; b=Ut801QSvrL/oy6+0qNMQd1JenynjbQyuYf8Rdl+2Ta+g6GMD3J+bb+DAZAtLViBvfwsLyhPZ4eB2o789S3Gfn9bF26N6fTVwOFEFnD4SxpK09EHBsSkafw4W/oR8u2vpIptA8Sd8jiaLNlU/A+di9rT23WMUTA/a7+WqArNZPp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DKugC/rn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DKugC/rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F231F0089B;
	Wed,  7 Oct 2026 00:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334152;
	bh=ATgSt1HGDknDxxw0jgIUwsFghmx651fwjCBnJKB9fKU=;
	h=Date:To:From:Subject;
	b=DKugC/rnvEPmHlxlWhakVLUlrwxKdHZC8F9qZs4BV9JaPmN2wqQ5L92H7cc2NOo0z
	 d5yqqQkgWU/kVsf6+wLz7zI7/D2hfpleaNyKCYkpZ9MZEBvRqo16LWi60zldkSzy+R
	 5tYhjy2DhdOdKlyktM09MYxS3sTh3zpSO8i4sd0E=
Date: Tue, 06 Oct 2026 17:49:11 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch removed from -mm tree
Message-Id: <20261007004912.08F231F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
Date: Thu, 10 Sep 2026 14:32:43 +0800

The shared tail vmemmap page allocated in vmemmap_get_tail() used to be
left uninitialized, because memmap_init_range() would later overwrite it. 
That forced users such as HugeTLB to defer the initialization to their own
setup paths.

Now that memmap_init_range() skips shared tail vmemmap pages, initialize
them immediately in vmemmap_get_tail() with init_compound_tail() instead.

This adds initialization at the point where the shared tail page is
allocated.  The existing HugeTLB initialization remains necessary until
the compound page order is set and memmap_init_range() starts skipping
shared tails.  It is removed when HugeTLB switches to the section-based
mechanism.

Link: https://lore.kernel.org/20260910063256.64386-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/sparse-vmemmap.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation
+++ a/mm/sparse-vmemmap.c
@@ -338,19 +338,11 @@ static __meminit struct page *vmemmap_ge
 	tail = zone->vmemmap_tails[idx];
 	if (tail)
 		return tail;
-
-	/*
-	 * Only allocate the page, but do not initialize it.
-	 *
-	 * Any initialization done here will be overwritten by memmap_init().
-	 *
-	 * hugetlb_bootmem_struct_page_init() will take care of initialization
-	 * after memmap_init().
-	 */
-
 	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 	if (!p)
 		return NULL;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
 
 	tail = virt_to_page(p);
 	zone->vmemmap_tails[idx] = tail;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


