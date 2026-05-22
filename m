Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE70C233924
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 00:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779411000; cv=none; b=SGpgGQ3uqX/eDHQmY/NHfLLjUOYwCg2Ykt0kxsNvzA50Vv8NGRPWY4OgbwzQqk16ZsOXZmbyFWNpoXxhMHbhcNCBv/5PUpup/tZc9x15prVBDKnh1Wuuy2AW+lYN3CnYt+17C6i+vEY32mmNoinjjIgzZGsQknqOyUN0OPA8aqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779411000; c=relaxed/simple;
	bh=T7YdyrHb3oFzWvo2L3HChCj8w6x/psDUtrxeHAGRALU=;
	h=Date:To:From:Subject:Message-Id; b=N0iIAKnc0Wqmwfta1WdYM+Px5HopsENX2fZDF/8Ba8DoqSCQWS4M5aub1QuSRp0IyxPxkfOHH8LJcgGLsxaWP1FSSerFgtUwKABn06KaXj95Z+ml1n5qqRWDziIbeQ7dlAbXfTbcUD1l7q1j2g+q7UNlfxeM5X5qgrQDoEqYRDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zv8mhq/M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zv8mhq/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5661F000E9;
	Fri, 22 May 2026 00:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779410998;
	bh=aJIqLQ5MCyIC5/5bLptHfazr4IyI/kol8VsR3pEU4XU=;
	h=Date:To:From:Subject;
	b=zv8mhq/MRdQZGXRsX29bawgsZ4bBaRL7xxVohfjZFZMaxfwHVlGHT/xNeV/oKn91p
	 0DZOTJpg35cUgE64jScIaQVIy4IOKYhfNleOSLqiilEvYO/dzv06E9djce2Fj4PXCc
	 Lrn9vd/T/mCJAYzPcWKNaCWr7n5MPq9x/h1G6Tw4=
Date: Thu, 21 May 2026 17:49:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-close-fd-on-write-error.patch added to mm-new branch
Message-Id: <20260522004958.6A5661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/split_huge_page_test.c: close fd on write error
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-close-fd-on-write-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-close-fd-on-write-error.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: selftests/mm/split_huge_page_test.c: close fd on write error
Date: Wed, 20 May 2026 02:03:36 +0000

When create_pagecache_thp_and_fd() write returns error on
/proc/sys/vm/dropcache, it just "goto err_out_unlink", which left fd still
open.

Use "goto err_out_close" to close the fd.

Link: https://lore.kernel.org/20260520020336.28914-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-close-fd-on-write-error
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -640,7 +640,7 @@ static int create_pagecache_thp_and_fd(c
 	}
 	if (write(*fd, "3", 1) != 1) {
 		ksft_perror("write to drop_caches");
-		goto err_out_unlink;
+		goto err_out_close;
 	}
 	close(*fd);
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

selftests-mm-close-fd-on-write-error.patch

