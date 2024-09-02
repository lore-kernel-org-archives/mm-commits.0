Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580A35FB8D
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247859; cv=none; b=koTPc1kvLL5xHdAW5VI8qpCvZVWhu9lEgks3Fq7e/4wYPhnudfI4cR41dgZOTRv19TmYyVlMn9VNmY/2tlWd8U+eT20IEThmxdxJKlRM/dxMk20jRiEheMeTgf/E70zpoCBiAkXvZyvZyuXOye8TO1rfzaDXn16wIcVe81gOfyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247859; c=relaxed/simple;
	bh=yszTw5NA6Q/4ii+nWtc4SX4LfIkuLG/2J1Jv1gD4j/M=;
	h=Date:To:From:Subject:Message-Id; b=Y06ClVcN5HIWpBmNvDZWH+JeJ3TxcoOBQ1KiR/abIsMSNsZfqeO+XEdCLfEuFngWKRW179cCtTl5mSGsdIpqwrovjn9ClBY9CQ8ujsfiXkE1VjOcf8WZ0ao0Cjr4+oyId28ADbr+1HrxBJqGsaNXqIIPWMSeJwdqEjDwK7PEP+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vwq3tAKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vwq3tAKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D05EC4CEC2;
	Mon,  2 Sep 2024 03:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247859;
	bh=yszTw5NA6Q/4ii+nWtc4SX4LfIkuLG/2J1Jv1gD4j/M=;
	h=Date:To:From:Subject:From;
	b=vwq3tAKpFaY96ko84keKATbwEknl7NKKoGv4nPgZH03VOSVyRFapoblA75SOu+Hg1
	 0JmvshRVMFvs7GuQw8atBqDYMDbNbdfiTFOpxtg/alYBWNCiG6ff3Y9o0Db6rtV8WZ
	 szBHvtbcGqAYDESe3gUIJrscVl1NHmA/oczvqrQ4=
Date: Sun, 01 Sep 2024 20:30:58 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-initiate-deprecation-of-v1-soft-limit.patch removed from -mm tree
Message-Id: <20240902033059.2D05EC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: initiate deprecation of v1 soft limit
has been removed from the -mm tree.  Its filename was
     memcg-initiate-deprecation-of-v1-soft-limit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: initiate deprecation of v1 soft limit
Date: Wed, 14 Aug 2024 15:00:19 -0700

Memcg v1 provides soft limit functionality for the best effort memory
sharing between multiple workloads on a system.  It is usually triggered
through kswapd and at the moment does not reclaim kernel memory.

Memcg v2 provides more straightforward best effort (memory.low) and hard
protection (memory.min) functionalities.  Let's initiate the deprecation
of soft limit from v1 and gather if v2 needs something more to move the
existing v1 users to v2 regarding soft limit.

Link: https://lkml.kernel.org/r/20240814220021.3208384-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    8 ++++++--
 mm/memcontrol-v1.c                             |    3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~memcg-initiate-deprecation-of-v1-soft-limit
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -78,6 +78,8 @@ Brief summary of control files.
  memory.memsw.max_usage_in_bytes     show max memory+Swap usage recorded
  memory.soft_limit_in_bytes	     set/show soft limit of memory usage
 				     This knob is not available on CONFIG_PREEMPT_RT systems.
+                                     This knob is deprecated and shouldn't be
+                                     used.
  memory.stat			     show various statistics
  memory.use_hierarchy		     set/show hierarchical account enabled
                                      This knob is deprecated and shouldn't be
@@ -701,8 +703,10 @@ For compatibility reasons writing 1 to m
 
 	# echo 1 > memory.use_hierarchy
 
-7. Soft limits
-==============
+7. Soft limits (DEPRECATED)
+===========================
+
+THIS IS DEPRECATED!
 
 Soft limits allow for greater sharing of memory. The idea behind soft limits
 is to allow control groups to use as much of the memory as needed, provided
--- a/mm/memcontrol-v1.c~memcg-initiate-deprecation-of-v1-soft-limit
+++ a/mm/memcontrol-v1.c
@@ -2545,6 +2545,9 @@ static ssize_t mem_cgroup_write(struct k
 		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
 			ret = -EOPNOTSUPP;
 		} else {
+			pr_warn_once("soft_limit_in_bytes is deprecated and will be removed. "
+				     "Please report your usecase to linux-mm@kvack.org if you "
+				     "depend on this functionality.\n");
 			WRITE_ONCE(memcg->soft_limit, nr_pages);
 			ret = 0;
 		}
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


