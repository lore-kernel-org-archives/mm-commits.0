Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2D043F4B7
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 06:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453295; cv=none; b=GiqzY+CV8aHNmlLD8KSl6IMqkq844lVRyIs1wiR+mxXyN3MUqxoiPOXSANu12OuzermHdU+GKcPFSuy2wlJxDwv23gVHRaUO7khz+EIKBBX5m80T/U/rG78JVZLRcLpG+xENxx9ptwIJzrHPGNv0fbGRoVBrnxvC2X1Pp0dJ7Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453295; c=relaxed/simple;
	bh=emmjy5O9oMRyBAIVn1X01B2f3fjKpkKJHBf07YFJdRY=;
	h=Date:To:From:Subject:Message-Id; b=gwndyZ0CReuRxOlDKDmVOcunCYrBmGPvEsZwYM2kDlIeUc/bZRbZ9U/g7nnP49jqftuCAOZjLgJ3nrTa9WMKNO7adERw4dqtO0qeakimqq01Muo64aXOH0lI3veed1udmwcK3uf4zjos1rNDyHWxAKtr6CR/tGYEWSkbGiCaaE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JLw0HysA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JLw0HysA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8E91F000FF;
	Tue, 15 Sep 2026 06:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789453293;
	bh=xsyFKhVUm11nuK7sbfPVNZ2u5gFxvEgQujXmqKtm5XU=;
	h=Date:To:From:Subject;
	b=JLw0HysA3At8EQa7Xar35Zx/ug+UTbdSYUWs16jxO9JfNRaCHA08+w4hbQsG6OjCn
	 cXVaN5g9Qy2IhWulmX60+c/yeRgdgdghSMvynx75vRV9ebJIPyYPhgHaCy+DZ1J2/V
	 NHJv0cp7LjXaSshNa5Cl/2LVfPx+3cCGb2/Qf6D0=
Date: Mon, 14 Sep 2026 23:21:33 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch added to mm-new branch
Message-Id: <20260915062133.6F8E91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: group xa_init with vbq field initializations
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/vmalloc: group xa_init with vbq field initializations
Date: Tue, 15 Sep 2026 10:43:30 +0800

Patch series "mm/vmalloc: minor cleanups", v2.

Small cleanup series for mm/vmalloc.c, no functional changes:

- Group xa_init() with the other vmap_block_queue field initializations
  in vmalloc_init(), instead of after the unrelated vfree_deferred setup.

- Extract vmap_insert_free_area() helper to deduplicate the allocate-
  and-insert pattern that appeared both inside the loop body and after
  the loop in vmap_init_free_space().

- Extract show_busy_info() from vmalloc_info_show(), mirroring the
  existing show_purge_info() pattern, so the top-level show function
  only orchestrates the two data sources.


This patch (of 3):

Move xa_init() next to the other vbq field initializations instead of
after the unrelated vfree_deferred setup.

Link: https://lore.kernel.org/20260915-vmalloc_study-v2-0-cc4dfe635e22@linux.dev
Link: https://lore.kernel.org/20260915-vmalloc_study-v2-1-cc4dfe635e22@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-group-xa_init-with-vbq-field-initializations
+++ a/mm/vmalloc.c
@@ -5585,10 +5585,11 @@ void __init vmalloc_init(void)
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
mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch
mm-vmalloc-extract-vmap_insert_free_area-helper.patch
mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch

