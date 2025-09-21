Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3424021D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489949; cv=none; b=I0iSryYzNZO7FxmUdQAEGMLyo+bzMXZcPzzzKACRLi51KGkTNMEoGQAMWHvPQ/ISV1O/GftEHqB4869EIG334F0qwPrOwZaGPk6h7rVaj8NQX0fR33PLAk9j/q7+6wsavczsuQs1JLv/09/qXTuiWhSuUcgdyUPsb3SKThg8Edo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489949; c=relaxed/simple;
	bh=Dg9bkhkXkqE6EqUdSIQwfcFLQ9rWAQZuNMcopbBHIBM=;
	h=Date:To:From:Subject:Message-Id; b=sErrJmjYpvjd1siZYlMK0ZvpKlUPvgnWT4fbecMDeGnzGUWumNwSzB3P2jcjtVlHILaBvdpFEmzUiSRGZWXH/IBcVUFUzDXP2C1UkfLJBtZfKfoDCP5HDOfEDVNd+RH7NhSjcVzTsEqA39BQyfVaaosPlXvH/dNJOzc8FWZNLpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cvrl1Tky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cvrl1Tky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BB4C4CEE7;
	Sun, 21 Sep 2025 21:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489949;
	bh=Dg9bkhkXkqE6EqUdSIQwfcFLQ9rWAQZuNMcopbBHIBM=;
	h=Date:To:From:Subject:From;
	b=Cvrl1TkyGx/Uq9twVoxB6Kha9yLHNJzLxIPxW9+0hKks1hEhcNl30v5+yTeSMFAAW
	 Esq2tFLAAeHdKMZ78ge3wUzdFsQoMNSRxLC51rYCGFeYKvIKCSfcSYnQ/zc5JmJI0G
	 0fgCR8K0cPglaVum50tm9ViVKK9oenGO5Gj+YNLM=
Date: Sun, 21 Sep 2025 14:25:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,sj@kernel.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-mark-swap-address-space-ro-and-add-context-debug-check.patch removed from -mm tree
Message-Id: <20250921212549.08BB4C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: mark swap address space ro and add context debug check
has been removed from the -mm tree.  Its filename was
     mm-swap-mark-swap-address-space-ro-and-add-context-debug-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: mark swap address space ro and add context debug check
Date: Wed, 17 Sep 2025 00:00:57 +0800

Swap cache is now backed by swap table, and the address space is not
holding any mutable data anymore.  And swap cache is now protected by the
swap cluster lock, instead of the XArray lock.  All access to swap cache
are wrapped by swap cache helpers.  Locking is mostly handled internally
by swap cache helpers, only a few __swap_cache_* helpers require the
caller to lock the cluster by themselves.

Worth noting that, unlike XArray, the cluster lock is not IRQ safe.  The
swap cache was very different compared to filemap, and now it's completely
separated from filemap.  Nothing wants to mark or change anything or do a
writeback callback in IRQ.

So explicitly document this and add a debug check to avoid further
potential misuse.  And mark the swap cache space as read-only to avoid any
user wrongly mixing unexpected filemap helpers with swap cache.

Link: https://lkml.kernel.org/r/20250916160100.31545-13-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: Chris Li <chrisl@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h       |   12 +++++++++++-
 mm/swap_state.c |    3 ++-
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/mm/swap.h~mm-swap-mark-swap-address-space-ro-and-add-context-debug-check
+++ a/mm/swap.h
@@ -99,6 +99,16 @@ static __always_inline struct swap_clust
 {
 	struct swap_cluster_info *ci = __swap_offset_to_cluster(si, offset);
 
+	/*
+	 * Nothing modifies swap cache in an IRQ context. All access to
+	 * swap cache is wrapped by swap_cache_* helpers, and swap cache
+	 * writeback is handled outside of IRQs. Swapin or swapout never
+	 * occurs in IRQ, and neither does in-place split or replace.
+	 *
+	 * Besides, modifying swap cache requires synchronization with
+	 * swap_map, which was never IRQ safe.
+	 */
+	VM_WARN_ON_ONCE(!in_task());
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
 	if (irq)
 		spin_lock_irq(&ci->lock);
@@ -192,7 +202,7 @@ void __swap_writepage(struct folio *foli
 #define SWAP_ADDRESS_SPACE_SHIFT	14
 #define SWAP_ADDRESS_SPACE_PAGES	(1 << SWAP_ADDRESS_SPACE_SHIFT)
 #define SWAP_ADDRESS_SPACE_MASK		(SWAP_ADDRESS_SPACE_PAGES - 1)
-extern struct address_space swap_space;
+extern struct address_space swap_space __ro_after_init;
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
 	return &swap_space;
--- a/mm/swap_state.c~mm-swap-mark-swap-address-space-ro-and-add-context-debug-check
+++ a/mm/swap_state.c
@@ -37,7 +37,8 @@ static const struct address_space_operat
 #endif
 };
 
-struct address_space swap_space __read_mostly = {
+/* Set swap_space as read only as swap cache is handled by swap table */
+struct address_space swap_space __ro_after_init = {
 	.a_ops = &swap_aops,
 };
 
_

Patches currently in -mm which might be from kasong@tencent.com are


