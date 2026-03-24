Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AED364029
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388540; cv=none; b=O4/3fm6YevnhD3SWUdg3KryQNr/2xI3Kx3bv3hQQaSeEKq3zqkciq4euJsM4ltLU8aoRrg7H+r4Y2i1C/DrkxUZlNVdvl/ZuAoLtDAOE1fBMITKCkg1lrRkoAwWwanp92RoahpA6Pf02mFh5XdT9fHucAvsaT6E194zWS2pA87Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388540; c=relaxed/simple;
	bh=2n7hI8qgQv7uWPCkU3CvReTPS7ukkDvE6uS2xOOxZ88=;
	h=Date:To:From:Subject:Message-Id; b=MgDzSZVTmsdxbO7wBF7q+hXozp4WRHRajSxDkEJAPVfHkwVKruaaulIPqgq4v2jryfEAriofDx0xCpEbMKoPCB/QzCwhpksSkPG8RhrieTRpHJqCsa4KpjT074PZdMoqnUc6dYBW5+de+WFLP2cE9O63mmVXQr3t8cP5LPpQkTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m9EiDxxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m9EiDxxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF29C19424;
	Tue, 24 Mar 2026 21:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388539;
	bh=2n7hI8qgQv7uWPCkU3CvReTPS7ukkDvE6uS2xOOxZ88=;
	h=Date:To:From:Subject:From;
	b=m9EiDxxQugmM5BBvV663edz4DyEseAu3zvHvsTHt0wM7o3I87tuRlY3u2uzz+tC2u
	 D0C8TGEzaFBtyUt0IpmfH+l8REmVeQJMyS+IAp5TIZDLLbmk5Dg6lli3puVJsUAqv2
	 j3jbYXCAPxCOsGifGY5YCaJwOxdRogXz8NwZkTJ0=
Date: Tue, 24 Mar 2026 14:42:19 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator.patch removed from -mm tree
Message-Id: <20260324214219.CFF29C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: protect si->swap_file properly and use as a mount indicator
has been removed from the -mm tree.  Its filename was
     mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3376,7 +3377,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap;
 	}
 
-	si->swap_file = swap_file;
 	mapping = swap_file->f_mapping;
 	dentry = swap_file->f_path.dentry;
 	inode = mapping->host;
@@ -3426,7 +3426,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	si->max = maxpages;
 	si->pages = maxpages - 1;
-	nr_extents = setup_swap_extents(si, &span);
+	nr_extents = setup_swap_extents(si, swap_file, &span);
 	if (nr_extents < 0) {
 		error = nr_extents;
 		goto bad_swap_unlock_inode;
@@ -3535,6 +3535,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
+
+	si->swap_file = swap_file;
 	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
@@ -3559,10 +3561,9 @@ bad_swap:
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


