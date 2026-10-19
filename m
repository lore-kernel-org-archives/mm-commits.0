Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792448502;
	b=jOK9Rlo6tKqL836mEADpvTidxJCQMWAXN4I0oAR7bBm06ZhG0oQr1A87gbqLZXt/aq4C
	 I6vfadMqv8fkYE+g1RRJNhYWD25DFjGOBPtNCtBRVo3e3hFTC9CDottfvGyj+3kJxfRsn
	 Ih4VF5juwCi7w8yO67s0FiS9hlmt26Xh6JfwtWbwduBAwebRnWlDv0VJyBpFvs1c4KyHP
	 zLFqEBTxNiKh5FCx7goOUA1shfey0RYns12ba+IvBbHRrziYPh6R/l9abQO7osqy7lTh/
	 6MEqEpzsPc64+03y8ATMWcDrqxrXkEbI4lT8YCaPw/fMopR5Gyktg/0bas/dgvDOO1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448502;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=IrmFStrxWye7dcbeoq2RKF2LiXBI37hi5qUe8gclDG0=;
	b=3Em4rI7HzAA0Avu74wAqfHqljxAWaLMZCYQtV2NU+Sl9G2kWhV4UPvee6OGAL6thOYVJ
	 SHzHdggghuC0rer2jQjnXAtwu8sKZbkA3GGIZSXb0+7QJUxCZg65wnt80M+UsDFYpaXL7
	 9vmB+BMyk/RyuukZuER9a4qClEJ6LVIDg59ei8+xmGtK0R2cvOdik5gAFgHLvbDbXanPt
	 jZIwCbd485w1iYOJvYLGyjixzr7ZEvcW+TJmxNfINsnq07dHSore7JNTpE+zxysMaadaI
	 FbKYRU54vcwcTF12GpM7UChnUzvpKl1vx+0fGGlQ/sobIFSu0osGd425AbgqfVNc7BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=d5eaRcOe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5D0606A31A;
	Mon, 19 Oct 2026 22:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=d5eaRcOe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5BC1F000C4;
	Mon, 19 Oct 2026 22:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792448501;
	bh=IrmFStrxWye7dcbeoq2RKF2LiXBI37hi5qUe8gclDG0=;
	h=Date:To:From:Subject;
	b=d5eaRcOeve5HCzQE/b0AH7cwJd2uTUz84M4uUU9DG5C7/aAluGvERbn+D76mjJcRH
	 4CnNiRE8OH2LRkLUTp8yZMyLsMNoPjSHPcyF809WRIMiavglf7+z5BB1lVlgNd9+oL
	 RGDh672TXXM70Kp5iaKs8WG0fDwp8FFjGgyexgKk=
Date: Mon, 19 Oct 2026 15:21:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,pasha.tatashin@soleen.com,mhocko@suse.com,joshua.hahnjy@gmail.com,david@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-apply-bind-policies-against-the-scoped-allocation-zone.patch added to mm-unstable branch
Message-Id: <20261019222141.BF5BC1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mempolicy: apply bind policies against the scoped allocation zone
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-apply-bind-policies-against-the-scoped-allocation-zone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-apply-bind-policies-against-the-scoped-allocation-zone.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Gregory Price (Meta)" <gourry@gourry.net>
Subject: mm/mempolicy: apply bind policies against the scoped allocation zone
Date: Sat, 17 Oct 2026 22:33:49 -0400

QEMU fails to start a guest with a VFIO device when guest RAM comes
from a memory backend bound to a movable-only node:

  vfio_container_dma_map(0x55b1b1317800, 0x0, 0x10000000,
                         0x7f39a2200000)
    = -12 (Cannot allocate memory)

VFIO pins guest RAM when the device is realized, and the pin faults
the pages in. io_uring fixed buffers fail the same way. Faulting the
range in before pinning lets the same pin succeed, since resident
pages are migrated off the node instead.

A long-term pin faults under memalloc_pin_save(). PF_MEMALLOC_PIN makes
current_gfp_context() clear __GFP_MOVABLE, but policy_nodemask() tests
apply_policy_zone() against the caller's gfp.

The bind keeps its movable-only nodemask, and the allocation finds no
usable zone:

  page allocation failure:
      order:0,
      mode:0x140dc2(GFP_HIGHUSER|__GFP_ZERO|__GFP_COMP),
      nodemask=1,cpuset=/,mems_allowed=0-1

  Call Trace:
   warn_alloc+0x136/0x150
   __alloc_frozen_pages_noprof+0xed8/0x1720
   alloc_pages_mpol+0xaa/0x170
   vma_alloc_folio_noprof+0x65/0xd0
   __handle_mm_fault+0x137b/0x1ac0
   handle_mm_fault+0xa0/0x270
   __get_user_pages+0x250/0xfd0
   __gup_longterm_locked+0x116/0x870
   gup_fast_fallback+0xcfc/0xdf0
   pin_user_pages_fast+0x47/0x60
   io_pin_pages+0x9a/0x110

Base page faults fail with -ENOMEM.
hugetlb faults fail with -EFAULT.

Check the policy zone against current_gfp_context(gfp), so a pin-scoped
fault falls back off the movable-only nodemask, like any other
non-movable allocation under the same bind.

Tested in qemu with a dax/kmem movable-only node 1. io_uring and VFIO
pins of unfaulted base pages and 2MB hugetlb pages now succeed and land
on node 0 (correct). QEMU now starts with the same backend binding.

Link: https://lore.kernel.org/20261018023349.1697434-1-gourry@gourry.net
Fixes: 8e3560d963d2 ("mm: honor PF_MEMALLOC_PIN for all movable pages")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-apply-bind-policies-against-the-scoped-allocation-zone
+++ a/mm/mempolicy.c
@@ -2302,7 +2302,7 @@ static nodemask_t *policy_nodemask(gfp_t
 		break;
 	case MPOL_BIND:
 		/* Restrict to nodemask (but not on lower zones) */
-		if (apply_policy_zone(pol, gfp_zone(gfp)) &&
+		if (apply_policy_zone(pol, gfp_zone(current_gfp_context(gfp))) &&
 		    cpuset_nodemask_valid_mems_allowed(&pol->nodes))
 			nodemask = &pol->nodes;
 		if (pol->home_node != NUMA_NO_NODE)
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch
mm-vmscan-reclaim-every-zone-in-per-node-proactive-reclaim.patch
mm-mempolicy-apply-bind-policies-against-the-scoped-allocation-zone.patch

