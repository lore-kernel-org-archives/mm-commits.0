Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0DE384223
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 18:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782757612; cv=none; b=qZPUPQgCIjXm4DCdbT+zub7grpaU2NwZrFh6ew/PI44en8046hjS6xg7SMUsNrhgzJAId9ARyU/aNXVktGTuRUGOnUO0LnmYEmb2tXkVlVK59LeX8i32heMHBKqOYu+xPLK+JjRRT6e37YdGJQxSujGPTAw0ElEQsfPhyp4EJbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782757612; c=relaxed/simple;
	bh=XGOv/Diy1EctnfrNxse5AwRIeeKli/Nnsi/sgkj62rA=;
	h=Date:To:From:Subject:Message-Id; b=kpD/uZ/nK2Cpl+r9lhJReTxPAwcA8MtxuYXiDUGgSceToBlwF+Nz0PW0K6jzdBI9hZirEDq/1QndqDRBhO451fSl0y6FG0uspo9wc9LqNnYXDTGa+sNUZkG1qghdV5b2fMiuFQQELpp/hntfa6lygPsaJy6lZse1u/wah8krtPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q90IThPl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q90IThPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92891F000E9;
	Mon, 29 Jun 2026 18:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782757610;
	bh=58cvVyJg9zezH9Wl0SeEVvGXBgCI49rUBXzooPXsGQs=;
	h=Date:To:From:Subject;
	b=Q90IThPlNtLNDJGQXWca3SpIiHFyLbyroghI/zW/gxSXnTBQSAKab7+cJRfDT6gT1
	 LftDZEeY+eq9VVdnGG6CxBckTIWHkww7nKBy0e9JTI0c2aWXs0tUPaUehg6jYxJovU
	 bF8P/wgsJzzK1j2Wq3oRSN/k9ZFnl9gRjoImIUsg=
Date: Mon, 29 Jun 2026 11:26:50 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kkernel.org,sj@kernel.org,saileshnandanavanam@gmail.com,rppt@kernel.org,plafer@proton.me,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,doehyunbaek@gmail.com,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-use-kvmalloc-for-target-regions-array.patch added to mm-new branch
Message-Id: <20260629182650.B92891F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: use kvmalloc for target regions array
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-use-kvmalloc-for-target-regions-array.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-use-kvmalloc-for-target-regions-array.patch

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
Reviewed-by: SJ Park <sj@kkernel.org>
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
@@ -1356,14 +1356,14 @@ static int damon_commit_target_regions(s
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

mm-damon-core-use-kvmalloc-for-target-regions-array.patch

