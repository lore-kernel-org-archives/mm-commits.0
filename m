Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59ED1E0DB0
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545710; cv=none; b=ZT+CJKqhTS6aOTlbSWpU01gsJHHrJPa3De3T2ltMzXm5DrTWGwo1QDugnrRFKaE4O6PwBNXs+EH7Kx3cpmTQA9KewKQSWdAWVYdDleqs47R5xYlTtkIUCrQ/edJc0CXCkjzoyegTsyVLwj0v+lcK5TVa0m3V3AWPCudwP32VotI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545710; c=relaxed/simple;
	bh=+lxeq+iC4Gpd9LZFMDTO6KHJBkgFnysP4ePl1KM7ZFY=;
	h=Date:To:From:Subject:Message-Id; b=Rwt6QEXSXsH6Vm06e279mIqFcQWFwsLrtpIJwV4g7s/IarS6q9rbHf3joE9YltzCT3bxtIsM4S/g8TfKGeBRSyhqWOi6tTTrp6GWb8eYhDj4EMclbt+tkye2PiY1whmwh4lkxh01Uc2+dSk+JN+m4EOmWz38dvk/qWN9/nxab8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l7Mrx9FU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l7Mrx9FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AF5C4CEE4;
	Tue,  1 Apr 2025 22:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545710;
	bh=+lxeq+iC4Gpd9LZFMDTO6KHJBkgFnysP4ePl1KM7ZFY=;
	h=Date:To:From:Subject:From;
	b=l7Mrx9FUE4/iiK8sbA6rmusZtD5tYTI3ljSNn5Ueimu8eJ8DEJIBOukiSjZaZExeq
	 mDY2W/OQCVV6LctSIFWLeBxnnOFMF4RZEjbij37vVqPPVAJiXOkMto1Bqjzqk1asP1
	 px1taMAP3QFy2dz+ZSVzO2jISyPNiLbQGRJpOPfw=
Date: Tue, 01 Apr 2025 15:15:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,muchun.song@linux.dev,mjguzik@gmail.com,david@redhat.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb_vmemmap-fix-memory-loads-ordering.patch removed from -mm tree
Message-Id: <20250401221510.14AF5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_vmemmap: fix memory loads ordering
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-fix-memory-loads-ordering.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/hugetlb_vmemmap: fix memory loads ordering
Date: Wed, 8 Jan 2025 00:48:21 -0700

Using x86_64 as an example, for a 32KB struct page[] area describing a 2MB
hugeTLB, HVO reduces the area to 4KB by the following steps:

1. Split the (r/w vmemmap) PMD mapping the area into 512 (r/w) PTEs;
2. For the 8 PTEs mapping the area, remap PTE 1-7 to the page mapped
   by PTE 0, and at the same time change the permission from r/w to
   r/o;
3. Free the pages PTE 1-7 used to map, hence the reduction from 32KB
   to 4KB.

However, the following race can happen due to improperly memory loads
ordering:
  CPU 1 (HVO)                     CPU 2 (speculative PFN walker)

  page_ref_freeze()
  synchronize_rcu()
                                  rcu_read_lock()
                                  page_is_fake_head() is false
  vmemmap_remap_pte()
  XXX: struct page[] becomes r/o

  page_ref_unfreeze()
                                  page_ref_count() is not zero

                                  atomic_add_unless(&page->_refcount)
                                  XXX: try to modify r/o struct page[]

Specifically, page_is_fake_head() must be ordered after page_ref_count()
on CPU 2 so that it can only return true for this case, to avoid the later
attempt to modify r/o struct page[].

This patch adds the missing memory barrier and makes the tests on
page_is_fake_head() and page_ref_count() done in the proper order.

Link: https://lkml.kernel.org/r/20250108074822.722696-1-yuzhao@google.com
Fixes: bd225530a4c7 ("mm/hugetlb_vmemmap: fix race with speculative PFN walkers")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Will Deacon <will@kernel.org>
Closes: https://lore.kernel.org/20241128142028.GA3506@willie-the-truck/
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Will Deacon <will@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   37 +++++++++++++++++++++++++++++++++++
 include/linux/page_ref.h   |    2 -
 2 files changed, 38 insertions(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-hugetlb_vmemmap-fix-memory-loads-ordering
+++ a/include/linux/page-flags.h
@@ -226,11 +226,48 @@ static __always_inline const struct page
 	}
 	return page;
 }
+
+static __always_inline bool page_count_writable(const struct page *page, int u)
+{
+	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
+		return true;
+
+	/*
+	 * The refcount check is ordered before the fake-head check to prevent
+	 * the following race:
+	 *   CPU 1 (HVO)                     CPU 2 (speculative PFN walker)
+	 *
+	 *   page_ref_freeze()
+	 *   synchronize_rcu()
+	 *                                   rcu_read_lock()
+	 *                                   page_is_fake_head() is false
+	 *   vmemmap_remap_pte()
+	 *   XXX: struct page[] becomes r/o
+	 *
+	 *   page_ref_unfreeze()
+	 *                                   page_ref_count() is not zero
+	 *
+	 *                                   atomic_add_unless(&page->_refcount)
+	 *                                   XXX: try to modify r/o struct page[]
+	 *
+	 * The refcount check also prevents modification attempts to other (r/o)
+	 * tail pages that are not fake heads.
+	 */
+	if (atomic_read_acquire(&page->_refcount) == u)
+		return false;
+
+	return page_fixed_fake_head(page) == page;
+}
 #else
 static inline const struct page *page_fixed_fake_head(const struct page *page)
 {
 	return page;
 }
+
+static inline bool page_count_writable(const struct page *page, int u)
+{
+	return true;
+}
 #endif
 
 static __always_inline int page_is_fake_head(const struct page *page)
--- a/include/linux/page_ref.h~mm-hugetlb_vmemmap-fix-memory-loads-ordering
+++ a/include/linux/page_ref.h
@@ -234,7 +234,7 @@ static inline bool page_ref_add_unless(s
 
 	rcu_read_lock();
 	/* avoid writing to the vmemmap area being remapped */
-	if (!page_is_fake_head(page) && page_ref_count(page) != u)
+	if (page_count_writable(page, u))
 		ret = atomic_add_unless(&page->_refcount, nr, u);
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from yuzhao@google.com are


