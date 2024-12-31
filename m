Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880867FD
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 00:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735604032; cv=none; b=mvh7LdHZwaBFDxJo6xMiR3166RKKslA0sTufwQgz2uBD6DTvE0NYVo6LTUzUTdRTLbE4HLx9fSuBXJBnKS+R/tUSLoCboZAsKfDFi7AvD8m2PdnBIt+MDw0yUTk2uOmWz7+JdVG4jmbjAA6QAhI+uz8DjBuqdoSGhswB0zJnzfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735604032; c=relaxed/simple;
	bh=QHiJ8v43eZ8V5RRlRTMKo0YRPo3qQRJjZJNprIjphuI=;
	h=Date:To:From:Subject:Message-Id; b=jDcSqnsvj9i+Hzs4nx5fZaSfSUzoiV5yOqYDcgRWvWveYARv7d6txn1F5Z99hUSPsv8p+0IuHF+P1MzJZKeObeZrvCprFQ+ZQ8owVnT9B4AzUhgQzu1Eb4JSIShWsrp60kbeczzWfcQW2hGrj8v8w3cGYtWURsRduZIROKZUR0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SQoSyNDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SQoSyNDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116E6C4CED0;
	Tue, 31 Dec 2024 00:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735604032;
	bh=QHiJ8v43eZ8V5RRlRTMKo0YRPo3qQRJjZJNprIjphuI=;
	h=Date:To:From:Subject:From;
	b=SQoSyNDGPeHj6cwIuXrcVr1sqKAnokz2FpRhX1d1CJYqNXqzHvvZYfS+3LRmMmXAg
	 08zmq6I7F62JJZteVgVziaabUu/QpaGvcob/qzI/eaGHJQ5BYS3svfPk40aAtJy+uc
	 pUapPR1xay7Wu2hiaxXbe0OJVb30qUtkrB5451Yw=
Date: Mon, 30 Dec 2024 16:13:51 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-clean-up-device-availability-check.patch added to mm-unstable branch
Message-Id: <20241231001352.116E6C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: clean up device availability check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-clean-up-device-availability-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-clean-up-device-availability-check.patch

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
Subject: mm, swap: clean up device availability check
Date: Tue, 31 Dec 2024 01:46:13 +0800

Remove highest_bit and lowest_bit.  After the HDD allocation path has been
removed, the only purpose of these two fields is to determine whether the
device is full or not, which can instead be determined by checking the
inuse_pages.

Link: https://lkml.kernel.org/r/20241230174621.61185-6-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/inode.c     |    1 -
 fs/f2fs/data.c       |    1 -
 fs/iomap/swapfile.c  |    1 -
 include/linux/swap.h |    2 --
 mm/page_io.c         |    1 -
 mm/swapfile.c        |   38 ++++++++------------------------------
 6 files changed, 8 insertions(+), 36 deletions(-)

--- a/fs/btrfs/inode.c~mm-swap-clean-up-device-availability-check
+++ a/fs/btrfs/inode.c
@@ -10044,7 +10044,6 @@ out:
 	*span = bsi.highest_ppage - bsi.lowest_ppage + 1;
 	sis->max = bsi.nr_pages;
 	sis->pages = bsi.nr_pages - 1;
-	sis->highest_bit = bsi.nr_pages - 1;
 	return bsi.nr_extents;
 }
 #else
--- a/fs/f2fs/data.c~mm-swap-clean-up-device-availability-check
+++ a/fs/f2fs/data.c
@@ -4043,7 +4043,6 @@ retry:
 		cur_lblock = 1;	/* force Empty message */
 	sis->max = cur_lblock;
 	sis->pages = cur_lblock - 1;
-	sis->highest_bit = cur_lblock - 1;
 out:
 	if (not_aligned)
 		f2fs_warn(sbi, "Swapfile (%u) is not align to section: 1) creat(), 2) ioctl(F2FS_IOC_SET_PIN_FILE), 3) fallocate(%lu * N)",
--- a/fs/iomap/swapfile.c~mm-swap-clean-up-device-availability-check
+++ a/fs/iomap/swapfile.c
@@ -189,7 +189,6 @@ int iomap_swapfile_activate(struct swap_
 	*pagespan = 1 + isi.highest_ppage - isi.lowest_ppage;
 	sis->max = isi.nr_pages;
 	sis->pages = isi.nr_pages - 1;
-	sis->highest_bit = isi.nr_pages - 1;
 	return isi.nr_extents;
 }
 EXPORT_SYMBOL_GPL(iomap_swapfile_activate);
--- a/include/linux/swap.h~mm-swap-clean-up-device-availability-check
+++ a/include/linux/swap.h
@@ -306,8 +306,6 @@ struct swap_info_struct {
 	struct list_head frag_clusters[SWAP_NR_ORDERS];
 					/* list of cluster that are fragmented or contented */
 	unsigned int frag_cluster_nr[SWAP_NR_ORDERS];
-	unsigned int lowest_bit;	/* index of first free in swap_map */
-	unsigned int highest_bit;	/* index of last free in swap_map */
 	unsigned int pages;		/* total of usable pages of swap */
 	unsigned int inuse_pages;	/* number of those currently in use */
 	struct percpu_cluster __percpu *percpu_cluster; /* per cpu's swap location */
--- a/mm/page_io.c~mm-swap-clean-up-device-availability-check
+++ a/mm/page_io.c
@@ -163,7 +163,6 @@ reprobe:
 		page_no = 1;	/* force Empty message */
 	sis->max = page_no;
 	sis->pages = page_no - 1;
-	sis->highest_bit = page_no - 1;
 out:
 	return ret;
 bad_bmap:
--- a/mm/swapfile.c~mm-swap-clean-up-device-availability-check
+++ a/mm/swapfile.c
@@ -55,7 +55,7 @@ static bool swap_count_continued(struct
 static void free_swap_count_continuations(struct swap_info_struct *);
 static void swap_entry_range_free(struct swap_info_struct *si, swp_entry_t entry,
 				  unsigned int nr_pages);
-static void swap_range_alloc(struct swap_info_struct *si, unsigned long offset,
+static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static bool folio_swapcache_freeable(struct folio *folio);
 static struct swap_cluster_info *lock_cluster(struct swap_info_struct *si,
@@ -650,7 +650,7 @@ static bool cluster_alloc_range(struct s
 	}
 
 	memset(si->swap_map + start, usage, nr_pages);
-	swap_range_alloc(si, start, nr_pages);
+	swap_range_alloc(si, nr_pages);
 	ci->count += nr_pages;
 
 	if (ci->count == SWAPFILE_CLUSTER) {
@@ -888,19 +888,11 @@ static void del_from_avail_list(struct s
 	spin_unlock(&swap_avail_lock);
 }
 
-static void swap_range_alloc(struct swap_info_struct *si, unsigned long offset,
+static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries)
 {
-	unsigned int end = offset + nr_entries - 1;
-
-	if (offset == si->lowest_bit)
-		si->lowest_bit += nr_entries;
-	if (end == si->highest_bit)
-		WRITE_ONCE(si->highest_bit, si->highest_bit - nr_entries);
 	WRITE_ONCE(si->inuse_pages, si->inuse_pages + nr_entries);
 	if (si->inuse_pages == si->pages) {
-		si->lowest_bit = si->max;
-		si->highest_bit = 0;
 		del_from_avail_list(si);
 
 		if (si->cluster_info && vm_swap_full())
@@ -933,15 +925,8 @@ static void swap_range_free(struct swap_
 	for (i = 0; i < nr_entries; i++)
 		clear_bit(offset + i, si->zeromap);
 
-	if (offset < si->lowest_bit)
-		si->lowest_bit = offset;
-	if (end > si->highest_bit) {
-		bool was_full = !si->highest_bit;
-
-		WRITE_ONCE(si->highest_bit, end);
-		if (was_full && (si->flags & SWP_WRITEOK))
-			add_to_avail_list(si);
-	}
+	if (si->inuse_pages == si->pages)
+		add_to_avail_list(si);
 	if (si->flags & SWP_BLKDEV)
 		swap_slot_free_notify =
 			si->bdev->bd_disk->fops->swap_slot_free_notify;
@@ -1051,15 +1036,12 @@ start_over:
 		plist_requeue(&si->avail_lists[node], &swap_avail_heads[node]);
 		spin_unlock(&swap_avail_lock);
 		spin_lock(&si->lock);
-		if (!si->highest_bit || !(si->flags & SWP_WRITEOK)) {
+		if ((si->inuse_pages == si->pages) || !(si->flags & SWP_WRITEOK)) {
 			spin_lock(&swap_avail_lock);
 			if (plist_node_empty(&si->avail_lists[node])) {
 				spin_unlock(&si->lock);
 				goto nextsi;
 			}
-			WARN(!si->highest_bit,
-			     "swap_info %d in list but !highest_bit\n",
-			     si->type);
 			WARN(!(si->flags & SWP_WRITEOK),
 			     "swap_info %d in list but !SWP_WRITEOK\n",
 			     si->type);
@@ -2441,8 +2423,8 @@ static void _enable_swap_info(struct swa
 	 */
 	plist_add(&si->list, &swap_active_head);
 
-	/* add to available list iff swap device is not full */
-	if (si->highest_bit)
+	/* add to available list if swap device is not full */
+	if (si->inuse_pages < si->pages)
 		add_to_avail_list(si);
 }
 
@@ -2606,7 +2588,6 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	drain_mmlist();
 
 	/* wait for anyone still in scan_swap_map_slots */
-	p->highest_bit = 0;		/* cuts scans short */
 	while (p->flags >= SWP_SCANNING) {
 		spin_unlock(&p->lock);
 		spin_unlock(&swap_lock);
@@ -2941,8 +2922,6 @@ static unsigned long read_swap_header(st
 		return 0;
 	}
 
-	si->lowest_bit  = 1;
-
 	maxpages = swapfile_maximum_size;
 	last_page = swap_header->info.last_page;
 	if (!last_page) {
@@ -2959,7 +2938,6 @@ static unsigned long read_swap_header(st
 		if ((unsigned int)maxpages == 0)
 			maxpages = UINT_MAX;
 	}
-	si->highest_bit = maxpages - 1;
 
 	if (!maxpages)
 		return 0;
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

