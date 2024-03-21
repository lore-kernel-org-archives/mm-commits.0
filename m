Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93507134420
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 21:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711055008; cv=none; b=NdXhupLK2YNQJudr8VAFdE3C9wM7LlHjXRWYQBxt4C1iZb/GUmMx6ZwV+bT0za2dJ4Lqq81HCOkFohEJz5fKhPXNP+g1LeDVmj8DdGnRbfkXidwf9xzxIEtGBPfnp3bNZuY2kLlZRg8xcR9b1dKqdMb//aYw93sxdYxh3+Jvsjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711055008; c=relaxed/simple;
	bh=G3QKg9f+CswguWngsJVvIAJVQ8xiJFNXtjJeiVERiSM=;
	h=Date:To:From:Subject:Message-Id; b=fpYINFTIAoHVeZK4yKIK49pnL6o6KElIqVvqexkpEi7MjuQILzd0TjYTZ+YyDe3JeohZ40JMXNuVmzTCRAAs2vcJ+A7ZXaKjjgOXKiJXhwyr1j6JsdcWVk7uelbG0z3b+7xPhMB6STSxobPnIsSxKqCsrPn9w2ZdgmIBWIcGITA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J0xMs3L3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J0xMs3L3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CAFC433C7;
	Thu, 21 Mar 2024 21:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711055008;
	bh=G3QKg9f+CswguWngsJVvIAJVQ8xiJFNXtjJeiVERiSM=;
	h=Date:To:From:Subject:From;
	b=J0xMs3L3jewhHFbLloEfxjhx7TdJeHhML1+EBBlGwJqqAg+7ovzhgtrrZDYPLxfeY
	 I/xl8rQKvUvEuC97ow+zInCgu0QaeWYvQPukFK4sbl279nXxuYfEc9nv4TVo7XHCFX
	 UyMFJHwazDR5M+jH6hZABEyhfwMNGHnFud+6a9qc=
Date: Thu, 21 Mar 2024 14:03:27 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-support-page_mapcount-on-page_has_type-pages.patch added to mm-unstable branch
Message-Id: <20240321210328.06CAFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: support page_mapcount() on page_has_type() pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-support-page_mapcount-on-page_has_type-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-support-page_mapcount-on-page_has_type-pages.patch

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
Subject: mm: support page_mapcount() on page_has_type() pages
Date: Thu, 21 Mar 2024 14:24:42 +0000

Return 0 for pages which can't be mapped.  This matches how page_mapped()
works.  It is more convenient for users to not have to filter out these
pages.

Link: https://lkml.kernel.org/r/20240321142448.1645400-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c             |    7 ++-----
 include/linux/mm.h         |    8 +++++---
 include/linux/page-flags.h |    4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

--- a/fs/proc/page.c~mm-support-page_mapcount-on-page_has_type-pages
+++ a/fs/proc/page.c
@@ -67,7 +67,7 @@ static ssize_t kpagecount_read(struct fi
 		 */
 		ppage = pfn_to_online_page(pfn);
 
-		if (!ppage || PageSlab(ppage) || page_has_type(ppage))
+		if (!ppage)
 			pcount = 0;
 		else
 			pcount = page_mapcount(ppage);
@@ -124,11 +124,8 @@ u64 stable_page_flags(struct page *page)
 
 	/*
 	 * pseudo flags for the well known (anonymous) memory mapped pages
-	 *
-	 * Note that page->_mapcount is overloaded in SLAB, so the
-	 * simple test in page_mapped() is not enough.
 	 */
-	if (!PageSlab(page) && page_mapped(page))
+	if (page_mapped(page))
 		u |= 1 << KPF_MMAP;
 	if (PageAnon(page))
 		u |= 1 << KPF_ANON;
--- a/include/linux/mm.h~mm-support-page_mapcount-on-page_has_type-pages
+++ a/include/linux/mm.h
@@ -1224,14 +1224,16 @@ static inline void page_mapcount_reset(s
  * a large folio, it includes the number of times this page is mapped
  * as part of that folio.
  *
- * The result is undefined for pages which cannot be mapped into userspace.
- * For example SLAB or special types of pages. See function page_has_type().
- * They use this field in struct page differently.
+ * Will report 0 for pages which cannot be mapped into userspace, eg
+ * slab, page tables and similar.
  */
 static inline int page_mapcount(struct page *page)
 {
 	int mapcount = atomic_read(&page->_mapcount) + 1;
 
+	/* Handle page_has_type() pages */
+	if (mapcount < 0)
+		mapcount = 0;
 	if (unlikely(PageCompound(page)))
 		mapcount += folio_entire_mapcount(page_folio(page));
 
--- a/include/linux/page-flags.h~mm-support-page_mapcount-on-page_has_type-pages
+++ a/include/linux/page-flags.h
@@ -971,12 +971,12 @@ static inline bool is_page_hwpoison(stru
  * page_type may be used.  Because it is initialised to -1, we invert the
  * sense of the bit, so __SetPageFoo *clears* the bit used for PageFoo, and
  * __ClearPageFoo *sets* the bit used for PageFoo.  We reserve a few high and
- * low bits so that an underflow or overflow of page_mapcount() won't be
+ * low bits so that an underflow or overflow of _mapcount won't be
  * mistaken for a page type value.
  */
 
 #define PAGE_TYPE_BASE	0xf0000000
-/* Reserve		0x0000007f to catch underflows of page_mapcount */
+/* Reserve		0x0000007f to catch underflows of _mapcount */
 #define PAGE_MAPCOUNT_RESERVE	-128
 #define PG_buddy	0x00000080
 #define PG_offline	0x00000100
_

Patches currently in -mm which might be from willy@infradead.org are

mm-increase-folio-batch-size.patch
mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch

