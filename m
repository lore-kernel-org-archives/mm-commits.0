Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE3E29D27D
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465697; cv=none; b=ZrrxrtzE5TSy5LA75oWR746sPfjBL3SBHoiutsXw8+UQFvpp3FoA5deudO5jKst61xdQplUAwzjlBt+uQd0YUK4N0VLAGjRA5LJJsgKslGhHvJuF1QoELTFuy169/Xk8O4wZKk3ZaOBqocyLndjh9qAr5XTEmXnsqov5Rd2tFeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465697; c=relaxed/simple;
	bh=G0T8Hn4QtXeeiW3dB4DuGC/jmeJnccaNZ59XuXeOEZY=;
	h=Date:To:From:Subject:Message-Id; b=D+v6iwtFymmyE4LqXEFIfLwyuBJY14F0E6rCYxM/QF2LddfX+PSo2I55V41wNFKqFOaH73764QMgfNWqFuXzdepr3+I384F6KxVAPyceSBddwEaw7wONniIrpqBpP8JHH+j1hNSBacztjQjRLUVcL/FXAr00ls9ym92KMSegrLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fSjUF+YG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fSjUF+YG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686361F000E9;
	Fri, 31 Jul 2026 02:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465696;
	bh=42Vpfw/aYc5+/I/N53kDNZ0GQgs1sFrKwvUA7bTWlcg=;
	h=Date:To:From:Subject;
	b=fSjUF+YGrKGYE0DLQjWb2Tl+gAX2q/Hz5oYFpQ2lkTTGIcVFn6a/ZNzcuyA9mPv6G
	 hIYpQqSrk9YHEs1jHlpbRR6zd4TsX6TfyelmhFHMxdOddkji0BJE46zhXBwl2I2YsI
	 WreI96Z8TkiXxOv0qOW/4EYCZXwACX/ufGCS/8pA=
Date: Thu, 30 Jul 2026 19:41:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,saileshnandanavanam@gmail.com,rppt@kernel.org,plafer@proton.me,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,doehyunbaek@gmail.com,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-use-kvmalloc-for-target-regions-array.patch removed from -mm tree
Message-Id: <20260731024136.686361F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: use kvmalloc for target regions array
has been removed from the -mm tree.  Its filename was
     mm-damon-core-use-kvmalloc-for-target-regions-array.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mm/damon/core: use kvmalloc for target regions array
Date: Mon, 29 Jun 2026 07:55:32 -0700

Patch series "mm/damon: five misc fixups"

Five patches for miscellaneous DAMON fixups.  Use better fit kernel
functions, cleanup/fixup documents, and add unit tests.

The five patches were initially sent and revisioned by different
individuals.  Each patch contains changelog on their commentary area.  The
patches are curated into this series by SJ, for the convenience in
reposting.


This patch (of 5):

damon_commit_target_regions() temporarily allocates a single contiguous
memory region using kmalloc to store copies of all damon_regions of the
damon_target.  However, if the damon_target has a large number of
damon_regions, the total size may exceed KMALLOC_MAX_SIZE.

This problem can be avoided by using kvmalloc instead of kmalloc.

Link: https://lore.kernel.org/20260629145538.134832-1-sj@kernel.org
Link: https://lore.kernel.org/20260629145538.134832-2-sj@kernel.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: Doehyun Baek <doehyunbaek@gmail.com>
Cc: Philippe Laferriere <plafer@proton.me>
Cc: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-use-kvmalloc-for-target-regions-array
+++ a/mm/damon/core.c
@@ -1369,14 +1369,14 @@ static int damon_commit_target_regions(s
 	if (!i)
 		return 0;
 
-	ranges = kmalloc_objs(*ranges, i, GFP_KERNEL | __GFP_NOWARN);
+	ranges = kvmalloc_objs(*ranges, i, GFP_KERNEL | __GFP_NOWARN);
 	if (!ranges)
 		return -ENOMEM;
 	i = 0;
 	damon_for_each_region(src_region, src)
 		ranges[i++] = src_region->ar;
 	err = damon_set_regions(dst, ranges, i, src_min_region_sz);
-	kfree(ranges);
+	kvfree(ranges);
 	return err;
 }
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are


