Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95752127B53
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711477820; cv=none; b=HAvvn6veWxvahQfUQ8S72NWiqHG0V+WcsGZ7IKeFC5wGifB8/6FwzilSOViSDnSzNao0MMDpA7C+1h7eAkcXa/qiW/xqHKTzGKLHgHkoEFtXB4guo3VGuOxegZEu9L96KX+Mbzkz5X9ppqIqvmYlUxp3SR+g9cTMVqJFc/BpFoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711477820; c=relaxed/simple;
	bh=IT55gvwmle9CkZFhvS1dpkXzIU+FKTHc1+tjOQ1l7Ck=;
	h=Date:To:From:Subject:Message-Id; b=tpU7munWZUINnVuL/M/J8fv7ihu01frggItoJP6/NEgI1MiLfNa17Wx8VK4Pc8SKtQ254lPi7AgOJA0Y1XaTqupHD21kRxySwaElhHw7++mrEVek7MqG8P0HEmRkc4uuEC6KzuHx5rVde+3YvT+C18/gzZlpFcBkKCPJcUH1+Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BOZ6UKry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BOZ6UKry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEACC433F1;
	Tue, 26 Mar 2024 18:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711477820;
	bh=IT55gvwmle9CkZFhvS1dpkXzIU+FKTHc1+tjOQ1l7Ck=;
	h=Date:To:From:Subject:From;
	b=BOZ6UKryf8qPa6JxlWV7Hwp7b10dU1+GGwSBbZIxX1EJNpdyBrvQn+eyTFEGscSKx
	 X47ACy5vutmgtUtc++dI7dWk8+qjsTksoNGZSAIPK5RzLbaYvdS/tkbjrrtZJzhXcA
	 wC33W6jrBgeg9O/LX4AkPP03nb6mVDkEWz6VUZtU=
Date: Tue, 26 Mar 2024 11:30:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-page_mapped-take-a-const-argument.patch added to mm-unstable branch
Message-Id: <20240326183020.0FEACC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make page_mapped() take a const argument
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-page_mapped-take-a-const-argument.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-page_mapped-take-a-const-argument.patch

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
Subject: mm: make page_mapped() take a const argument
Date: Tue, 26 Mar 2024 17:10:28 +0000

None of the functions called by page_mapped() modify the page or folio, so
mark them all as const.

Link: https://lkml.kernel.org/r/20240326171045.410737-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 ++++++------
 mm/internal.h      |    7 ++++---
 mm/rmap.c          |    2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

--- a/include/linux/mm.h~mm-make-page_mapped-take-a-const-argument
+++ a/include/linux/mm.h
@@ -1200,7 +1200,7 @@ static inline int is_vmalloc_or_module_a
  * debugging purposes - it does not include PTE-mapped sub-pages; look
  * at folio_mapcount() or page_mapcount() instead.
  */
-static inline int folio_entire_mapcount(struct folio *folio)
+static inline int folio_entire_mapcount(const struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 	return atomic_read(&folio->_entire_mapcount) + 1;
@@ -1240,7 +1240,7 @@ static inline int page_mapcount(struct p
 	return mapcount;
 }
 
-int folio_total_mapcount(struct folio *folio);
+int folio_total_mapcount(const struct folio *folio);
 
 /**
  * folio_mapcount() - Calculate the number of mappings of this folio.
@@ -1253,14 +1253,14 @@ int folio_total_mapcount(struct folio *f
  *
  * Return: The number of times this folio is mapped.
  */
-static inline int folio_mapcount(struct folio *folio)
+static inline int folio_mapcount(const struct folio *folio)
 {
 	if (likely(!folio_test_large(folio)))
 		return atomic_read(&folio->_mapcount) + 1;
 	return folio_total_mapcount(folio);
 }
 
-static inline bool folio_large_is_mapped(struct folio *folio)
+static inline bool folio_large_is_mapped(const struct folio *folio)
 {
 	/*
 	 * Reading _entire_mapcount below could be omitted if hugetlb
@@ -1288,7 +1288,7 @@ static inline bool folio_mapped(struct f
  * For compound page it returns true if any sub-page of compound page is mapped,
  * even if this particular sub-page is not itself mapped by any PTE or PMD.
  */
-static inline bool page_mapped(struct page *page)
+static inline bool page_mapped(const struct page *page)
 {
 	if (likely(!PageCompound(page)))
 		return atomic_read(&page->_mapcount) >= 0;
@@ -2070,7 +2070,7 @@ static inline void set_page_links(struct
  *
  * Return: A positive power of two.
  */
-static inline long folio_nr_pages(struct folio *folio)
+static inline long folio_nr_pages(const struct folio *folio)
 {
 	if (!folio_test_large(folio))
 		return 1;
--- a/mm/internal.h~mm-make-page_mapped-take-a-const-argument
+++ a/mm/internal.h
@@ -71,7 +71,7 @@ void page_writeback_init(void);
  * How many individual pages have an elevated _mapcount.  Excludes
  * the folio's entire_mapcount.
  */
-static inline int folio_nr_pages_mapped(struct folio *folio)
+static inline int folio_nr_pages_mapped(const struct folio *folio)
 {
 	return atomic_read(&folio->_nr_pages_mapped) & FOLIO_PAGES_MAPPED;
 }
@@ -81,7 +81,8 @@ static inline int folio_nr_pages_mapped(
  * folio. We cannot rely on folio->swap as there is no guarantee that it has
  * been initialized. Used for calling arch_swap_restore()
  */
-static inline swp_entry_t folio_swap(swp_entry_t entry, struct folio *folio)
+static inline swp_entry_t folio_swap(swp_entry_t entry,
+		const struct folio *folio)
 {
 	swp_entry_t swap = {
 		.val = ALIGN_DOWN(entry.val, folio_nr_pages(folio)),
@@ -90,7 +91,7 @@ static inline swp_entry_t folio_swap(swp
 	return swap;
 }
 
-static inline void *folio_raw_mapping(struct folio *folio)
+static inline void *folio_raw_mapping(const struct folio *folio)
 {
 	unsigned long mapping = (unsigned long)folio->mapping;
 
--- a/mm/rmap.c~mm-make-page_mapped-take-a-const-argument
+++ a/mm/rmap.c
@@ -1134,7 +1134,7 @@ int pfn_mkclean_range(unsigned long pfn,
 	return page_vma_mkclean_one(&pvmw);
 }
 
-int folio_total_mapcount(struct folio *folio)
+int folio_total_mapcount(const struct folio *folio)
 {
 	int mapcount = folio_entire_mapcount(folio);
 	int nr_pages;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch

