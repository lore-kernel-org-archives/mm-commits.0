Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80E1182B3
	for <mm-commits@vger.kernel.org>; Thu,  6 Jun 2024 02:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717640407; cv=none; b=SKsXKf3qdJoFtAm6c5AjhYgUjPuOyxAvEmenE2KgrnMVeEURdOpltF74V0GqcyynyNfVBgX7oQ/K00D1OSE/dIObdAR6dYiCGTNZ3gLAQc9VR5lnCy9kWM62/GrijtB6RbJ0qsMOpSyYPYgROwlEGFfyt5E9dscfu2V1mAu7Gd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717640407; c=relaxed/simple;
	bh=XTieQALs1GIiX1bqltHqO6Op66D+mARR9PoEMGQo7Ww=;
	h=Date:To:From:Subject:Message-Id; b=WLaXcqLilBQ0NVB/O5sCMUQRA6g/zsfBhNcPL6LljmdEk+4P4BORZsP+hQ7JH/aZ9IAR+ZvQu/33SWnQkX1jZSZ45e2gc+OEqgMW4ojcNywPTAcu0yy/0hPlWVkfkgvx/DpC5qr9yufMZOAvnq43ck+DdnmC2ELexwahbqGpM38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BPHMyX0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BPHMyX0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FD3C4AF1C;
	Thu,  6 Jun 2024 02:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717640407;
	bh=XTieQALs1GIiX1bqltHqO6Op66D+mARR9PoEMGQo7Ww=;
	h=Date:To:From:Subject:From;
	b=BPHMyX0dEFgyUzxKsnmLXSBZqamZ8kSxhMAsHKt9T3ga03pyrKGV1n2r8a/zQeW+q
	 sRe1h8wzTyuvluAazqbGUyzBSBuDT5levZSe+cL9j4XHr2N3cdGEyix6RdM+Gj9sul
	 fMI3QFKbM47wryOg2OYtnzDWjeuce0rplzn+HUtU=
Date: Wed, 05 Jun 2024 19:20:06 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,xiehuan09@gmail.com,will@kernel.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,ioworker0@gmail.com,fengwei.yin@intel.com,david@redhat.com,chrisl@kernel.org,catalin.marinas@arm.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes.patch removed from -mm tree
Message-Id: <20240606022007.20FD3C4AF1C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: arm64: fix the out-of-bounds issue in contpte_clear_young_dirty_ptes
has been removed from the -mm tree.  Its filename was
     mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: arm64: fix the out-of-bounds issue in contpte_clear_young_dirty_ptes
Date: Fri, 24 May 2024 12:54:44 +1200

We are passing a huge nr to __clear_young_dirty_ptes() right now.  While
we should pass the number of pages, we are actually passing CONT_PTE_SIZE.
This is causing lots of crashes of MADV_FREE, panic oops could vary
everytime.

Link: https://lkml.kernel.org/r/20240524005444.135417-1-21cnbao@gmail.com
Fixes: 89e86854fb0a ("mm/arm64: override clear_young_dirty_ptes() batch helper")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Lance Yang <ioworker0@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/contpte.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/mm/contpte.c~mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes
+++ a/arch/arm64/mm/contpte.c
@@ -376,7 +376,7 @@ void contpte_clear_young_dirty_ptes(stru
 	 * clearing access/dirty for the whole block.
 	 */
 	unsigned long start = addr;
-	unsigned long end = start + nr;
+	unsigned long end = start + nr * PAGE_SIZE;
 
 	if (pte_cont(__ptep_get(ptep + nr - 1)))
 		end = ALIGN(end, CONT_PTE_SIZE);
@@ -386,7 +386,7 @@ void contpte_clear_young_dirty_ptes(stru
 		ptep = contpte_align_down(ptep);
 	}
 
-	__clear_young_dirty_ptes(vma, start, ptep, end - start, flags);
+	__clear_young_dirty_ptes(vma, start, ptep, (end - start) / PAGE_SIZE, flags);
 }
 EXPORT_SYMBOL_GPL(contpte_clear_young_dirty_ptes);
 
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch
mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally.patch
mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch
mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch

