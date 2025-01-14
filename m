Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D0E5695
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 00:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736813989; cv=none; b=fi5vR2nafv1OdhkQ+wodC6f3KS/imn7eoutUtcxmnCv90R5SRTvMjesON0KaYkq9tjbcJ5aeYVJXOZL+i3o3iy4tvsjOIA5P2DBS0xl3XhmePPGThl85Uv+k86tyl6y+1gXgF9uQynl5BjwvomqZk/4zYkcW7WzmzdXkuRrqVQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736813989; c=relaxed/simple;
	bh=dikEt49AxZFPDdNOnN4kvTD6aqSqWvNq8OaRz/O2wEw=;
	h=Date:To:From:Subject:Message-Id; b=BCdtrW+b6tm3PHDUkCWLarBLmFpXsqrA1bhbnW0RDEWE9KTivErN5i42mlCejM86WIsGSNVG1LIbFjGC+m1UZPHU4ztHOvm6YEGoBmlZWaiKIr/S7XwYiCc6C8tjnphwk2QycQYqIHZI5rJrwQUo0/+0cjywRIDlfj0f5bKqmfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E/r9RMJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E/r9RMJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831C1C4CED6;
	Tue, 14 Jan 2025 00:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736813988;
	bh=dikEt49AxZFPDdNOnN4kvTD6aqSqWvNq8OaRz/O2wEw=;
	h=Date:To:From:Subject:From;
	b=E/r9RMJYmPplIeUguuTBbN5lNV7jgNVha7WDLn9zaXfg1+7hrV76Kx+ls0ncPu/+q
	 vqcuknjewsKfuGkX6sBBz65E/krOUsvgEW9Mym34kApuefuR6Axr/XGdnCagFSQP69
	 0yp+LDOSP+aRVI2KzLS6CK2jRlbbU3xYJBNnc9Sg=
Date: Mon, 13 Jan 2025 16:19:47 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-hold-a-reference-during-scan-and-cleanup-flag-usage.patch added to mm-unstable branch
Message-Id: <20250114001948.831C1C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: hold a reference during scan and cleanup flag usage
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-hold-a-reference-during-scan-and-cleanup-flag-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-hold-a-reference-during-scan-and-cleanup-flag-usage.patch

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
Subject: mm, swap: hold a reference during scan and cleanup flag usage
Date: Tue, 14 Jan 2025 01:57:26 +0800

The flag SWP_SCANNING was used as an indicator of whether a device is
being scanned for allocation, and prevents swapoff.  Combined with
SWP_WRITEOK, they work as a set of barriers for a clean swapoff:

1. Swapoff clears SWP_WRITEOK, allocation requests will see
   ~SWP_WRITEOK and abort as it's serialized by si->lock.
2. Swapoff unuses all allocated entries.
3. Swapoff waits for SWP_SCANNING flag to be cleared, so ongoing
   allocations will stop, preventing UAF.
4. Now swapoff can free everything safely.

This will make the allocation path have a hard dependency on si->lock. 
Allocation always have to acquire si->lock first for setting SWP_SCANNING
and checking SWP_WRITEOK.

This commit removes this flag, and just uses the existing per-CPU refcount
instead to prevent UAF in step 3, which serves well for such usage without
dependency on si->lock, and scales very well too.  Just hold a reference
during the whole scan and allocation process.  Swapoff will kill and wait
for the counter.

And for preventing any allocation from happening after step 1 so the unuse
in step 2 can ensure all slots are free, swapoff will acquire the ci->lock
of each cluster one by one to ensure all allocations see ~SWP_WRITEOK and
abort.

This way these dependences on si->lock are gone.  And worth noting we
can't kill the refcount as the first step for swapoff as the unuse process
have to acquire the refcount.

Link: https://lkml.kernel.org/r/20250113175732.48099-8-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/swapfile.c        |   90 +++++++++++++++++++++++++----------------
 2 files changed, 57 insertions(+), 34 deletions(-)

--- a/include/linux/swap.h~mm-swap-hold-a-reference-during-scan-and-cleanup-flag-usage
+++ a/include/linux/swap.h
@@ -219,7 +219,6 @@ enum {
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
 					/* add others here before... */
-	SWP_SCANNING	= (1 << 14),	/* refcount in scan_swap_map */
 };
 
 #define SWAP_CLUSTER_MAX 32UL
--- a/mm/swapfile.c~mm-swap-hold-a-reference-during-scan-and-cleanup-flag-usage
+++ a/mm/swapfile.c
@@ -658,6 +658,8 @@ static bool cluster_alloc_range(struct s
 {
 	unsigned int nr_pages = 1 << order;
 
+	lockdep_assert_held(&ci->lock);
+
 	if (!(si->flags & SWP_WRITEOK))
 		return false;
 
@@ -1059,8 +1061,6 @@ static int cluster_alloc_swap(struct swa
 {
 	int n_ret = 0;
 
-	si->flags += SWP_SCANNING;
-
 	while (n_ret < nr) {
 		unsigned long offset = cluster_alloc_swap_entry(si, order, usage);
 
@@ -1069,8 +1069,6 @@ static int cluster_alloc_swap(struct swa
 		slots[n_ret++] = swp_entry(si->type, offset);
 	}
 
-	si->flags -= SWP_SCANNING;
-
 	return n_ret;
 }
 
@@ -1112,6 +1110,22 @@ static int scan_swap_map_slots(struct sw
 	return cluster_alloc_swap(si, usage, nr, slots, order);
 }
 
+static bool get_swap_device_info(struct swap_info_struct *si)
+{
+	if (!percpu_ref_tryget_live(&si->users))
+		return false;
+	/*
+	 * Guarantee the si->users are checked before accessing other
+	 * fields of swap_info_struct, and si->flags (SWP_WRITEOK) is
+	 * up to dated.
+	 *
+	 * Paired with the spin_unlock() after setup_swap_info() in
+	 * enable_swap_info(), and smp_wmb() in swapoff.
+	 */
+	smp_rmb();
+	return true;
+}
+
 int get_swap_pages(int n_goal, swp_entry_t swp_entries[], int entry_order)
 {
 	int order = swap_entry_order(entry_order);
@@ -1139,13 +1153,16 @@ start_over:
 		/* requeue si to after same-priority siblings */
 		plist_requeue(&si->avail_lists[node], &swap_avail_heads[node]);
 		spin_unlock(&swap_avail_lock);
-		spin_lock(&si->lock);
-		n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,
-					    n_goal, swp_entries, order);
-		spin_unlock(&si->lock);
-		if (n_ret || size > 1)
-			goto check_out;
-		cond_resched();
+		if (get_swap_device_info(si)) {
+			spin_lock(&si->lock);
+			n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,
+					n_goal, swp_entries, order);
+			spin_unlock(&si->lock);
+			put_swap_device(si);
+			if (n_ret || size > 1)
+				goto check_out;
+			cond_resched();
+		}
 
 		spin_lock(&swap_avail_lock);
 		/*
@@ -1296,16 +1313,8 @@ struct swap_info_struct *get_swap_device
 	si = swp_swap_info(entry);
 	if (!si)
 		goto bad_nofile;
-	if (!percpu_ref_tryget_live(&si->users))
+	if (!get_swap_device_info(si))
 		goto out;
-	/*
-	 * Guarantee the si->users are checked before accessing other
-	 * fields of swap_info_struct.
-	 *
-	 * Paired with the spin_unlock() after setup_swap_info() in
-	 * enable_swap_info().
-	 */
-	smp_rmb();
 	offset = swp_offset(entry);
 	if (offset >= si->max)
 		goto put_out;
@@ -1785,10 +1794,13 @@ swp_entry_t get_swap_page_of_type(int ty
 		goto fail;
 
 	/* This is called for allocating swap entry, not cache */
-	spin_lock(&si->lock);
-	if ((si->flags & SWP_WRITEOK) && scan_swap_map_slots(si, 1, 1, &entry, 0))
-		atomic_long_dec(&nr_swap_pages);
-	spin_unlock(&si->lock);
+	if (get_swap_device_info(si)) {
+		spin_lock(&si->lock);
+		if ((si->flags & SWP_WRITEOK) && scan_swap_map_slots(si, 1, 1, &entry, 0))
+			atomic_long_dec(&nr_swap_pages);
+		spin_unlock(&si->lock);
+		put_swap_device(si);
+	}
 fail:
 	return entry;
 }
@@ -2562,6 +2574,25 @@ bool has_usable_swap(void)
 	return ret;
 }
 
+/*
+ * Called after clearing SWP_WRITEOK, ensures cluster_alloc_range
+ * see the updated flags, so there will be no more allocations.
+ */
+static void wait_for_allocation(struct swap_info_struct *si)
+{
+	unsigned long offset;
+	unsigned long end = ALIGN(si->max, SWAPFILE_CLUSTER);
+	struct swap_cluster_info *ci;
+
+	BUG_ON(si->flags & SWP_WRITEOK);
+
+	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
+		ci = lock_cluster(si, offset);
+		unlock_cluster(ci);
+		offset += SWAPFILE_CLUSTER;
+	}
+}
+
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
@@ -2632,6 +2663,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 
+	wait_for_allocation(p);
+
 	disable_swap_slots_cache_lock();
 
 	set_current_oom_origin();
@@ -2674,15 +2707,6 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	spin_lock(&p->lock);
 	drain_mmlist();
 
-	/* wait for anyone still in scan_swap_map_slots */
-	while (p->flags >= SWP_SCANNING) {
-		spin_unlock(&p->lock);
-		spin_unlock(&swap_lock);
-		schedule_timeout_uninterruptible(1);
-		spin_lock(&swap_lock);
-		spin_lock(&p->lock);
-	}
-
 	swap_file = p->swap_file;
 	p->swap_file = NULL;
 	p->max = 0;
_

Patches currently in -mm which might be from kasong@tencent.com are

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

