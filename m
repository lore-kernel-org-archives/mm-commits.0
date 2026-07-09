Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B44E43B3C0
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 18:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622484; cv=none; b=f6Rpi+sdsuBXL5Jna/0FCekHxB0iZzPyGdxyM2efPR+R22WaReEF7Ks87bc6aRuO77Py21CGlwxBDo03e4qbS3WQLxFLn8ki9Awie9txKdYFCAxDexwuCzD8++QWK/c0YpF+o4xlsB1r6iMdj8EBz6GcD6PNB6jrIK7ctdd44MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622484; c=relaxed/simple;
	bh=FrKgv9BAj1KhGftC/ONxxUcVTi4d3oC+LOXDjWe8ksQ=;
	h=Date:To:From:Subject:Message-Id; b=F+ncqjIPRvfUBgtQf1PQLb0miytZjkI3A8YQJ2qjWTJDncKflRmh9EI3nZ7Oy4TUhO4XHA3jhvksDBYNqoVOpTkfJ8oEXbDEtDozDPws7F0mvg2uA+cI1IBNjPndO/9mtO90zT4rpiikgIywW+GUcuXMMl7buUYaHtA5E1U8Okg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lIA7afT/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lIA7afT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D984A1F000E9;
	Thu,  9 Jul 2026 18:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783622483;
	bh=zfRJmfgzMUbdo45krh8QFdxSuXMYinarjYqa6PrMEn4=;
	h=Date:To:From:Subject;
	b=lIA7afT//lwG0nMMKsZE5+aWx7D+bOpa7QH5RPwrp9q0J/1GqMWBQop3XfGbzlOq7
	 DN3E/VlVgpv4RAX+e0F0GwV7e8vaEtbz35AqWP/7A9kZLxUPkZyXs4djY1V9SewFOY
	 /MDQkrNd5PiEuzHZ05rCRML/lJgY9pQEcnkbCsrg=
Date: Thu, 09 Jul 2026 11:41:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch added to mm-unstable branch
Message-Id: <20260709184122.D984A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: make sure tail_page->private is zero at page free time
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch

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
Subject: mm/page_alloc: make sure tail_page->private is zero at page free time
Date: Thu, 09 Jul 2026 14:06:04 -0400

Any code using tail_page->private of a folio, a compound page or a
high-order page is supposed to reset it after use, otherwise ->private
data can leak to new page user and cause unexpected issues.  Add a
bad_page() check at page free path for it.

Link: https://lore.kernel.org/20260709-keep-subpage-private-zero-at-free-v3-4-7e4fe155f5b9@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time
+++ a/mm/page_alloc.c
@@ -1377,15 +1377,23 @@ static __always_inline bool __free_pages
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
+					bad++;
+					continue;
+				}
+
+				if (tail_page->private) {
+					bad_page(tail_page, "nonzero private");
 					bad++;
 					continue;
 				}
 			}
-			(page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			tail_page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
 		}
 	}
 	if (folio_test_anon(folio)) {
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_owner-add-numa-node-filter-fix.patch
mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

