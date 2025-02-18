Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32633A1B6
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 04:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739853263; cv=none; b=nwF/ZrpFmy49OttOerEEmNErM5QzX2M8ZBXG9cKaKssmF3WyFj1Nc65qHEX2XclyuyBf5pUkjHIDgK9wNn0qceprCoj7a3l+zyzPZYJc1HFQnWMP42S5xuZf/mBr97V+mfUC9tI2wOQtad9Y/1hxwoU1jL98n1dmketjU/+OG8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739853263; c=relaxed/simple;
	bh=C4WXNIlghh12pZjVKt8q8W4Ojh5+fAzYNZTglfWwcos=;
	h=Date:To:From:Subject:Message-Id; b=hQVNMvCJH6MRTVxwIpqZ6UdD4Nkh2657PqEvbeez0K4W/cES9ndTxZaMy0PKp25uUXf3yvf8UbCpFDpNxyfQ21AO6YChNl67FyVI3Wlj6CTxYq97DtWybXHc9SaadCKjGFFDA6CqtMzQHl8xL8nssJ1P+/Rl2OGhFQzy5wUmmcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ChdNx6BJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ChdNx6BJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EE1C4CEE2;
	Tue, 18 Feb 2025 04:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739853263;
	bh=C4WXNIlghh12pZjVKt8q8W4Ojh5+fAzYNZTglfWwcos=;
	h=Date:To:From:Subject:From;
	b=ChdNx6BJLYKH2yCsNPldjhgcZYwz/UHauO1BKL/ygr3IdvZSToWbjHgPLjYV4Qrvf
	 3rpvzyQKLRiuw8L4K0RsI8/+b5BsEas11O9s88XNzk4/aEWn2bLHbv/u94vLDhY2JB
	 pYU2FfqKkFFRBTMndtXvzjOeshEoXvdkycgffERg=
Date: Mon, 17 Feb 2025 20:34:22 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-wait-for-hugepage-folios-to-be-freed.patch added to mm-unstable branch
Message-Id: <20250218043423.13EE1C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: wait for hugepage folios to be freed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-wait-for-hugepage-folios-to-be-freed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-wait-for-hugepage-folios-to-be-freed.patch

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
Subject: mm/hugetlb: wait for hugepage folios to be freed
Date: Sat, 15 Feb 2025 15:20:26 +0800

Since the introduction of commit b65d4adbc0f0 ("mm: hugetlb: defer freeing
of HugeTLB pages"), which supports deferring the freeing of HugeTLB pages,
the allocation of contiguous memory through cma_alloc() may fail
probabilistically.

In the CMA allocation process, if it is found that the CMA area is occupied
by in-use hugepage folios, these in-use hugepage folios need to be migrated
to another location. When there are no available hugepage folios in the
free HugeTLB pool during the migration of in-use HugeTLB pages, new folios
are allocated from the buddy system. A temporary state is set on the newly
allocated folio. Upon completion of the hugepage folio migration, the
temporary state is transferred from the new folios to the old folios.
Normally, when the old folios with the temporary state are freed, it is
directly released back to the buddy system. However, due to the deferred
freeing of HugeTLB pages, the PageBuddy() check fails, ultimately leading
to the failure of cma_alloc().

Here is a simplified call trace illustrating the process:
cma_alloc()
    ->__alloc_contig_migrate_range() // Migrate in-use hugepage
        ->unmap_and_move_huge_page()
            ->folio_putback_hugetlb() // Free old folios
    ->test_pages_isolated()
        ->__test_page_isolated_in_pageblock()
             ->PageBuddy(page) // Check if the page is in buddy

To resolve this issue, we have implemented a function named
wait_for_hugepage_folios_freed(). This function ensures that the hugepage
folios are properly released back to the buddy system after their migration
is completed. By invoking wait_for_hugepage_folios_freed() before calling
PageBuddy(), we ensure that PageBuddy() will succeed.

Link: https://lkml.kernel.org/r/1739604026-2258-1-git-send-email-yangge1116@126.com
Fixes: b65d4adbc0f0 ("mm: hugetlb: defer freeing of HugeTLB pages")
Signed-off-by: Ge Yang <yangge1116@126.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +++++
 mm/hugetlb.c            |    8 ++++++++
 mm/page_isolation.c     |   10 ++++++++++
 3 files changed, 23 insertions(+)

--- a/include/linux/hugetlb.h~mm-hugetlb-wait-for-hugepage-folios-to-be-freed
+++ a/include/linux/hugetlb.h
@@ -682,6 +682,7 @@ struct huge_bootmem_page {
 
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
+void wait_for_hugepage_folios_freed(void);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
@@ -1066,6 +1067,10 @@ static inline int replace_free_hugepage_
 	return 0;
 }
 
+static inline void wait_for_hugepage_folios_freed(void)
+{
+}
+
 static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 					   unsigned long addr,
 					   bool cow_from_owner)
--- a/mm/hugetlb.c~mm-hugetlb-wait-for-hugepage-folios-to-be-freed
+++ a/mm/hugetlb.c
@@ -2943,6 +2943,14 @@ int replace_free_hugepage_folios(unsigne
 	return ret;
 }
 
+void wait_for_hugepage_folios_freed(void)
+{
+	struct hstate *h;
+
+	for_each_hstate(h)
+		flush_free_hpage_work(h);
+}
+
 typedef enum {
 	/*
 	 * For either 0/1: we checked the per-vma resv map, and one resv
--- a/mm/page_isolation.c~mm-hugetlb-wait-for-hugepage-folios-to-be-freed
+++ a/mm/page_isolation.c
@@ -615,6 +615,16 @@ int test_pages_isolated(unsigned long st
 	int ret;
 
 	/*
+	 * Due to the deferred freeing of HugeTLB folios, the hugepage folios may
+	 * not immediately release to the buddy system. This can cause PageBuddy()
+	 * to fail in __test_page_isolated_in_pageblock(). To ensure that the
+	 * hugepage folios are properly released back to the buddy system, we
+	 * invoke the wait_for_hugepage_folios_freed() function to wait for the
+	 * release to complete.
+	 */
+	wait_for_hugepage_folios_freed();
+
+	/*
 	 * Note: pageblock_nr_pages != MAX_PAGE_ORDER. Then, chunks of free
 	 * pages are not aligned to pageblock_nr_pages.
 	 * Then we just check migratetype first.
_

Patches currently in -mm which might be from yangge1116@126.com are

mm-hugetlb-wait-for-hugepage-folios-to-be-freed.patch

