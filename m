Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F211C273FE
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 04:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741063639; cv=none; b=cI4NOdHItaZt+T5zA6JhY4Lk/QbvKj4s6NOtskIhZrGdzjMYIIR+VfIcJ9Q9pJQHlVb2aM/sGMEfc1FQ5hoXZgFxjyrzhruLW93cosEeV2l0l2vjMwkkdEEcSgFew3jksOhHP2ZLuTbO8M12T+S2kWDjDAWWe6iK9h/VY8oVwa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741063639; c=relaxed/simple;
	bh=+UsZo45Cnr/bY5GfFlGYdpuJCqjxy0IHDzkfb3cSJ6c=;
	h=Date:To:From:Subject:Message-Id; b=gNP/FgZEitr00YLn5M0GpjxJi9u8YhCpOtrwGGTFrSjM+J6Phd8oZmrkwg+p0VUk04WBoQCGUnDZQxbcJIKX60l5S/Y+aLmrBMGXOYnLPof3vsIrzHi9/rXAfiKPc2fnuYt66p37z0kJbTSVSc3xJMJEyXgJYsJIdHTLzu3dYnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t6PJVtAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t6PJVtAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AB7C4CEE5;
	Tue,  4 Mar 2025 04:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741063638;
	bh=+UsZo45Cnr/bY5GfFlGYdpuJCqjxy0IHDzkfb3cSJ6c=;
	h=Date:To:From:Subject:From;
	b=t6PJVtArQMTZkLBT2PGIw4c9EJiGu52p0fwooIy5Mp0t9VvOoG4y42vKwEtHSKZu8
	 3UIrguNvDHWDxUfaAA1gfO69sjJ2mL7etvTk69zhqHzphqCZILWg4g6ZydU/MpwKPo
	 3houwYm78VxuoFlkqGyV6Inh/SW/wRNbGU9LDB40=
Date: Mon, 03 Mar 2025 20:47:17 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-bypass-root-memcg-check-for-skmem-charging.patch added to mm-unstable branch
Message-Id: <20250304044718.64AB7C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: bypass root memcg check for skmem charging
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-bypass-root-memcg-check-for-skmem-charging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-bypass-root-memcg-check-for-skmem-charging.patch

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
Subject: memcg: bypass root memcg check for skmem charging
Date: Thu, 27 Feb 2025 18:23:54 -0800

The root memcg is never associated with a socket in mem_cgroup_sk_alloc,
so there is no need to check if the given memcg is root for the skmem
charging code path.

Link: https://lkml.kernel.org/r/20250228022354.2624249-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-bypass-root-memcg-check-for-skmem-charging
+++ a/mm/memcontrol.c
@@ -4888,7 +4888,7 @@ bool mem_cgroup_charge_skmem(struct mem_
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return memcg1_charge_skmem(memcg, nr_pages, gfp_mask);
 
-	if (try_charge(memcg, gfp_mask, nr_pages) == 0) {
+	if (try_charge_memcg(memcg, gfp_mask, nr_pages) == 0) {
 		mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
 		return true;
 	}
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-add-hierarchical-effective-limits-for-v2.patch
memcg-dont-call-propagate_protected_usage-for-v1.patch
page_counter-track-failcnt-only-for-legacy-cgroups.patch
page_counter-reduce-struct-page_counter-size.patch
memcg-bypass-root-memcg-check-for-skmem-charging.patch

