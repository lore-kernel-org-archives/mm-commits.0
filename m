Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED36A367;
	Thu,  6 Mar 2025 05:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239449; cv=none; b=Qf5pOYGnx0CYvBd/r+raWfUi/C/ON55J7BV5JRpm1aORHQSnnEGhU87aqXHdOZkghNhPm8id4LStOdUPwoYSMKkCc2ACgIZ7rdO+ndXQrN8sxIlycBes80JPO44gmh+Pi6/1Gjw6eWTFSK2ndVd/lHM5MUadlteKdVFoAN9pz10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239449; c=relaxed/simple;
	bh=obpiEw14KF47SJUHEowbo6xpFnJa8gGe64tSBOi2S/g=;
	h=Date:To:From:Subject:Message-Id; b=QSPEAiDaVvBwAReJUtzHcmoDxuoImCqI7ExZBO3r6eJtx3/RFWH5OWvtyXtjg2JfJtgiM2pFk1votthh1Ts3KDIF0OWZEq1WTkm3rQYLrFr4jdkGTLfw0wndNfTLBREPw8OOs8BM3SLjvdpPO5yFcn0ht2+0glOkWrHy++WfPgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YNggxEt3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YNggxEt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C94C4CEE4;
	Thu,  6 Mar 2025 05:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239448;
	bh=obpiEw14KF47SJUHEowbo6xpFnJa8gGe64tSBOi2S/g=;
	h=Date:To:From:Subject:From;
	b=YNggxEt3qRJYluV8+RA/B9jrgHhwVPhTd7Y4yFOLVLrftIASWPQ8abS8pF6vcXTsd
	 RSkgf3ybRGOdeTpo2z98RZBKtpncoRRxiOhLc05dF9AsJ9bGVtwPA4Z2NElL2kahZZ
	 cYAq/3EoUx7l4OJFfXRsHJ/93gKI3qFOjV2ZA0DI=
Date: Wed, 05 Mar 2025 21:37:27 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-wait-for-hugetlb-folios-to-be-freed.patch removed from -mm tree
Message-Id: <20250306053728.65C94C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: wait for hugetlb folios to be freed
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-wait-for-hugetlb-folios-to-be-freed.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ge Yang <yangge1116@126.com>
Subject: mm/hugetlb: wait for hugetlb folios to be freed
Date: Wed, 19 Feb 2025 11:46:44 +0800

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

Link: https://lkml.kernel.org/r/1739936804-18199-1-git-send-email-yangge1116@126.com
Fixes: c77c0a8ac4c5 ("mm/hugetlb: defer freeing of huge pages if in non-task context")
Signed-off-by: Ge Yang <yangge1116@126.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +++++
 mm/hugetlb.c            |    8 ++++++++
 mm/page_isolation.c     |   10 ++++++++++
 3 files changed, 23 insertions(+)

--- a/include/linux/hugetlb.h~mm-hugetlb-wait-for-hugetlb-folios-to-be-freed
+++ a/include/linux/hugetlb.h
@@ -682,6 +682,7 @@ struct huge_bootmem_page {
 
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
+void wait_for_freed_hugetlb_folios(void);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
@@ -1066,6 +1067,10 @@ static inline int replace_free_hugepage_
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
@@ -2943,6 +2943,14 @@ int replace_free_hugepage_folios(unsigne
 	return ret;
 }
 
+void wait_for_freed_hugetlb_folios(void)
+{
+	if (llist_empty(&hpage_freelist))
+		return;
+
+	flush_work(&free_hpage_work);
+}
+
 typedef enum {
 	/*
 	 * For either 0/1: we checked the per-vma resv map, and one resv
--- a/mm/page_isolation.c~mm-hugetlb-wait-for-hugetlb-folios-to-be-freed
+++ a/mm/page_isolation.c
@@ -608,6 +608,16 @@ int test_pages_isolated(unsigned long st
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


