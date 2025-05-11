Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD620143736
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746934441; cv=none; b=YWjtOIarkhiHVNY8vCCsKexKyBC/phnq1ISo/TKyUGd2zYjTm5ZsZl17m/KHFy+dJs6TJB8f9giQojrXCoVvPtYwgGx+PzvlUYHyTllIK89mddSmKi3s5FK1s01SMbCL9xn1Fvm29n7Ondht88tu8AXonBcnU7WSuT/QVkGLYMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746934441; c=relaxed/simple;
	bh=+ujlxU9Mj0SDtiLrd0kgjJSmTQRFRG6qJj+GnpvMijs=;
	h=Date:To:From:Subject:Message-Id; b=VKgPe9jA1nUlwrbLhUauKoFKAWoImo1cqHrYkBMYJS0ObmMo+RUI4+LcPudlAFzhGC+lrmk4PmkJ8NM/iDBykD3ymGPOPRq8m+MTWSxs8bdYRPUkg07v8easl3YPHRzdXbc6E3dMkTbKFokZCG5Wdy69YoHuWSpi1R/Q4LCAkVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=10wB7Pg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="10wB7Pg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290FEC4CEE4;
	Sun, 11 May 2025 03:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746934441;
	bh=+ujlxU9Mj0SDtiLrd0kgjJSmTQRFRG6qJj+GnpvMijs=;
	h=Date:To:From:Subject:From;
	b=10wB7Pg115aCnF5OJuQY5IN3KP0riLR6sjqvDhdbTQ+Q94fEOzxYJMI6BJ62cDKWt
	 O2pTnoRwwG7AzcZqcTAiw7VgKklJ06NUMsxI9NCb2De37djFL7+4YXaJnP+kITlo9T
	 qwAqWVj/EaP+hI9BjPm75jXsqKu9hxhCoTr7LU14=
Date: Sat, 10 May 2025 20:34:00 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch removed from -mm tree
Message-Id: <20250511033401.290FEC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: simplify MEMCG_VMALLOC updates - fix
has been removed from the -mm tree.  Its filename was
     memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch

This patch was dropped because it was folded into memcg-vmalloc-simplify-memcg_vmalloc-updates.patch

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: simplify MEMCG_VMALLOC updates - fix
Date: Fri, 4 Apr 2025 10:41:52 -0700

add comment

Link: https://lkml.kernel.org/r/bmlkdbqgwboyqrnxyom7n52fjmo76ux77jhqw5odc6c6dfon3h@zdylwtmlywbt
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmalloc.c~memcg-vmalloc-simplify-memcg_vmalloc-updates-fix
+++ a/mm/vmalloc.c
@@ -3371,6 +3371,7 @@ void vfree(const void *addr)
 
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
+	/* All pages of vm should be charged to same memcg, so use first one. */
 	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
 		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
 	for (i = 0; i < vm->nr_pages; i++) {
@@ -3672,6 +3673,7 @@ static void *__vmalloc_area_node(struct
 		node, page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
+	/* All pages of vm should be charged to same memcg, so use first one. */
 	if (gfp_mask & __GFP_ACCOUNT && area->nr_pages)
 		mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
 				     area->nr_pages);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-vmalloc-simplify-memcg_vmalloc-updates.patch
memcg-remove-root-memcg-check-from-refill_stock.patch
memcg-decouple-drain_obj_stock-from-local-stock.patch
memcg-introduce-memcg_uncharge.patch
memcg-manually-inline-__refill_stock.patch
memcg-no-refilling-stock-from-obj_cgroup_release.patch
memcg-do-obj_cgroup_put-inside-drain_obj_stock.patch
memcg-use-__mod_memcg_state-in-drain_obj_stock.patch
memcg-manually-inline-replace_stock_objcg.patch
memcg-optimize-memcg_rstat_updated.patch
memcg-multi-memcg-percpu-charge-cache.patch
memcg-multi-memcg-percpu-charge-cache-fix.patch
memcg-multi-memcg-percpu-charge-cache-fix-2.patch
memcg-multi-memcg-percpu-charge-cache-fix-4.patch
memcg-introduce-non-blocking-limit-setting-option.patch
memcg-introduce-non-blocking-limit-setting-option-v3.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

