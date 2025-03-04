Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43A579F5
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 04:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741062875; cv=none; b=bc/wftd+mAv/qEo7i2rHEHExyQn1pGmIIB34Tn7MHy/1DW1ehceSuh5eIRI92QYNyMlMWpGZJA6CLJ318H9ucccY4FaSJCyOcc7ZU8gwe4plcpZiMaVcxVWLM/bqmnqiabZonCHj88y0PWCXPeDvB4qpvuBnhIRMy2rMb7Lwnxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741062875; c=relaxed/simple;
	bh=YIUYQUjzBwBiGTbog48aiJLYWjoI1HT/GXPjNZ7KvK0=;
	h=Date:To:From:Subject:Message-Id; b=CYcfAJBKxQo6KGIMb2RczNXnq1CcaPADmK1e6E0cElX876o5r5fsZI4NbIBN4fid1naFvCf+0SSE0VGqsH7n4/lboF/RDY9eMW3Xk4fv7iQmqtlNU45q9aHvc43Ia5RCEw1lW+BH2uxcl899+fRNMWHib3EuIvnCqZQX+UkO9hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dBsugatI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dBsugatI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFE2C4CEE5;
	Tue,  4 Mar 2025 04:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741062875;
	bh=YIUYQUjzBwBiGTbog48aiJLYWjoI1HT/GXPjNZ7KvK0=;
	h=Date:To:From:Subject:From;
	b=dBsugatIee3gJWBjP3lWfjqTGmgx/3DLyZSje53FYYUmZyKcVAzJz4R4L2+js2bU6
	 /SY9vixpny4/X/79ze+5qIw7iFsTpAXVmZei5b0C/zrva40uU74ka0Vo5XHrXdLNj0
	 fuzCuRXGX8nrkUSk5ccgkRiCjVvVwXrOIlw4Tt6M=
Date: Mon, 03 Mar 2025 20:34:34 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-dont-call-propagate_protected_usage-for-v1.patch added to mm-unstable branch
Message-Id: <20250304043434.DBFE2C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: don't call propagate_protected_usage() for v1
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-dont-call-propagate_protected_usage-for-v1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-dont-call-propagate_protected_usage-for-v1.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: don't call propagate_protected_usage() for v1
Date: Thu, 27 Feb 2025 23:58:06 -0800

Patch series "page_counter cleanup and size reduction".

Commit c6f53ed8f213a ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
accidently increased the size of struct page_counter.  This series
rearrange the fields to reduce its size and also has some cleanups.


This patch (of 3):

Memcg-v1 does not support memory protection (min/low) and thus there is no
need to track protected memory usage for it.

Link: https://lkml.kernel.org/r/20250228075808.207484-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20250228075808.207484-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-dont-call-propagate_protected_usage-for-v1
+++ a/mm/memcontrol.c
@@ -3601,6 +3601,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 {
 	struct mem_cgroup *parent = mem_cgroup_from_css(parent_css);
 	struct mem_cgroup *memcg, *old_memcg;
+	bool memcg_on_dfl = cgroup_subsys_on_dfl(memory_cgrp_subsys);
 
 	old_memcg = set_active_memcg(parent);
 	memcg = mem_cgroup_alloc(parent);
@@ -3618,7 +3619,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	if (parent) {
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 
-		page_counter_init(&memcg->memory, &parent->memory, true);
+		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
@@ -3638,7 +3639,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 		return &memcg->css;
 	}
 
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
+	if (memcg_on_dfl && !cgroup_memory_nosocket)
 		static_branch_inc(&memcg_sockets_enabled_key);
 
 	if (!cgroup_memory_nobpf)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-add-hierarchical-effective-limits-for-v2.patch
memcg-dont-call-propagate_protected_usage-for-v1.patch
page_counter-track-failcnt-only-for-legacy-cgroups.patch
page_counter-reduce-struct-page_counter-size.patch

