Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6D1166F0C
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011017; cv=none; b=lzRfu78Z6b4oyo5M27tJ+IdNcBfkayedvH4Lyrellz1FV+rf0Ee1WeM6vXKBbzbYLkw3AapjkqX+o8tILx2vXij0fYmfYBKJUUd2iEVTScrqy/BbC6JDYXZhq2JJdhE8/VaEOMgCOGp+EUJwadrGLnr6Y9FUqf0a5tKkpVltr0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011017; c=relaxed/simple;
	bh=UkRXhI4ImQur7fPDzvEzVvC8IS3aR3fH0mzjn2fIncQ=;
	h=Date:To:From:Subject:Message-Id; b=bXf13UFGHyz5n3yRdrhvugJoyKAw/j+9ONZrfss9AzQhhxMWeR0vixP3cxeJFl6U+wGFGGCBbCoilK5bScKZCP7dYYrYAGKv7U/E37n0Asl1bmIUH/8AyH6JPyRDJcWtyQq+3QMbIYXT0LJ9QspDnkYbOd7MRnkPA27Qp+s64zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zh1hX4PU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zh1hX4PU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93463C4CEE4;
	Mon, 12 May 2025 00:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011017;
	bh=UkRXhI4ImQur7fPDzvEzVvC8IS3aR3fH0mzjn2fIncQ=;
	h=Date:To:From:Subject:From;
	b=Zh1hX4PULfkiM3h+bWBglCakeVoLL9OmdjLqXZpRUIhnhBESuXDMDMr8y//zgcOIM
	 JsrqSeJ1jX4LQMRS15Xe6iBqEbh/O+9Ft6cwQrJAQ4bVRjYenEK6YlcdWzqAyHXq0V
	 +IQ0M3BhotNuVDV1terTnMtrt3AW1hKaePphbp+4=
Date: Sun, 11 May 2025 17:50:17 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,urezki@gmail.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-vmalloc-simplify-memcg_vmalloc-updates.patch removed from -mm tree
Message-Id: <20250512005017.93463C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: vmalloc: simplify MEMCG_VMALLOC updates
has been removed from the -mm tree.  Its filename was
     memcg-vmalloc-simplify-memcg_vmalloc-updates.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: vmalloc: simplify MEMCG_VMALLOC updates
Date: Wed, 2 Apr 2025 22:33:26 -0700

The vmalloc region can either be charged to a single memcg or none.  At
the moment kernel traverses all the pages backing the vmalloc region to
update the MEMCG_VMALLOC stat.  However there is no need to look at all
the pages as all those pages will be charged to a single memcg or none. 
Simplify the MEMCG_VMALLOC update by just looking at the first page of the
vmalloc region.

[shakeel.butt@linux.dev: add comment]
  Link: https://lkml.kernel.org/r/bmlkdbqgwboyqrnxyom7n52fjmo76ux77jhqw5odc6c6dfon3h@zdylwtmlywbt
Link: https://lkml.kernel.org/r/20250403053326.26860-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/vmalloc.c~memcg-vmalloc-simplify-memcg_vmalloc-updates
+++ a/mm/vmalloc.c
@@ -3371,12 +3371,13 @@ void vfree(const void *addr)
 
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
+	/* All pages of vm should be charged to same memcg, so use first one. */
+	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
+		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
 	for (i = 0; i < vm->nr_pages; i++) {
 		struct page *page = vm->pages[i];
 
 		BUG_ON(!page);
-		if (!(vm->flags & VM_MAP_PUT_PAGES))
-			mod_memcg_page_state(page, MEMCG_VMALLOC, -1);
 		/*
 		 * High-order allocs for huge vmallocs are split, so
 		 * can be freed as an array of order-0 allocations
@@ -3672,12 +3673,10 @@ static void *__vmalloc_area_node(struct
 		node, page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
-	if (gfp_mask & __GFP_ACCOUNT) {
-		int i;
-
-		for (i = 0; i < area->nr_pages; i++)
-			mod_memcg_page_state(area->pages[i], MEMCG_VMALLOC, 1);
-	}
+	/* All pages of vm should be charged to same memcg, so use first one. */
+	if (gfp_mask & __GFP_ACCOUNT && area->nr_pages)
+		mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
+				     area->nr_pages);
 
 	/*
 	 * If not enough pages were obtained to accomplish an
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-introduce-non-blocking-limit-setting-option.patch
memcg-introduce-non-blocking-limit-setting-option-v3.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

