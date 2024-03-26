Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FB5481A3
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 19:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711482783; cv=none; b=LaDCC9LO+1xEwR2XWwabjZmiUcq9wGVnYkG04GBAHiVRcKQR+Tfg/RavHykMMOhYB+gr+XY2ePCAc3HjLgyQOabcvPrzpOhr0sUW1xrjmYQzVv+NEekEJjrJpoX72EpnH9O8CRKLJZxkcUZKw5lTxOm/fhIdw2YbE81rerOgltE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711482783; c=relaxed/simple;
	bh=rJkq4XxkM+XipZnCNI6AGv+qt/jXq1nXmFVlDdDX6jk=;
	h=Date:To:From:Subject:Message-Id; b=Zi2veJU6H+iIZgfxs4lxYsyui7e3O4IvMTdbfiDhfd1EQd0zhXRX29oyTFtae9fiHaWaFaDjzTuoREdAuT66p6YMlqLv4KrBu7wn0UjNN/ZAlOeFXoInbisVSpsxhR9g/tgo+fxbNT9bbJLkaCY8ZjuXqhjaK+m9BcsN5hSpcGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pB6CIvwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pB6CIvwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E17EC433F1;
	Tue, 26 Mar 2024 19:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711482782;
	bh=rJkq4XxkM+XipZnCNI6AGv+qt/jXq1nXmFVlDdDX6jk=;
	h=Date:To:From:Subject:From;
	b=pB6CIvwKORHh2ow+bSs2WeiNKVGqz+x2zFZI8WBlVyXb0VAiV+SJ/ce/TjAiKjdVP
	 vM5QiHVmYK86wM+7LIUZZ4EUI4a7txE2uQVoC6VHzSKKxFAaKyTh2Y0tfWVObd52xo
	 YwEU7S1L9/xVHIqF7x40Cz5RiQQcMPuemYpFhuho=
Date: Tue, 26 Mar 2024 12:53:02 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch added to mm-unstable branch
Message-Id: <20240326195302.9E17EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc.c: don't show protection in zone's ->lowmem_reserve[] for empty zone
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/page_alloc.c: don't show protection in zone's ->lowmem_reserve[] for empty zone
Date: Tue, 26 Mar 2024 14:11:32 +0800

On one node, for lower zone's ->lowmem_reserve[], it will show how much
memory is reserved in this lower zone to avoid excessive page allocation
from the relevant higher zone's fallback allocation.

However, currently lower zone's lowmem_reserve[] element will be filled
even though the relevant higher zone is empty.  That doesnt' make sense
and can cause confusion.

E.g on node 0 of one system as below, it has zone
DMA/DMA32/NORMAL/MOVABLE/DEVICE, among them zone MOVABLE/DEVICE are the
highest and both are empty.  In zone DMA/DMA32's protection array, we can
see that it has value for zone MOVABLE and DEVICE.

Node 0, zone      DMA
  ......
  pages free     2816
        boost    0
        min      7
        low      10
        high     13
        spanned  4095
        present  3998
        managed  3840
        cma      0
        protection: (0, 1582, 23716, 23716, 23716)
   ......
Node 0, zone    DMA32
  pages free     403269
        boost    0
        min      753
        low      1158
        high     1563
        spanned  1044480
        present  487039
        managed  405070
        cma      0
        protection: (0, 0, 22134, 22134, 22134)
   ......
Node 0, zone   Normal
  pages free     5423879
        boost    0
        min      10539
        low      16205
        high     21871
        spanned  5767168
        present  5767168
        managed  5666438
        cma      0
        protection: (0, 0, 0, 0, 0)
   ......
Node 0, zone  Movable
  pages free     0
        boost    0
        min      32
        low      32
        high     32
        spanned  0
        present  0
        managed  0
        cma      0
        protection: (0, 0, 0, 0, 0)
Node 0, zone   Device
  pages free     0
        boost    0
        min      0
        low      0
        high     0
        spanned  0
        present  0
        managed  0
        cma      0
        protection: (0, 0, 0, 0, 0)

Here, clear out the element value in lower zone's ->lowmem_reserve[] if the
relevant higher zone is empty.

And also replace space with tab in _deferred_grow_zone()

Link: https://lkml.kernel.org/r/20240326061134.1055295-7-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone
+++ a/mm/page_alloc.c
@@ -315,7 +315,7 @@ static inline bool deferred_pages_enable
 static bool __ref
 _deferred_grow_zone(struct zone *zone, unsigned int order)
 {
-       return deferred_grow_zone(zone, order);
+	return deferred_grow_zone(zone, order);
 }
 #else
 static inline bool deferred_pages_enabled(void)
@@ -5911,10 +5911,11 @@ static void setup_per_zone_lowmem_reserv
 
 			for (j = i + 1; j < MAX_NR_ZONES; j++) {
 				struct zone *upper_zone = &pgdat->node_zones[j];
+				bool empty = !zone_managed_pages(upper_zone);
 
 				managed_pages += zone_managed_pages(upper_zone);
 
-				if (clear)
+				if (clear || empty)
 					zone->lowmem_reserve[j] = 0;
 				else
 					zone->lowmem_reserve[j] = managed_pages / ratio;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch
mm-move-array-mem_section-init-code-out-of-memory_present.patch
mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch
mm-make-__absent_pages_in_range-as-static.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch
mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch
mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch
mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch

