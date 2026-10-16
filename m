Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924DE3D6CC6;
	Fri, 16 Oct 2026 21:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792186846; cv=none; b=jqGzBn8NucCoeWxdAEPAjOy1EmKxTADIuqLb3b6LtU7sXrjIOWMXlCiKv85Uz7lZ/Xw33r0p4FuCfNHzxCp0+hxwEul7S69RnDgP1z0UAEHizaEjFLeoyvMN5kzxPsJpRWrvjO4xiF7eWj23UzY9q3zw7T42ZJsmGUsqU39lEko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792186846; c=relaxed/simple;
	bh=UALNbYGeVGfx7ycRj9DrABccg+2AAGjQiBS4Bf2xUEg=;
	h=Date:To:From:Subject:Message-Id; b=M7NvFi6+9v9M0PZOliQuAo+Eyr8ZwXWnv+2XhYGfM0QeRE7OBPymi97NUyNihMtTK2VIBrcRAFmXfjpRmsIZeJFPszrm1gknUJnzK9uSB/Djyf1nTlLvVsEIJE0W75Zc3p4gWV0BMEKtG3/ATcGBA+JlbxtKmmOmYY7etupT7V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ogvNFTaV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ogvNFTaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E491F000C4;
	Fri, 16 Oct 2026 21:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792186845;
	bh=YlF+da7io3pnpiqk+0YlDdLXJyJ+lmmFLONzro/9MD0=;
	h=Date:To:From:Subject;
	b=ogvNFTaVOxxdSkqrrNEZQm3GJNXmMyYnZvpPayRBUrQBOovkN/Ryxlt1ddYXgVXTC
	 YgJh+52/3Ps7s/3CyzbrRGjh4YYF2Ti0brLgMF4gXTt5GJCvdfA8v3p0ovfV6WZOmJ
	 PfPtqKk7PcY1f/twCFs9ekc4Ff3hrqx+gM4t4uss=
Date: Fri, 16 Oct 2026 14:40:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,qi.zheng@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,fvdl@google.com,dev.jain@arm.com,david@kernel.org,brendan.jackman@linux.dev,baoquan.he@linux.dev,riel@surriel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-count-guard-pages-as-free-again-when-their-buddy-merges.patch added to mm-unstable branch
Message-Id: <20261016214044.E5E491F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: count guard pages as free again when their buddy merges
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-count-guard-pages-as-free-again-when-their-buddy-merges.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-count-guard-pages-as-free-again-when-their-buddy-merges.patch

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
From: Rik van Riel <riel@surriel.com>
Subject: mm/page_alloc: count guard pages as free again when their buddy merges
Date: Fri, 16 Oct 2026 12:23:04 -0400

With debug_guardpage_minorder set, expand() turns the unused halves of a
split into guard pages, which page_del_and_expand() leaves out of the free
counts.  Freeing the allocated half credits only that half, and
__free_one_page() then merges the guard buddy with clear_page_guard(),
which no longer touches the counters.

The merged block goes on a free list with the guard pages never counted,
so NR_FREE_PAGES falls behind the free lists by every guard that merges. 
Before commit e0932b6c1f94 ("mm: page_alloc: consolidate free page
accounting"), __set_page_guard() and __clear_page_guard() adjusted the
counts themselves; that commit dropped both adjustments but kept the
subtraction implicit in expand().

Count the guard pages under the merged block's migratetype when the buddy
is cleared.  account_freepages() skips an isolated block as it does for
every other free page, and moving the block off the isolated list counts
it then.

Booting a 16GB VM with debug_pagealloc=on debug_guardpage_minorder=1,
check the difference in free pages reported between /proc/vmstat and
/proc/buddyinfo.

At three points (idle, after a read and file-creation load, after a second
load), check the difference between nr_free_pages and the buddyinfo
numbers in the normal zone, as a number of pages:

                idle   after load   after second load
    unpatched   -130        79205               99121
    patched      -16           45                   0

The small remaining difference seems to be due to the numbers not being
read at exactly the same time, and is also seen without guard pages.

Link: https://lore.kernel.org/20261016122304.5b1eba8e@fangorn
Fixes: e0932b6c1f94 ("mm: page_alloc: consolidate free page accounting")
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Assisted-by: LLM
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-count-guard-pages-as-free-again-when-their-buddy-merges
+++ a/mm/page_alloc.c
@@ -971,10 +971,12 @@ static inline void __free_one_page(struc
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
 		 */
-		if (page_is_guard(buddy))
+		if (page_is_guard(buddy)) {
 			clear_page_guard(zone, buddy, order);
-		else
+			account_freepages(zone, 1 << order, migratetype);
+		} else {
 			__del_page_from_free_list(buddy, zone, order, buddy_mt);
+		}
 
 		if (unlikely(buddy_mt != migratetype)) {
 			/*
_

Patches currently in -mm which might be from riel@surriel.com are

mm-page_alloc-count-guard-pages-as-free-again-when-their-buddy-merges.patch

