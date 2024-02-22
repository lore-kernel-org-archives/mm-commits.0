Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BE028E3
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560094; cv=none; b=qwptk7h15fYy4ZxdVSM3CdRFHaYq6nC5Wsul7ZjsRgZsGpAIO8OIbz6V18IR8nG4CGlbjslgNDiDYfCOXbKYJE13lSNJuVdSRfuVvEGRyre/yc1Ve1I/1xTU3QJ84XFJMZIx/atRd3fjA8f9pGZ+FyAcpKO6LvpdBa8UbE+4sPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560094; c=relaxed/simple;
	bh=zY6mqCICOkuy1g3VCVwv6yp73jFqavhfZL7pnO8olTU=;
	h=Date:To:From:Subject:Message-Id; b=FlcUqJioGXIO/NYM93LxESmY7D3SYylZvk3PdMD0AsNi/xZdFaaKoSH5kPqsyPbSJlcayNjyTYe58dY2j7bWmPMZ66gCf5L03mvP3FwaO7EgQnGjIlwg6dcm8Kf4bg8+b8eDQJLkHTTE8vntIq+oy//psRrirCH088/vXJn4L7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fKm2PqwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fKm2PqwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86ACC43390;
	Thu, 22 Feb 2024 00:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560093;
	bh=zY6mqCICOkuy1g3VCVwv6yp73jFqavhfZL7pnO8olTU=;
	h=Date:To:From:Subject:From;
	b=fKm2PqwWUWx8HI5YudqUUnzMjrCg01YAunZIUvmMy5ylv7+H98n/RqSIjVD6ToFC4
	 XoTvAPbZJIRcNiO++7HKg1m3AN/T4oitnoAkkvsVgUoeXiDmY4gp/pkt+knj1FFNHR
	 y8HB5l/zvhGpiCzmn4kSjkGrSRFOtLy64hNTnmSs=
Date: Wed, 21 Feb 2024 16:01:33 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chriscli@google.com,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch removed from -mm tree
Message-Id: <20240222000133.B86ACC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: make sure each swapfile always have zswap rb-tree
has been removed from the -mm tree.  Its filename was
     mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: make sure each swapfile always have zswap rb-tree
Date: Fri, 19 Jan 2024 11:22:22 +0000

Patch series "mm/zswap: optimize the scalability of zswap rb-tree", v2.

When testing the zswap performance by using kernel build -j32 in a tmpfs
directory, I found the scalability of zswap rb-tree is not good, which is
protected by the only spinlock.  That would cause heavy lock contention if
multiple tasks zswap_store/load concurrently.

So a simple solution is to split the only one zswap rb-tree into multiple
rb-trees, each corresponds to SWAP_ADDRESS_SPACE_PAGES (64M).  This idea
is from the commit 4b3ef9daa4fc ("mm/swap: split swap cache into 64MB
trunks").

Although this method can't solve the spinlock contention completely, it
can mitigate much of that contention.  Below is the results of kernel
build in tmpfs with zswap shrinker enabled:

     linux-next  zswap-lock-optimize
real 1m9.181s    1m3.820s
user 17m44.036s  17m40.100s
sys  7m37.297s   4m54.622s

So there are clearly improvements.  And it's complementary with the
ongoing zswap xarray conversion by Chris.  Anyway, I think we can also
merge this first, it's complementary IMHO.  So I just refresh and resend
this for further discussion.


This patch (of 2):

Not all zswap interfaces can handle the absence of the zswap rb-tree,
actually only zswap_store() has handled it for now.

To make things simple, we make sure each swapfile always have the zswap
rb-tree prepared before being enabled and used.  The preparation is
unlikely to fail in practice, this patch just make it explicit.

Link: https://lkml.kernel.org/r/20240117-b4-zswap-lock-optimize-v2-0-b5cc55479090@bytedance.com
Link: https://lkml.kernel.org/r/20240117-b4-zswap-lock-optimize-v2-1-b5cc55479090@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chris Li <chriscli@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zswap.h |    7 +++++--
 mm/swapfile.c         |   10 +++++++---
 mm/zswap.c            |    8 +++-----
 3 files changed, 15 insertions(+), 10 deletions(-)

--- a/include/linux/zswap.h~mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree
+++ a/include/linux/zswap.h
@@ -30,7 +30,7 @@ struct zswap_lruvec_state {
 bool zswap_store(struct folio *folio);
 bool zswap_load(struct folio *folio);
 void zswap_invalidate(int type, pgoff_t offset);
-void zswap_swapon(int type);
+int zswap_swapon(int type);
 void zswap_swapoff(int type);
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
 void zswap_lruvec_state_init(struct lruvec *lruvec);
@@ -51,7 +51,10 @@ static inline bool zswap_load(struct fol
 }
 
 static inline void zswap_invalidate(int type, pgoff_t offset) {}
-static inline void zswap_swapon(int type) {}
+static inline int zswap_swapon(int type)
+{
+	return 0;
+}
 static inline void zswap_swapoff(int type) {}
 static inline void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg) {}
 static inline void zswap_lruvec_state_init(struct lruvec *lruvec) {}
--- a/mm/swapfile.c~mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree
+++ a/mm/swapfile.c
@@ -2348,8 +2348,6 @@ static void enable_swap_info(struct swap
 				unsigned char *swap_map,
 				struct swap_cluster_info *cluster_info)
 {
-	zswap_swapon(p->type);
-
 	spin_lock(&swap_lock);
 	spin_lock(&p->lock);
 	setup_swap_info(p, prio, swap_map, cluster_info);
@@ -3167,6 +3165,10 @@ SYSCALL_DEFINE2(swapon, const char __use
 	if (error)
 		goto bad_swap_unlock_inode;
 
+	error = zswap_swapon(p->type);
+	if (error)
+		goto free_swap_address_space;
+
 	/*
 	 * Flush any pending IO and dirty mappings before we start using this
 	 * swap device.
@@ -3175,7 +3177,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	error = inode_drain_writes(inode);
 	if (error) {
 		inode->i_flags &= ~S_SWAPFILE;
-		goto free_swap_address_space;
+		goto free_swap_zswap;
 	}
 
 	mutex_lock(&swapon_mutex);
@@ -3199,6 +3201,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	error = 0;
 	goto out;
+free_swap_zswap:
+	zswap_swapoff(p->type);
 free_swap_address_space:
 	exit_swap_address_space(p->type);
 bad_swap_unlock_inode:
--- a/mm/zswap.c~mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree
+++ a/mm/zswap.c
@@ -1518,9 +1518,6 @@ bool zswap_store(struct folio *folio)
 	if (folio_test_large(folio))
 		return false;
 
-	if (!tree)
-		return false;
-
 	/*
 	 * If this is a duplicate, it must be removed before attempting to store
 	 * it, otherwise, if the store fails the old page won't be removed from
@@ -1775,19 +1772,20 @@ void zswap_invalidate(int type, pgoff_t
 	spin_unlock(&tree->lock);
 }
 
-void zswap_swapon(int type)
+int zswap_swapon(int type)
 {
 	struct zswap_tree *tree;
 
 	tree = kzalloc(sizeof(*tree), GFP_KERNEL);
 	if (!tree) {
 		pr_err("alloc failed, zswap disabled for swap type %d\n", type);
-		return;
+		return -ENOMEM;
 	}
 
 	tree->rbroot = RB_ROOT;
 	spin_lock_init(&tree->lock);
 	zswap_trees[type] = tree;
+	return 0;
 }
 
 void zswap_swapoff(int type)
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch
mm-zsmalloc-remove-migrate_write_lock_nested.patch
mm-zsmalloc-remove-unused-zspage-isolated.patch
mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch
mm-zsmalloc-remove-set_zspage_mapping.patch
mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch
mm-zsmalloc-remove-get_zspage_mapping.patch
maintainers-add-chengming-zhou-as-a-zswap-reviewer.patch

