Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177591A681C
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 03:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782358862; cv=none; b=QXqYC5O9JgFHjV7m7P7K5iQyIj0O7KxeqcUbzoxwzB2y97IuNzDTexCtbQHAOHWfUKg+MSc2jbBEoxqfQkbSrHHfCnftZNVyfJlmMyy30sQM+qGXyDNR4YVE2oNSmEl2SGJdURjnIAF994HY6iecSzxO/9GanMIjWg2PEiz/DJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782358862; c=relaxed/simple;
	bh=MsVszBVILO3SIUrswFK+JlgrbBEh7Qy5LX/9pFpPAFc=;
	h=Date:To:From:Subject:Message-Id; b=texGhLSn08rOrwm7c8AaHVaf2Y9ishcLev4c3dexxclRRCe1UBk68m5pXO+Ptvscn2F1EMsTfKbV6hvKPWNjN70gVmsGLgr5rO9r/o6JbnWKx/yy87PoFOHQHspq7NIURpBiV6dM92g26CJUqjbfwAGogBzkqnTyYPCyWUJNVng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YeEqtwKx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YeEqtwKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A3E1F000E9;
	Thu, 25 Jun 2026 03:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782358860;
	bh=NYk8FxgjBhRvA8u3FL7Y8NbqRqMOgodqf3s/y8QgWWA=;
	h=Date:To:From:Subject;
	b=YeEqtwKx+fl2OTOLsohCR4RHQIV/LC/0dObCbi097Ydb0Ca9WdwoMbf0zLytOckWh
	 ErBq8l5kckcm3x2idXRLhwJI2d3PMuqRzmIwVSEXxpF1Hil78zZwgz2wF269fBLxgw
	 MZt8N+Rd82avTXbQYdyfI5+BstJc7+rrOn0yQOME=
Date: Wed, 24 Jun 2026 20:41:00 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,rafael@kernel.org,gregkh@linuxfoundation.org,dakr@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch_numa-remove-redundant-nodemask-clears-in-numa_init.patch added to mm-new branch
Message-Id: <20260625034100.98A3E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch_numa: remove redundant nodemask clears in numa_init()
has been added to the -mm mm-new branch.  Its filename is
     arch_numa-remove-redundant-nodemask-clears-in-numa_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch_numa-remove-redundant-nodemask-clears-in-numa_init.patch

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: arch_numa: remove redundant nodemask clears in numa_init()
Date: Thu, 18 Jun 2026 01:39:19 +0900

numa_init() clears numa_nodes_parsed, node_possible_map and
node_online_map, then calls numa_memblks_init(), which clears the same
nodemasks.  Nothing uses them in between.

These clears have been redundant since commit 767507654c22 ("arch_numa:
switch over to numa_memblks") made numa_init() use numa_memblks_init().

No functional change.

Link: https://lore.kernel.org/20260617163919.2544899-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/arch_numa.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/base/arch_numa.c~arch_numa-remove-redundant-nodemask-clears-in-numa_init
+++ a/drivers/base/arch_numa.c
@@ -231,10 +231,6 @@ static int __init numa_init(int (*init_f
 {
 	int ret;
 
-	nodes_clear(numa_nodes_parsed);
-	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
-
 	ret = numa_memblks_init(init_func, /* memblock_force_top_down */ false);
 	if (ret < 0)
 		goto out_free_distance;
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

arch_numa-remove-redundant-nodemask-clears-in-numa_init.patch

