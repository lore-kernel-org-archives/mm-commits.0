Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B479A35
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 00:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735604051; cv=none; b=fztn4hRXpoRZN6bVC8XIDf8zPYWab6ml68xSOZvr9MtveMxXvO9rqkr3rd5qIOBjfY6se/8qHvIiFHaeCGjhInBIsPGYNYOFsrRnTIBufglQmK1XGXrD2ApQGUFtikvNsEa7sj2zNDljfWDJ+Vrarj47FzNolJkuqGA+x/N4mzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735604051; c=relaxed/simple;
	bh=AyMLrNr73sq+p7YiPPkrMG0hYN/S/sRhhovCxxErLy8=;
	h=Date:To:From:Subject:Message-Id; b=tUsWCUPtvS27KtusIYBgRtpRiYvhZiCvMbjQZ7fwE4E+pKVTB4GM74YqIh8Aq0bOMF0owcxUGtCvFFz8l42ueaBlnoAGaBIpwWJE/RQRHohG4xbhSCG/bAV0zm5AAI7ercqJaZw4sXGRyqEMU+pTyGfPT2FD4kyc1tt9Lm4GJNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YYWr3WRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YYWr3WRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30678C4CED0;
	Tue, 31 Dec 2024 00:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735604051;
	bh=AyMLrNr73sq+p7YiPPkrMG0hYN/S/sRhhovCxxErLy8=;
	h=Date:To:From:Subject:From;
	b=YYWr3WRtNklni+CNFxrd1HVcg55iugxw6rl3WiMPRFvYsEqUXZ41qyr70GUEUYb4b
	 /eeaucCy+kvqTvuhH0xBcJucCufbF3bzbadIqCRcBdW/if2mZJfMBNgqmT2UBEntaJ
	 VdD5qies2C1sPiruAgqMru+p7xq1ftUwV8nAqVE8=
Date: Mon, 30 Dec 2024 16:14:10 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-a-global-swap-cluster-for-non-rotation-devices.patch added to mm-unstable branch
Message-Id: <20241231001411.30678C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: use a global swap cluster for non-rotation devices
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-use-a-global-swap-cluster-for-non-rotation-devices.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-a-global-swap-cluster-for-non-rotation-devices.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: use a global swap cluster for non-rotation devices
Date: Tue, 31 Dec 2024 01:46:20 +0800

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

Link: https://lkml.kernel.org/r/20241230174621.61185-13-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Suggested-by: Chris Li <chrisl@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +
 mm/swapfile.c        |   55 +++++++++++++++++++++++++++++------------
 2 files changed, 41 insertions(+), 16 deletions(-)

--- a/include/linux/swap.h~mm-swap-use-a-global-swap-cluster-for-non-rotation-devices
+++ a/include/linux/swap.h
@@ -318,6 +318,8 @@ struct swap_info_struct {
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
@@ -814,7 +814,10 @@ static unsigned int alloc_swap_scan_clus
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
 
@@ -875,9 +878,16 @@ static unsigned long cluster_alloc_swap_
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
@@ -972,8 +982,10 @@ new_cluster:
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
 
@@ -2778,6 +2790,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	mutex_unlock(&swapon_mutex);
 	free_percpu(p->percpu_cluster);
 	p->percpu_cluster = NULL;
+	kfree(p->global_cluster);
+	p->global_cluster = NULL;
 	vfree(swap_map);
 	kvfree(zeromap);
 	kvfree(cluster_info);
@@ -3183,17 +3197,24 @@ static struct swap_cluster_info *setup_c
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
+		si->global_cluster = kmalloc(sizeof(*si->global_cluster), GFP_KERNEL);
 		for (i = 0; i < SWAP_NR_ORDERS; i++)
-			cluster->next[i] = SWAP_ENTRY_INVALID;
-		local_lock_init(&cluster->lock);
+			si->global_cluster->next[i] = SWAP_ENTRY_INVALID;
+		spin_lock_init(&si->global_cluster_lock);
 	}
 
 	/*
@@ -3467,6 +3488,8 @@ bad_swap_unlock_inode:
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

mm-list_lru-fix-false-warning-of-negative-counter.patch
mm-madvise-fix-potential-workingset-node-list_lru-leaks.patch
mm-memcontrol-avoid-duplicated-memcg-enable-check.patch
mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch
mm-swap_cgroup-remove-global-swap-cgroup-lock.patch
mm-swap_cgroup-decouple-swap-cgroup-recording-and-clearing.patch
mm-swap-minor-clean-up-for-swap-entry-allocation.patch
mm-swap-fold-swap_info_get_cont-in-the-only-caller.patch
mm-swap-remove-old-allocation-path-for-hdd.patch
mm-swap-use-cluster-lock-for-hdd.patch
mm-swap-clean-up-device-availability-check.patch
mm-swap-clean-up-plist-removal-and-adding.patch
mm-swap-hold-a-reference-during-scan-and-cleanup-flag-usage.patch
mm-swap-use-an-enum-to-define-all-cluster-flags-and-wrap-flags-changes.patch
mm-swap-reduce-contention-on-device-lock.patch
mm-swap-simplify-percpu-cluster-updating.patch
mm-swap-introduce-a-helper-for-retrieving-cluster-from-offset.patch
mm-swap-use-a-global-swap-cluster-for-non-rotation-devices.patch
mm-swap_slots-remove-slot-cache-for-freeing-path.patch

