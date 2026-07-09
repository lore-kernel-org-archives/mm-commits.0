Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B34643B485
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622487; cv=none; b=UM2kfOLzscYHuokX+wHEQ7aYRA1MKQQUjhlcbDJ49YxOSAf8jP6EUhs4jbOOoNZ/1AEmBRXElbmfj0yOjdbV5OZw4f1BVrYgpaAACu2O4jlSs54DOiQ+07ztZ44ClGyjIBplSTStKEr56GWyc23nVtpv0GIMu8vm6dXQe+uXt+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622487; c=relaxed/simple;
	bh=DZ9zuUh40mxNYqvDInY5ha3CPRKK85i9tWVo2tkaO68=;
	h=Date:To:From:Subject:Message-Id; b=H1hCeW4jhKn617VOo5Y4IOy7qaiQulRlb3frsxo3FzHluwRi3yuFR8KsjderVD0Roexe/hUvJ+fxd2PIlm+/8tMi2LOEmgEquz0waQDjM+r/Mec/4+34DJXb5VAns3mqx3qiUsMe3dNlDGAnOKfeZncmFPXDmijCBBbN3nbksxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W32Erd0l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W32Erd0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0462D1F000E9;
	Thu,  9 Jul 2026 18:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783622485;
	bh=EaLs/h0SQqxhJ2vOuzp91OucvkGlNCfawLTvf5C7gkc=;
	h=Date:To:From:Subject;
	b=W32Erd0lkRGCuKKOwvMcWDXcb8mZtS1RkNjLikMP2VaMl/c962I2kHE8fTDeHRu5x
	 Zo+rcXFWMZ5hcm3b3W091C/TqlejiUlZ00+4XXw0ssNmmwSJWFA7tSqbB0gkjB7JQ0
	 vZqMEbRle3Pc3q1rIh49wc7aRruQhDprheZxmUqQ=
Date: Thu, 09 Jul 2026 11:41:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch added to mm-unstable branch
Message-Id: <20260709184125.0462D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: remove set_page_private() in prep_compound_tail()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page_alloc: remove set_page_private() in prep_compound_tail()
Date: Thu, 09 Jul 2026 14:06:05 -0400

Tail pages are expected to have (and optionally be checked) zeroed
->private when they are freed.  It stays true during subsequent
reallocation, so replace the tail_page->private initialization with a
VM_WARN_ON_ONCE() in compound page preparation.

Link: https://lore.kernel.org/20260709-keep-subpage-private-zero-at-free-v3-5-7e4fe155f5b9@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-page_alloc-remove-set_page_private-in-prep_compound_tail
+++ a/mm/internal.h
@@ -741,7 +741,7 @@ static inline void prep_compound_tail(st
 {
 	tail->mapping = TAIL_MAPPING;
 	set_compound_head(tail, head, order);
-	set_page_private(tail, 0);
+	VM_WARN_ON_ONCE(tail->private);
 }
 
 static inline void init_compound_tail(struct page *tail,
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_owner-add-numa-node-filter-fix.patch
mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

