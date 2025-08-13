Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B75B2F744B
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 22:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755124863; cv=none; b=SSSXtSkgTYBfmhHio8qnVGkMNoFstaWHIjnkfNkMkDYwnp1DV2y1FG1N+MEKzvtfRC/TmmEidW9OYFaMJyYYgXQktup38GcQQy3p5JA5g7l2Y0q0mw6J5X3LXkc8YlNgDfyjDaTUviGX/gt9FFK7qJZf2ubnqPoC6T+RKNGKDrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755124863; c=relaxed/simple;
	bh=huEN4pNeyHOsBtb4dp6E97Ebk61Ee2ihphlcB9AWAlM=;
	h=Date:To:From:Subject:Message-Id; b=oQrDurfh5wNC39Wt4TMiDkh7oA2SN9XYHU+Zro6N5yvjl4Sy8idjVg3rU1kx59uVzbtUW1rTx6r7ogFub8JdxAgMsKpw2ToG6Bbcikj3Favs1ymYhitd1qgYfbVjrSOxWF41Q6VqxP7QW3Nja1ozX5MMioSDtpFHXTRdZ+xmrFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lJCAdW4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lJCAdW4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6063C4CEEB;
	Wed, 13 Aug 2025 22:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755124862;
	bh=huEN4pNeyHOsBtb4dp6E97Ebk61Ee2ihphlcB9AWAlM=;
	h=Date:To:From:Subject:From;
	b=lJCAdW4+ObVQjnMiOSpNBdxMgpxvuJxBtYZa3lEz9RkEWoVmaGZuEKl3Reo4xjugW
	 O3RUB2iocQ44CLe+kqciY2mYHrCFDxH9k8fMxuig9JXUkDn2b+Vwh+9eD0v0pviaJa
	 BTrveNEC0w9JgINW12MmheflYF3g32LuEJcSh1tM=
Date: Wed, 13 Aug 2025 15:41:02 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,shakeel.butt@linux.dev,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-optimize-exit-to-user-space-fix.patch added to mm-new branch
Message-Id: <20250813224102.D6063C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-optimize-exit-to-user-space-fix
has been added to the -mm mm-new branch.  Its filename is
     memcg-optimize-exit-to-user-space-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-optimize-exit-to-user-space-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-optimize-exit-to-user-space-fix
Date: Wed Aug 13 03:38:42 PM PDT 2025

remove now-unneeded test of memcg_nr_pages_over_high==0, per Shakeel

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memcontrol.c~memcg-optimize-exit-to-user-space-fix
+++ a/mm/memcontrol.c
@@ -2213,9 +2213,6 @@ void __mem_cgroup_handle_over_high(gfp_t
 	struct mem_cgroup *memcg;
 	bool in_retry = false;
 
-	if (likely(!nr_pages))
-		return;
-
 	memcg = get_mem_cgroup_from_mm(current->mm);
 	current->memcg_nr_pages_over_high = 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch

