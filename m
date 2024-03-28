Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A1A535CA
	for <mm-commits@vger.kernel.org>; Thu, 28 Mar 2024 19:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711652808; cv=none; b=LDhXXG/H1zBg5OmX7wm3KfSwXWw6inhuG2YsgJbCSnTw4LvMgC5mxOmF2ZMTqVRARyy8ybnLpisu7A2wSTXKF0NiGNey3DPPMWuuWiA7qihDBHHt+zeC6yZ8ilVZhOgijiIdIY1ha1PpZ7w+9kQEfiFAprA29qzbm5INXCbi+PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711652808; c=relaxed/simple;
	bh=mLoPnvZA26RIoiWJYk63dXVGAC/F9QCWi0wVTRIPceE=;
	h=Date:To:From:Subject:Message-Id; b=hPq/JNiqafek6M4YuK9qve6KbMc5eIlBltB8Wq+r3DLksJv+aiwSdJihui2qynaYS7vNPjmYtkUYJy0CL+YF65Wex33SrHIQ0rRNrsB0Eyef7XredgDb8D2mJiWODMxgr2kpwDMLX0aKDnfu304uzdHrcZwJXJa+T0WBn5v839M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u8zBALsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u8zBALsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BB4C43390;
	Thu, 28 Mar 2024 19:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711652807;
	bh=mLoPnvZA26RIoiWJYk63dXVGAC/F9QCWi0wVTRIPceE=;
	h=Date:To:From:Subject:From;
	b=u8zBALsg2nyCL08OKA9ZtxJiAhYR9WcSna/NvjO1qsCBTE3676WWfgZWNi2ZEDvCW
	 9QCHuhAOz5lpDvw4JiBwH5T1Y+82iMtAlxOX37Ka20Drk4fG74JLwK4dvCbjBZJPZy
	 2R5Z3/LrFAgowkvSyEhkZEDZHfU1pi7lOJLJ6diY=
Date: Thu, 28 Mar 2024 12:06:46 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core-v3.patch added to mm-unstable branch
Message-Id: <20240328190647.82BB4C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: remove meaningless calculation of zone->managed_pages in free_area_init_core()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core-v3.patch

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
Subject: mm/mm_init.c: remove meaningless calculation of zone->managed_pages in free_area_init_core()
Date: Thu, 28 Mar 2024 17:12:14 +0800

Change to initialize zone->managed_pages as zone->present_pages for now
because later page_group_by_mobility_disabled need be set according to
zone->managed_pages.  Otherwise it will cause setting
page_group_by_mobility_disabled to 1 always.

Link: https://lkml.kernel.org/r/ZgU0bsJ2FEjykvju@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core-v3
+++ a/mm/mm_init.c
@@ -1582,7 +1582,7 @@ static void __init free_area_init_core(s
 		 * Initialize zone->managed_pages as 0 , it will be reset
 		 * when memblock allocator frees pages into buddy system.
 		 */
-		zone_init_internals(zone, j, nid, 0);
+		zone_init_internals(zone, j, nid, zone->present_pages);
 
 		if (!size)
 			continue;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core-v3.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch
mm-move-array-mem_section-init-code-out-of-memory_present.patch
mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch
mm-make-__absent_pages_in_range-as-static.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2.patch
mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch
mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch
mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch

