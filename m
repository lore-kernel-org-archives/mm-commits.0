Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883A033A033
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465837; cv=none; b=Hdnys9+gTboWr8aFWQZodRA1OWaekZ/lBMZKEUPbl0nrMMn/qkhnrfoUfwwPjNYQ6Bf3YUYlWOqDo8UIM2aPG8k5OLk5p9zN9/Z0ZsqpROjO7yl743rfpzydgrjD9bVAHzXVTU/HZyjezR8ETX2O9ETMR/SrnKvOCI+2BiT3j+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465837; c=relaxed/simple;
	bh=6wSdHNt2hMYS/8URhI/vzHFEz6s6FZNvUjS8f9TM3fQ=;
	h=Date:To:From:Subject:Message-Id; b=MLRrVzk+D72S4gQ+OWmCs3MVDSZGHtJJoHS4Cy1rGC3cra0IUFdGApBIyk7N46d1EyCuEAorV/hTHnuL+XAwAcmgWx6fgAaYPXiMwmilgBHriOH8H5aDQHyCkC+4hyrimDaa1QM+rUY+A8fuGMnXP/TveGfiNPbXCH+qadtkRqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R5G60X5T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R5G60X5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2631F00A3A;
	Fri, 31 Jul 2026 02:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465836;
	bh=UxnaNF7ITAept3UsAPNGKmziDEm9ihGG6QpbUW8y38A=;
	h=Date:To:From:Subject;
	b=R5G60X5TS7MwZ+v0lPa6xjiDc+5CorSPsXP8Y6oMm4nbZb8X3Tb9LC6iQtLoSe/7w
	 lFNY4WSghb61o2yqEb+dpGjOpUVTTrTEvvIoF8qzXL7wkWv0AcNu5tj7EdBT80cgls
	 /i66ePxuO5AS5MGtDXciYtHgDDMv3HfvemoO4aq8=
Date: Thu, 30 Jul 2026 19:43:55 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,jiayuan.chen@linux.dev,hannes@cmpxchg.org,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-reset-oom_group-in-css_reset.patch removed from -mm tree
Message-Id: <20260731024356.5E2631F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: reset oom_group in css_reset
has been removed from the -mm tree.  Its filename was
     mm-memcg-reset-oom_group-in-css_reset.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
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

memcg-bail-out-memoryhigh-when-memcg-is-dying.patch
memcg-bail-out-memorymax-when-memcg-is-dying.patch
memcg-bail-out-proactive-reclaim-when-memcg-is-dying.patch
memcg-v1-bail-out-reclaim-when-memcg-is-dying.patch

