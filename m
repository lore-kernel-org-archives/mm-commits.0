Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A842E65D
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 00:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771547790; cv=none; b=r88RRB7udxjsNpBL50POIAONvZ2613OTKWNvMdgjT4oYGrab43OH6HDjD8fKtVt3lH051D2NkUPjx/P5ZREfSiOkIZpdFAbrbqznGVKw1fnWmUK6GKSIsapg2LuojR3CvVXs3Mw6iG/JCbrm8cehMw6HzrD7IF7kSVe1QrvADzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771547790; c=relaxed/simple;
	bh=7Q3C9TKXTV3ZNTge712XmYkKkS12cLMRX8Vylg7yyys=;
	h=Date:To:From:Subject:Message-Id; b=YvhEQDsNOfuvD1XLGD6fv7tNYB0+gnSHEAzwaf2krxIlCTS1stm+xfxMK6bhBnuZbTy/4880d0FieVI/OBNqiYhjDRjkeM/NP3OB+TRBQ4fZkaKp1eu5GEVwanmy1BrGMba0B7TEgAzI5k2TPXy2qq/PxGPqEhCaIbHr7usLb5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0I4YpA6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0I4YpA6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD15C4CEF7;
	Fri, 20 Feb 2026 00:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771547789;
	bh=7Q3C9TKXTV3ZNTge712XmYkKkS12cLMRX8Vylg7yyys=;
	h=Date:To:From:Subject:From;
	b=0I4YpA6vZAIqzNLOQUY6RovP72Czwpqyd5hTbNgEDFVMiNSw4n13PrgGtf5cW1N1h
	 3YG4UiLTBEO/N919HEMO2Eb3Ctd4YyDX4+1v63uZbOPgnqnuNfFyDw74mct6NhLBOo
	 n4qE2N0GrMrbV0AZKIV0m692Yo5lpnLSsyMBnfeY=
Date: Thu, 19 Feb 2026 16:36:29 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator.patch added to mm-new branch
Message-Id: <20260220003629.ADD15C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: protect si->swap_file properly and use as a mount indicator
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: protect si->swap_file properly and use as a mount indicator
Date: Wed, 18 Feb 2026 04:06:26 +0800

Patch series "mm, swap: swap table phase III: remove swap_map", v3.

This series removes the static swap_map and uses the swap table for the
swap count directly.  This saves about ~30% memory usage for the static
swap metadata.  For example, this saves 256MB of memory when mounting a
1TB swap device.  Performance is slightly better too, since the double
update of the swap table and swap_map is now gone.

Test results:

Mounting a swap device:
=======================
Mount a 1TB brd device as SWAP, just to verify the memory save:

`free -m` before:
               total        used        free      shared  buff/cache   available
Mem:            1465        1051         417           1          61         413
Swap:        1054435           0     1054435

`free -m` after:
               total        used        free      shared  buff/cache   available
Mem:            1465         795         672           1          62         670
Swap:        1054435           0     1054435

Idle memory usage is reduced by ~256MB just as expected.  And following
this design we should be able to save another ~512MB in a next phase.

Build kernel test:
==================
Test using ZSWAP with NVME SWAP, make -j48, defconfig, in a x86_64 VM
with 5G RAM, under global pressure, avg of 32 test run:

                Before            After:
System time:    1038.97s          1013.75s (-2.4%)

Test using ZRAM as SWAP, make -j12, tinyconfig, in a ARM64 VM with 1.5G
RAM, under global pressure, avg of 32 test run:

                Before            After:
System time:    67.75s            66.65s (-1.6%)

The result is slightly better.

Redis / Valkey benchmark:
=========================
Test using ZRAM as SWAP, in a ARM64 VM with 1.5G RAM, under global pressure,
avg of 64 test run:

Server: valkey-server --maxmemory 2560M
Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get

        no persistence              with BGSAVE
Before: 472705.71 RPS               369451.68 RPS
After:  481197.93 RPS (+1.8%)       374922.32 RPS (+1.5%)

In conclusion, performance is better in all cases, and memory usage is
much lower.

The swap cgroup array will also be merged into the swap table in a later
phase, saving the other ~60% part of the static swap metadata and making
all the swap metadata dynamic.  The improved API for swap operations also
reduces the lock contention and makes more batching operations possible.


This patch (of 12):

/proc/swaps uses si->swap_map as the indicator to check if the swap
device is mounted. swap_map will be removed soon, so change it to use
si->swap_file instead because:

- si->swap_file is exactly the only dynamic content that /proc/swaps is
  interested in. Previously, it was checking si->swap_map just to ensure
  si->swap_file is available. si->swap_map is set under mutex
  protection, and after si->swap_file is set, so having si->swap_map set
  guarantees si->swap_file is set.

- Checking si->flags doesn't work here. SWP_WRITEOK is cleared during
  swapoff, but /proc/swaps is supposed to show the device under swapoff
  too to report the swapoff progress. And SWP_USED is set even if the
  device hasn't been properly set up.

We can have another flag, but the easier way is to just check
si->swap_file directly. So protect si->swap_file setting with mutext,
and set si->swap_file only when the swap device is truly enabled.

/proc/swaps only interested in si->swap_file and a few static data
reading. Only si->swap_file needs protection. Reading other static
fields is always fine.

Link: https://lkml.kernel.org/r/20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com
Link: https://lkml.kernel.org/r/20260218-swap-table-p3-v3-1-f4e34be021a7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/mm/swapfile.c~mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator
+++ a/mm/swapfile.c
@@ -110,6 +110,7 @@ struct swap_info_struct *swap_info[MAX_S
 
 static struct kmem_cache *swap_table_cachep;
 
+/* Protects si->swap_file for /proc/swaps usage */
 static DEFINE_MUTEX(swapon_mutex);
 
 static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
@@ -2532,7 +2533,8 @@ static void drain_mmlist(void)
 /*
  * Free all of a swapdev's extent information
  */
-static void destroy_swap_extents(struct swap_info_struct *sis)
+static void destroy_swap_extents(struct swap_info_struct *sis,
+				 struct file *swap_file)
 {
 	while (!RB_EMPTY_ROOT(&sis->swap_extent_root)) {
 		struct rb_node *rb = sis->swap_extent_root.rb_node;
@@ -2543,7 +2545,6 @@ static void destroy_swap_extents(struct
 	}
 
 	if (sis->flags & SWP_ACTIVATED) {
-		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 
 		sis->flags &= ~SWP_ACTIVATED;
@@ -2626,9 +2627,9 @@ EXPORT_SYMBOL_GPL(add_swap_extent);
  * Typically it is in the 1-4 megabyte range.  So we can have hundreds of
  * extents in the rbtree. - akpm.
  */
-static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
+static int setup_swap_extents(struct swap_info_struct *sis,
+			      struct file *swap_file, sector_t *span)
 {
-	struct file *swap_file = sis->swap_file;
 	struct address_space *mapping = swap_file->f_mapping;
 	struct inode *inode = mapping->host;
 	int ret;
@@ -2646,7 +2647,7 @@ static int setup_swap_extents(struct swa
 		sis->flags |= SWP_ACTIVATED;
 		if ((sis->flags & SWP_FS_OPS) &&
 		    sio_pool_init() != 0) {
-			destroy_swap_extents(sis);
+			destroy_swap_extents(sis, swap_file);
 			return -ENOMEM;
 		}
 		return ret;
@@ -2857,7 +2858,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	flush_work(&p->reclaim_work);
 	flush_percpu_swap_cluster(p);
 
-	destroy_swap_extents(p);
+	destroy_swap_extents(p, p->swap_file);
 	if (p->flags & SWP_CONTINUED)
 		free_swap_count_continuations(p);
 
@@ -2945,7 +2946,7 @@ static void *swap_start(struct seq_file
 		return SEQ_START_TOKEN;
 
 	for (type = 0; (si = swap_type_to_info(type)); type++) {
-		if (!(si->flags & SWP_USED) || !si->swap_map)
+		if (!(si->swap_file))
 			continue;
 		if (!--l)
 			return si;
@@ -2966,7 +2967,7 @@ static void *swap_next(struct seq_file *
 
 	++(*pos);
 	for (; (si = swap_type_to_info(type)); type++) {
-		if (!(si->flags & SWP_USED) || !si->swap_map)
+		if (!(si->swap_file))
 			continue;
 		return si;
 	}
@@ -3377,7 +3378,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap;
 	}
 
-	si->swap_file = swap_file;
 	mapping = swap_file->f_mapping;
 	dentry = swap_file->f_path.dentry;
 	inode = mapping->host;
@@ -3427,7 +3427,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	si->max = maxpages;
 	si->pages = maxpages - 1;
-	nr_extents = setup_swap_extents(si, &span);
+	nr_extents = setup_swap_extents(si, swap_file, &span);
 	if (nr_extents < 0) {
 		error = nr_extents;
 		goto bad_swap_unlock_inode;
@@ -3536,6 +3536,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
+
+	si->swap_file = swap_file;
 	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
@@ -3560,10 +3562,9 @@ bad_swap:
 	kfree(si->global_cluster);
 	si->global_cluster = NULL;
 	inode = NULL;
-	destroy_swap_extents(si);
+	destroy_swap_extents(si, swap_file);
 	swap_cgroup_swapoff(si->type);
 	spin_lock(&swap_lock);
-	si->swap_file = NULL;
 	si->flags = 0;
 	spin_unlock(&swap_lock);
 	vfree(swap_map);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-speed-up-hibernation-allocation-and-writeout.patch
mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator.patch
mm-swap-clean-up-swapon-process-and-locking.patch
mm-swap-remove-redundant-arguments-and-locking-for-enabling-a-device.patch
mm-swap-consolidate-bad-slots-setup-and-make-it-more-robust.patch
mm-workingset-leave-highest-bits-empty-for-anon-shadow.patch
mm-swap-implement-helpers-for-reserving-data-in-the-swap-table.patch
mm-swap-mark-bad-slots-in-swap-table-directly.patch
mm-swap-simplify-swap-table-sanity-range-check.patch
mm-swap-use-the-swap-table-to-track-the-swap-count.patch
mm-swap-no-need-to-truncate-the-scan-border.patch
mm-swap-simplify-checking-if-a-folio-is-swapped.patch
mm-swap-no-need-to-clear-the-shadow-explicitly.patch

