Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912B4748F
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291625; cv=none; b=A+12gdTWyTdCQbzR3KPnZxnXkrcE2GtTD42CQQRvAQx++GxqVA0QNYKvA1899HuJCiRldWKBBkCHOOgMCK22Bum3SiItNbTfPZTOWqxwB9we/SJH2wj1bzchrQwRENap1a9BpP+lBttBYRwY1E29UDGwIaF+0Kd61ZpMr1shnnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291625; c=relaxed/simple;
	bh=0D5zv074QlOEuvfGCfswet3/44ddMOeQ63Uo43XOpdQ=;
	h=Date:To:From:Subject:Message-Id; b=Ju1LgGTYmPwkY88OxcsdvD3RF5u4Lg7hJMgZO48WR3D9QFxYkNVT06A1guvetsPFcES/OfZmzIl9sGJog6gCMk6L3BVqL3CjaRQD9WCoNEez/hO41jx+8/XVfNh9gCplPPUlf8wDIk3aeMpZdE1TdUIYgqykpG0wxtpMyy5Koj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wKE6tcO0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wKE6tcO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CB5C32782;
	Tue, 25 Jun 2024 05:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291625;
	bh=0D5zv074QlOEuvfGCfswet3/44ddMOeQ63Uo43XOpdQ=;
	h=Date:To:From:Subject:From;
	b=wKE6tcO0AmX1rVhNsuiv0Oovfh94ME2j2ITIqmD7aCBHz4Bhyx3bV1kXAcniE0HJf
	 RZX/cknwPpRWdNAgudY7fnB+CqBLPoiyJSTuP0ttpMhGqB02B5GIeqvVjC09XPm7jC
	 BvykY/FQGJHUwFJ9oH8bi0qjguppaSlRcbIos1Q0=
Date: Mon, 24 Jun 2024 22:00:24 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,minchan@kernel.org,mgorman@techsingularity.net,linmiaohe@huawei.com,kasong@tencent.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmswap-fix-a-theoretical-underflow-in-readahead-window-calculation.patch removed from -mm tree
Message-Id: <20240625050025.67CB5C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,swap: fix a theoretical underflow in readahead window calculation
has been removed from the -mm tree.  Its filename was
     mmswap-fix-a-theoretical-underflow-in-readahead-window-calculation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm,swap: fix a theoretical underflow in readahead window calculation
Date: Fri, 31 May 2024 16:12:28 +0800

Patch series "mm,swap: cleanup VMA based swap readahead window
calculation".

When VMA based swap readahead is introduced in commit ec560175c0b6 ("mm,
swap: VMA based swap readahead"), "struct vma_swap_readahead" is defined
to describe the readahead window.  Because we wanted to save the PTE
entries in the struct at that time.  But after commit 4f8fcf4ced0b
("mm/swap: swap_vma_readahead() do the pte_offset_map()"), we no longer
save PTE entries in the struct.  The size of the struct becomes so small,
that it's better to use the fields of the struct directly.  This can
simplify the code to improve the code readability.  The line number of
source code reduces too.

A theoretical underflow issue and some related code cleanup is done in the
series too.


This patch (of 3):

In swap readahead window calculation, if the fault PFN is smaller than the
readahead window size, underflow may occurs.  This is only possible in
theory, because the start of the virtual address space will not be used
for anonymous pages in practice.  Even if underflow occurs, there will be
no functional bugs.  In the worst cases, some swap entries may be swapped
in incorrectly and some pages may be allocate on the wrong nodes.

Anyway, we still needs to fix the issue via some underflow checking.

Link: https://lkml.kernel.org/r/20240531081230.310128-1-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20240531081230.310128-2-ying.huang@intel.com
Fixes: ec560175c0b6 ("mm, swap: VMA based swap readahead")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/swap_state.c~mmswap-fix-a-theoretical-underflow-in-readahead-window-calculation
+++ a/mm/swap_state.c
@@ -788,6 +788,8 @@ static void swap_ra_info(struct vm_fault
 		lpfn = fpfn - left;
 		rpfn = fpfn + win - left;
 	}
+	if ((long)lpfn < 0)
+		lpfn = 0;
 	start = max3(lpfn, PFN_DOWN(vma->vm_start),
 		     PFN_DOWN(faddr & PMD_MASK));
 	end = min3(rpfn, PFN_DOWN(vma->vm_end),
_

Patches currently in -mm which might be from ying.huang@intel.com are


