Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A001A8F68
	for <mm-commits@vger.kernel.org>; Sun,  6 Apr 2025 23:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743983038; cv=none; b=X4ibiU2i7YSYwP8b0Nf3f03smUdX52oF/uyY0lN2AG+N16Vhgq6lzzAhl7oaOBsKn8f0OOEPkO07VRrNU7Cm2Z0xGSUkdPS83sFMl5z8ycRoPhigny/h19DmMbf/M1pCbtAw4BmwdzLDQ4rSGX6j+d3o+wjt2+Nc9jUgqHQC/ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743983038; c=relaxed/simple;
	bh=NsuvvxH4FbCqlZwBNs3npH5BXH86a9aSkIDPkipK/ac=;
	h=Date:To:From:Subject:Message-Id; b=lUTMLoBE1QS94r7cCk0qP7RlI41Usv3T8jid6Ul7mN6Fih4KqWHxjSptu5hTz0g8HNCHxBPtbFt8NjReh3ML2/iYSOsaN2gFpZXuFM+vAVRZ9bKcGRoobNmPItIcMrBxKoDz285+lkpAPWnqcxUee6hOJI2wFA76ZD/lXD5ELEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gj/z75An; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gj/z75An"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527A4C4CEE3;
	Sun,  6 Apr 2025 23:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743983037;
	bh=NsuvvxH4FbCqlZwBNs3npH5BXH86a9aSkIDPkipK/ac=;
	h=Date:To:From:Subject:From;
	b=gj/z75AnElVJJRtAu43yc/iB1jYyBeKSqOxkcpJEJqQm1md/wBj34Ukq7YO1gfeeF
	 gktCRnFfY3kroAmj8u1U0abERqYw0C6ND0mwraCZxLtcNdHVuiWrXmAX6VYcgoxp0D
	 nXxrDTzeOsCzUAYfVrKDwdfN6k+UW3UOj16qVA5g=
Date: Sun, 06 Apr 2025 16:43:56 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-vmalloc-simplify-memcg_vmalloc-updates.patch added to mm-new branch
Message-Id: <20250406234357.527A4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: vmalloc: simplify MEMCG_VMALLOC updates
has been added to the -mm mm-new branch.  Its filename is
     memcg-vmalloc-simplify-memcg_vmalloc-updates.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-vmalloc-simplify-memcg_vmalloc-updates.patch

This patch will later appear in the mm-new branch at
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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: vmalloc: simplify MEMCG_VMALLOC updates
Date: Wed, 2 Apr 2025 22:33:26 -0700

The vmalloc region can either be charged to a single memcg or none.  At
the moment kernel traverses all the pages backing the vmalloc region to
update the MEMCG_VMALLOC stat.  However there is no need to look at all
the pages as all those pages will be charged to a single memcg or none. 
Simplify the MEMCG_VMALLOC update by just looking at the first page of the
vmalloc region.

Link: https://lkml.kernel.org/r/20250403053326.26860-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/vmalloc.c~memcg-vmalloc-simplify-memcg_vmalloc-updates
+++ a/mm/vmalloc.c
@@ -3370,12 +3370,12 @@ void vfree(const void *addr)
 
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
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
@@ -3671,12 +3671,9 @@ static void *__vmalloc_area_node(struct
 		node, page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
-	if (gfp_mask & __GFP_ACCOUNT) {
-		int i;
-
-		for (i = 0; i < area->nr_pages; i++)
-			mod_memcg_page_state(area->pages[i], MEMCG_VMALLOC, 1);
-	}
+	if (gfp_mask & __GFP_ACCOUNT && area->nr_pages)
+		mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
+				     area->nr_pages);
 
 	/*
 	 * If not enough pages were obtained to accomplish an
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-vmalloc-simplify-memcg_vmalloc-updates.patch
memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch

