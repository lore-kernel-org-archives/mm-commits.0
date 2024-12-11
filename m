Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20092451EA
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 00:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733877954; cv=none; b=Fc8/oVyKIFlDvcHNmve+BNddgY6YNkSK93e0nLx5WkHuMZwD4wY9x3vIHL4MGVHQUh1Gc9qJeZYoPjGuE5uWGJEVr7KDuU6BUxC1O9M1bdU+O3vh1niPu0N5M0gZBwOpzj4DbI1s44tR0FQp9LmkIdTbmRMb2A+1KWzI6WMsC7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733877954; c=relaxed/simple;
	bh=c58b6Qse0EV7IFdH6TqkjeCziFBwPbKGg3/ViTurgG4=;
	h=Date:To:From:Subject:Message-Id; b=VUEmvQACRG/gm6NBZcqV9z6sl7ZniCgXx7mSaQjan2++asrOAkWJwbMzHKbWcuPdL3nlE9b0LQVlLBDyEQpoogT6hv3Tf7tvgkfkC5rqKyVq7rCgf5jCyd02V3voBovi7Clxg3iinabPMgjqMuVxiE8r+Ox73sF7xUVIVauaUnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nbT2dD34; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nbT2dD34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4363DC4CED6;
	Wed, 11 Dec 2024 00:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733877953;
	bh=c58b6Qse0EV7IFdH6TqkjeCziFBwPbKGg3/ViTurgG4=;
	h=Date:To:From:Subject:From;
	b=nbT2dD34TV2v/TNNXwUPsqU5lt3x6L0L41+JaLviCKgw8CNvXfFkU0dG51/MLsDCC
	 U7C8HwWfnIUkJ43Y52+lKwbq6xgQeah2Grb0gLWSqeOHva++MxP3sYw9o9H0YQ9IpN
	 XnnDRrxMG2wbC9GA/UrIom7PPxSh1tvmpo9hYLFg=
Date: Tue, 10 Dec 2024 16:45:52 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,iamjoonsoo.kim@lge.com,david@redhat.com,cl@linux.com,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-remove-slab-checks-in-isolate_movable_page.patch added to mm-unstable branch
Message-Id: <20241211004553.4363DC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: remove slab checks in isolate_movable_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-remove-slab-checks-in-isolate_movable_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-remove-slab-checks-in-isolate_movable_page.patch

This patch will later appear in the mm-unstable branch at
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
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/migrate: remove slab checks in isolate_movable_page()
Date: Tue, 10 Dec 2024 21:48:07 +0900

Commit 8b8817630ae8 ("mm/migrate: make isolate_movable_page() skip slab
pages") introduced slab checks to prevent mis-identification of slab pages
as movable kernel pages.

However, after Matthew's frozen folio series, these slab checks became
unnecessary as the migration logic fails to increase the reference count
for frozen slab folios.  Remove these redundant slab checks and associated
memory barriers.

Link: https://lkml.kernel.org/r/20241210124807.8584-1-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 --------
 mm/slub.c    |    4 ----
 2 files changed, 12 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-slab-checks-in-isolate_movable_page
+++ a/mm/migrate.c
@@ -68,10 +68,6 @@ bool isolate_movable_page(struct page *p
 	if (!folio)
 		goto out;
 
-	if (unlikely(folio_test_slab(folio)))
-		goto out_putfolio;
-	/* Pairs with smp_wmb() in slab freeing, e.g. SLUB's __free_slab() */
-	smp_rmb();
 	/*
 	 * Check movable flag before taking the page lock because
 	 * we use non-atomic bitops on newly allocated page flags so
@@ -79,10 +75,6 @@ bool isolate_movable_page(struct page *p
 	 */
 	if (unlikely(!__folio_test_movable(folio)))
 		goto out_putfolio;
-	/* Pairs with smp_wmb() in slab allocation, e.g. SLUB's alloc_slab_page() */
-	smp_rmb();
-	if (unlikely(folio_test_slab(folio)))
-		goto out_putfolio;
 
 	/*
 	 * As movable pages are not isolated from LRU lists, concurrent
--- a/mm/slub.c~mm-migrate-remove-slab-checks-in-isolate_movable_page
+++ a/mm/slub.c
@@ -2414,8 +2414,6 @@ static inline struct slab *alloc_slab_pa
 
 	slab = folio_slab(folio);
 	__folio_set_slab(folio);
-	/* Make the flag visible before any changes to folio->mapping */
-	smp_wmb();
 	if (folio_is_pfmemalloc(folio))
 		slab_set_pfmemalloc(slab);
 
@@ -2636,8 +2634,6 @@ static void __free_slab(struct kmem_cach
 
 	__slab_clear_pfmemalloc(slab);
 	folio->mapping = NULL;
-	/* Make the mapping reset visible before clearing the flag */
-	smp_wmb();
 	__folio_clear_slab(folio);
 	mm_account_reclaimed_pages(pages);
 	unaccount_slab(slab, order, s);
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-migrate-remove-slab-checks-in-isolate_movable_page.patch

