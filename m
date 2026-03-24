Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8B037CD3F
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388672; cv=none; b=DLKE+XjPs0LXlSj0s1rByUCwbLz0XZw4EFQE8wye91wpuDTNkQBRXOhgGBOFirmYg1Wikgc55pnaxPGIiCejwvGHxvqvAdNDLDt+eng41UM87dQ87uUC/n0MVTWfeDxVrEPmccD2jR7wZLWBf8+AyqQPle/HlW0aN6ColeTV9/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388672; c=relaxed/simple;
	bh=nmeCtAnVbS0SG1trcjvrHTXftnb4xMqAobC84PIoaaw=;
	h=Date:To:From:Subject:Message-Id; b=XEVyO8WV87KI1mJmwsuN8gYejQ5ysyPIqQ4cIbCQpeE6JBmtMU+xv8R/GRZlar2Aoh4z0rq5cW+8libb4sIIkJvFy5GaXAeqHsCJHdWBortDV1K/vvAcHvRbvKTx5QP00WlnHAKO0xWs8pMl6urfvzziOH6y4+IlzBA7MZM4SBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l9pBLhoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l9pBLhoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C3DC19424;
	Tue, 24 Mar 2026 21:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388672;
	bh=nmeCtAnVbS0SG1trcjvrHTXftnb4xMqAobC84PIoaaw=;
	h=Date:To:From:Subject:From;
	b=l9pBLhoFzA6SeryQ7qvjTYK+eczKHAmDHjn1LuLMaS/2AXS+aTuTAdrQrJ2qnvTHh
	 3w0PuYLZR50TjfWOQm+vJbDNyeWhBtf8OPnKv/QJ/NZhnwyxClUNVy/J81fxNAzyb3
	 eq7/M1CNpZDjF2xpj5XJd09cZUOn0KogR908IEDc=
Date: Tue, 24 Mar 2026 14:44:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,will@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kas@kernel.org,gorbunov.ivan@h-partners.com,david@kernel.org,gladyshev.ilya1@h-partners.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-ref_unless-functions-unless_zero-only.patch removed from -mm tree
Message-Id: <20260324214431.F2C3DC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make ref_unless functions unless_zero only
has been removed from the -mm tree.  Its filename was
     mm-make-ref_unless-functions-unless_zero-only.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Subject: mm: make ref_unless functions unless_zero only
Date: Sun, 1 Mar 2026 13:19:39 +0000

There are no users of (folio/page)_ref_add_unless(page, nr, u) with u != 0
[1] and all current users are "internal" for page refcounting API.  This
allows us to safely drop this parameter and reduce function semantics to
the "unless zero" cases only.

If needed, these functions for the u!=0 cases can be trivially
reintroduced later using the same atomic_add_unless operations as before.

[1]: The last user was dropped in v5.18 kernel, commit 27674ef6c73f ("mm:
remove the extra ZONE_DEVICE struct page refcount").  There is no trace of
discussion as to why this cleanup wasn't done earlier.

Link: https://lkml.kernel.org/r/a0c89b49d38c671a0bdd35069d15ee13e08314d2.1772370066.git.gladyshev.ilya1@h-partners.com
Co-developed-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    2 +-
 include/linux/page_ref.h |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-make-ref_unless-functions-unless_zero-only
+++ a/include/linux/mm.h
@@ -1506,7 +1506,7 @@ static inline int folio_put_testzero(str
  */
 static inline bool get_page_unless_zero(struct page *page)
 {
-	return page_ref_add_unless(page, 1, 0);
+	return page_ref_add_unless_zero(page, 1);
 }
 
 static inline struct folio *folio_get_nontail_page(struct page *page)
--- a/include/linux/page_ref.h~mm-make-ref_unless-functions-unless_zero-only
+++ a/include/linux/page_ref.h
@@ -228,18 +228,18 @@ static inline int folio_ref_dec_return(s
 	return page_ref_dec_return(&folio->page);
 }
 
-static inline bool page_ref_add_unless(struct page *page, int nr, int u)
+static inline bool page_ref_add_unless_zero(struct page *page, int nr)
 {
-	bool ret = atomic_add_unless(&page->_refcount, nr, u);
+	bool ret = atomic_add_unless(&page->_refcount, nr, 0);
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
 		__page_ref_mod_unless(page, nr, ret);
 	return ret;
 }
 
-static inline bool folio_ref_add_unless(struct folio *folio, int nr, int u)
+static inline bool folio_ref_add_unless_zero(struct folio *folio, int nr)
 {
-	return page_ref_add_unless(&folio->page, nr, u);
+	return page_ref_add_unless_zero(&folio->page, nr);
 }
 
 /**
@@ -255,12 +255,12 @@ static inline bool folio_ref_add_unless(
  */
 static inline bool folio_try_get(struct folio *folio)
 {
-	return folio_ref_add_unless(folio, 1, 0);
+	return folio_ref_add_unless_zero(folio, 1);
 }
 
 static inline bool folio_ref_try_add(struct folio *folio, int count)
 {
-	return folio_ref_add_unless(folio, count, 0);
+	return folio_ref_add_unless_zero(folio, count);
 }
 
 static inline int page_ref_freeze(struct page *page, int count)
_

Patches currently in -mm which might be from gladyshev.ilya1@h-partners.com are


