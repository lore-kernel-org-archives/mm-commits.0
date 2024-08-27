Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DE61C8FB0
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801433; cv=none; b=NHu3prQJ5ncF++VUyizYsgTVJ6BuPpSA/SmGMOJZbLpK9WOGEDC9nNv7LHXoKFA8qi4NSul5B8r2VCDMFvIvW5PrWyMdwH9lkrsrwucVgKN1K2K+z4cmT+XgiKK6b05wsw9m91XQKmlTSBRLQ9/bP3Zs3r+YoSxAhw7ywrc9Wz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801433; c=relaxed/simple;
	bh=Dl6RpMZGtygpaiUYKS3Y+3zdzy89+1yuwQOf9jj4n4o=;
	h=Date:To:From:Subject:Message-Id; b=l1keMvcxLFY1MuUh0htR5M54tTc9V2vlsHul0bUuDjeOxwe6hXIQSHm1OIJ8leWt6iFRWRGqQ/fPOqLbZYoWcEQWcAWxzecXb6OVeK/ncaOZJ/eDMp1GsD4nDH6u19g9DId4vkN4yOmOnWwBdhtYgvGrCe0nJuRuor76ABCZCCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ucsRv3uN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ucsRv3uN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60816C4FF48;
	Tue, 27 Aug 2024 23:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724801432;
	bh=Dl6RpMZGtygpaiUYKS3Y+3zdzy89+1yuwQOf9jj4n4o=;
	h=Date:To:From:Subject:From;
	b=ucsRv3uNE8dTxSuLcvPT+uNa1ge2/gYM4iUxNm2ehd0asr2Mwp1CvUkqKDEgBKIRa
	 eVPEn7cjPsMOe2d75yXN28TQHDFfvSiWlEYn2IToXPUxO4YCvd/kWo4H9liZpXWv5p
	 zVb9WBbnPaLiY/IAthMBzYCg/iFiL/vfZLFPMtXY=
Date: Tue, 27 Aug 2024 16:30:31 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,surenb@google.com,shy828301@gmail.com,shakeel.butt@linux.dev,senozhatsky@chromium.org,ryncsn@gmail.com,ryan.roberts@arm.com,nphamcs@gmail.com,minchan@kernel.org,mhocko@suse.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,hch@infradead.org,hannes@cmpxchg.org,hanchuanhua@oppo.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch added to mm-unstable branch
Message-Id: <20240827233032.60816C4FF48@smtp.kernel.org>
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
Date: Wed, 21 Aug 2024 15:45:39 +0800

Patch series "mm: Ignite large folios swap-in support", v7.

Currently, we support mTHP swapout but not swapin.  This means that once
mTHP is swapped out, it will come back as small folios when swapped in. 
This is particularly detrimental for devices like Android, where more than
half of the memory is in swap.

The lack of mTHP swapin functionality makes mTHP a showstopper in
scenarios that heavily rely on swap.  This patchset introduces mTHP
swap-in support.  It starts with synchronous devices similar to zRAM,
aiming to benefit as many users as possible with minimal changes.


This patch (of 2):

With large folios swap-in, we might need to uncharge multiple entries all
together, add nr argument in mem_cgroup_swapin_uncharge_swap().

For the existing two users, just pass nr=1.

Link: https://lkml.kernel.org/r/20240821074541.516249-1-hanchuanhua@oppo.com
Link: https://lkml.kernel.org/r/20240821074541.516249-2-hanchuanhua@oppo.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Chuanhua Han <hanchuanhua@oppo.com>
Acked-by: Chris Li <chrisl@kernel.org>
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
Cc: Yosry Ahmed <yosryahmed@google.com>
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
@@ -4572,14 +4572,15 @@ int mem_cgroup_swapin_charge_folio(struc
 
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
@@ -4599,7 +4600,7 @@ void mem_cgroup_swapin_uncharge_swap(swp
 		 * let's not wait for it.  The page already received a
 		 * memory+swap charge, drop the swap entry duplicate.
 		 */
-		mem_cgroup_uncharge_swap(entry, 1);
+		mem_cgroup_uncharge_swap(entry, nr_pages);
 	}
 }
 
--- a/mm/memory.c~mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios
+++ a/mm/memory.c
@@ -4101,7 +4101,7 @@ vm_fault_t do_swap_page(struct vm_fault
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

mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios-fix.patch
vpda-try-to-fix-the-potential-crash-due-to-misusing-__gfp_nofail.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-bug_on-to-avoid-null-deference-while-__gfp_nofail-fails.patch
mm-prohibit-null-deference-exposed-for-unsupported-non-blockable-__gfp_nofail.patch
mm-rename-instances-of-swap_info_struct-to-meaningful-si.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix.patch
mm-override-mthp-enabled-defaults-at-kernel-cmdline-fix.patch
mm-count-the-number-of-anonymous-thps-per-size.patch
mm-count-the-number-of-partially-mapped-anonymous-thps-per-size.patch
mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch

