Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D721A76B2
	for <mm-commits@vger.kernel.org>; Tue, 10 Sep 2024 19:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725995334; cv=none; b=Jw7blaQ5Cm+gq1CxOth0VmdN5C+/G3JrEhZkWM6s36VhOVDrOu7DDbuaQaWu20KCdcjCG3W/oWwAeT9HHwR22aMSmi5/fXqE0Rs9tR0WHjK8AmIVRWRyLRNCHxBuJTzuY+V00o6ydmVl3SYYRt7zaTWxc2x//lgE4YJPvv65nhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725995334; c=relaxed/simple;
	bh=88HW+c/yGZd/8IHTphyiyUeTDN1T9DwjzrEpAtE9XG8=;
	h=Date:To:From:Subject:Message-Id; b=DpCa9YQON1R0pegPjCqWCuANP7AtMlphxxytZ/hotHmZ3CW63Gb5QA95DwHnRroKprwiiDnitThOVdMp2m5Bo7FPaa92/7+LGTyIcvYyO2TiS2MzFsHRAFL4KfXwpDxR1tK+azDgXWnrdCFurT1xCaNJDXQkL2CWyEQf+pOlY+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rfCnDpld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rfCnDpld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8D5C4CEC4;
	Tue, 10 Sep 2024 19:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725995334;
	bh=88HW+c/yGZd/8IHTphyiyUeTDN1T9DwjzrEpAtE9XG8=;
	h=Date:To:From:Subject:From;
	b=rfCnDpld+LoT72X/xnAUgHL9BDKtjWRDB2+XrCEXUwpcIvy4wJ/SMBldFF47S4+YR
	 nZB/U73AWZGDU1Z0YObLNgl4dFYWyQ+Wml5XiSKzIomVVYu4iRz/hNTNnK/rqhkLqJ
	 oU1KPAJ2ErWq9ROHeHqfknPP2yC9n7TKm0ZqImXE=
Date: Tue, 10 Sep 2024 12:08:53 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,usamaarif642@gmail.com,surenb@google.com,shy828301@gmail.com,shakeel.butt@linux.dev,senozhatsky@chromium.org,ryncsn@gmail.com,ryan.roberts@arm.com,nphamcs@gmail.com,minchan@kernel.org,mhocko@suse.com,kasong@tencent.com,kanchana.p.sridhar@intel.com,kaleshsingh@google.com,hughd@google.com,hch@infradead.org,hannes@cmpxchg.org,hanchuanhua@oppo.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch added to mm-unstable branch
Message-Id: <20240910190854.8A8D5C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add nr argument in mem_cgroup_swapin_uncharge_swap() helper to support large folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: add nr argument in mem_cgroup_swapin_uncharge_swap() helper to support large folios
Date: Mon, 9 Sep 2024 11:21:18 +1200

With large folios swap-in, we might need to uncharge multiple entries all
together, add nr argument in mem_cgroup_swapin_uncharge_swap().

For the existing two users, just pass nr=1.

Link: https://lkml.kernel.org/r/20240908232119.2157-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++--
 mm/memcontrol.c            |    7 ++++---
 mm/memory.c                |    2 +-
 mm/swap_state.c            |    2 +-
 4 files changed, 9 insertions(+), 7 deletions(-)

--- a/include/linux/memcontrol.h~mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios
+++ a/include/linux/memcontrol.h
@@ -699,7 +699,8 @@ int mem_cgroup_hugetlb_try_charge(struct
 
 int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry);
-void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry);
+
+void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry, unsigned int nr_pages);
 
 void __mem_cgroup_uncharge(struct folio *folio);
 
@@ -1206,7 +1207,7 @@ static inline int mem_cgroup_swapin_char
 	return 0;
 }
 
-static inline void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry)
+static inline void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry, unsigned int nr)
 {
 }
 
--- a/mm/memcontrol.c~mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios
+++ a/mm/memcontrol.c
@@ -4560,14 +4560,15 @@ int mem_cgroup_swapin_charge_folio(struc
 
 /*
  * mem_cgroup_swapin_uncharge_swap - uncharge swap slot
- * @entry: swap entry for which the page is charged
+ * @entry: the first swap entry for which the pages are charged
+ * @nr_pages: number of pages which will be uncharged
  *
  * Call this function after successfully adding the charged page to swapcache.
  *
  * Note: This function assumes the page for which swap slot is being uncharged
  * is order 0 page.
  */
-void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry)
+void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 {
 	/*
 	 * Cgroup1's unified memory+swap counter has been charged with the
@@ -4587,7 +4588,7 @@ void mem_cgroup_swapin_uncharge_swap(swp
 		 * let's not wait for it.  The page already received a
 		 * memory+swap charge, drop the swap entry duplicate.
 		 */
-		mem_cgroup_uncharge_swap(entry, 1);
+		mem_cgroup_uncharge_swap(entry, nr_pages);
 	}
 }
 
--- a/mm/memory.c~mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios
+++ a/mm/memory.c
@@ -4104,7 +4104,7 @@ vm_fault_t do_swap_page(struct vm_fault
 					ret = VM_FAULT_OOM;
 					goto out_page;
 				}
-				mem_cgroup_swapin_uncharge_swap(entry);
+				mem_cgroup_swapin_uncharge_swap(entry, 1);
 
 				shadow = get_shadow_from_swap_cache(entry);
 				if (shadow)
--- a/mm/swap_state.c~mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios
+++ a/mm/swap_state.c
@@ -522,7 +522,7 @@ struct folio *__read_swap_cache_async(sw
 	if (add_to_swap_cache(new_folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
 		goto fail_unlock;
 
-	mem_cgroup_swapin_uncharge_swap(entry);
+	mem_cgroup_swapin_uncharge_swap(entry, 1);
 
 	if (shadow)
 		workingset_refault(new_folio, shadow);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-fix-swap_read_folio_zeromap-for-large-folios-with-partial-zeromap.patch
mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch

