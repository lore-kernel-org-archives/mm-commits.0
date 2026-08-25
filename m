Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BCA340281;
	Tue, 25 Aug 2026 01:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622818; cv=none; b=QmA7poycTvDyTgHRQEtcXqJ99Qqud/fQG68iGVo+EDF4piF9YKS+bEmthtC/FCQFalLyf+h9fR2dVX+fgdtLTP7da5lLzdNTVv4VPQCCjNsvyYw3unrUSSwljg52SlK1nZuKsiNzK9EMj4vzVS21zFnLf59qKUk22dCajdIpXmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622818; c=relaxed/simple;
	bh=VtEVvRbN6NIjLkAxIizrwJZgCiR/LSsDYRJ7n3DJ47o=;
	h=Date:To:From:Subject:Message-Id; b=oR7oncfa4zZ8T4uUMLjL17rhaTr9YoGTE2y1j3fM9Uavv3ntslbIh26qbTT9Uwg9OKt9rB/kCGgFNZkLLuHw2c7Byy6CPzqbcEWPLLLkAug7zhaAGnC07bt17gYM55JHSwMG269AzB29L4cYBpgsV9JVBs/uOnHXzKG5JsWCWrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gmv1tox5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gmv1tox5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CC91F00A3A;
	Tue, 25 Aug 2026 01:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622816;
	bh=qYZsg3bpTsYzg8vpKlUtRD2Pz/uwmtl5bz8MxQiArog=;
	h=Date:To:From:Subject;
	b=Gmv1tox5p5R+RhYyOC4gz0+4pz/jkVlBYvjW9dS4YiVNi6xm8nDeqO4yyk1XOVkmT
	 5jspnRIs+etKK4cXwk8cqDGSgcUJKh4N0V1STit5NkwkQJcUrVEnWTQPv+yRrDMQXA
	 bB5obk8OZ7iqZVvjEojwHhOOgm+jkJDjcMolmLa4=
Date: Mon, 24 Aug 2026 18:53:36 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterx@redhat.com,kas@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,hughd@google.com,ackerleytng@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios.patch removed from -mm tree
Message-Id: <20260825015336.66CC91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: fix always draining LRU caches in collect_longterm_unpinnable_folios()
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/gup: fix always draining LRU caches in collect_longterm_unpinnable_folios()
Date: Fri, 31 Jul 2026 22:27:53 +0200

folio_may_be_lru_cached() is currently only true for small folios, and
for small folios FOLL_PIN adds GUP_PIN_COUNTING_BIAS references instead
of 1 in try_grab_folio()/try_grab_folio_fast().

Consequently, our

	folio_ref_count(folio) != folio_expected_ref_count(folio) + 1

check in collect_longterm_unpinnable_folios() will currently always
identify "reference mismatch" and first drain the local LRU cache to then
drain the LRU cache on all CPUs, as collect_longterm_unpinnable_folios()
is really called after pinning the folios with FOLL_PIN.

Add a comment because the current code is not quite intuitive: we used to
drain only to make sure the folio_isolate_lru() would succeed. But then we
also started draining to make later migration more reliable.

We'll refactor that code soon a bit, to also make it usable in other
context where we really want to remove any references from LRU caches.

Let's add CC stable, because having an easy way for excessive LRU cache
draining on all CPUs does not sound right. In common scenarios we
don't expect to ever have to drain.

Link: https://lore.kernel.org/20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org
Fixes: 98c6d259319e ("mm/gup: check ref_count instead of lru before migration")
Fixes: a09a8a1fbb37 ("mm/gup: local lru_add_drain() to avoid lru_add_drain_all()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios
+++ a/mm/gup.c
@@ -2273,6 +2273,7 @@ static unsigned long collect_longterm_un
 
 	for (folio = pofs_get_folio(pofs, i); folio;
 	     folio = pofs_next_folio(folio, pofs, &i)) {
+		const int pin_refs = folio_has_pincount(folio) ? 1 : GUP_PIN_COUNTING_BIAS;
 
 		if (folio_is_longterm_pinnable(folio))
 			continue;
@@ -2287,15 +2288,20 @@ static unsigned long collect_longterm_un
 			continue;
 		}
 
+		/*
+		 * We drain not only to make the folio_isolate_lru() succeed,
+		 * but also to remove any other folio references from LRU
+		 * caches.
+		 */
 		if (drained == 0 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
+				folio_expected_ref_count(folio) + pin_refs) {
 			lru_add_drain();
 			drained = 1;
 		}
 		if (drained == 1 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
+				folio_expected_ref_count(folio) + pin_refs) {
 			lru_add_drain_all();
 			drained = 2;
 		}
_

Patches currently in -mm which might be from david@kernel.org are


