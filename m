Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722E44A0C;
	Wed, 19 Feb 2025 00:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739923797; cv=none; b=F3pMuBWKANOyaMnEWlpVORsQYNJn5/U7R4ZWiEiz4+wU586Jai4Y/SDI33xVzNwSDRgcsIi7jbl9kjILPv3Ti1lGcYegr7mrEbMpBYnQWP1nswKUA4Vs/fvtPlcqhUlHhWENfRIkjnNZVF9DV5zk445DSrkr69QnTeA6BB2GRg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739923797; c=relaxed/simple;
	bh=UkQ5Gk7PV8lNOsJeg6rp0Noz39WSha3HmDfwtagg0UA=;
	h=Date:To:From:Subject:Message-Id; b=c7ZdIqWt6Oy5iw/0OaNLx5v4FvMZtA5Wb51Fm46xdukr/h3MOM2/JWIUxncAjUEL5f7DJWgHWTECXssPNS0N0+yynQB6afu1AegwSl6zC1R5CK0012mfjBUYGBfCAeMKsX2mQmxsa39PG0JfZow6E4Duk03w8V8gmTxwQQCq2kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aUZ6HexR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aUZ6HexR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB89FC4CEE2;
	Wed, 19 Feb 2025 00:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739923796;
	bh=UkQ5Gk7PV8lNOsJeg6rp0Noz39WSha3HmDfwtagg0UA=;
	h=Date:To:From:Subject:From;
	b=aUZ6HexRkXW986J3P6aJSxzfTYu5HxlACqPY2bKmPA6pqn5Exn27/fPpZht2173Ly
	 QyEcqZJfN83xR0PiBnSpYxYB5oWeCrajKsIFQ3QLyAmhqmAzqBz0K8SLS+UGNTfv+4
	 Q3SC8Amb6yEretLrvKMGY4iEkOQEFXvWFJ5QiIfE=
Date: Tue, 18 Feb 2025 16:09:56 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-wait-for-hugetlb-folios-to-be-freed.patch added to mm-unstable branch
Message-Id: <20250219000956.BB89FC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: wait for hugetlb folios to be freed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-wait-for-hugetlb-folios-to-be-freed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-wait-for-hugetlb-folios-to-be-freed.patch

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
From: Ge Yang <yangge1116@126.com>
Subject: mm/hugetlb: wait for hugetlb folios to be freed
Date: Tue, 18 Feb 2025 19:40:28 +0800

Since the introduction of commit c77c0a8ac4c52 ("mm/hugetlb: defer freeing
of huge pages if in non-task context"), which supports deferring the
freeing of hugetlb pages, the allocation of contiguous memory through
cma_alloc() may fail probabilistically.

In the CMA allocation process, if it is found that the CMA area is
occupied by in-use hugetlb folios, these in-use hugetlb folios need to be
migrated to another location.  When there are no available hugetlb folios
in the free hugetlb pool during the migration of in-use hugetlb folios,
new folios are allocated from the buddy system.  A temporary state is set
on the newly allocated folio.  Upon completion of the hugetlb folio
migration, the temporary state is transferred from the new folios to the
old folios.  Normally, when the old folios with the temporary state are
freed, it is directly released back to the buddy system.  However, due to
the deferred freeing of hugetlb pages, the PageBuddy() check fails,
ultimately leading to the failure of cma_alloc().

Here is a simplified call trace illustrating the process:
cma_alloc()
    ->__alloc_contig_migrate_range() // Migrate in-use hugetlb folios
        ->unmap_and_move_huge_page()
            ->folio_putback_hugetlb() // Free old folios
    ->test_pages_isolated()
        ->__test_page_isolated_in_pageblock()
             ->PageBuddy(page) // Check if the page is in buddy

To resolve this issue, we have implemented a function named
wait_for_freed_hugetlb_folios().  This function ensures that the hugetlb
folios are properly released back to the buddy system after their
migration is completed.  By invoking wait_for_freed_hugetlb_folios()
before calling PageBuddy(), we ensure that PageBuddy() will succeed.

Link: https://lkml.kernel.org/r/1739878828-9960-1-git-send-email-yangge1116@126.com
Fixes: c77c0a8ac4c52 ("mm/hugetlb: defer freeing of huge pages if in non-task context")
Signed-off-by: Ge Yang <yangge1116@126.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +++++
 mm/hugetlb.c            |    5 +++++
 mm/page_isolation.c     |   10 ++++++++++
 3 files changed, 20 insertions(+)

--- a/include/linux/hugetlb.h~mm-hugetlb-wait-for-hugetlb-folios-to-be-freed
+++ a/include/linux/hugetlb.h
@@ -697,6 +697,7 @@ bool hugetlb_bootmem_page_zones_valid(in
 
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
+void wait_for_freed_hugetlb_folios(void);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
@@ -1092,6 +1093,10 @@ static inline int replace_free_hugepage_
 	return 0;
 }
 
+static inline void wait_for_freed_hugetlb_folios(void)
+{
+}
+
 static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 					   unsigned long addr,
 					   bool cow_from_owner)
--- a/mm/hugetlb.c~mm-hugetlb-wait-for-hugetlb-folios-to-be-freed
+++ a/mm/hugetlb.c
@@ -2955,6 +2955,11 @@ int replace_free_hugepage_folios(unsigne
 	return ret;
 }
 
+void wait_for_freed_hugetlb_folios(void)
+{
+	flush_work(&free_hpage_work);
+}
+
 typedef enum {
 	/*
 	 * For either 0/1: we checked the per-vma resv map, and one resv
--- a/mm/page_isolation.c~mm-hugetlb-wait-for-hugetlb-folios-to-be-freed
+++ a/mm/page_isolation.c
@@ -615,6 +615,16 @@ int test_pages_isolated(unsigned long st
 	int ret;
 
 	/*
+	 * Due to the deferred freeing of hugetlb folios, the hugepage folios may
+	 * not immediately release to the buddy system. This can cause PageBuddy()
+	 * to fail in __test_page_isolated_in_pageblock(). To ensure that the
+	 * hugetlb folios are properly released back to the buddy system, we
+	 * invoke the wait_for_freed_hugetlb_folios() function to wait for the
+	 * release to complete.
+	 */
+	wait_for_freed_hugetlb_folios();
+
+	/*
 	 * Note: pageblock_nr_pages != MAX_PAGE_ORDER. Then, chunks of free
 	 * pages are not aligned to pageblock_nr_pages.
 	 * Then we just check migratetype first.
_

Patches currently in -mm which might be from yangge1116@126.com are

mm-hugetlb-wait-for-hugepage-folios-to-be-freed.patch
mm-hugetlb-wait-for-hugetlb-folios-to-be-freed.patch

