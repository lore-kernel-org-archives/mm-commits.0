Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A7416DED2
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006263; cv=none; b=HxOhCF3GA9YYOt+F61VTIGnGfThcF8NEPE2XZkVaLLK+x1Kc9G0v6hfaKjmUVXE0kIovUp0QKQyH+nZ38FSou2pOCaLBscTmy5PcgInVX2h0lRhUsR3eiq+xhypnRbRMEdAQ2AT9/GZL7OUuu9abjfDkwm8nNfHTO2W+RrT0ANQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006263; c=relaxed/simple;
	bh=3zmuh3QUCsrjnhvvhCCmNBMOpPXBJi+roK57sEjCmAM=;
	h=Date:To:From:Subject:Message-Id; b=LuxP/1MIXmloX8G59Rw79ew9kHnDcUwHrolDWBhlJhf4UWvt43yT5+qrh2QcHdXY3/CKf82KbEuGRJkbYZGJ/LC1U5Tu7X5zd3w3YiWtG93R45Vbut4+gZcLae4xYttvAxFtjDdkAoqskH2AkYjHc12U67V01IULtZVkIQ8iboc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2agfHQPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2agfHQPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80CFC4CED6;
	Thu, 16 Jan 2025 05:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006262;
	bh=3zmuh3QUCsrjnhvvhCCmNBMOpPXBJi+roK57sEjCmAM=;
	h=Date:To:From:Subject:From;
	b=2agfHQPwE/HrkXm6IVp6PKS9PS/ijALrhYm4enhfIjaPXkCPrF1pCa9d22ATk+w2b
	 pGgPBR0CjpJ7hrmJtwYpqGZThPtredqKdOIQnQPK6qZtz9hGfzAcpKblNzqiomh7QQ
	 qfv2R4I8ztDbOGHu8RW36ufmFeQUu6ZgduNuIrho=
Date: Wed, 15 Jan 2025 21:44:22 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-use-a-global-swap-cluster-for-non-rotation-devices.patch removed from -mm tree
Message-Id: <20250116054422.C80CFC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: use a global swap cluster for non-rotation devices
has been removed from the -mm tree.  Its filename was
     mm-swap-use-a-global-swap-cluster-for-non-rotation-devices.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: use a global swap cluster for non-rotation devices
Date: Tue, 14 Jan 2025 01:57:31 +0800

Non-rotational devices (SSD / ZRAM) can tolerate fragmentation, so the
goal of the SWAP allocator is to avoid contention for clusters.  It uses a
per-CPU cluster design, and each CPU will use a different cluster as much
as possible.

However, HDDs are very sensitive to fragmentation, contention is trivial
in comparison.  Therefore, we use one global cluster instead.  This
ensures that each order will be written to the same cluster as much as
possible, which helps make the I/O more continuous.

This ensures that the performance of the cluster allocator is as good as
that of the old allocator.  Tests after this commit compared to those
before this series:

Tested using 'make -j32' with tinyconfig, a 1G memcg limit, and HDD swap:

make -j32 with tinyconfig, using 1G memcg limit and HDD swap:

Before this series:
114.44user 29.11system 39:42.90elapsed 6%CPU (0avgtext+0avgdata 157284maxresident)k
2901232inputs+0outputs (238877major+4227640minor)pagefaults

After this commit:
113.90user 23.81system 38:11.77elapsed 6%CPU (0avgtext+0avgdata 157260maxresident)k
2548728inputs+0outputs (235471major+4238110minor)pagefaults

[ryncsn@gmail.com: check kmalloc() return in setup_clusters]
  Link: https://lkml.kernel.org/r/CAMgjq7Au+o04ckHyT=iU-wVx9az=t0B-ZiC5E0bDqNrAtNOP-g@mail.gmail.com
Link: https://lkml.kernel.org/r/20250113175732.48099-13-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Suggested-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +
 mm/swapfile.c        |   58 +++++++++++++++++++++++++++++------------
 2 files changed, 44 insertions(+), 16 deletions(-)

--- a/include/linux/swap.h~mm-swap-use-a-global-swap-cluster-for-non-rotation-devices
+++ a/include/linux/swap.h
@@ -317,6 +317,8 @@ struct swap_info_struct {
 	unsigned int pages;		/* total of usable pages of swap */
 	atomic_long_t inuse_pages;	/* number of those currently in use */
 	struct percpu_cluster __percpu *percpu_cluster; /* per cpu's swap location */
+	struct percpu_cluster *global_cluster; /* Use one global cluster for rotating device */
+	spinlock_t global_cluster_lock;	/* Serialize usage of global cluster */
 	struct rb_root swap_extent_root;/* root of the swap extent rbtree */
 	struct block_device *bdev;	/* swap device or bdev of swap file */
 	struct file *swap_file;		/* seldom referenced */
--- a/mm/swapfile.c~mm-swap-use-a-global-swap-cluster-for-non-rotation-devices
+++ a/mm/swapfile.c
@@ -820,7 +820,10 @@ static unsigned int alloc_swap_scan_clus
 out:
 	relocate_cluster(si, ci);
 	unlock_cluster(ci);
-	__this_cpu_write(si->percpu_cluster->next[order], next);
+	if (si->flags & SWP_SOLIDSTATE)
+		__this_cpu_write(si->percpu_cluster->next[order], next);
+	else
+		si->global_cluster->next[order] = next;
 	return found;
 }
 
@@ -881,9 +884,16 @@ static unsigned long cluster_alloc_swap_
 	struct swap_cluster_info *ci;
 	unsigned int offset, found = 0;
 
-	/* Fast path using per CPU cluster */
-	local_lock(&si->percpu_cluster->lock);
-	offset = __this_cpu_read(si->percpu_cluster->next[order]);
+	if (si->flags & SWP_SOLIDSTATE) {
+		/* Fast path using per CPU cluster */
+		local_lock(&si->percpu_cluster->lock);
+		offset = __this_cpu_read(si->percpu_cluster->next[order]);
+	} else {
+		/* Serialize HDD SWAP allocation for each device. */
+		spin_lock(&si->global_cluster_lock);
+		offset = si->global_cluster->next[order];
+	}
+
 	if (offset) {
 		ci = lock_cluster(si, offset);
 		/* Cluster could have been used by another order */
@@ -975,8 +985,10 @@ new_cluster:
 		}
 	}
 done:
-	local_unlock(&si->percpu_cluster->lock);
-
+	if (si->flags & SWP_SOLIDSTATE)
+		local_unlock(&si->percpu_cluster->lock);
+	else
+		spin_unlock(&si->global_cluster_lock);
 	return found;
 }
 
@@ -2784,6 +2796,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	mutex_unlock(&swapon_mutex);
 	free_percpu(p->percpu_cluster);
 	p->percpu_cluster = NULL;
+	kfree(p->global_cluster);
+	p->global_cluster = NULL;
 	vfree(swap_map);
 	kvfree(zeromap);
 	kvfree(cluster_info);
@@ -3189,17 +3203,27 @@ static struct swap_cluster_info *setup_c
 	for (i = 0; i < nr_clusters; i++)
 		spin_lock_init(&cluster_info[i].lock);
 
-	si->percpu_cluster = alloc_percpu(struct percpu_cluster);
-	if (!si->percpu_cluster)
-		goto err_free;
-
-	for_each_possible_cpu(cpu) {
-		struct percpu_cluster *cluster;
-
-		cluster = per_cpu_ptr(si->percpu_cluster, cpu);
+	if (si->flags & SWP_SOLIDSTATE) {
+		si->percpu_cluster = alloc_percpu(struct percpu_cluster);
+		if (!si->percpu_cluster)
+			goto err_free;
+
+		for_each_possible_cpu(cpu) {
+			struct percpu_cluster *cluster;
+
+			cluster = per_cpu_ptr(si->percpu_cluster, cpu);
+			for (i = 0; i < SWAP_NR_ORDERS; i++)
+				cluster->next[i] = SWAP_ENTRY_INVALID;
+			local_lock_init(&cluster->lock);
+		}
+	} else {
+		si->global_cluster = kmalloc(sizeof(*si->global_cluster),
+				     GFP_KERNEL);
+		if (!si->global_cluster)
+			goto err_free;
 		for (i = 0; i < SWAP_NR_ORDERS; i++)
-			cluster->next[i] = SWAP_ENTRY_INVALID;
-		local_lock_init(&cluster->lock);
+			si->global_cluster->next[i] = SWAP_ENTRY_INVALID;
+		spin_lock_init(&si->global_cluster_lock);
 	}
 
 	/*
@@ -3473,6 +3497,8 @@ bad_swap_unlock_inode:
 bad_swap:
 	free_percpu(si->percpu_cluster);
 	si->percpu_cluster = NULL;
+	kfree(si->global_cluster);
+	si->global_cluster = NULL;
 	inode = NULL;
 	destroy_swap_extents(si);
 	swap_cgroup_swapoff(si->type);
_

Patches currently in -mm which might be from kasong@tencent.com are


