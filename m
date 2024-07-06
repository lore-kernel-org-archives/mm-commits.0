Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072B913CA8C
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292055; cv=none; b=eOLONaRCIIaUFrT4LOIe9fvjvUIgSs+E+Kcq62SgkjxXRxW/0tOTjyctmW/SBE3ybSSirLaNVYX90E9ovysqpK3oyVvrOjHl3U1GO+FUBJ3faDtQ0+dioViL/kSocnI0IIFQXvdjDrprzqCED+UUnk0s5KvDsl8AhH9J6kLQpdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292055; c=relaxed/simple;
	bh=y5QbLDWpqV5y0oyM+XUxPrRkH3Lx5Be6A7TA7yFqisg=;
	h=Date:To:From:Subject:Message-Id; b=tfOkO/9RxC7Tt+XGeqeo1M6lNkMlgTeAei/6i+QiyukAxVs4dP2JW//42D/tN12FyTaJHPzrraK0TpRodE21Ed56us3e/mwp1QS4fYIAixEsZJ7QqQaNqvEeudCRwRdHnOxQjkKIczt2aj7NwIZVd7Z2ULBA487+YcEL9V6+1TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KGvtgdkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KGvtgdkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00FEC2BD10;
	Sat,  6 Jul 2024 18:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292054;
	bh=y5QbLDWpqV5y0oyM+XUxPrRkH3Lx5Be6A7TA7yFqisg=;
	h=Date:To:From:Subject:From;
	b=KGvtgdkf0URjGANU6JPFF7x+yuYrYFIyePq1caKu+nQwp18mAQZz7Z8rt6KnPfSSU
	 qtj6QVsLyeBcZma5ZAwM2J14/WwO8KhXXhx6yULN+QpOrKZ80jpxProVBHLlSaVPz5
	 WK8C6B84/wNs6SZ7p4X2PlFZIG46PHCAlrqjsTwU=
Date: Sat, 06 Jul 2024 11:54:14 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch removed from -mm tree
Message-Id: <20240706185414.D00FEC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: drop obsolete cache line padding in struct mem_cgroup
has been removed from the -mm tree.  Its filename was
     mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: drop obsolete cache line padding in struct mem_cgroup
Date: Mon, 1 Jul 2024 18:59:31 +0000

After the grouping of the cgroup v1-related fields and the corresponding
reorganization of the struct mem_cgroup, the existing cache line padding
doesn't make much sense anymore.  Let's drop it for now and put back to
new places, if necessary.

Link: https://lkml.kernel.org/r/20240701185932.704807-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup
+++ a/include/linux/memcontrol.h
@@ -220,8 +220,6 @@ struct mem_cgroup {
 	/* handle for "memory.swap.events" */
 	struct cgroup_file swap_events_file;
 
-	CACHELINE_PADDING(_pad1_);
-
 	/* memory.stat */
 	struct memcg_vmstats	*vmstats;
 
@@ -305,8 +303,6 @@ struct mem_cgroup {
 	bool tcpmem_active;
 	int tcpmem_pressure;
 
-	CACHELINE_PADDING(_pad2_);
-
 	/*
 	 * set > 0 if pages under this cgroup are moving to other cgroup.
 	 */
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


