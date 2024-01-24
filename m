Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C551818AF8
	for <mm-commits@vger.kernel.org>; Wed, 24 Jan 2024 10:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091413; cv=none; b=UJ/eIPtZdTnQ1VpW8sQ9RboDbQHKKHpNfRLm5DLvaJqk1Piu8AhGAjYtSzcvObOj0VK6H0pyP0umjBhutBUzcFsgvevCd74pUDq77CwRH/WSHxTyQGTzb2lKEFzMYm1a9D4YixI/V9c3RJj7CyMtnD8PqXbs/mIQH4lNJma7Wyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091413; c=relaxed/simple;
	bh=jkWeQqvKZXMKFMzZsU/cUHUu3e9dwM5x9yn4nR433wU=;
	h=Date:To:From:Subject:Message-Id; b=ZRKzXWAFa29jzCEG8P5rmRNwzk4GKVih3LjN2nJ6udpJeqxjuesb/nBNY1ocuvdllypogVTi2i00cB/JcDFBtdY7/mzEo+t8YQ4wyFXEm1caI8L4PJOTIx2n9xWwb222CUApM2awyf12Y97TCX6lAvbFnngFEAdRkihDvN5VmbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=onmvEQMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="onmvEQMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0750C433C7;
	Wed, 24 Jan 2024 10:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091413;
	bh=jkWeQqvKZXMKFMzZsU/cUHUu3e9dwM5x9yn4nR433wU=;
	h=Date:To:From:Subject:From;
	b=onmvEQMgMQLPIf8Fv4lHRVNyP6JkMDNLLpuMsejoJ39Vr+iMEVJeavbESzFOY6d7a
	 yCFm+wVOqskrXMRe3FnOMypuOTyK5+R0hxK85RuiNYfIvHn2uIOscoG5rN9/H4qX00
	 BkEFK3CQ5sDQxqz/dRYDtfUoNDrmj4pWCJiHrisw=
Date: Wed, 24 Jan 2024 02:16:50 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chriscli@google.com,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch added to mm-unstable branch
Message-Id: <20240124101652.F0750C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: make sure each swapfile always have zswap rb-tree
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch

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
 mm/zswap.c            |    7 ++++---
 3 files changed, 16 insertions(+), 8 deletions(-)

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
@@ -1519,7 +1519,7 @@ bool zswap_store(struct folio *folio)
 	if (folio_test_large(folio))
 		return false;
 
-	if (!zswap_enabled || !tree)
+	if (!zswap_enabled)
 		return false;
 
 	/*
@@ -1772,19 +1772,20 @@ void zswap_invalidate(int type, pgoff_t
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

mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch
mm-zswap-split-zswap-rb-tree.patch

