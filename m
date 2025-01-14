Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BF523C717
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837065; cv=none; b=LMqk6sVpVwrjv2S859RMTv6RMwlzuI4Z8AZ80O5FsC6St6zS9zxUqk1CyRMFMkNJPd8hs1WlIKsTiO1YN5iZMskD47gGGimqIaxFFZdQOrsMuELNQxu5gaP1hzup0HICvkBlmB0bf0JyKK2HoeJPTWqzK2GMoZfZHoF3hBJAq50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837065; c=relaxed/simple;
	bh=nGpH+JerGtbtIZEDttr6+3BtJs+kY/NmUkiVpzMiUhU=;
	h=Date:To:From:Subject:Message-Id; b=rRI5fmUvvegvA9nOgquB0S2ULd4DFCdmguJigYyWMgiMYwgWOYid6BMBwF1s5qJmFGxK14MUeyddjHmB15FWLpaFNtKpnFcEnNzETnNLo2xlpS2qp3uTXtL72yqyP6P7oODYo9N5JmwaH7/xaZXlShezHxwOMuaUawCdM5RfoWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r7uf8T2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r7uf8T2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B630C4CEDD;
	Tue, 14 Jan 2025 06:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837065;
	bh=nGpH+JerGtbtIZEDttr6+3BtJs+kY/NmUkiVpzMiUhU=;
	h=Date:To:From:Subject:From;
	b=r7uf8T2Vaph8Jvsm/y04cdREksvztWg2AwpdOk8RdXe0dbrxR8EVwTwr/xQWVTnFo
	 kJjHcnGEvuNiO+tgnFxEwQiQI/FCTZQLAAukzEwU+mkGXOIFGh4Olo9aK5RHHsLgSq
	 +QNhUHLpFGY6d9w5KPKC290LBRJqWQ5D0E0F7ecs=
Date: Mon, 13 Jan 2025 22:44:24 -0800
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-hugetlb-introduce-memcg_accounts_hugetlb.patch removed from -mm tree
Message-Id: <20250114064425.3B630C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg/hugetlb: introduce memcg_accounts_hugetlb
has been removed from the -mm tree.  Its filename was
     memcg-hugetlb-introduce-memcg_accounts_hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: memcg/hugetlb: introduce memcg_accounts_hugetlb
Date: Wed, 11 Dec 2024 12:39:49 -0800

Patch series "memcg/hugetlb: Rework memcg hugetlb charging", v3.

This series cleans up memcg's hugetlb charging logic by deprecating the
current memcg hugetlb try-charge + {commit, cancel} logic present in
alloc_hugetlb_folio.  A single function mem_cgroup_charge_hugetlb takes
its place instead.  This makes the code more maintainable by simplifying
the error path and reduces memcg's footprint in hugetlb logic.

This patch introduces a few changes in the hugetlb folio allocation
error path:
(a) Instead of having multiple return points, we consolidate them to
    two: one for reaching the memcg limit or running out of memory
    (-ENOMEM) and one for hugetlb allocation fails / limit being
    reached (-ENOSPC).
(b) Previously, the memcg limit was checked before the folio is acquired,
    meaning the hugeTLB folio isn't acquired if the limit is reached.
    This patch performs the charging after the folio is reached, meaning
    if memcg's limit is reached, the acquired folio is freed right away.

This patch builds on two earlier patch series: [2] which adds memcg
hugeTLB counters, and [3] which deprecates charge moving and removes the
last references to mem_cgroup_cancel_charge.  The request for this cleanup
can be found in [2].

[1] https://lore.kernel.org/all/20231006184629.155543-1-nphamcs@gmail.com/
[2] https://lore.kernel.org/all/20241101204402.1885383-1-joshua.hahnjy@gmail.com/
[3] https://lore.kernel.org/linux-mm/20241025012304.2473312-1-shakeel.butt@linux.dev/


This patch (of 3):

This patch isolates the check for whether memcg accounts hugetlb.  This
condition can only be true if the memcg mount option
memory_hugetlb_accounting is on, which includes hugetlb usage in
memory.current.

Link: https://lkml.kernel.org/r/20241211203951.764733-1-joshua.hahnjy@gmail.com
Link: https://lkml.kernel.org/r/20241211203951.764733-2-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~memcg-hugetlb-introduce-memcg_accounts_hugetlb
+++ a/mm/memcontrol.c
@@ -1448,6 +1448,18 @@ unsigned long memcg_page_state_local_out
 		memcg_page_state_output_unit(item);
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static bool memcg_accounts_hugetlb(void)
+{
+	return cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_HUGETLB_ACCOUNTING;
+}
+#else /* CONFIG_HUGETLB_PAGE */
+static bool memcg_accounts_hugetlb(void)
+{
+	return false;
+}
+#endif /* CONFIG_HUGETLB_PAGE */
+
 static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 {
 	int i;
@@ -1469,7 +1481,7 @@ static void memcg_stat_format(struct mem
 
 #ifdef CONFIG_HUGETLB_PAGE
 		if (unlikely(memory_stats[i].idx == NR_HUGETLB) &&
-		    !(cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_HUGETLB_ACCOUNTING))
+			!memcg_accounts_hugetlb())
 			continue;
 #endif
 		size = memcg_page_state_output(memcg, memory_stats[i].idx);
@@ -4540,8 +4552,7 @@ int mem_cgroup_hugetlb_try_charge(struct
 	 * but do not attempt to commit charge later (or cancel on error) either.
 	 */
 	if (mem_cgroup_disabled() || !memcg ||
-		!cgroup_subsys_on_dfl(memory_cgrp_subsys) ||
-		!(cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_HUGETLB_ACCOUNTING))
+		!cgroup_subsys_on_dfl(memory_cgrp_subsys) || !memcg_accounts_hugetlb())
 		return -EOPNOTSUPP;
 
 	if (try_charge(memcg, gfp, nr_pages))
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-damon-paddr-improve-readability-of-damon_pa_stat.patch

