Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D8C3B6C09
	for <mm-commits@vger.kernel.org>; Sun, 27 Sep 2026 05:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790488292; cv=none; b=HlA4k5o8Z/8BL08DIftNNqhXeBhsJ8GofR4ZrT+ck0//MsJYqLRg6E9VO5z3IdU2Y8EvAOgiAOdmkWlRLLNDq8p86n+/YDr8rchvaCZgEK68lIJJKufWFRk04ZSRrbU+eG7G5mF2+iAw+got+RLfbAN8LB/EhVan/+mayhkECIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790488292; c=relaxed/simple;
	bh=q9TwriU9B681MlCpOjGxiZCeQxnsQVeU4GXBU3sYLc4=;
	h=Date:To:From:Subject:Message-Id; b=Qc00+4AMs8QOqFURBbjdx7as5sd1QllMiGlIB3+mzea4TX/EGeGl7c7loucJbajDGKeJBG7/WJogT3ynjhYUUQvylwQ7UaG6YNG1k8JIUhYLE/Y9eW2tyi48ASqHdZ8a/MRYCTOMykpSHlrVyBnEB/0N16FjqsN95J5hv7h7bik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tzBUkBh6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tzBUkBh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868171F000FF;
	Sun, 27 Sep 2026 05:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790488290;
	bh=udUY4qIo44eiFQVRuKbWJroGMBQ6E8Yj8/UEaK0SkFA=;
	h=Date:To:From:Subject;
	b=tzBUkBh60YiC5a8oLMbk0eoz9dNm9niFXdOpGmJ+oHu5PtOGX/8gP0WTVVKk5eTRv
	 vfjyCUSjxhxCRChBN73m1t/wYLhBXpEUCBe5DsWs5f+W77uTZT6fN1lL12MVBkUZ5t
	 kfr5dP4PSwq1OWhEiwM8rXxhJmkSI/kXf3ucsYJI=
Date: Sat, 26 Sep 2026 22:51:30 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-open-code-init_compound_tail.patch added to mm-unstable branch
Message-Id: <20260927055130.868171F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse-vmemmap: open-code init_compound_tail()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-vmemmap-open-code-init_compound_tail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-open-code-init_compound_tail.patch

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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: open-code init_compound_tail()
Date: Sun, 27 Sep 2026 10:54:33 +0800

init_compound_tail() is only used by vmemmap_shared_tail_page(), where
the shared tail page setup intentionally passes NULL as the compound head.

Keeping this helper in mm/internal.h exposes that special case to the rest
of the MM code and can make the NULL head argument look generally valid.
Open-code the initialization at the only call site so the special-case use
stays local to sparse vmemmap optimization.

No functional change intended.

Link: https://lore.kernel.org/20260927025441.741633-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Lance Yang <lance.yang@linux.dev>
---

 mm/internal.h       |    9 ---------
 mm/sparse-vmemmap.c |    5 ++++-
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/mm/internal.h~mm-sparse-vmemmap-open-code-init_compound_tail
+++ a/mm/internal.h
@@ -786,15 +786,6 @@ static inline void prep_compound_tail(st
 	VM_WARN_ON_ONCE(tail->private);
 }
 
-static inline void init_compound_tail(struct page *tail,
-		const struct page *head, unsigned int order, struct zone *zone)
-{
-	atomic_set(&tail->_mapcount, -1);
-	set_page_node(tail, zone_to_nid(zone));
-	set_page_zone(tail, zone_idx(zone));
-	prep_compound_tail(tail, head, order);
-}
-
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-open-code-init_compound_tail
+++ a/mm/sparse-vmemmap.c
@@ -217,7 +217,10 @@ struct page __ref *vmemmap_shared_tail_p
 	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
 		page = (struct page *)addr + i;
 		mm_zero_struct_page(page);
-		init_compound_tail(page, NULL, order, zone);
+		atomic_set(&page->_mapcount, -1);
+		set_page_node(page, zone_to_nid(zone));
+		set_page_zone(page, zone_idx(zone));
+		prep_compound_tail(page, NULL, order);
 	}
 
 	page = virt_to_page(addr);
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-allocate-shared-tail-page-array-dynamically.patch
mm-sparse-vmemmap-introduce-config_vmemmap_optimization.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-compound-page-orders.patch
mm-sparse-vmemmap-set-compound-page-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-move-vmemmap-optimization-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch

