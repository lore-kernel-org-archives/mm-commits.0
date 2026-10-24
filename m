Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832537;
	b=b0oTcz6bvvQ9IfuXuamrWrlLXh/7abN9vq9Q7BkLRlhzp1rbEFpIW+v0sJIhmM97PSRv
	 uOy35aCH9oAMnsAy7ZXTKRbZ20UIniUO70GaRu+bAI2fpJ9fIoquX4IsL0zwuQpA5Azrd
	 Ib1Tb/jcyHYpKg1bVNotOp2gqz65wf4w3abaxwUhIFVC7EJm+dPr4fP7h5RE4+B7CGU8D
	 fIzlySDF1fUZ4TaRcVxFmmKQxowWTVMcFD2eLifPZ4cyR9l6aqSK6jG9urp1oQNo97nzu
	 Qgd/ySsHYIdguvWwUG7FBb6+OA2htWt7H07Wg98W5tSDtzCYOskrdzY7rHA/8BeK6TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832537;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=fnox/UIkNZ2fC0EmGbuWcRP61deS2PrR1/WAByO+bEA=;
	b=4aPw4LX2y6WkYhMGPIy+3JXT0/0z2Nrt9auzy2QoheNPhrl6yBHAUwq8KPz2VdEVgnXg
	 fG6zg1FwLJSlTkv5GFD65Xjj4NeMrFra8qYhJ03/WsbG98Dw0P91RseXWvE+QQvEwDax6
	 YPfctH/eHmR1D/oC1o+l85okHg8sA+BhmFopY27nByL63lWV5P3K9LQNqW5qREQg81ba1
	 RJysnwY7HfUUOEPiLRmKMFwhxSzcZ7tjVhELozKAsCFZKY45RtgFftfKOeHlKu/NzLMIj
	 uJM8IBMvZNpjQ/hvWc64ygAZdzDcBfpckOesECp2GZSfRp6r+96NtMD2B2Wbk1KU1Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="kzjh7I/j";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9673606A329;
	Sat, 24 Oct 2026 09:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kzjh7I/j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30411F01825;
	Sat, 24 Oct 2026 09:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832536;
	bh=fnox/UIkNZ2fC0EmGbuWcRP61deS2PrR1/WAByO+bEA=;
	h=Date:To:From:Subject;
	b=kzjh7I/jwS0tDGoPbDc1CSLfkk9JNZ0EvzWxleMehGNoVq5Gw1Q/y1o3ayf9jqS42
	 ozx/aClHhSuTPLGeI+xDwv06feOD3s/Puk8UU7mQfFPP0DJf136F1ccDh52PyODGzF
	 tLSlTQ+MygIC1uwEkDqPcWRruQpprHuYXWgKfPM4=
Date: Sat, 24 Oct 2026 02:02:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,pasha.tatashin@soleen.com,mhocko@suse.com,joshua.hahnjy@gmail.com,david@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-apply-bind-policies-against-the-scoped-allocation-zone.patch removed from -mm tree
Message-Id: <20261024090216.B30411F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mempolicy: apply bind policies against the scoped allocation zone
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-apply-bind-policies-against-the-scoped-allocation-zone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-page_alloc-let-the-highest-memory-node-recover-from-hopeless-state.patch

