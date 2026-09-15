Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D1E248881
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 06:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453165; cv=none; b=bC0B07pbG3LRYLVdbgvsB5Kl4m0YMuXBpYxbpebnYObqWP57XS72LaAePmyN9PSvOCosMFlFIYtmbKIgrrl8K4/o+z4b/Mb7JjCj66oGF+rgV7kMochMr+zq2b2X/1443ovuwNdn7QZNkLPfgMfu5yLQ8VV7YC/4vrR47hDSbsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453165; c=relaxed/simple;
	bh=dxRJE497u03gKK2cnaP+W9YL8qTqsXzaI+S9cCxSO48=;
	h=Date:To:From:Subject:Message-Id; b=qYk/J/l7zOGWVOZoPIHqc5UNKyzSCE0epmwLkvADMCPZ3IujC16l11+REcsigrpkZvWNpZKDm3hZOMs5sku7mUZfICp9dQKmThSniKvKfB22x0o3ByyZu7ULt/aAV0C/oDgu9XZfA8F3JduDRl3JK/P5oQhzaTYnSjIm0Uq9aHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u0OMgLpi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u0OMgLpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68791F00893;
	Tue, 15 Sep 2026 06:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789453164;
	bh=p+2iko0pEiDpy8Os090ZEJ41UBvJkqqLjYe1PDDnhZE=;
	h=Date:To:From:Subject;
	b=u0OMgLpiOp399IGJ7RYKvGTBEddCx6IihXdQSmE9jlksx0OZBImXlQ1SSOL+yBqR4
	 W9GVsUxsZym6ACwsRgTl82oKerY3v5+Uytcm01a0J8Q36ohAQCzK3Uw22ZmkqR64v2
	 gRqn5LFSVqVKiS5AZBjnlbPu2IlkxI9j7RbfonOI=
Date: Mon, 14 Sep 2026 23:19:23 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dev.jain@arm.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch removed from -mm tree
Message-Id: <20260915061923.E68791F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: group xa_init with vbq field initializations
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/vmalloc: group xa_init with vbq field initializations
Date: Mon, 14 Sep 2026 11:34:00 +0800

Move xa_init() next to the other vbq field initializations instead of
after the unrelated vfree_deferred setup.

Link: https://lore.kernel.org/20260914-vmalloc_study-v1-1-526f68559706@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-group-xa_init-with-vbq-field-initializations
+++ a/mm/vmalloc.c
@@ -5591,10 +5591,11 @@ void __init vmalloc_init(void)
 		vbq = &per_cpu(vmap_block_queue, i);
 		spin_lock_init(&vbq->lock);
 		INIT_LIST_HEAD(&vbq->free);
+		xa_init(&vbq->vmap_blocks);
+
 		p = &per_cpu(vfree_deferred, i);
 		init_llist_head(&p->list);
 		INIT_WORK(&p->wq, delayed_vfree_work);
-		xa_init(&vbq->vmap_blocks);
 	}
 
 	/*
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch
tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch
tools-mm-page_owner_sort-add-module-name-sort-cull-filter-support.patch
tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch
mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch
mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max.patch
mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range.patch
mm-vmalloc-extract-vmap_insert_free_area-helper.patch

