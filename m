Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED3B3D9670
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 23:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788997069; cv=none; b=NavWJoZQfITzDC+bD6jVfxRBUMdrSnop8tDdcoZr16fQnxybnt4cMjfvzNKjyUHxoxQu/4UCy9xf1fBseO0OdDstmuMvfMxuvmvqn+EGQwombOeEQi+5B/YvIOGAboCH9K3cnx/FyvQCmHOO8KBLqHjQyvwkYcfMyqIiG8NC1xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788997069; c=relaxed/simple;
	bh=2f4CYi3RVSNWAFhZ49bs8s/PpcJ631BzZV33LUU6OIw=;
	h=Date:To:From:Subject:Message-Id; b=nktI2ku7Qyf2pnVbWNQgGnIpCar15OC3/tRMswc622gnYNlQBDz1hPSuJdHV6cqGk1qwIzfV7J1UOZAki1Ar5/IVJjmMI+1QwgHWz6Gzz86VDiT6gdrhnFDcwd6RAsl4z87ny8y0V7swQlCVRkPYjmWmctr7aKQcn2FEZx4QNG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2ILzMJxf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2ILzMJxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C871F00893;
	Wed,  9 Sep 2026 23:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788997068;
	bh=JAkFr50lQ1dkVvUiPCu0yayiaDCxJYPvcKpLKfAS1ls=;
	h=Date:To:From:Subject;
	b=2ILzMJxfNiml7AGjvNTQaAkn4lMMFU7DRbjSMXGF+oCVwmAtj5n0eyu9zkIbp4wps
	 qK5SZVkRQhMtkpB84XrkptAN0DXHpQgUk2paMdofxk35US8op/RwdiBJTbJzvw/5/M
	 nEeWqHEPOxRGVMOC0dqEnXP6u5Coy+zl7lW/Krv4=
Date: Wed, 09 Sep 2026 16:37:47 -0700
To: mm-commits@vger.kernel.org,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure.patch removed from -mm tree
Message-Id: <20260909233748.54C871F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: drop refcount before freeing on memcg charge failure
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure.patch

This patch was dropped because an updated version will be issued

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
Fixes: 991135774c0e ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
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


