Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29E6FC09
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600550; cv=none; b=ZLFdNqn5ow4Bp+nglPPfvxp/wzJTa+RvWd4N7iMgldBrxiRq74ZVsxaq79Xt2nwdOmTHtls0wZHtllk6p/ITGC/l50lgd8eiaQLBr6z7P6aY1Ot6vvRqEuTI5Qe1xmHhTy04frby4ejFVwFX6XoV0J07qdYz6q5v6hnY+1HHdpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600550; c=relaxed/simple;
	bh=i6+SDhhyPLmFoxsCiULbllkwIdceATa4QFyBRIhdkr0=;
	h=Date:To:From:Subject:Message-Id; b=c9hdURtM+GLT7yZ5LaMmYfIJzqCsQPWeGsTQHqwQu18O+OGNaJ9OHJPLavDHk+mlCH0tIJTonrXQEfGEQc7cBkpHS1G2A5pA0twdkDyNVomVuT8YLgBh3Cv5p6+333EcSOJz4N0sFlT+lLxj1gKYbX2844CZPH/JMgj0aUYRz74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qDpkTuNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qDpkTuNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7432C433C7;
	Tue,  5 Mar 2024 01:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600549;
	bh=i6+SDhhyPLmFoxsCiULbllkwIdceATa4QFyBRIhdkr0=;
	h=Date:To:From:Subject:From;
	b=qDpkTuNnpZgvBzwGPPq8mXmPha6R1M9Pbj111kNR0kwhrleIIGPNmL7ZkimB2Kukz
	 S8CT4jMaeP8oUezvDzXmNzvYdd7KqXfs0xA6LKFpZoT0zEy0bfUWLd5vXkiaEe4ZNk
	 8K1+oWjMN1P7M9LWeKweTk/Dnlmz61KKmxJ815/g=
Date: Mon, 04 Mar 2024 17:02:29 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,yuzhao@google.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,mkoutny@suse.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch removed from -mm tree
Message-Id: <20240305010229.C7432C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_owner: add support for splitting to any order in split page_owner
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: page_owner: add support for splitting to any order in split page_owner
Date: Mon, 26 Feb 2024 15:55:32 -0500

It adds a new_order parameter to set new page order in page owner.  It
prepares for upcoming changes to support split huge page to any lower
order.

Link: https://lkml.kernel.org/r/20240226205534.1603748-7-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_owner.h |   13 ++++++++-----
 mm/huge_memory.c           |    2 +-
 mm/page_alloc.c            |    4 ++--
 mm/page_owner.c            |    7 +++----
 4 files changed, 14 insertions(+), 12 deletions(-)

--- a/include/linux/page_owner.h~mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner
+++ a/include/linux/page_owner.h
@@ -11,7 +11,8 @@ extern struct page_ext_operations page_o
 extern void __reset_page_owner(struct page *page, unsigned short order);
 extern void __set_page_owner(struct page *page,
 			unsigned short order, gfp_t gfp_mask);
-extern void __split_page_owner(struct page *page, int order);
+extern void __split_page_owner(struct page *page, int old_order,
+			int new_order);
 extern void __folio_copy_owner(struct folio *newfolio, struct folio *old);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
 extern void __dump_page_owner(const struct page *page);
@@ -31,10 +32,11 @@ static inline void set_page_owner(struct
 		__set_page_owner(page, order, gfp_mask);
 }
 
-static inline void split_page_owner(struct page *page, int order)
+static inline void split_page_owner(struct page *page, int old_order,
+			int new_order)
 {
 	if (static_branch_unlikely(&page_owner_inited))
-		__split_page_owner(page, order);
+		__split_page_owner(page, old_order, new_order);
 }
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *old)
 {
@@ -56,10 +58,11 @@ static inline void reset_page_owner(stru
 {
 }
 static inline void set_page_owner(struct page *page,
-			unsigned int order, gfp_t gfp_mask)
+			unsigned short order, gfp_t gfp_mask)
 {
 }
-static inline void split_page_owner(struct page *page, int order)
+static inline void split_page_owner(struct page *page, int old_order,
+			int new_order)
 {
 }
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *folio)
--- a/mm/huge_memory.c~mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner
+++ a/mm/huge_memory.c
@@ -2933,7 +2933,7 @@ static void __split_huge_page(struct pag
 	unlock_page_lruvec(lruvec);
 	/* Caller disabled irqs, so they are still disabled here */
 
-	split_page_owner(head, order);
+	split_page_owner(head, order, 0);
 
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
--- a/mm/page_alloc.c~mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner
+++ a/mm/page_alloc.c
@@ -2616,7 +2616,7 @@ void split_page(struct page *page, unsig
 
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
-	split_page_owner(page, order);
+	split_page_owner(page, order, 0);
 	split_page_memcg(page, order, 0);
 }
 EXPORT_SYMBOL_GPL(split_page);
@@ -4801,7 +4801,7 @@ static void *make_alloc_exact(unsigned l
 		struct page *page = virt_to_page((void *)addr);
 		struct page *last = page + nr;
 
-		split_page_owner(page, order);
+		split_page_owner(page, order, 0);
 		split_page_memcg(page, order, 0);
 		while (page < --last)
 			set_page_refcounted(last);
--- a/mm/page_owner.c~mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner
+++ a/mm/page_owner.c
@@ -306,19 +306,18 @@ void __set_page_owner_migrate_reason(str
 	page_ext_put(page_ext);
 }
 
-void __split_page_owner(struct page *page, int order)
+void __split_page_owner(struct page *page, int old_order, int new_order)
 {
 	int i;
 	struct page_ext *page_ext = page_ext_get(page);
 	struct page_owner *page_owner;
-	unsigned int nr = 1 << order;
 
 	if (unlikely(!page_ext))
 		return;
 
-	for (i = 0; i < nr; i++) {
+	for (i = 0; i < (1 << old_order); i++) {
 		page_owner = get_page_owner(page_ext);
-		page_owner->order = 0;
+		page_owner->order = new_order;
 		page_ext = page_ext_next(page_ext);
 	}
 	page_ext_put(page_ext);
_

Patches currently in -mm which might be from ziy@nvidia.com are


