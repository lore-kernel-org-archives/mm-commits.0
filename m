Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A302A39A061
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439141; cv=none; b=NGtnp8mpMqRiQ2eVD+NraDpGHMF9tWI/L391fzg05wkhLdeYjsapgMkx+J3yh1AFUMHz4xUA3qv2dX6/NRdQxxl8ffaNVRrsOie8IlAYtulzIffqYS7NXMLaYgU24fe6Nmp06WB1XHaM4YrF4HwwEpx9zs70qy6hR9AZFNhXXq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439141; c=relaxed/simple;
	bh=JJ1F5tOH10LXcywiP3YZADSjaKr87jH8ibWkUoVwB+M=;
	h=Date:To:From:Subject:Message-Id; b=UGB+7GdJqNXwb7mpGF4zK15HW/GYyPqCU/GlSpr876hF5r7yYF4fr9nOJ+e7wBxglq41IqEjwWffYQmUizofmy6KIQw8LEuGYZsiRwaMhAHWnsdxX6rDE8AU7lJdLWmhXTQuYk7qq8UAo1HjKWEVR89FdJYdqhP6VfKB51QUqvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eb6iz2OC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eb6iz2OC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3730F1F00893;
	Tue,  2 Jun 2026 22:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439140;
	bh=E0lHkVm/nhmm0SvMdP2xk4KURdroPfMgHkaeGK+kjos=;
	h=Date:To:From:Subject;
	b=Eb6iz2OC9VbRqs3IKWCKA2P9e4jtvNOcexZH6oHmFNw3cKrBsUfIck9iqnr2p1LZv
	 1b+mRNWKUYTwKYMVUNerWK3gXRrmXB5WR/7cR0tqslO//EDGQ0ltnDyDRK0zLx/J7s
	 1qKpDPdCn42nolgfkGgmkt1+a8LjeJtNcW+y1FJM=
Date: Tue, 02 Jun 2026 15:25:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-close-fd-on-write-error.patch removed from -mm tree
Message-Id: <20260602222540.3730F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/split_huge_page_test.c: close fd on write error
has been removed from the -mm tree.  Its filename was
     selftests-mm-close-fd-on-write-error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -625,7 +625,7 @@ static int create_pagecache_thp_and_fd(c
 	}
 	if (write(*fd, "3", 1) != 1) {
 		ksft_perror("write to drop_caches");
-		goto err_out_unlink;
+		goto err_out_close;
 	}
 	close(*fd);
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


