Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F981EC4EB
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 21:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733953506; cv=none; b=q99cHXr7p4Uh6+MsXOlrt894O+oqtVt534GluIfupAXqTG3OaZwchmM95Q1hUb4lFth267xXXgg9D4UtyIurru0uiRR+0JLOFMRFlzRxkQSAsP1xox6VlaqmbP6JPzgtYlT5MDkOcuGav56iJvgPSjNoHkPh0yoGXCks00/fSFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733953506; c=relaxed/simple;
	bh=ws5pksqlezuxP2dSA/CDxBk0XBpm34DA6pi7aZiDPKg=;
	h=Date:To:From:Subject:Message-Id; b=oZe9I9lJWdQUd6n8hwpd6V/Bo8nboavCpajhDLcHlfkqVN/fLb29oF7hInxN3eOwL/UZqjflPPyrAq8+SZNlkDkvEic/dw60eFkJy+sFI2JcMIiXSOHTMUPkv4NLGhsex9PRTwq9zm7zGfpNKXriEqbyzLgbea2SogXDX8/3/UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KOke1kuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KOke1kuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C73C4CED2;
	Wed, 11 Dec 2024 21:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733953506;
	bh=ws5pksqlezuxP2dSA/CDxBk0XBpm34DA6pi7aZiDPKg=;
	h=Date:To:From:Subject:From;
	b=KOke1kuUYrpwdN1/cD1sslXIhxSXSg/1wtyUzBZtC/Plytg+OzzMC3JjVeHr5od/8
	 Wj9SSyY8pRbe/RC9V6rKkzxO1H4CVTrERuAQA3NwN6c0QHOGb3DXfDPmgQxV2K1Ne1
	 TnnbiLKljBP/i/bcSiwvE0C1YEW+7T7DrxciH2eo=
Date: Wed, 11 Dec 2024 13:45:04 -0800
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-hugetlb-introduce-memcg_accounts_hugetlb.patch added to mm-unstable branch
Message-Id: <20241211214506.37C73C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg/hugetlb: introduce memcg_accounts_hugetlb
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-hugetlb-introduce-memcg_accounts_hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-hugetlb-introduce-memcg_accounts_hugetlb.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
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

memcg-hugetlb-introduce-memcg_accounts_hugetlb.patch
memcg-hugetlb-introduce-mem_cgroup_charge_hugetlb.patch
memcg-hugetlb-remove-memcg-hugetlb-try-commit-cancel-protocol.patch

