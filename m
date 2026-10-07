Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0032264AB;
	Wed,  7 Oct 2026 00:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334389; cv=none; b=W5O4ekcT6gkmaTJabrgfRf/wfe9/4mkgbNf9uAQU5ZEKWbgYAfNmKE/XkGDsl4KThvA8dl4p01Lr4BYmPYLj0zFgE3zY6mEbBP5RA4cHpYMlhsPNGMTnDr9rLsGS9u/GOJrZeJJo5raV7tPPJFs12zGlGqasL3WfZXH9ddOqzAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334389; c=relaxed/simple;
	bh=74dNvMGve2pZvwywao/PQVv6aA1LxxPh0HQxmoj7qcM=;
	h=Date:To:From:Subject:Message-Id; b=DhizdzD7WEMKkhIAaDUvmyPQHIaBfZGDe81Pzb+Gtu8xp2BkLEr/5+fRiBvy4ugaLFOQcuNu/KHITvJAgbJJOMgpykzvZIuCJsXYwBQujRJKOjKoy0CYIktXKoLdivIhQM8OxeuMg54pUz6e6bnd1+WWgnv0MiJu9b910vP+4mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X/EPsl6n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X/EPsl6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5581F0089C;
	Wed,  7 Oct 2026 00:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334388;
	bh=RmJy45UiwGrapkPoWNzvhXINnviPLi57uE9SXlUsKkg=;
	h=Date:To:From:Subject;
	b=X/EPsl6nxVkqqA3My1xLOUZggwtp5P/1dViIpp4hCbayPmZkgAkWoF+qWzIGy5dYF
	 oeCnUv/SJiST3Z8Z5wpo+6iD+UScNe7rh0tP2g/vp6q5bgK3jcBaCRSz4lUordps7a
	 zAEEhUH1WJgfPmbB7Kzn5IwbiT50mLpP2Aa+aT+c=
Date: Tue, 06 Oct 2026 17:53:08 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,vannapurve@google.com,surenb@google.com,stable@vger.kernel.org,si.yanteng@linux.dev,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,peterx@redhat.com,osalvador@suse.de,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,mawupeng1@huawei.com,louhongxiang@huawei.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,jthoughton@google.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,fvdl@google.com,dzm91@hust.edu.cn,david@kernel.org,corbet@lwn.net,alexs@kernel.org,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure.patch removed from -mm tree
Message-Id: <20261007005308.5D5581F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: drop refcount before freeing on memcg charge failure
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ackerley Tng <ackerleytng@google.com>
Subject: mm: hugetlb: drop refcount before freeing on memcg charge failure
Date: Wed, 09 Sep 2026 10:11:01 -0700

When mem_cgroup_charge_hugetlb(folio, gfp) returns -ENOMEM, the folio has
its refcount set to 1 via folio_ref_unfreeze(folio, 1).

The error path calls free_huge_folio(folio) directly, which expects a
refcount of 0.  Hence, VM_BUG_ON_FOLIO(folio_ref_count(folio), folio) is
triggered.

Even with CONFIG_DEBUG_VM disabled, returning a folio with refcount 1 to
the freelist can corrupt allocator state later.

Use folio_put(folio) instead of free_huge_folio(folio) to properly drop
the reference before freeing it.

Link: https://lore.kernel.org/20260909-hugetlb-alloc-folio-memcg-charge-error-handling-v2-2-4b4a8a19a7f7@google.com
Fixes: 991135774c0e ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dongliang Mu <dzm91@hust.edu.cn>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Hongxiang Lou <louhongxiang@huawei.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure
+++ a/mm/hugetlb.c
@@ -2917,7 +2917,7 @@ struct folio *hugetlb_alloc_folio(struct
 	lruvec_stat_mod_folio(folio, NR_HUGETLB, nr_pages);
 
 	if (ret == -ENOMEM) {
-		free_huge_folio(folio);
+		folio_put(folio);
 		/*
 		 * Skip uncharging hugetlb_cgroup since the charges
 		 * were committed to the folio and freeing the folio
_

Patches currently in -mm which might be from ackerleytng@google.com are


