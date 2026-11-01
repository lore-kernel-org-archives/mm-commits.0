Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793560753;
	b=1TGSa++pyAJduIQ6e0eMKuP77neott5hwlzF5oKO7zPYEYWKraLE6XGypkhXQa4Suc3f
	 Obs3NUGqE2tURp43YKnQgNyIg0Q5+7XHG3VzODBseP/AycmqJEU4y/tHw1IbonN2TJfYl
	 SlNg9zFui4Rftfvb4YzG+b0XgvhqtNrR2vZ7mO4WJ1wasNF6sXPjMAHXbrCnsoiwU7df6
	 nXxI+leB/EHMnTq1ZV8vLw4hbP3dIQTWjLKjb2lRwp//Ha/9OPlBbRKr3fhxiHw/t6q7Z
	 dPJDlPEc4SgIiuk3Gbi/Y/WQ5eCOGWWcZd7qdNQUcPZhiAfDaCa9w/y2bguaWRklwmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793560753;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ENEUPGo4j+nP1jMjyko3qpUNpyXi/BHhbNkFDvONJdM=;
	b=ikeiZWpr9Szb+6WFBQt+5EsNKReBI3tg6NSp6VG63SkkD2YHQp97jR3Qh89CaTXXJ7Da
	 1xUmQg/UeaPyOJpxzkFWrgf2Kh9aDgJSqR3KXVx69VY99nngQGX5aOA3N7vsRBzXDaMFV
	 lyUwZu5FcQGUPsZcN8CBvV7sFm0b0Nwup6gOy+kVdl1EvnSpMNotZ0pahu5uZnAVn9a6R
	 OJd8WJcD2dGNGDrAbgquaNoEsx3d0xzN7GaEpWylmzuhn6u7LEqSZ/6UUcA5UU14yGKAD
	 Gs9Yzt+0QLaHkqt+t+gmbC2qUBfsKAGKwf8gfyr/9lUTKRUVfYUI84ES/iDvUi2EPCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jgEbTCW6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9059606A324;
	Sun,  1 Nov 2026 19:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jgEbTCW6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413771F000C1;
	Sun,  1 Nov 2026 19:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793560752;
	bh=ENEUPGo4j+nP1jMjyko3qpUNpyXi/BHhbNkFDvONJdM=;
	h=Date:To:From:Subject;
	b=jgEbTCW6C5AofkkW3BEE8CZH20/T2perJkpRVN6lxf3878SZMnYMbKRFsyFLGlkzc
	 fTxG+90oZnwQsIDGKdZHjarHM7VQw3piH64MDSIIDKICg/aCuiALfKHtkiLTndXU3u
	 cSeVC1sf/cjMqkHHctUVNNkx2z4m9D/+4eYs6cpc=
Date: Sun, 01 Nov 2026 11:19:11 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterx@redhat.com,
	mason@kernel.org,luto@amacapital.net,jhubbard@nvidia.com,jgg@ziepe.ca,
	david@kernel.org,skhawaja@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-gup-check-folio-mapping-under-folio-lock-in-memfd_pin_folios.patch removed from -mm tree
Message-Id: <20261101191912.413771F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/gup: check folio->mapping under folio lock in memfd_pin_folios()
has been removed from the -mm tree.  Its filename was
     mm-gup-check-folio-mapping-under-folio-lock-in-memfd_pin_folios.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Samiullah Khawaja <skhawaja@google.com>
Subject: mm/gup: check folio->mapping under folio lock in memfd_pin_folios()
Date: Sat, 31 Oct 2026 20:35:40 +0000

memfd_pin_folios() pins folios from the page cache without taking the
folio lock. So khugepaged or MADV_COLLAPSE can replace the folio after
its refcount check while memfd_pin_folios() still pins the old folio,
and the caller ends up with a folio that is no longer part of the memfd.

Lock the folio and recheck folio->mapping before pinning it, like other
page cache users do. If the folio was removed, retry the folio lookup
from the index that was removed.

Link: https://lore.kernel.org/20261031203540.2282507-1-skhawaja@google.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Andy Lutomirski <luto@amacapital.net>
Closes: https://lore.kernel.org/all/CALCETrV5eqg6d9=+BQhCpRwBNe3aCQiut8vxPBs8b7PToqjaHg@mail.gmail.com/
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Chris Mason <mason@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/gup.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-check-folio-mapping-under-folio-lock-in-memfd_pin_folios
+++ a/mm/gup.c
@@ -3464,7 +3464,7 @@ long memfd_pin_folios(struct file *memfd
 {
 	unsigned int flags, nr_folios, nr_found;
 	unsigned int i, pgshift = PAGE_SHIFT;
-	pgoff_t start_idx, end_idx;
+	pgoff_t start_idx, end_idx, retry_idx;
 	struct folio *folio = NULL;
 	struct folio_batch fbatch;
 	struct hstate *h;
@@ -3505,6 +3505,7 @@ long memfd_pin_folios(struct file *memfd
 			 * reason, we try to allocate them and add them to the
 			 * page cache.
 			 */
+			retry_idx = start_idx;
 			nr_found = filemap_get_folios_contig(memfd->f_mapping,
 							     &start_idx,
 							     end_idx,
@@ -3517,7 +3518,21 @@ long memfd_pin_folios(struct file *memfd
 			for (i = 0; i < nr_found; i++) {
 				folio = fbatch.folios[i];
 
+				/*
+				 * The folio might have been removed from the
+				 * page cache (e.g., truncated or collapsed)
+				 * after the lookup. Recheck under the folio
+				 * lock.
+				 */
+				folio_lock(folio);
+				if (unlikely(folio->mapping != memfd->f_mapping)) {
+					folio_unlock(folio);
+					start_idx = retry_idx;
+					break;
+				}
+
 				if (try_grab_folio(folio, 1, FOLL_PIN)) {
+					folio_unlock(folio);
 					folio_batch_release(&fbatch);
 					ret = -EINVAL;
 					goto err;
_

Patches currently in -mm which might be from skhawaja@google.com are


