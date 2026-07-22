Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285A930F815
	for <mm-commits@vger.kernel.org>; Wed, 22 Jul 2026 23:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784762547; cv=none; b=OPCkK2aJjz47+h6rHagYtKfnmsuzRYfCv+6TDJ4cADFmMph/CxBYMmQS2oN4CUEhNRVYQhO5XrKQfp8sA39xDB+b2K/sYzIJ0nsiR9Jysir4N6rg8xAtB6ZUgJClg7aBeQKDClM29jB7YJh+xC9wtrDNndmp5Lr9l7xBG7lpt/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784762547; c=relaxed/simple;
	bh=v69GecBoNKpoixPDgZwa+3NCrRWnVKIJq/uO2WJr4W8=;
	h=Date:To:From:Subject:Message-Id; b=sNGcmxs/rr5rNUrbLoaG4DZWhY8sLT/XxvOSEhhiykaX1ppZIKGluxkskG823tt3zho8cc9ic3YCNvm3IQvhWTFA1nxThlgV9p+MPTY4wEUYMWdgUeluhNT1wAM28jwiDIrYg0GBpho+qdHiL3FS0UYzpJ2gY4PjozuzpFKY0ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dK+5kgUf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dK+5kgUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AF31F000E9;
	Wed, 22 Jul 2026 23:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784762545;
	bh=71ey0mvKsuJOXeDRAt6ZFA6V/WtEOsu7KY20GJtEeLI=;
	h=Date:To:From:Subject;
	b=dK+5kgUf6lJiwm26y3rPjlfX0h1E9N8jwSlVNv+7ryrC50fxW4KwpEux9hyJ2mG0F
	 UUQRfLhc06vw6CoFbAsFPcrg2DEoDhAMQex34kC7qmFWzF21NHREBTJ7MmPDdj70z7
	 sqEOpLSazOMy7cNavUypkYj30a8vDxPjT+gB+q+Q=
Date: Wed, 22 Jul 2026 16:22:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,gourry@gourry.net,david@kernel.org,brendan.jackman@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-__gfp_fs-lockdep-annotation-for-direct-compaction.patch added to mm-new branch
Message-Id: <20260722232225.A9AF31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: __GFP_FS lockdep annotation for direct compaction
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-__gfp_fs-lockdep-annotation-for-direct-compaction.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-__gfp_fs-lockdep-annotation-for-direct-compaction.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: __GFP_FS lockdep annotation for direct compaction
Date: Wed, 22 Jul 2026 10:56:44 -0400

Patch series "mm: fix reclaim storms in defrag_mode", v2.

As we deployed vm.defrag_mode=1 in Meta production, some workloads
regressed with recurring pressure spikes and swap storms (which in turn
triggered userspace OOM rules on pressure and swap utilization levels).

Tracing pinned this to non-movable requests spinning and reclaiming
unproductively when kswapd/kcompactd are overwhelmed.  Direct reclaim
predominantly frees up pages in movable blocks, but those requests cannot
use that space under defrag_mode rules; and it is unlikely to free up
whole blocks incidentally for __rmqueue_claim() to work.

This series fixes it by making non-movable requests participate in
pageblock production in the allocator slowpath - meaning, they will invoke
direct reclaim and direct compaction with pageblock_order.

That requires some small-ish adjustments up front in the allocator and the
compaction code: three prep patches and the fix last.

The series has been in production against one of the affected workloads
for several weeks and restores the OOM kill rate to !defrag_mode baseline.


This patch (of 4):

A subsequent patch will have some order-0 allocations participate in
compaction under defrag_mode, to stave off extfrag events.

Since this is a sprawling expansion of entry points, and compaction can
enter filesystem paths, add lockdep annotations that catches __GFP_FS
passing errors.

Direct reclaim has had this annotation for a while, and since reclaim and
compaction are usually used in conjunction, this is unlikely to unearth
old bugs.  It's more about future proofing and peace of mind.

Link: https://lore.kernel.org/20260722150006.3848560-1-hannes@cmpxchg.org
Link: https://lore.kernel.org/20260722150006.3848560-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Gregory Price <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-__gfp_fs-lockdep-annotation-for-direct-compaction
+++ a/mm/page_alloc.c
@@ -4207,12 +4207,14 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 
 	psi_memstall_enter(&pflags);
 	delayacct_compact_start();
+	fs_reclaim_acquire(gfp_mask);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
 								prio, &page);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
+	fs_reclaim_release(gfp_mask);
 	psi_memstall_leave(&pflags);
 	delayacct_compact_end();
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-mempolicy-fix-automatic-numa-balancing-for-shmem.patch
mm-gfp_types-fix-__gfp_account-gfp_kernel_account-documentation.patch
mm-page_alloc-__gfp_fs-lockdep-annotation-for-direct-compaction.patch
mm-compaction-support-non-movable-compaction-for-pageblock-requests.patch
mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode.patch

