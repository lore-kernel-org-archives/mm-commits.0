Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17283155308
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 20:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712175421; cv=none; b=UDAz2pVhBWD1NrKECsD89X/I5+JNATxn+0Gv5db+q62xvYmeCyMESNn6WtMLoA98IXzt4YtdCOVOyAj+rJt/NHaYZVV4d9xgG/x5EBOlhnWpZcfgmhmjlMnKg6YPc1Vq2axQ4v1kZnWh4H7bkPdJ0C5ynL9xCbnLmF+yFlD54qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712175421; c=relaxed/simple;
	bh=uKi8mipnkkebA1I95n3kphzDXFqzb72tl9srjK3pCdA=;
	h=Date:To:From:Subject:Message-Id; b=UCaedJsdavclqWBoXBJWy2v3s3i6O3PRv3UUcLrvmtF7Ap82r/dspPe8pCcAbhpZVTQNOvkgDhivjLFLn9cSJp9smVayxZ+Ac/w30f+jVCWF+a7N5Q22JstHbh38KVD8FDIOfDT0JfjGHLEFQVnHX+xdPem4HODERD17cuF8njA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a53lt05V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a53lt05V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF48C433F1;
	Wed,  3 Apr 2024 20:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712175421;
	bh=uKi8mipnkkebA1I95n3kphzDXFqzb72tl9srjK3pCdA=;
	h=Date:To:From:Subject:From;
	b=a53lt05VFJiLTkWihaRH4NV3BGX/k7ShZyNT7l4bOLv789AqqjRTRrO7FMNIKA6cY
	 xC8uLJENlaXF6YyoAEzDUbozfI9MOK1usyFmm9NyrfCSjmxRw2L/mOcet7pmuNqBVC
	 fzOXvFs3YxN0aIH585nH/GwyJsI/l/x91SSXtOX0=
Date: Wed, 03 Apr 2024 13:17:00 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,mhocko@suse.com,ioworker0@gmail.com,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-avoid-split-during-madv_pageout-and-madv_cold-fix.patch added to mm-unstable branch
Message-Id: <20240403201700.DBF48C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-madvise-avoid-split-during-madv_pageout-and-madv_cold-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-avoid-split-during-madv_pageout-and-madv_cold-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-avoid-split-during-madv_pageout-and-madv_cold-fix.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm-madvise-avoid-split-during-madv_pageout-and-madv_cold-fix
Date: Wed, 3 Apr 2024 18:17:56 +0100

arch_enter_lazy_mmu_mode() needs to be before the continue

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/madvise.c~mm-madvise-avoid-split-during-madv_pageout-and-madv_cold-fix
+++ a/mm/madvise.c
@@ -486,10 +486,9 @@ restart:
 					pte_offset_map_lock(mm, pmd, addr, &ptl);
 				if (!start_pte)
 					break;
-				if (err)
-					continue;
 				arch_enter_lazy_mmu_mode();
-				nr = 0;
+				if (!err)
+					nr = 0;
 				continue;
 			}
 		}
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-swap-remove-cluster_flag_huge-from-swap_cluster_info-flags.patch
mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache.patch
mm-swap-simplify-struct-percpu_cluster.patch
mm-swap-allow-storage-of-all-mthp-orders.patch
mm-vmscan-avoid-split-during-shrink_folio_list.patch
mm-madvise-avoid-split-during-madv_pageout-and-madv_cold.patch
mm-madvise-avoid-split-during-madv_pageout-and-madv_cold-fix.patch

