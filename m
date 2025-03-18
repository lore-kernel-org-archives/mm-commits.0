Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DEE1922D4
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274476; cv=none; b=JLQ80gUpMh5Q435idk/Ph2V1k9AE/t9kgDKka2i0e70oRKvCQmdu/sEzxFLA1VClfUFOf28oxhIms8Dr8SVS1ljNZtdbj2e/F2aozegRViChtMsXMryZeZF3nGFwKgiscFYfEGcOgzWeEk/ISiTYV8fkYS32XP2TAwMqUTTkg5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274476; c=relaxed/simple;
	bh=pP4KC2cZDP7deeVCm3i3JkZwlZmsYfKEJef+NYLFpx4=;
	h=Date:To:From:Subject:Message-Id; b=SLQpOJbIW7lgtBfj8PMUF9iqw/uzwXZ8XKM1D6zkVdKWSN4vhlelH8+DWdsvbfZoad7hGwoplBYcOK5bjiuIVc7Xf4Nts393d8cjgh3l7vffoUlRh4qD35bzzBLx/4V+DOpspzPFZJRs2+oRNQff0/CP7hGsErUy1stlu253RNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GJLt+iTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GJLt+iTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08806C4CEDD;
	Tue, 18 Mar 2025 05:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274476;
	bh=pP4KC2cZDP7deeVCm3i3JkZwlZmsYfKEJef+NYLFpx4=;
	h=Date:To:From:Subject:From;
	b=GJLt+iTUGsTVlXuAYzxheqgqh3pmlT89SeTlVw9gvQ4KB/ftbj/idd0OMTV9JgYUN
	 PBBzc2i6enOnhaaTiaX4hAERxqwLCF0wGB+Zf+VjkODMUoh6a6xLP3VPpXJWuOthHK
	 jurrKSZEZBMcyIQJBe/QoZ6O8PxkXiIKW0uEidA0=
Date: Mon, 17 Mar 2025 22:07:55 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,jane.chu@oracle.com,dave.jiang@intel.com,dan.j.williams@intel.com,apopple@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-use-folios-more-widely-within-dax.patch removed from -mm tree
Message-Id: <20250318050756.08806C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax: use folios more widely within DAX
has been removed from the -mm tree.  Its filename was
     dax-use-folios-more-widely-within-dax.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: dax: use folios more widely within DAX
Date: Mon, 16 Dec 2024 15:53:56 +0000

Convert from pfn to folio instead of page and use those folios throughout
to avoid accesses to page->index and page->mapping.

Link: https://lkml.kernel.org/r/20241216155408.8102-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Dan Willaims <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   53 +++++++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

--- a/fs/dax.c~dax-use-folios-more-widely-within-dax
+++ a/fs/dax.c
@@ -320,38 +320,39 @@ static unsigned long dax_end_pfn(void *e
 	for (pfn = dax_to_pfn(entry); \
 			pfn < dax_end_pfn(entry); pfn++)
 
-static inline bool dax_page_is_shared(struct page *page)
+static inline bool dax_folio_is_shared(struct folio *folio)
 {
-	return page->mapping == PAGE_MAPPING_DAX_SHARED;
+	return folio->mapping == PAGE_MAPPING_DAX_SHARED;
 }
 
 /*
- * Set the page->mapping with PAGE_MAPPING_DAX_SHARED flag, increase the
+ * Set the folio->mapping with PAGE_MAPPING_DAX_SHARED flag, increase the
  * refcount.
  */
-static inline void dax_page_share_get(struct page *page)
+static inline void dax_folio_share_get(struct folio *folio)
 {
-	if (page->mapping != PAGE_MAPPING_DAX_SHARED) {
+	if (folio->mapping != PAGE_MAPPING_DAX_SHARED) {
 		/*
 		 * Reset the index if the page was already mapped
 		 * regularly before.
 		 */
-		if (page->mapping)
-			page->share = 1;
-		page->mapping = PAGE_MAPPING_DAX_SHARED;
+		if (folio->mapping)
+			folio->page.share = 1;
+		folio->mapping = PAGE_MAPPING_DAX_SHARED;
 	}
-	page->share++;
+	folio->page.share++;
 }
 
-static inline unsigned long dax_page_share_put(struct page *page)
+static inline unsigned long dax_folio_share_put(struct folio *folio)
 {
-	return --page->share;
+	return --folio->page.share;
 }
 
 /*
- * When it is called in dax_insert_entry(), the shared flag will indicate that
- * whether this entry is shared by multiple files.  If so, set the page->mapping
- * PAGE_MAPPING_DAX_SHARED, and use page->share as refcount.
+ * When it is called in dax_insert_entry(), the shared flag will indicate
+ * that whether this entry is shared by multiple files.  If so, set
+ * the folio->mapping PAGE_MAPPING_DAX_SHARED, and use page->share
+ * as refcount.
  */
 static void dax_associate_entry(void *entry, struct address_space *mapping,
 		struct vm_area_struct *vma, unsigned long address, bool shared)
@@ -364,14 +365,14 @@ static void dax_associate_entry(void *en
 
 	index = linear_page_index(vma, address & ~(size - 1));
 	for_each_mapped_pfn(entry, pfn) {
-		struct page *page = pfn_to_page(pfn);
+		struct folio *folio = pfn_folio(pfn);
 
 		if (shared) {
-			dax_page_share_get(page);
+			dax_folio_share_get(folio);
 		} else {
-			WARN_ON_ONCE(page->mapping);
-			page->mapping = mapping;
-			page->index = index + i++;
+			WARN_ON_ONCE(folio->mapping);
+			folio->mapping = mapping;
+			folio->index = index + i++;
 		}
 	}
 }
@@ -385,17 +386,17 @@ static void dax_disassociate_entry(void
 		return;
 
 	for_each_mapped_pfn(entry, pfn) {
-		struct page *page = pfn_to_page(pfn);
+		struct folio *folio = pfn_folio(pfn);
 
-		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
-		if (dax_page_is_shared(page)) {
+		WARN_ON_ONCE(trunc && folio_ref_count(folio) > 1);
+		if (dax_folio_is_shared(folio)) {
 			/* keep the shared flag if this page is still shared */
-			if (dax_page_share_put(page) > 0)
+			if (dax_folio_share_put(folio) > 0)
 				continue;
 		} else
-			WARN_ON_ONCE(page->mapping && page->mapping != mapping);
-		page->mapping = NULL;
-		page->index = 0;
+			WARN_ON_ONCE(folio->mapping && folio->mapping != mapping);
+		folio->mapping = NULL;
+		folio->index = 0;
 	}
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-separate-folio_split_memcg_refs-from-split_page_memcg.patch
mm-simplify-split_page_memcg.patch
mm-remove-references-to-folio-in-split_page_memcg.patch
mm-simplify-folio_memcg_charged.patch
mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch

