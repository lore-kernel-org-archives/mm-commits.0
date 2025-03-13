Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A10A1F0997
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 22:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741903983; cv=none; b=YfmFGgqVopAjJmble3xYw8MIdlsP5M1CC5ZuYkuNyqsUcNpFuSqEsz/LzxeCaUslOOII67te2CFCZydW3VQPwmfpYrqgA4zLg2UV2c+GNKDeEDe8JYyt62bxPTU7NVO+nLC1weMBHVRueLAVYTKKMy7i3IIlcl60ZsKPyoYqmYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741903983; c=relaxed/simple;
	bh=O77MOeZDxtP7fVbjt1cHhbUooF+rm3uj4ZH2MC75xl0=;
	h=Date:To:From:Subject:Message-Id; b=c5HY3QKTR4bYMFcDJhTqLAnc4KDb33Jxc6GKHO6DWtWC0hiDhd95D1+0awZy4DNcHP3o1pkMWVOLeuC9ggMlX4DGGpiK3XROten8IknsQpLS7X5rgr4Hl5YFveBTsd1z37EihFKflu7VjcvLneppf5KPmEQqHmy3sRXPhNjQnsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ov29U2Qu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ov29U2Qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DF6C4CEDD;
	Thu, 13 Mar 2025 22:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741903982;
	bh=O77MOeZDxtP7fVbjt1cHhbUooF+rm3uj4ZH2MC75xl0=;
	h=Date:To:From:Subject:From;
	b=Ov29U2Qu+8cEYwLKS7YKZWLMRByy4g+5zlYU+m+b4H28kt7wOUMDcRUmz27ZY14hB
	 N6li/E79g1UgydwXjOY4saNw1/xpnrAw9vDcfIe+kCojfqZJfMaR3nSKvwQDV/WENb
	 al4R1MIk+AV5wfgcDeNrh0x0KupOiEv2hxr7G5Bs=
Date: Thu, 13 Mar 2025 15:13:01 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhockoc@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-avoid-refill_stock-for-root-memcg.patch added to mm-unstable branch
Message-Id: <20250313221302.91DF6C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: avoid refill_stock for root memcg
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-avoid-refill_stock-for-root-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-avoid-refill_stock-for-root-memcg.patch

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
Subject: memcg: avoid refill_stock for root memcg
Date: Wed, 12 Mar 2025 22:48:12 -0700

We never charge the page counters of root memcg, so there is no need to
put root memcg in the memcg stock.  At the moment, refill_stock() can be
called from try_charge_memcg(), obj_cgroup_uncharge_pages() and
mem_cgroup_uncharge_skmem().

The try_charge_memcg() and mem_cgroup_uncharge_skmem() are never called
with root memcg, so those are fine.  However obj_cgroup_uncharge_pages()
can potentially call refill_stock() with root memcg if the objcg object
has been reparented over to the root memcg.  Let's just avoid
refill_stock() from obj_cgroup_uncharge_pages() for root memcg.

Link: https://lkml.kernel.org/r/20250313054812.2185900-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhockoc@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-avoid-refill_stock-for-root-memcg
+++ a/mm/memcontrol.c
@@ -2643,7 +2643,8 @@ static void obj_cgroup_uncharge_pages(st
 
 	mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
 	memcg1_account_kmem(memcg, -nr_pages);
-	refill_stock(memcg, nr_pages);
+	if (!mem_cgroup_is_root(memcg))
+		refill_stock(memcg, nr_pages);
 
 	css_put(&memcg->css);
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-drain-obj-stock-on-cpu-hotplug-teardown.patch
memcg-add-hierarchical-effective-limits-for-v2.patch
memcg-dont-call-propagate_protected_usage-for-v1.patch
page_counter-track-failcnt-only-for-legacy-cgroups.patch
page_counter-reduce-struct-page_counter-size.patch
memcg-bypass-root-memcg-check-for-skmem-charging.patch
memcg-avoid-refill_stock-for-root-memcg.patch

