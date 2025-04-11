Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB71126FA65
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 03:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744340628; cv=none; b=k4YzjY36yUUM61bPDv/zKXzuPecX/GjFvpltK5oOI82mTTOJiN/6eQ5OmYzF+HEEA2Tfyw4S4qWqbfwS4V5GUOJQ23JP8nrQWk4KKSyoqOXKU6yyPVBb+Xpe4zORdWPaMr88Ixspt6RuWe3FhjkK5b12W15bgEnJmhG3UCNeH7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744340628; c=relaxed/simple;
	bh=idkkEleT4hWmkSpQFmiw4IyN5x39Z1p6z0su7erXh/U=;
	h=Date:To:From:Subject:Message-Id; b=FWIWH7GCWfTeZbYROuuO3E9Ps0FAdnnLtFj0siWqVyf6xNPso7Z2hAOl4KoZot5ZBsw1N6j3pf0lLJykfdGU86VnJm8Fuc7OixJQWpArgKK9ZgALJAbMbwdxUmiNED5Mbx+J4PcyYBBupU/ZPiF+pF757fgHN3kTlrewXRm8Dus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DiJJaur9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DiJJaur9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38811C4CEDD;
	Fri, 11 Apr 2025 03:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744340627;
	bh=idkkEleT4hWmkSpQFmiw4IyN5x39Z1p6z0su7erXh/U=;
	h=Date:To:From:Subject:From;
	b=DiJJaur9CH58rjfpRpIC3f5Df55IztSHBUXDQvZ4Prx2NJ5oXaho/BNYR1hC7x9/P
	 dO8ApvSCNuxosCZzI6uV7kMNkDWpWbFN2hMsatDtAJoVyjuxJNOkcdZN0tDAUZR73x
	 OCWgC/50Qi/60mT+/I4St+ZD1dXtqJpCSZJjZJaU=
Date: Thu, 10 Apr 2025 20:03:46 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup.patch added to mm-hotfixes-unstable branch
Message-Id: <20250411030347.38811C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: fix swap counter leak from offline cgroup
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix swap counter leak from offline cgroup
Date: Thu, 10 Apr 2025 16:18:12 +0800

commit 73f839b6d2ed addressed an issue regarding the swap counter leak
that occurred from an offline cgroup.  However, commit 89ce924f0bd4
modified the parameter from @swap_memcg to @memcg (presumably this
alteration was introduced while resolving conflicts).  Fix this problem by
reverting this minor change.

Link: https://lkml.kernel.org/r/20250410081812.10073-1-songmuchun@bytedance.com
Fixes: 89ce924f0bd4 ("mm: memcontrol: move memsw charge callbacks to v1")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol-v1.c~mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup
+++ a/mm/memcontrol-v1.c
@@ -620,7 +620,7 @@ void memcg1_swapout(struct folio *folio,
 		mem_cgroup_id_get_many(swap_memcg, nr_entries - 1);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
-	swap_cgroup_record(folio, mem_cgroup_id(memcg), entry);
+	swap_cgroup_record(folio, mem_cgroup_id(swap_memcg), entry);
 
 	folio_unqueue_deferred_split(folio);
 	folio->memcg_data = 0;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup.patch

