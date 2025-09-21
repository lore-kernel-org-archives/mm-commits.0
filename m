Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D547D28DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489821; cv=none; b=Ex55kIwu8HtyCh+hxHIbj4o2b1gO0JmdmlEhyovRvhOrzHNchtk3p653i2XKPt+NQlocl6XWkN1MiDUo02Tcbye9gIvBftXnEOlBrZs1S0Ir/FXm1iWEkxh/6lztBjPe+8X1IQaSwNS6C0evC0DNpCKdqxO49alkLtEboKjOSZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489821; c=relaxed/simple;
	bh=zsMpeV1VI769xe8MQJkWIJzAWkKUb+dItIYIBLabBB0=;
	h=Date:To:From:Subject:Message-Id; b=Xj/BG0tx6I2T4CIDKyQFePDKm5j8lp4y2NWYku5T+TBO7I+uOLukOtQDUfxuEYHcmsV3bFGCSlFnrpD+8X8e2mJGZOjAMvrmFf0v07FhV21KA9/BO60BQpo883mYbMDq2TIWVuShhpJ0rHXh2HBVxRRIV/jA3PHeCOpsABHxKwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q/paoVal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q/paoVal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6000DC4CEE7;
	Sun, 21 Sep 2025 21:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489821;
	bh=zsMpeV1VI769xe8MQJkWIJzAWkKUb+dItIYIBLabBB0=;
	h=Date:To:From:Subject:From;
	b=Q/paoValjw5vHTcO49mppttZBKnyK+H0dzrz4WV1yNQkVBu7IggqVAhziRkoG4SHZ
	 2SXtUCS+O6cjaySgsuiCm+u14yvq+qrakm8pwvYZrrmctpC8+Re5R/4VtQFgtOb7oo
	 8BYhuoU+kRvXpTwC0jo+2HSkBSjs5mHJrDxRP7eQ=
Date: Sun, 21 Sep 2025 14:23:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-simplify-folio_page-and-folio_page_idx.patch removed from -mm tree
Message-Id: <20250921212341.6000DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: simplify folio_page() and folio_page_idx()
has been removed from the -mm tree.  Its filename was
     mm-simplify-folio_page-and-folio_page_idx.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: simplify folio_page() and folio_page_idx()
Date: Mon, 1 Sep 2025 17:03:33 +0200

Now that a single folio/compound page can no longer span memory sections
in problematic kernel configurations, we can stop using nth_page() in
folio_page() and folio_page_idx().

While at it, turn both macros into static inline functions and add kernel
doc for folio_page_idx().

Link: https://lkml.kernel.org/r/20250901150359.867252-13-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |   16 ++++++++++++++--
 include/linux/page-flags.h |    5 ++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-simplify-folio_page-and-folio_page_idx
+++ a/include/linux/mm.h
@@ -210,10 +210,8 @@ extern unsigned long sysctl_admin_reserv
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
-#define folio_page_idx(folio, p)	(page_to_pfn(p) - folio_pfn(folio))
 #else
 #define nth_page(page,n) ((page) + (n))
-#define folio_page_idx(folio, p)	((p) - &(folio)->page)
 #endif
 
 /* to align the pointer to the (next) page boundary */
@@ -225,6 +223,20 @@ extern unsigned long sysctl_admin_reserv
 /* test whether an address (unsigned long or pointer) is aligned to PAGE_SIZE */
 #define PAGE_ALIGNED(addr)	IS_ALIGNED((unsigned long)(addr), PAGE_SIZE)
 
+/**
+ * folio_page_idx - Return the number of a page in a folio.
+ * @folio: The folio.
+ * @page: The folio page.
+ *
+ * This function expects that the page is actually part of the folio.
+ * The returned number is relative to the start of the folio.
+ */
+static inline unsigned long folio_page_idx(const struct folio *folio,
+		const struct page *page)
+{
+	return page - &folio->page;
+}
+
 static inline struct folio *lru_to_folio(struct list_head *head)
 {
 	return list_entry((head)->prev, struct folio, lru);
--- a/include/linux/page-flags.h~mm-simplify-folio_page-and-folio_page_idx
+++ a/include/linux/page-flags.h
@@ -316,7 +316,10 @@ static __always_inline unsigned long _co
  * check that the page number lies within @folio; the caller is presumed
  * to have a reference to the page.
  */
-#define folio_page(folio, n)	nth_page(&(folio)->page, n)
+static inline struct page *folio_page(struct folio *folio, unsigned long n)
+{
+	return &folio->page + n;
+}
 
 static __always_inline int PageTail(const struct page *page)
 {
_

Patches currently in -mm which might be from david@redhat.com are


