Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7895D522A
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 19:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717010438; cv=none; b=G0gcE6adCclvAjJA3TSj09Fn4/WvmXMiMQcwtMnqClQsbQeE+RqM/T/JU+uE4J6x56qz/NT7D9pthKfyMYgxl5sXNuD0yaUu9nWRk7Mpk/28UzrGAHnBvBF5BX8bEayp93bGT+9fURGEsDY2k2Th2m4cD+ir68gE/AKDeyQFH1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717010438; c=relaxed/simple;
	bh=V2bG0DhvpafYOvi4ADZergqB03VoI/0C7J6fmL9YWlA=;
	h=Date:To:From:Subject:Message-Id; b=nDsdL/jyYR8TmajCrsBFpySQ9ZIMs5i0gUF+9idPlpXgZRkB+tsOdpfMfEnF2U/PX+ywmElpeL8MpqroWR1bVEdo095IqFqeEB3SsxfPFIWUgqB4XMMlLmkMvjZ/VhkWiNliVf3UBzEMFYifkG87Hx+uwKb7R9a0d5lAryM9reo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gb9tzId2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gb9tzId2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14CDC32781;
	Wed, 29 May 2024 19:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717010438;
	bh=V2bG0DhvpafYOvi4ADZergqB03VoI/0C7J6fmL9YWlA=;
	h=Date:To:From:Subject:From;
	b=gb9tzId27oHpwAZogKLikImQhtbn21O/STceKPYTMyzrerAn7TCNjkqFljTD4DT+R
	 VAD9/E5GIQQWha6GWrPzQOx7nDfTi/hN0z87u6Jp9UFfcpQWJPed1myznF0bqLmB6t
	 gOTLpGeR/t/1/qb+K679mvgwIBbGLzQ6dHFArYrw=
Date: Wed, 29 May 2024 12:20:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,rafael@kernel.org,pavel@ucw.cz,len.brown@intel.com,khalid.aziz@oracle.com,kasong@tencent.com,hughd@google.com,hch@infradead.org,hannes@cmpxchg.org,hanchuanhua@oppo.com,david@redhat.com,davem@davemloft.net,chrisl@kernel.org,baolin.wang@linux.alibaba.com,andreas@gaisler.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch added to mm-unstable branch
Message-Id: <20240529192037.E14CDC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove the implementation of swap_free() and always use swap_free_nr()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch

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
Subject: mm: remove the implementation of swap_free() and always use swap_free_nr()
Date: Wed, 29 May 2024 20:28:20 +1200

To streamline maintenance efforts, we propose removing the implementation
of swap_free().  Instead, we can simply invoke swap_free_nr() with nr set
to 1.  swap_free_nr() is designed with a bitmap consisting of only one
long, resulting in overhead that can be ignored for cases where nr equals
1.

A prime candidate for leveraging swap_free_nr() lies within
kernel/power/swap.c.  Implementing this change facilitates the adoption of
batch processing for hibernation.

Link: https://lkml.kernel.org/r/20240529082824.150954-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <len.brown@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   10 +++++-----
 kernel/power/swap.c  |    5 ++---
 mm/swapfile.c        |   17 ++++-------------
 3 files changed, 11 insertions(+), 21 deletions(-)

--- a/include/linux/swap.h~mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr
+++ a/include/linux/swap.h
@@ -477,7 +477,6 @@ extern int add_swap_count_continuation(s
 extern void swap_shmem_alloc(swp_entry_t);
 extern int swap_duplicate(swp_entry_t);
 extern int swapcache_prepare(swp_entry_t);
-extern void swap_free(swp_entry_t);
 extern void swap_free_nr(swp_entry_t entry, int nr_pages);
 extern void swapcache_free_entries(swp_entry_t *entries, int n);
 extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
@@ -556,10 +555,6 @@ static inline int swapcache_prepare(swp_
 	return 0;
 }
 
-static inline void swap_free(swp_entry_t swp)
-{
-}
-
 static inline void swap_free_nr(swp_entry_t entry, int nr_pages)
 {
 }
@@ -608,6 +603,11 @@ static inline void free_swap_and_cache(s
 	free_swap_and_cache_nr(entry, 1);
 }
 
+static inline void swap_free(swp_entry_t entry)
+{
+	swap_free_nr(entry, 1);
+}
+
 #ifdef CONFIG_MEMCG
 static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
--- a/kernel/power/swap.c~mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr
+++ a/kernel/power/swap.c
@@ -200,12 +200,11 @@ void free_all_swap_pages(int swap)
 
 	while ((node = swsusp_extents.rb_node)) {
 		struct swsusp_extent *ext;
-		unsigned long offset;
 
 		ext = rb_entry(node, struct swsusp_extent, node);
 		rb_erase(node, &swsusp_extents);
-		for (offset = ext->start; offset <= ext->end; offset++)
-			swap_free(swp_entry(swap, offset));
+		swap_free_nr(swp_entry(swap, ext->start),
+			     ext->end - ext->start + 1);
 
 		kfree(ext);
 	}
--- a/mm/swapfile.c~mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr
+++ a/mm/swapfile.c
@@ -1343,19 +1343,6 @@ static void swap_entry_free(struct swap_
 	swap_range_free(p, offset, 1);
 }
 
-/*
- * Caller has made sure that the swap device corresponding to entry
- * is still around or has not been recycled.
- */
-void swap_free(swp_entry_t entry)
-{
-	struct swap_info_struct *p;
-
-	p = _swap_info_get(entry);
-	if (p)
-		__swap_entry_free(p, entry);
-}
-
 static void cluster_swap_free_nr(struct swap_info_struct *sis,
 		unsigned long offset, int nr_pages)
 {
@@ -1385,6 +1372,10 @@ static void cluster_swap_free_nr(struct
 	unlock_cluster_or_swap_info(sis, ci);
 }
 
+/*
+ * Caller has made sure that the swap device corresponding to entry
+ * is still around or has not been recycled.
+ */
 void swap_free_nr(swp_entry_t entry, int nr_pages)
 {
 	int nr;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-huge_mm-fix-undefined-reference-to-mthp_stats-for-config_sysfs=n.patch
mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes.patch
mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch
mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally.patch
mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch

