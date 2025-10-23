Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1D02C11D5
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 20:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761250204; cv=none; b=BT/LWeu5lVknxTPgVKeh3LOz6pCPeGUO5GGBcvpgfSjvNF3RiIOXa9rASN6MnpdK6OWkHHRtFZWnACZ8E1ekDq5FZ3n67l5wBJqHvHkNZXnd17ZefcbvorAf3196BtA5BeQ4QERoAvNWaQro/6mg8PEhSYXKu8CZdVnbgYML5gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761250204; c=relaxed/simple;
	bh=jOkmNvL+6y1vQnq/2npCZ31Wq5LabCj/0RLZuMtzJ2w=;
	h=Date:To:From:Subject:Message-Id; b=VKgFwCH06BWbTVpnk/9ltuQPMom1UBoLDubDgNRs8AXWgvtB6je01QtUlqcS56VMmQl4fWJDtBvM3TwufJQJNUTYnOhEXTrYs3M+FG+6uFUUXSP/7JU1yoqqGBXMitoNAy6oN8ujI6OSfW9BpS0x0lCmC6J5vX3rNqqAG/fW6TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PdjDDvUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PdjDDvUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DA2C4CEE7;
	Thu, 23 Oct 2025 20:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761250204;
	bh=jOkmNvL+6y1vQnq/2npCZ31Wq5LabCj/0RLZuMtzJ2w=;
	h=Date:To:From:Subject:From;
	b=PdjDDvUPEUrnDIrig543SWxGxz6gnaGhxwbJ/sxZqZpk8Pq8BhdJuAD4iiEH9L04M
	 3nOHQ48wJ7VtoRfbs/6902cpvQu7RmItXxcyje1dx9DMRLWvpDtEGC5FWnSD46Oyvy
	 2L7fajZNMgwk6qcfZmMkQi+dR9Wel9p9yHUpGfFE=
Date: Thu, 23 Oct 2025 13:10:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-__split_page.patch added to mm-new branch
Message-Id: <20251023201004.55DA2C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: add __split_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-add-__split_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-__split_page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_alloc: add __split_page()
Date: Thu, 23 Oct 2025 19:59:36 +0800

Factor out the splitting of non-compound page from make_alloc_exact() and
split_page() into a new helper function __split_page().

While at it, convert the VM_BUG_ON_PAGE() into a VM_WARN_ON_PAGE().

Link: https://lkml.kernel.org/r/20251023115940.3573158-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    9 +++++++++
 mm/page_alloc.c         |   19 ++++++++++++-------
 2 files changed, 21 insertions(+), 7 deletions(-)

--- a/include/linux/mmdebug.h~mm-page_alloc-add-__split_page
+++ a/include/linux/mmdebug.h
@@ -47,6 +47,15 @@ void vma_iter_dump_tree(const struct vma
 			BUG();						\
 		}							\
 	} while (0)
+#define VM_WARN_ON_PAGE(cond, page)		({			\
+	int __ret_warn = !!(cond);					\
+									\
+	if (unlikely(__ret_warn)) {					\
+		dump_page(page, "VM_WARN_ON_PAGE(" __stringify(cond)")");\
+		WARN_ON(1);						\
+	}								\
+	unlikely(__ret_warn);						\
+})
 #define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
--- a/mm/page_alloc.c~mm-page_alloc-add-__split_page
+++ a/mm/page_alloc.c
@@ -3082,6 +3082,15 @@ void free_unref_folios(struct folio_batc
 	folio_batch_reinit(folios);
 }
 
+static void __split_page(struct page *page, unsigned int order)
+{
+	VM_WARN_ON_PAGE(PageCompound(page), page);
+
+	split_page_owner(page, order, 0);
+	pgalloc_tag_split(page_folio(page), order, 0);
+	split_page_memcg(page, order);
+}
+
 /*
  * split_page takes a non-compound higher-order page, and splits it into
  * n (1<<order) sub-pages: page[0..n]
@@ -3094,14 +3103,12 @@ void split_page(struct page *page, unsig
 {
 	int i;
 
-	VM_BUG_ON_PAGE(PageCompound(page), page);
 	VM_BUG_ON_PAGE(!page_count(page), page);
 
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
-	split_page_owner(page, order, 0);
-	pgalloc_tag_split(page_folio(page), order, 0);
-	split_page_memcg(page, order);
+
+	__split_page(page, order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
@@ -5370,9 +5377,7 @@ static void *make_alloc_exact(unsigned l
 		struct page *page = virt_to_page((void *)addr);
 		struct page *last = page + nr;
 
-		split_page_owner(page, order, 0);
-		pgalloc_tag_split(page_folio(page), order, 0);
-		split_page_memcg(page, order);
+		__split_page(page, order);
 		while (page < --last)
 			set_page_refcounted(last);
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch
mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch
mm-huge_memory-use-folio_skip_prot_numa-for-pmd-folio.patch
mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch
mm-page_alloc-add-__split_page.patch
mm-cma-add-__cma_release.patch
mm-page_alloc-add-alloc_contig_frozen_rangepages.patch
mm-cma-add-cma_alloc_frozen_compound.patch
mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio.patch

