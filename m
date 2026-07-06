Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01313EEAE2
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 22:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783377155; cv=none; b=SNYy60+D4Kn5xZowRTpnv/KRlJtRB5Kt1FuE2Dm/ld6PXGvTv1F7Hr2FovpMhqFFGAZjM78cwgWwgM+3mdjiCwrCpcaMmb7KGGN6Ks23rqkQa/iLl91ihoWsIXc6vllDI8IzaeTMjGBFm3avG4M29oadpswWgsJdBmQy73cSLpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783377155; c=relaxed/simple;
	bh=fY9AF4Z9U3DreeyULHyeoXH6D2cBjEtLj7zs5hxBZEA=;
	h=Date:To:From:Subject:Message-Id; b=lDs/9XjL2UoSJwssBS8xHZxmxdV2eOTNG9GFZThH1INORm12cu+h96hLopDSpmcjmVJHyDrQW1UrJNc8ACt8MOc7jEFXpYZd+vsVYZDbvWPCytdNpFl4ILdCHD7rG7FQg5/49/e2cyNRysbCyOx6bDYPUCne3oHTjyi2GQz5cnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lhWs2vXA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lhWs2vXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD6B1F000E9;
	Mon,  6 Jul 2026 22:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783377153;
	bh=+qyV/44AJ0Kgqx1p7LjUIiBX7VYMZn/ARYALPlVl2BQ=;
	h=Date:To:From:Subject;
	b=lhWs2vXASh/tHCuQURtNS7aAZD2lh9a6ZAg6ngyFikXoGl6kjz+/svl7mqUfr2wof
	 lJOqs74o1MS89mz+ZtLxgUCXVVukW15f0PScpTGuz7+O774ojsENz8YDM/lBzpvSJR
	 iO+ORLxQhO6g+PZWTn5kXj2kKN08DedUBW8MeSnk=
Date: Mon, 06 Jul 2026 15:32:32 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tj@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,dennis@kernel.org,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch added to mm-new branch
Message-Id: <20260706223233.4BD6B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: make sure tail_page->private is zero at page free time
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page_alloc: make sure tail_page->private is zero at page free time
Date: Fri, 03 Jul 2026 09:47:49 -0400

Any code using tail_page->private of a folio, a compound page or a
high-order page is supposed to reset it after use, otherwise ->private
data can leak to new page user and cause unexpected issues.  Add a
bad_page() check at page free path for it.

Link: https://lore.kernel.org/20260703-keep-subpage-private-zero-at-free-v2-4-2970fe777dd6@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time
+++ a/mm/page_alloc.c
@@ -1377,15 +1377,22 @@ static __always_inline bool __free_pages
 #endif
 		}
 		for (i = 1; i < (1 << order); i++) {
+			struct page *tail_page = page + i;
+
 			if (compound)
-				bad += free_tail_page_prepare(page, page + i);
+				bad += free_tail_page_prepare(page, tail_page);
 			if (is_check_pages_enabled()) {
-				if (free_page_is_bad(page + i)) {
+				if (free_page_is_bad(tail_page)) {
 					bad++;
 					continue;
 				}
 			}
-			(page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			tail_page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			if (is_check_pages_enabled() && tail_page->private) {
+				bad_page(tail_page, "nonzero private");
+				bad++;
+				continue;
+			}
 		}
 	}
 	if (folio_test_anon(folio)) {
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

