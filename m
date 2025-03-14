Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD4415886C
	for <mm-commits@vger.kernel.org>; Fri, 14 Mar 2025 19:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741981529; cv=none; b=bP387SgzRDManl0gLcD2Qw+6bTsYn7U2nYVBBCo0y0Zozat1iMjZMvptCIX5eg4yC0VOYFjSNfdN5WkyVCKuDmRTkpQ0k2LOE4BnUMgs4illsHoaygHBL3B281ELDkmdg/geGcmmwFdTSSwtJjncormuKO/svBUld2u6lbGBZkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741981529; c=relaxed/simple;
	bh=Y6J3PU2KUKTno6y+yUjk9SSfsT7/Mc8oC7qjHMLVfXo=;
	h=Date:To:From:Subject:Message-Id; b=CGy7W0yMe78E5+K4XqEe9ifOAkmnj3gGEaMxMl4MXyo3mf6nKpOGFlFsU6i5jmRo2gc9DfZgKwwiddgOc+8Vf0mxpoiguWcG/HICJdYYzsAo7bGgyntNK/iXXsipqPnijd5shwt7qwH8BVShIHS8ztW04WzqqoavRSqeqE9tOlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PsWP27Ol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PsWP27Ol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E445C4CEE3;
	Fri, 14 Mar 2025 19:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741981529;
	bh=Y6J3PU2KUKTno6y+yUjk9SSfsT7/Mc8oC7qjHMLVfXo=;
	h=Date:To:From:Subject:From;
	b=PsWP27OlV/vTzb2L6GhkB6GOf+DxDfE5U/F2yOS2BK2ymPDQoA5XSRaeRnHlpddIE
	 Aoz1Hp0RkgTMFRocP85YVdobX7nvoehLMBowx2QeI5GU2t/7N/bj6hD8IwmbOPUO5e
	 ioI52ewwlv3CTEzwxBb8cKrboVnWjReFKsFx5sPs=
Date: Fri, 14 Mar 2025 12:45:29 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch added to mm-unstable branch
Message-Id: <20250314194529.9E445C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: Remove references to folio in __memcg_kmem_uncharge_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch

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
Subject: mm: Remove references to folio in __memcg_kmem_uncharge_page()
Date: Fri, 14 Mar 2025 13:36:15 +0000

This use of folios is misleading because these pages are not part of
a folio.  Remove an unnecessary call to page_folio(), saving 58 bytes
of text in a Debian kernel build.

Link: https://lkml.kernel.org/r/20250314133617.138071-6-willy@infradead.org
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

 mm/memcontrol.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page
+++ a/mm/memcontrol.c
@@ -2726,16 +2726,14 @@ int __memcg_kmem_charge_page(struct page
  */
 void __memcg_kmem_uncharge_page(struct page *page, int order)
 {
-	struct folio *folio = page_folio(page);
-	struct obj_cgroup *objcg;
+	struct obj_cgroup *objcg = page_objcg(page);
 	unsigned int nr_pages = 1 << order;
 
-	if (!folio_memcg_kmem(folio))
+	if (!objcg)
 		return;
 
-	objcg = __folio_objcg(folio);
 	obj_cgroup_uncharge_pages(objcg, nr_pages);
-	folio->memcg_data = 0;
+	page->memcg_data = 0;
 	obj_cgroup_put(objcg);
 }
 
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

