Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960AD38D415
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298400; cv=none; b=Q+85AjhLGQHAyxESimT+IBXW/XLhy7T0N4UkAQm2j/l8+6l/MZvyr7QIPXmJyoFg3glvJHm3I4Cl9WzA2L9O6df3nCIxMa1Sm0l5i3UOzFASrXFxDHPhnsXXoleaFAmdmndUd7wW+Fv12rdUJf/FcyT6lapNOIFtJQe4giYHg4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298400; c=relaxed/simple;
	bh=TOqR6AUdSHxZnFKIuyr+OVZFQ/Noc5H4y/ZG4YfXYrc=;
	h=Date:To:From:Subject:Message-Id; b=RvjkDOB26jPhF9dRpabS4O2wbS70EC10v8ei/JRZG0wmTgCZnysg0zgx2V7BV68iFq9Yo4Pnocq6hIzhA1STHGq2OgFjPx9OGq5PAo6dapuJnW2GB+PWJkQJtMocn25Y29uY7wuaSP0J1D1fEoCzMFJRKUWk8fBd5OUu0bYSSDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cXrCJ2R8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cXrCJ2R8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6271F000E9;
	Wed, 29 Jul 2026 04:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298399;
	bh=BZSKNLez0pWFMRTI3uw3CcOM7nBmL/uFiAGm6l6uAE8=;
	h=Date:To:From:Subject;
	b=cXrCJ2R8qNjH91WPSC6J+MJe9CY26WELPk5r+fzTec21dJj/C+c5r1SNPWrwtyG94
	 pYP5xlIqxIcGC2+EHwBDAoJ50Nm2x+3o3lQUZNnrHNHfVCmlNyeDWnAjUndW3vk5jZ
	 3oN/bndbe2vgbQzTuKhuqFQeij310OeeWASpMYLY=
Date: Tue, 28 Jul 2026 21:13:19 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,rafael@kernel.org,gregkh@linuxfoundation.org,dakr@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arch_numa-remove-redundant-nodemask-clears-in-numa_init.patch removed from -mm tree
Message-Id: <20260729041319.6D6271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch_numa: remove redundant nodemask clears in numa_init()
has been removed from the -mm tree.  Its filename was
     arch_numa-remove-redundant-nodemask-clears-in-numa_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-early_ioremap-clarify-early_ioremap_reset-semantics.patch
riscv-remove-unused-__late_set_fixmap-and-__late_clear_fixmap.patch
arm64-remove-early_ioremap_reset-call-and-__late_-macros.patch

