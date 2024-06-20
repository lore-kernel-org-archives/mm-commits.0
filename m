Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800DD134A5
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 20:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718915552; cv=none; b=OR63ycZqD1LUGoZettfRt7bMh97e0E6GdflAQ1qcvRsqSSOuSl/QpZ+DIdWnsIl+oyCZn8B7yjyvzDFcTe0XoPgDTks2vwjXnZ+X2ZDTNLTikLwk9mQpXBlfg3N7sTt/QMb1rZNPZdCBzUx1ijk7gy/+f8Nquy+3m+6DOev/y90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718915552; c=relaxed/simple;
	bh=o73yOVSFM7/FzCUBDv+tI3jirtbeWS51QdRuwpzULsU=;
	h=Date:To:From:Subject:Message-Id; b=eY2Ihu+ZpIPiIk7bivinJ3nqcDnszILovVeRbpgX42ONd+rD2w0PGVn/5zgRoYypmDSBvUyVZLRVgH6nthhxDrIlJHYERKOekWY09Iyn0mZf3CtbX1D0wD0rBRl5q6RuBq7r8uOIN54iTOieoPhSSOA3YU0DjMoB1qZS7aL+RYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fX787vwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fX787vwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB80C2BD10;
	Thu, 20 Jun 2024 20:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718915552;
	bh=o73yOVSFM7/FzCUBDv+tI3jirtbeWS51QdRuwpzULsU=;
	h=Date:To:From:Subject:From;
	b=fX787vwtVnMKhZYUlZwqgT4TT4qyEzF0wL1q9Jzmomw4Zfu4F9oZzMTz9DMYeNPE4
	 XZylI1ery0sEuN+hzIM25WKATt6muLHFh2fhjBjjp2Kyfd6IKvsZ9PCkugCWMQBrOn
	 B3a6EjWiS/leWst/zDH9ZNrNxVGRHlI/KnFx804o=
Date: Thu, 20 Jun 2024 13:32:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osalvador@suse.de,oliver.sang@intel.com,linmiaohe@huawei.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-read-page_type-using-read_once.patch added to mm-unstable branch
Message-Id: <20240620203231.EEB80C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: read page_type using READ_ONCE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-read-page_type-using-read_once.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-read-page_type-using-read_once.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: read page_type using READ_ONCE
Date: Fri, 31 May 2024 14:56:16 +0200

KCSAN complains about possible data races: while we check for a page_type
-- for example for sanity checks -- we might concurrently modify the
mapcount that overlays page_type.

Let's use READ_ONCE to avoid load tearing (shouldn't make a difference)
and to make KCSAN happy.

Likely, we might also want to use WRITE_ONCE for the writer side of
page_type, if KCSAN ever complains about that.  But we'll not mess with
that for now.

Note: nothing should really be broken besides wrong KCSAN complaints.  The
sanity check that triggers this was added in commit 68f0320824fa
("mm/rmap: convert folio_add_file_rmap_range() into
folio_add_file_rmap_[pte|ptes|pmd]()").  Even before that similar races
likely where possible, ever since we added page_type in commit
6e292b9be7f4 ("mm: split page_type out from _mapcount").

Link: https://lkml.kernel.org/r/20240531125616.2850153-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202405281431.c46a3be9-lkp@intel.com
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/page-flags.h~mm-read-page_type-using-read_once
+++ a/include/linux/page-flags.h
@@ -949,9 +949,9 @@ enum pagetype {
 };
 
 #define PageType(page, flag)						\
-	((page->page_type & (PAGE_TYPE_BASE | flag)) == PAGE_TYPE_BASE)
+	((READ_ONCE(page->page_type) & (PAGE_TYPE_BASE | flag)) == PAGE_TYPE_BASE)
 #define folio_test_type(folio, flag)					\
-	((folio->page.page_type & (PAGE_TYPE_BASE | flag)) == PAGE_TYPE_BASE)
+	((READ_ONCE(folio->page.page_type) & (PAGE_TYPE_BASE | flag))  == PAGE_TYPE_BASE)
 
 static inline int page_type_has_type(unsigned int page_type)
 {
@@ -960,7 +960,7 @@ static inline int page_type_has_type(uns
 
 static inline int page_has_type(const struct page *page)
 {
-	return page_type_has_type(page->page_type);
+	return page_type_has_type(READ_ONCE(page->page_type));
 }
 
 #define FOLIO_TYPE_OPS(lname, fname)					\
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch
fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch
fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch
fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch
fs-proc-move-page_mapcount-to-fs-proc-internalh.patch
documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch
mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-highmem-reimplement-totalhigh_pages-by-walking-zones.patch
mm-highmem-reimplement-totalhigh_pages-by-walking-zones-fix.patch
mm-highmem-make-nr_free_highpages-return-unsigned-long.patch
mm-read-page_type-using-read_once.patch

