Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894088;
	b=MWxLb1wdANmoAAGn9m/1OZDeRCM2qre/MrfOULotzXxxRZfBS19u/i5brRT2sQbDaKEB
	 ul0KPf6OM+Tod34Z6979tcGb65J3hBstHcqV1DmKrM2hx5dO1PiNFxOyehQ0cyW0XZADV
	 pxUpRAIKJB7665v8a/q22fA7OOKu6XrHY5JZjw94+P4ByB6OBbhTbjGWhSLS4R3eidHJA
	 JkIajFfwEx5p0RSWoc/tStP1VRRKe+PDt0f5V7v82yaU6Jq4YS6hFhxQuJZd4bpqUh15j
	 afHDhObqYFOz0Fa58RH9ui8bImQzQ/CoXOISWV/QFYjFkfS2X5S2EczBRKlFiXJ2YhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894088;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=SyeuW0v1edLG9+y0XOeXm1zhLvni72RagtW+Pj7DuWI=;
	b=OO/F+BTKTFnqftiR2ZDnijhJ5DS5C/blIFplxgzsWcJZfRNKE7Qko4Y5ds3uENcEP0uA
	 +khJJBWU8qSb1nKxBW89P8ZQJtAYMeGrHcI0qdpaqqpQJQO5xGngmzjNLDJ8LzXx1j0aj
	 Je6aGyb1OuYMhVcWlNxBzSIpkPFkyTGx4T2zUEG/28piU/ZADfmv87dLmhnK3vr0aC0kF
	 Z3bvOhc9vuXdfE2xth7zSw1pYKmLHvxoLXiwEz/6EyhldEsoEHwQ2eKnSjXw6/c7YhyjK
	 6dZRZJyW/6+ZSo73acKNliJ2tFgi0mbqKEzIqVASACfRV/Od2MqmUWw4x/3fWo+6rwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BrVAH2YZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD87606BE83
	for <mm-commits@vger.kernel.org>; Thu,  5 Nov 2026 15:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BrVAH2YZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A48C1F00A1B;
	Thu,  5 Nov 2026 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793894087;
	bh=SyeuW0v1edLG9+y0XOeXm1zhLvni72RagtW+Pj7DuWI=;
	h=Date:To:From:Subject;
	b=BrVAH2YZhbUj/2OOIDD60I9nRNmlItxm1Cx3O78bWs3qfmOlVgKDVfE3nlep90MSP
	 PFS2pv6dhdaZhrTX8HmS0TnPHSXauJs7tSCvIjwu2tfNhCBSa1ydX9NFfpxIym8b37
	 31n1le1KjB7JP0MpWa+lW/hO6FMPCut1VsuR/meo=
Date: Thu, 05 Nov 2026 07:54:46 -0800
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-remove-find_get_page_flags.patch removed from -mm tree
Message-Id: <20261105155447.4A48C1F00A1B@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: remove find_get_page_flags()
has been removed from the -mm tree.  Its filename was
     mm-remove-find_get_page_flags.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove find_get_page_flags()
Date: Mon, 02 Nov 2026 17:54:10 -0500

There are no callers left. Remove it.

Link: https://lore.kernel.org/20261102-page-wrappers-v1-5-e7280bdb31f6@columbia.edu
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

 include/linux/pagemap.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-find_get_page_flags
+++ a/include/linux/pagemap.h
@@ -846,12 +846,6 @@ static inline struct page *find_get_page
 	return pagecache_get_page(mapping, offset, 0, 0);
 }
 
-static inline struct page *find_get_page_flags(struct address_space *mapping,
-					pgoff_t offset, fgf_t fgp_flags)
-{
-	return pagecache_get_page(mapping, offset, fgp_flags, 0);
-}
-
 /**
  * find_lock_page - locate, pin and lock a pagecache page
  * @mapping: the address_space to search
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-remove-mod_memcg_page_state.patch
mm-memcontrol-remove-page_memcg_check.patch
mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch
mm-remove-find_lock_page.patch
mm-remove-read_cache_page_gfp.patch
mm-remove-thp_size-and-thp_order.patch

