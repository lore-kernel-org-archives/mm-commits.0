Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD34158545
	for <mm-commits@vger.kernel.org>; Fri, 18 Apr 2025 03:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945866; cv=none; b=GKHNPjkz1QJB2Chvt3UrOTBBVXjkXC6YKgu7ywVY6Qt/FOJK83yfJlv8YG3C9y3Oev34VCvo/g6lEVqlcl9kT9I+mh/ZEVNzC4Nm5IbtiEfm1edyCA1qMJsRZ85EqA9pX511I7/zPbmdQbI9iB8hz7bIaEt0CkwTiPOZZ6EEeA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945866; c=relaxed/simple;
	bh=rWEIGX5s7dQQH4VefoaZiyBvh8z30D7IvP6YgC9hpaY=;
	h=Date:To:From:Subject:Message-Id; b=h71MU/n1TA85DHL/jU6NDcM890ZsdEWPEUOXpxHb4ikKy3LvNjkEOi4fAmNIKJ3mk1DzP90m40ulyS/Zr3yAefwFM5W76blbukwRAs6NGg4rBpdEKyP0JZJcTmPGx/xG2w4P+hZpR9xA8CHQgv3FVp4Xbzp9bP3N4H8k+2/sq9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hl3ZhvkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hl3ZhvkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C5EC4CEEB;
	Fri, 18 Apr 2025 03:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744945866;
	bh=rWEIGX5s7dQQH4VefoaZiyBvh8z30D7IvP6YgC9hpaY=;
	h=Date:To:From:Subject:From;
	b=hl3ZhvkABmqPFuJfh8Zw0oaOcROAJ9ZTnfJzU8kAqcRfnKWJegZxTslHODLjwlUxM
	 hzTRI/lS16h/1lmA4tC1hftkzo6YiIwRiw6e2fPFO09hTw4Z2/wzQGyAoFdtIRIxjQ
	 W+OOGKDVRmaw0xaJOerufsZQOcr1ymEpDApM00zw=
Date: Thu, 17 Apr 2025 20:11:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhocko@suse.com,jackmanb@google.com,iamjoonsoo.kim@lge.com,harry.yoo@oracle.com,hannes@cmpxchg.org,cl@linux.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-slab-allocator-maintainers.patch removed from -mm tree
Message-Id: <20250418031105.E3C5EC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update SLAB ALLOCATOR maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-update-slab-allocator-maintainers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: MAINTAINERS: update SLAB ALLOCATOR maintainers
Date: Thu, 10 Apr 2025 11:00:22 +0200

With permission, reduce the number of maintainers.  Create a CREDITS entry
for Joonsoo (Pekka already has one).  Thanks for all the work!

Link: https://lkml.kernel.org/r/20250410090021.72296-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Christoph Lameter (Ampere) <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/CREDITS~maintainers-update-slab-allocator-maintainers
+++ a/CREDITS
@@ -2071,6 +2071,10 @@ S: 660 Harvard Ave. #7
 S: Santa Clara, CA 95051
 S: USA
 
+N: Joonsoo Kim
+E: iamjoonsoo.kim@lge.com
+D: Slab allocators
+
 N: Kukjin Kim
 E: kgene@kernel.org
 D: Samsung S3C, S5P and Exynos ARM architectures
--- a/MAINTAINERS~maintainers-update-slab-allocator-maintainers
+++ a/MAINTAINERS
@@ -22249,9 +22249,7 @@ F:	drivers/nvmem/layouts/sl28vpd.c
 
 SLAB ALLOCATOR
 M:	Christoph Lameter <cl@linux.com>
-M:	Pekka Enberg <penberg@kernel.org>
 M:	David Rientjes <rientjes@google.com>
-M:	Joonsoo Kim <iamjoonsoo.kim@lge.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Vlastimil Babka <vbabka@suse.cz>
 R:	Roman Gushchin <roman.gushchin@linux.dev>
_

Patches currently in -mm which might be from vbabka@suse.cz are

memcg-combine-slab-obj-stock-charging-and-accounting.patch

