Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6AB1A23A4
	for <mm-commits@vger.kernel.org>; Tue, 30 Dec 2025 18:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767118577; cv=none; b=JeJ21gBmf7czgCWDRsODQCy/X5Bw/YGL0uXfaMHv1XF1o1j9tZmjlEVhkXg9sZBqRKnh1HL9TITk/gfguwsqWu2Z9RY7pssEg/5l07Ah4UkBuys84FBctmTO2DygMP14D08WQRfLJoWoSsOisx7hsoHIO9i3JNSDSwzgm+j4VC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767118577; c=relaxed/simple;
	bh=fbYqny+4+BdWfIxKRBygYgJ0pWnHSm5WQJdi8vP6c6c=;
	h=Date:To:From:Subject:Message-Id; b=TiMDSaWkdRDhlDFP5NbjlrmZZoTKM1O7NvZuDkbXYJ4B7//MUqfHN/Cx/DZR5BVlfiwNPMytjNIySQTJF9XWMeCr+Rqtf2wgW+olfXVYJMbpaCcSY8lfA1LNShdHo1itLSa5fw/GfRuVuuZgvN59D4eaoje2lBC4OX7qAU18jzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=btF6wG9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="btF6wG9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A049C4CEFB;
	Tue, 30 Dec 2025 18:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767118576;
	bh=fbYqny+4+BdWfIxKRBygYgJ0pWnHSm5WQJdi8vP6c6c=;
	h=Date:To:From:Subject:From;
	b=btF6wG9eGVXDlUwn3q2bcb9zP1svwj0+9wo4E+veKADz2XgHmdEPz1ZYV/a6snbhH
	 NWeXzHcp9lt6Jl3MQOpkPA6kPxudUHX4STNQNCW69/YjeEcUlw4AJUcNRUWvtAtXhS
	 tynZkETKgeDfm5X0ZSmrwg0FPoKRMOAOs6HHRgsk=
Date: Tue, 30 Dec 2025 10:16:15 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-__split_page.patch added to mm-new branch
Message-Id: <20251230181616.8A049C4CEFB@smtp.kernel.org>
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

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_alloc: add __split_page()
Date: Tue, 30 Dec 2025 15:24:18 +0800

Factor out the splitting of non-compound page from make_alloc_exact() and
split_page() into a new helper function __split_page().

While at it, convert the VM_BUG_ON_PAGE() into a VM_WARN_ON_PAGE().

Link: https://lkml.kernel.org/r/20251230072422.265265-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |   10 ++++++++++
 mm/page_alloc.c         |   21 +++++++++++++--------
 2 files changed, 23 insertions(+), 8 deletions(-)

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
@@ -122,6 +131,7 @@ void vma_iter_dump_tree(const struct vma
 #define VM_BUG_ON_MM(cond, mm) VM_BUG_ON(cond)
 #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN_ON_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
--- a/mm/page_alloc.c~mm-page_alloc-add-__split_page
+++ a/mm/page_alloc.c
@@ -3080,6 +3080,15 @@ void free_unref_folios(struct folio_batc
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
@@ -3092,14 +3101,12 @@ void split_page(struct page *page, unsig
 {
 	int i;
 
-	VM_BUG_ON_PAGE(PageCompound(page), page);
-	VM_BUG_ON_PAGE(!page_count(page), page);
+	VM_WARN_ON_PAGE(!page_count(page), page);
 
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
-	split_page_owner(page, order, 0);
-	pgalloc_tag_split(page_folio(page), order, 0);
-	split_page_memcg(page, order);
+
+	__split_page(page, order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
@@ -5383,9 +5390,7 @@ static void *make_alloc_exact(unsigned l
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

mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch
mm-page_alloc-add-__split_page.patch
mm-cma-kill-cma_pages_valid.patch
mm-page_alloc-add-alloc_contig_frozen_rangepages.patch
mm-cma-add-cma_alloc_frozen_compound.patch
mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation.patch

