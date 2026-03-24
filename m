Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF3E18027
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388555; cv=none; b=dArclWphPY5otsqOfW1IyYxQNWkyFScoAaKLc0R2lqJe/5OgNa7XTLVXu7+Jq2xWzRfYczvMhXOnEwrL/EDocyyLxjGnsDMluw/GdiJ1FBI/9cIIpbS9WhvdWjtFsX1wgw2Bf23CV2sjLoZ46EwC97ERAx51GuEnqfc+kZnQZGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388555; c=relaxed/simple;
	bh=d/F5zkBQqwZ5sQDyLWZhhHx40ABdK5K6LweECCQ9+yI=;
	h=Date:To:From:Subject:Message-Id; b=pJmDfcfUAf556xu4AHSucsj2IVENnQlKxgmgYIuWQ09tcEdzZ/VjiQ9OptBS/5riVbviMmYBLaPUCiACpPk8iJgwH/2L0ulMhpvpt2gwL84tYK31as6S7jskZPzgbgawfx978htS0JgXx/WdaymuTU+FK+JdBP92W1Q+c0nQV9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XteDNzwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XteDNzwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01279C19424;
	Tue, 24 Mar 2026 21:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388555;
	bh=d/F5zkBQqwZ5sQDyLWZhhHx40ABdK5K6LweECCQ9+yI=;
	h=Date:To:From:Subject:From;
	b=XteDNzwDVbi+6X/VUnYqLq9Pd2AhcC8hKzzXnHnkFh1Xk9N1KgR72w5qPe0uWcuZp
	 E+sKHD3Le5WTlofcnv60k66nJmotgWhOdqUM3Xf8swS8eG1SNGXGmpRO4/pc5XpgoB
	 yRBonKar9G/JfssQIoPp+Ag+GvfBFURE4sTjFazI=
Date: Tue, 24 Mar 2026 14:42:34 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-no-need-to-clear-the-shadow-explicitly.patch removed from -mm tree
Message-Id: <20260324214235.01279C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: no need to clear the shadow explicitly
has been removed from the -mm tree.  Its filename was
     mm-swap-no-need-to-clear-the-shadow-explicitly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: no need to clear the shadow explicitly
Date: Wed, 18 Feb 2026 04:06:37 +0800

Since we no longer bypass the swap cache, every swap-in will clear the
swap shadow by inserting the folio into the swap table.  The only place we
may seem to need to free the swap shadow is when the swap slots are freed
directly without a folio (swap_put_entries_direct).  But with the swap
table, that is not needed either.  Freeing a slot in the swap table will
set the table entry to NULL, which erases the shadow just fine.

So just delete all explicit shadow clearing, it's no longer needed.  Also,
rearrange the freeing.

Link: https://lkml.kernel.org/r/20260218-swap-table-p3-v3-12-f4e34be021a7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h       |    1 -
 mm/swap_state.c |   21 ---------------------
 mm/swapfile.c   |    2 --
 3 files changed, 24 deletions(-)

--- a/mm/swapfile.c~mm-swap-no-need-to-clear-the-shadow-explicitly
+++ a/mm/swapfile.c
@@ -1287,7 +1287,6 @@ static void swap_range_alloc(struct swap
 static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			    unsigned int nr_entries)
 {
-	unsigned long begin = offset;
 	unsigned long end = offset + nr_entries - 1;
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
 	unsigned int i;
@@ -1312,7 +1311,6 @@ static void swap_range_free(struct swap_
 			swap_slot_free_notify(si->bdev, offset);
 		offset++;
 	}
-	__swap_cache_clear_shadow(swp_entry(si->type, begin), nr_entries);
 
 	/*
 	 * Make sure that try_to_unuse() observes si->inuse_pages reaching 0
--- a/mm/swap.h~mm-swap-no-need-to-clear-the-shadow-explicitly
+++ a/mm/swap.h
@@ -290,7 +290,6 @@ void __swap_cache_del_folio(struct swap_
 			    struct folio *folio, swp_entry_t entry, void *shadow);
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 				struct folio *old, struct folio *new);
-void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents);
 
 void show_swap_cache_info(void);
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
--- a/mm/swap_state.c~mm-swap-no-need-to-clear-the-shadow-explicitly
+++ a/mm/swap_state.c
@@ -350,27 +350,6 @@ void __swap_cache_replace_folio(struct s
 	}
 }
 
-/**
- * __swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
- * @entry: The starting index entry.
- * @nr_ents: How many slots need to be cleared.
- *
- * Context: Caller must ensure the range is valid, all in one single cluster,
- * not occupied by any folio, and lock the cluster.
- */
-void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents)
-{
-	struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
-	unsigned int ci_off = swp_cluster_offset(entry), ci_end;
-	unsigned long old;
-
-	ci_end = ci_off + nr_ents;
-	do {
-		old = __swap_table_xchg(ci, ci_off, null_to_swp_tb());
-		WARN_ON_ONCE(swp_tb_is_folio(old) || swp_tb_get_count(old));
-	} while (++ci_off < ci_end);
-}
-
 /*
  * If we are the only user, then try to free up the swap cache.
  *
_

Patches currently in -mm which might be from kasong@tencent.com are


