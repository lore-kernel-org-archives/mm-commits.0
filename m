Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFED1C84D9
	for <mm-commits@vger.kernel.org>; Fri, 14 Feb 2025 23:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739576436; cv=none; b=qqt2npEo9rKfS6zqpag/LsVHq8RqptyoPmS4dwihwp1EgdHNq2CaaOdtNIsQQFJJKKTIFdRvFbVQu3tqB5Pt211GjpIJeKtund5DvscS5g+KWJOrAVGnk1PbszCT26xp7AYBQpFyfd2OYYUA5WTBgiGQkrVbvhiZGaqGMDTmqCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739576436; c=relaxed/simple;
	bh=0wO5uFSmMOiWXoo/XJ4O13F/0y1n5Wi7Etk8riVXnYo=;
	h=Date:To:From:Subject:Message-Id; b=l8XP/+a8CX8fqihyTujbHcp6GBlNcdJEl5+TEi+vJDDOODWy+liZ2eevc0YJ86KQ0QkDA8m5yZN2/6gd+WXecP/iJ6xM2y1JPNTpFNYaojw6L0/rwb9QQNE78RiEj4O/L1c9vLFYG8n35WjxA2jjZBypWXGu2JMsJLtTjw0grMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IlYYNSI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IlYYNSI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF54C4CED1;
	Fri, 14 Feb 2025 23:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739576434;
	bh=0wO5uFSmMOiWXoo/XJ4O13F/0y1n5Wi7Etk8riVXnYo=;
	h=Date:To:From:Subject:From;
	b=IlYYNSI4nrqZFPARS+8/fMd//XjvWrRExVg4gGjnO3XZQSemdIARra3BWT0LuhRbl
	 mYzth1prF11YrDjWyarduqJNCrNfUpf1NehG/PvZGqc231akTmZaZxOZEqA3pK2yMm
	 GrkdT1rO0CMWYISxSAQPQH8mOUowciY2yzGYLhwM=
Date: Fri, 14 Feb 2025 15:40:34 -0800
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,jane.chu@oracle.com,dave.jiang@intel.com,dan.j.williams@intel.com,apopple@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-use-folios-more-widely-within-dax.patch added to mm-unstable branch
Message-Id: <20250214234034.BCF54C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dax: use folios more widely within DAX
has been added to the -mm mm-unstable branch.  Its filename is
     dax-use-folios-more-widely-within-dax.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-use-folios-more-widely-within-dax.patch

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

dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch

