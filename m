Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB32D14B948
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560565; cv=none; b=ITc+KnrWC+Ys6UuylA3sBqlZsX4y657xV7yPYmtuLxANB9IwOeod9HYV6rfqI+35hX0CI114Rksr2CSsXADkk9CGCz3Ot0uX8oAeWOcBwR1ZYsm2MqHLsnLGUoHpFucMrzre/IEovUGyyDJu/RDxWtLUIHRQ2t1DNpeHL+eSmpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560565; c=relaxed/simple;
	bh=vEyx5fsK1ayvF8yesuocbY1DeAnEvLahNVd2fgLzN5k=;
	h=Date:To:From:Subject:Message-Id; b=O/MQq7ziyhvWO6m08AdFYPte0SxnaG0BNw+ZSzWJrWO29iATVDhLrNYsGUXyepvwjAUzp10rKZxs0QD87KKwg+2kEgwh24mNYiFsVJPci6LgLBhpzMEBrVXlcG2N/fxoFCqE+uCKRxMmXlCPS4HWCGJU69dTSh79jNlIqKDM9hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FihWtMBS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FihWtMBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3EDC4CEC6;
	Tue, 17 Sep 2024 08:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560565;
	bh=vEyx5fsK1ayvF8yesuocbY1DeAnEvLahNVd2fgLzN5k=;
	h=Date:To:From:Subject:From;
	b=FihWtMBSQuxSlOBYVrhj59qw5XKLislOfJOIZ8mWXVvNjsLDe26p42xqbpUHGMG6t
	 kIhmNldhNx7ZDP2qVS6TCXg2UrPjBzP7Lg8TYHkRtZl8m4lG4M7dLJ4wTfULGDezJT
	 Tq4lRz79Z1hkheWe0VVRnVQjBd0DhA9k0npnHv/8=
Date: Tue, 17 Sep 2024 01:09:22 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,usamaarif642@gmail.com,surenb@google.com,shy828301@gmail.com,shakeel.butt@linux.dev,senozhatsky@chromium.org,ryncsn@gmail.com,ryan.roberts@arm.com,nphamcs@gmail.com,minchan@kernel.org,mhocko@suse.com,kasong@tencent.com,kanchana.p.sridhar@intel.com,kaleshsingh@google.com,hughd@google.com,hch@infradead.org,hannes@cmpxchg.org,hanchuanhua@oppo.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch removed from -mm tree
Message-Id: <20240917080924.EB3EDC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add nr argument in mem_cgroup_swapin_uncharge_swap() helper to support large folios
has been removed from the -mm tree.  Its filename was
     mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4559,14 +4559,15 @@ int mem_cgroup_swapin_charge_folio(struc
 
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
@@ -4586,7 +4587,7 @@ void mem_cgroup_swapin_uncharge_swap(swp
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


