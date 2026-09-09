Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B173B42C4;
	Wed,  9 Sep 2026 23:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788997251; cv=none; b=DUx/X0/gvj/OYwlWBbnFSy7QdReI0SAqH8V9wdcq0qh9S/9asU/T0oVmpA+mfGW/UvN07tEzlyP8qI+ErlrWGewl5FCWSn5LC46Be5bicY9pjNSqG3PPmbzLzxDKkzfw57i4Wh8GmGN4WvAea3rExxJ8AGJw/+OsGmlNn3yNQks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788997251; c=relaxed/simple;
	bh=Qf7jvpOKbSkQ/rigG4WUFq6Rlwz5ug3NUbrAK/3juwc=;
	h=Date:To:From:Subject:Message-Id; b=EWpk6ToDNtxaLXS0LjU0V1L01HquS/+Kx4ktb+xFZMBdVkfBqrkWnAKHpX61NLD2mwzjXvl0eUaCRMn6DMCpdP1yaOVMqkcPse73mtD+7IKWRHmMJc6P8FfO4xtcuvX+xfyXWQLXn2RbnoaeoiEd+BDO84ZRMBDs9dDxbPXTwb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y2v3oADh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y2v3oADh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7FA1F000FF;
	Wed,  9 Sep 2026 23:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788997250;
	bh=ctkwBZJ5mcQHj5xauChjKwaTCzWgPiP6EGWZMFhMpzk=;
	h=Date:To:From:Subject;
	b=y2v3oADhoBZr/7mnWJW4Ml1cRVlWijcz+K1uoxJoQFfS3LmhLbQWNOkbRSn+wFEXc
	 hfYeKz/9YmlTv0nrM32Q01ay0lG7mQJgurJv/XcepOgpSLBt+xPJa4nHgD752lbV/S
	 jTO5ARkEii2Nw6NUwMhr4eRxAQyu9wh/CJk4EmMI=
Date: Wed, 09 Sep 2026 16:40:49 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,vannapurve@google.com,surenb@google.com,stable@vger.kernel.org,si.yanteng@linux.dev,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,peterx@redhat.com,osalvador@suse.de,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,mawupeng1@huawei.com,louhongxiang@huawei.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,jthoughton@google.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,fvdl@google.com,dzm91@hust.edu.cn,david@kernel.org,corbet@lwn.net,alexs@kernel.org,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure.patch added to mm-unstable branch
Message-Id: <20260909234049.DE7FA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: drop refcount before freeing on memcg charge failure
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure.patch

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
Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-hugetlb-return-enospc-on-memcg-charge-failure.patch
mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure.patch

