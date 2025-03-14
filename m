Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507ED1FDA9C
	for <mm-commits@vger.kernel.org>; Fri, 14 Mar 2025 19:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741981523; cv=none; b=ZY9Vlx0aNvl79d068TbHqObQ+KH7v4iQDXnUdmelkMtkEd27t9MvqXL3dxgCQFgjQiz4Xu0sFgP91fOVCQmwLSeWggKC/hX/7HnJpVeyBTKV4yXbaTrKH8WHU6C4ggL2er75QQ3gVAV6cwVEaOucuzFx8Fve+/VpjG0uqbq40VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741981523; c=relaxed/simple;
	bh=j6q0hG05OZSt0WCGj8uFiFzien65vHc+sfpy5p/gkek=;
	h=Date:To:From:Subject:Message-Id; b=mW5YL+2TNgqTlPQHqprstHm5zz+W1FkXON6bfW7n2ekvy5LQlo5qI6tPfDNcHyP/1bGqHlrVTVkP3MmNeyqXwozNr5M74FDz+YbGyzjA5MdkKY4H57ZhSkrgWThAOq+//IHZsM+nO5l6/gNywEw8lMefxkFGpXINXj/vK8qIs1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BWpgCmv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BWpgCmv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B169AC4CEE3;
	Fri, 14 Mar 2025 19:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741981522;
	bh=j6q0hG05OZSt0WCGj8uFiFzien65vHc+sfpy5p/gkek=;
	h=Date:To:From:Subject:From;
	b=BWpgCmv67t5EK9nOnCEgHHPXKUlNp9BTFXh+BhCJyPccuxQAiytVpJzVU9eX4iDyE
	 VmPLBHFRIrEULyVk5pi6frBO+eEzbxR4iHYjZiC5eUuzi8/dbGc1exaGcygAONPjvQ
	 ARzWbP97WyRmIX2BaInnghVYO9Qbk269wfmufGz4=
Date: Fri, 14 Mar 2025 12:45:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-simplify-split_page_memcg.patch added to mm-unstable branch
Message-Id: <20250314194522.B169AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: simplify split_page_memcg()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-simplify-split_page_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-simplify-split_page_memcg.patch

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
Subject: mm: simplify split_page_memcg()
Date: Fri, 14 Mar 2025 13:36:12 +0000

The last argument to split_page_memcg() is now always 0, so remove it,
effectively reverting commit b8791381d7ed.

Link: https://lkml.kernel.org/r/20250314133617.138071-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   15 +++++++--------
 mm/page_alloc.c            |    4 ++--
 3 files changed, 11 insertions(+), 12 deletions(-)

--- a/include/linux/memcontrol.h~mm-simplify-split_page_memcg
+++ a/include/linux/memcontrol.h
@@ -1038,7 +1038,7 @@ static inline void memcg_memory_event_mm
 	rcu_read_unlock();
 }
 
-void split_page_memcg(struct page *head, int old_order, int new_order);
+void split_page_memcg(struct page *first, unsigned order);
 void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
 		unsigned new_order);
 
@@ -1461,7 +1461,7 @@ void count_memcg_event_mm(struct mm_stru
 {
 }
 
-static inline void split_page_memcg(struct page *head, int old_order, int new_order)
+static inline void split_page_memcg(struct page *first, unsigned order)
 {
 }
 
--- a/mm/memcontrol.c~mm-simplify-split_page_memcg
+++ a/mm/memcontrol.c
@@ -3066,22 +3066,21 @@ void __memcg_slab_free_hook(struct kmem_
 }
 
 /*
- * Because folio_memcg(head) is not set on tails, set it now.
+ * The objcg is only set on the first page, so transfer it to all the
+ * other pages.
  */
-void split_page_memcg(struct page *head, int old_order, int new_order)
+void split_page_memcg(struct page *first, unsigned order)
 {
-	struct folio *folio = page_folio(head);
-	int i;
-	unsigned int old_nr = 1 << old_order;
-	unsigned int new_nr = 1 << new_order;
+	struct folio *folio = page_folio(first);
+	unsigned int i, nr = 1 << order;
 
 	if (mem_cgroup_disabled() || !folio_memcg_charged(folio))
 		return;
 
-	for (i = new_nr; i < old_nr; i += new_nr)
+	for (i = 1; i < nr; i++)
 		folio_page(folio, i)->memcg_data = folio->memcg_data;
 
-	obj_cgroup_get_many(__folio_objcg(folio), old_nr / new_nr - 1);
+	obj_cgroup_get_many(__folio_objcg(folio), nr - 1);
 }
 
 void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
--- a/mm/page_alloc.c~mm-simplify-split_page_memcg
+++ a/mm/page_alloc.c
@@ -2778,7 +2778,7 @@ void split_page(struct page *page, unsig
 		set_page_refcounted(page + i);
 	split_page_owner(page, order, 0);
 	pgalloc_tag_split(page_folio(page), order, 0);
-	split_page_memcg(page, order, 0);
+	split_page_memcg(page, order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
@@ -4992,7 +4992,7 @@ static void *make_alloc_exact(unsigned l
 
 		split_page_owner(page, order, 0);
 		pgalloc_tag_split(page_folio(page), order, 0);
-		split_page_memcg(page, order, 0);
+		split_page_memcg(page, order);
 		while (page < --last)
 			set_page_refcounted(last);
 
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

