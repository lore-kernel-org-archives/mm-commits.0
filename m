Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B115E286D4D;
	Wed,  2 Sep 2026 21:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788385956; cv=none; b=iWqQR59gqHxy79Bq4IgKFdR16pY4QRfdYCgp8RW3chpclyI4npjPbU11hjCwyy7ZZ8qAvofwfLW4simQoijMk4JkAtMd9+BsrctMICQPJfAqOemE+EkxviU3//0FOuMdm+99majxIqCmgimiSglE36IuQebi3XD7HIZMNo0+h6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788385956; c=relaxed/simple;
	bh=4ORfokG30Vqj55xZURf/8K6GoncDYfTolbPP5O3Ioq0=;
	h=Date:To:From:Subject:Message-Id; b=EeMHRzTDROH5sLyQ0doxyTdHZ/pyi3ag6IPjslnQch3lKULep7olAnhaY44cFKw4ib1gHMG38jmlpfVqaVAgmJgWZoGU52clG/sYh2chEoOxNI+FpceWAxPZ5Zo2an1RXVgZxEHnNBOJyTM/ltFRYQqk2AytV2uI5zNMpYq0r5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AGzm/alE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AGzm/alE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93E71F00A3A;
	Wed,  2 Sep 2026 21:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788385949;
	bh=Wa54TkSgceWVso6Dp69G4SzLcl74UaaOxVf2vnaXqhI=;
	h=Date:To:From:Subject;
	b=AGzm/alEeMkNulhAFs11xYyHVXiXh0AH6TneuJKG/PPnQL4YO640nuAo0b2PTx7zN
	 mCwjz/uDCFAD7Ad9T3+TF0LGx8Q0GzB7JzKnIi7ji6QMCtXpBYDacb2za1gl53Iwyt
	 pZJx7w6WYP+DLy4q3/kqjG5FwxOy3KENAxbm4bQE=
Date: Wed, 02 Sep 2026 14:52:29 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,vannapurve@google.com,surenb@google.com,stable@vger.kernel.org,si.yanteng@linux.dev,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,peterx@redhat.com,osalvador@suse.de,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,mawupeng1@huawei.com,louhongxiang@huawei.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,jthoughton@google.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,fvdl@google.com,dzm91@hust.edu.cn,david@kernel.org,corbet@lwn.net,alexs@kernel.org,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure.patch added to mm-new branch
Message-Id: <20260902215229.A93E71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: drop refcount before freeing on memcg charge failure
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Wed, 02 Sep 2026 01:22:57 -0700

When mem_cgroup_charge_hugetlb(folio, gfp) returns -ENOMEM, the folio has
its refcount set to 1 via folio_ref_unfreeze(folio, 1).

The error path calls free_huge_folio(folio) directly, which expects a
refcount of 0.  Hence, VM_BUG_ON_FOLIO(folio_ref_count(folio), folio) is
triggered.

Even with CONFIG_DEBUG_VM disabled, returning a folio with refcount 1 to
the freelist can corrupt allocator state later.

Use folio_put(folio) instead of free_huge_folio(folio) to properly drop
the reference before freeing it.

Link: https://lore.kernel.org/20260902-hugetlb-alloc-folio-memcg-charge-error-handling-v1-2-e3e8942c141b@google.com
Link: https://lore.kernel.org/all/20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com/ [1]
Link: https://lore.kernel.org/all/20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com/ [2]
Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Alex Shi <alexs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dongliang Mu <dzm91@hust.edu.cn>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Hongxiang Lou <louhongxiang@huawei.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
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

