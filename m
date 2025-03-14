Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE071F4161
	for <mm-commits@vger.kernel.org>; Fri, 14 Mar 2025 19:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741981526; cv=none; b=B8a0tneCPOErbbmKMnUoX/S6Idl0gOtcTpNK5+HvwogZR4/2gtMvc2ST/qVHpXsDJKSYBZ5VQVcFano4QxmSVoRkD00wP/jPLxOTtAGuy6CWT6VRRvYtOyOtF8uOIRmWZVPtnf0PKPWdtDQ0dK39GNy9bI/NwvEhdGUCkAiQ8JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741981526; c=relaxed/simple;
	bh=eyJtnkyLRc84AOiPjh5lDFiwBIQZF880PZ+Qhd4YcnM=;
	h=Date:To:From:Subject:Message-Id; b=B+Ct+Hxk2swk0gba9eEFmf/CwhIEVY3gaHpf9D8d3W2CCccDtCOk0WpU9oVPfWeb8oDemlvoFwvIYqN6vbjownt/xSZSu5UBSKwF4ccGlbj7kt2OgrGIo46UtBsqSJZ4FyqbM6+72cZxSEM3m6YEEdpPUe/5JwtSgIyrAaftJcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hIu0ikj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hIu0ikj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF73C4CEE3;
	Fri, 14 Mar 2025 19:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741981525;
	bh=eyJtnkyLRc84AOiPjh5lDFiwBIQZF880PZ+Qhd4YcnM=;
	h=Date:To:From:Subject:From;
	b=hIu0ikj3p3bsHVB45vbdA8cFug8DxW7r1dxLdcvHD4/Dx7bqaLK2uZXR27Mynpa5c
	 GTkAXv/VSXKraVUub3YAdv19jJUnsn2i9v1kUxHlLuM84zOcJPdSuZcWGIBlfdjO2o
	 5TANceK+th67ZvGxqu2MyDZos3I+q9kCGFwpY/EE=
Date: Fri, 14 Mar 2025 12:45:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-references-to-folio-in-split_page_memcg.patch added to mm-unstable branch
Message-Id: <20250314194525.8FF73C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove references to folio in split_page_memcg()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-references-to-folio-in-split_page_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-references-to-folio-in-split_page_memcg.patch

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
Subject: mm: remove references to folio in split_page_memcg()
Date: Fri, 14 Mar 2025 13:36:13 +0000

We know that the passed in page is not part of a folio (it's a plain page
allocated with GFP_ACCOUNT), so we should get rid of the misleading
references to folios.

Introduce page_objcg() and page_set_objcg() helpers to make things more
clear.

Link: https://lkml.kernel.org/r/20250314133617.138071-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~mm-remove-references-to-folio-in-split_page_memcg
+++ a/mm/memcontrol.c
@@ -2677,6 +2677,23 @@ out:
 	return ret;
 }
 
+static struct obj_cgroup *page_objcg(const struct page *page)
+{
+	unsigned long memcg_data = page->memcg_data;
+
+	if (mem_cgroup_disabled() || !memcg_data)
+		return NULL;
+
+	VM_BUG_ON_PAGE((memcg_data & OBJEXTS_FLAGS_MASK) != MEMCG_DATA_KMEM,
+			page);
+	return (struct obj_cgroup *)(memcg_data - MEMCG_DATA_KMEM);
+}
+
+static void page_set_objcg(struct page *page, const struct obj_cgroup *objcg)
+{
+	page->memcg_data = (unsigned long)objcg | MEMCG_DATA_KMEM;
+}
+
 /**
  * __memcg_kmem_charge_page: charge a kmem page to the current memory cgroup
  * @page: page to charge
@@ -2695,8 +2712,7 @@ int __memcg_kmem_charge_page(struct page
 		ret = obj_cgroup_charge_pages(objcg, gfp, 1 << order);
 		if (!ret) {
 			obj_cgroup_get(objcg);
-			page->memcg_data = (unsigned long)objcg |
-				MEMCG_DATA_KMEM;
+			page_set_objcg(page, objcg);
 			return 0;
 		}
 	}
@@ -3069,18 +3085,18 @@ void __memcg_slab_free_hook(struct kmem_
  * The objcg is only set on the first page, so transfer it to all the
  * other pages.
  */
-void split_page_memcg(struct page *first, unsigned order)
+void split_page_memcg(struct page *page, unsigned order)
 {
-	struct folio *folio = page_folio(first);
+	struct obj_cgroup *objcg = page_objcg(page);
 	unsigned int i, nr = 1 << order;
 
-	if (mem_cgroup_disabled() || !folio_memcg_charged(folio))
+	if (!objcg)
 		return;
 
 	for (i = 1; i < nr; i++)
-		folio_page(folio, i)->memcg_data = folio->memcg_data;
+		page_set_objcg(&page[i], objcg);
 
-	obj_cgroup_get_many(__folio_objcg(folio), nr - 1);
+	obj_cgroup_get_many(objcg, nr - 1);
 }
 
 void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-decline-to-manipulate-the-refcount-on-a-slab-page.patch
dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
fs-convert-block_commit_write-to-take-a-folio.patch
fs-remove-page_file_mapping.patch
fs-remove-folio_file_mapping.patch
mm-assert-the-folio-is-locked-in-folio_start_writeback.patch
hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch
hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch
mm-convert-lru_add_page_tail-to-lru_add_split_folio.patch
mm-separate-folio_split_memcg_refs-from-split_page_memcg.patch
mm-simplify-split_page_memcg.patch
mm-remove-references-to-folio-in-split_page_memcg.patch
mm-simplify-folio_memcg_charged.patch
mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch
ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch
ocfs2-remove-reference-to-bh-b_page.patch

