Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32DE156678
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188524; cv=none; b=tbul07IKjnWxhXB9tSEwc2uPhQ3pkiH1xUN7LSCVNUwRg4TDJIG5l/ZYORwV0zJWlnMot19Z1gWYFFkbLakcA3JCn5Q8MWe02ekqIS4h2jIqTnyo5ZIk+Tw5+J9ntaCWz21XbD/dulfRw1H+m0ANBpsqcNOrnUuYW0tA5L9YWIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188524; c=relaxed/simple;
	bh=KM2qvEDUpY51ACzp4fz8rc2dJGY8O7ure+CfvrIXw3E=;
	h=Date:To:From:Subject:Message-Id; b=nwVQF2Rzv/hXAdvVsolBfdbZun774Fey7WSqAgMVjQKOcRtIw/j8Cnl+7AZ4ApNAd16iQmiJz/WmzTNWULrjsK/FewrD7NrSboGQj2J0daIOJPW8Gvp2uVo39BSynXahSSbkjSJ+sziriJPdPLfuKj695d1n35LBsqr8aknUPk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lAjWGGNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lAjWGGNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767F3C4CEEC;
	Mon, 17 Mar 2025 05:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188524;
	bh=KM2qvEDUpY51ACzp4fz8rc2dJGY8O7ure+CfvrIXw3E=;
	h=Date:To:From:Subject:From;
	b=lAjWGGNcovK2KquS4RD5w+bmVhd184uRHiBWpkiKjYLmGsov4j/Bqr+o2mtvMQjpv
	 AvsZKxP/fUN7CTsOxujIPZvlRzGehZjEONiZel2UjA/nDdQ/qfzREFBQhLZgsrQnqS
	 j8IUi42LGqS6S6tGHpDu0KP/ul/rvEPbbbHaFUQY=
Date: Sun, 16 Mar 2025 22:15:23 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-bypass-root-memcg-check-for-skmem-charging.patch removed from -mm tree
Message-Id: <20250317051524.767F3C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: bypass root memcg check for skmem charging
has been removed from the -mm tree.  Its filename was
     memcg-bypass-root-memcg-check-for-skmem-charging.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4881,7 +4881,7 @@ bool mem_cgroup_charge_skmem(struct mem_
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
memcg-avoid-refill_stock-for-root-memcg.patch
memcg-move-do_memsw_account-to-config_memcg_v1.patch

