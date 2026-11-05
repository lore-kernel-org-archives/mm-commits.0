Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894087;
	b=vNCkni5v6SQRMJT7wZXFZuubp/GEG5NLUVGGr1GgpSkTiVnhYkReIboJi4WG8nhTfE3i
	 /G2JICEY6yLwJQnTEy3qlr4ASBohpq9SlznbOTK5C116p0kLt39AMK0OgZpsvrciP5R2G
	 YEnLAb4yIB/qM3Nu2NZS6jfNDAZvKSGSWPnHJvsHYOymZSslGGb8dbRa4BWyEVdWXKuZV
	 sBew0xN9p8dhRCWtAfHWtpQN5BXMYNqQBHyR1VFgx1/Y5EnHuW+AsKIvj5edqAgxJL5He
	 fbYTxrFQP7tNsV/NanAYSqpdIJphATblEFoNpudSj4wOTYP4UDskh7g/r/pQqnNyj7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894087;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=CO7cXFAzcz9GOhtMhNJOZGva6duZlNHqXQXpWUY60Zs=;
	b=DOLAbGUv7eb0Mx5op/ztNKxNHoMWz7J4RXMeftSnOoP1b524QE1wLtuVjPsiLEgHJJCb
	 qc/Z7r4f6i2ZC0uP5CScC+NqYTwpk/dKMJE66r4yE7Cqb8W8sEgpr0pdmAUTP+XlO+nlc
	 o8SEtwmamuVdPJVHXz8xADeb031fpoX5qI7lUvfpO3IiFpDDGQY9bYJRRJF9elmuCFP7u
	 +EY6X7VPyap06MgADmFBNEbyPo6g4FnDsJfk60Bdpl3HmWaPiJrXvnI+N4Xe58/5adIXA
	 z1jYzUxq9YB5oMFYvicCZJ6vSuZdgWl/4oEGBhHZLkXT6HVn7JGzioMaYawGkwA6tpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dGtYk3cc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78024606CF9D
	for <mm-commits@vger.kernel.org>; Thu,  5 Nov 2026 15:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dGtYk3cc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382791F00A02;
	Thu,  5 Nov 2026 15:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793894086;
	bh=CO7cXFAzcz9GOhtMhNJOZGva6duZlNHqXQXpWUY60Zs=;
	h=Date:To:From:Subject;
	b=dGtYk3cc9Pv/zySPBqfxkYK9Ea+7aNkFxCC+fFvDAUTVlrctUp1O6pFEQRRsRve9k
	 qXMRp7p3LVv1iscT0Rfsu4h9TmtqmmAMLjRmzbtZU9fPla/++KW3KyeIwifYo0Sgkl
	 OWSD/HJBGGvPfBHFgv7+KTUnRXBh1hcXkwAn6gss=
Date: Thu, 05 Nov 2026 07:54:45 -0800
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-remove-attach_page_private-and-detach_page_private.patch removed from -mm tree
Message-Id: <20261105155446.382791F00A02@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: remove attach_page_private() and detach_page_private()
has been removed from the -mm tree.  Its filename was
     mm-remove-attach_page_private-and-detach_page_private.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove attach_page_private() and detach_page_private()
Date: Mon, 02 Nov 2026 17:54:09 -0500

There are no callers left of either wrapper. Remove them.

Link: https://lore.kernel.org/20261102-page-wrappers-v1-4-e7280bdb31f6@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
---

 include/linux/pagemap.h |   10 ----------
 1 file changed, 10 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-attach_page_private-and-detach_page_private
+++ a/include/linux/pagemap.h
@@ -635,16 +635,6 @@ static inline void *folio_detach_private
 	return data;
 }
 
-static inline void attach_page_private(struct page *page, void *data)
-{
-	folio_attach_private(page_folio(page), data);
-}
-
-static inline void *detach_page_private(struct page *page)
-{
-	return folio_detach_private(page_folio(page));
-}
-
 #ifdef CONFIG_NUMA
 struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *policy);
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-remove-mod_memcg_page_state.patch
mm-memcontrol-remove-page_memcg_check.patch
mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch
mm-remove-find_get_page_flags.patch
mm-remove-find_lock_page.patch
mm-remove-read_cache_page_gfp.patch
mm-remove-thp_size-and-thp_order.patch

