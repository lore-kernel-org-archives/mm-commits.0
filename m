Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098CD2F5313
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 17:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783358052; cv=none; b=gON5R7UXiPScjwNHpIM3u7FuSxLO089Omnf13DTt00hawbjQ3l5laMwnwh3OknN4rapJ9UEQTy8EdGA+eAHIQZVvhNG5VZwMnDA+rsbmTNJA1LuhYbwrGGFeSmMrLNxX6uMZ+8wvkn0Usy+vbdVG0SyDXIoE7+z5QQWB6SDa8mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783358052; c=relaxed/simple;
	bh=lRnpZ+WUI5gN+R6P9+UU9uTMcPGJrMhW4BDa6dj6BxM=;
	h=Date:To:From:Subject:Message-Id; b=XAl/7J0Q3xtML4wCHsTfBRxpMguAsHSgxnqeiMzTlCYRtb5Z7sI27jK5QMKccnX53xnY/iFrLPsEU7e3DtPF602WOrqW9yfY3I5wfUZVRHhQQhc1liPezGm6ELBwtiyocNT56uyczz6fkSRq2NZErZENtPBsP47yKRnvMnVJDgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0pNhG7w+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0pNhG7w+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8913F1F000E9;
	Mon,  6 Jul 2026 17:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783358050;
	bh=Y+cwqaVV4+97WcaqKJKBhZmdTU6mQ2AGR6J97XIDFC4=;
	h=Date:To:From:Subject;
	b=0pNhG7w+5PIp8FKfzkSgNkJoesnAuQ9f2uoC+W78y1g8zVqkwrne/MFvSd+Vqst8u
	 ENt/jF7MZ2GNkpAcr+ZX//rznywfOaKEQ1n04hzPSbo0P9jF2yAAbWj/kqxHj0rZzY
	 kKlMteA44onmHkJRA55GG7O98nhGx57nMzHbuTpY=
Date: Mon, 06 Jul 2026 10:14:10 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,jiayuan.chen@linux.dev,hannes@cmpxchg.org,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-reset-oom_group-in-css_reset.patch added to mm-new branch
Message-Id: <20260706171410.8913F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: reset oom_group in css_reset
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-reset-oom_group-in-css_reset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-reset-oom_group-in-css_reset.patch

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
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: mm: memcg: reset oom_group in css_reset
Date: Fri, 3 Jul 2026 14:38:24 +0800

memory.oom.group defaults to disabled, but css_reset did not clear
memcg->oom_group when a disabled memory css is kept alive by another
controller dependency.

Reset it with the other memory controller policies so a hidden memcg
cannot keep applying stale group OOM kill policy.

Link: https://lore.kernel.org/20260703063826.306878-2-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memcontrol.c~mm-memcg-reset-oom_group-in-css_reset
+++ a/mm/memcontrol.c
@@ -4362,6 +4362,7 @@ static void mem_cgroup_css_reset(struct
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
+	WRITE_ONCE(memcg->oom_group, false);
 #ifdef CONFIG_ZSWAP
 	WRITE_ONCE(memcg->zswap_max, PAGE_COUNTER_MAX);
 	WRITE_ONCE(memcg->zswap_writeback, true);
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are

mm-damon-core-split-a-fraction-of-regions-when-nr_regions-exceeds-max-2.patch
mm-damon-tests-core-kunit-test-split-above-max_nr_regions-2.patch
memcg-bail-out-memoryhigh-when-memcg-is-dying.patch
memcg-bail-out-memorymax-when-memcg-is-dying.patch
memcg-bail-out-proactive-reclaim-when-memcg-is-dying.patch
memcg-v1-bail-out-reclaim-when-memcg-is-dying.patch
mm-memcg-reset-zswap-settings-in-css_reset.patch
mm-memcg-reset-oom_group-in-css_reset.patch

