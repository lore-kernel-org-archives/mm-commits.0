Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B595835F5FB
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388542; cv=none; b=tINMf5DXjE7SBfHsyj1LQ13H0mNs5SHXRF3WH0TthPhgAsMy6aQOFZ9OhQKBr/8Wy46HTwltgxKIaenp6cwMyueByiQmwQjBdQDaOPNkgkwzliiFm3iEIvHRdA2naI3YXU19WrdwDaB9bhaYOD0TPud35aLFY+P0Drcpq710714=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388542; c=relaxed/simple;
	bh=T94cOGl3ZTN9JU5k/CxOr0M4kvKTa5h9aP3IIJcbYGY=;
	h=Date:To:From:Subject:Message-Id; b=rl7hFZlSCauiwLSWa5QKMaLFsseKqqbkWWyWcIC/7LnvKpSOs4WyKobc6mxeneb4ZkSbh0c2GYMuWpCV5JkVLoDbpZkTob0Pd1YCPFB7kZ9SCX3b/KPmi5FPWu9lhLbz2JWzpYxtTHdxFnsJQqLIpO2wVa87qh95TkaoxUWdmQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e5h/IlEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e5h/IlEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E07CC2BCB2;
	Tue, 24 Mar 2026 21:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388542;
	bh=T94cOGl3ZTN9JU5k/CxOr0M4kvKTa5h9aP3IIJcbYGY=;
	h=Date:To:From:Subject:From;
	b=e5h/IlEKNSb48sx2R0K+r94khTqdXgFSn17ro1cELjWvrVR3JQzMdnaBwghw462xo
	 JXA8DlBHzdrLTZd88cyH9uUBrlzQTUbqgrJfoEH81zSQunmhy1k2uTx1H9smQ/+k1A
	 sF1u48qd0wGe/9Hvq5LWJWsbb8pVeJUxxXHi+uPA=
Date: Tue, 24 Mar 2026 14:42:22 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-redundant-arguments-and-locking-for-enabling-a-device.patch removed from -mm tree
Message-Id: <20260324214222.8E07CC2BCB2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: remove redundant arguments and locking for enabling a device
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-redundant-arguments-and-locking-for-enabling-a-device.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: remove redundant arguments and locking for enabling a device
Date: Wed, 18 Feb 2026 04:06:28 +0800

There is no need to repeatedly pass zero map and priority values.  zeromap
is similar to cluster info and swap_map, which are only used once the swap
device is exposed.  And the prio values are currently read only once set,
and only used for the list insertion upon expose or swap info display.

Link: https://lkml.kernel.org/r/20260218-swap-table-p3-v3-3-f4e34be021a7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   48 ++++++++++++++++++------------------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

--- a/mm/swapfile.c~mm-swap-remove-redundant-arguments-and-locking-for-enabling-a-device
+++ a/mm/swapfile.c
@@ -2663,19 +2663,6 @@ static int setup_swap_extents(struct swa
 	return generic_swapfile_activate(sis, swap_file, span);
 }
 
-static void setup_swap_info(struct swap_info_struct *si, int prio,
-			    unsigned long *zeromap)
-{
-	si->prio = prio;
-	/*
-	 * the plist prio is negated because plist ordering is
-	 * low-to-high, while swap ordering is high-to-low
-	 */
-	si->list.prio = -si->prio;
-	si->avail_list.prio = -si->prio;
-	si->zeromap = zeromap;
-}
-
 static void _enable_swap_info(struct swap_info_struct *si)
 {
 	atomic_long_add(si->pages, &nr_swap_pages);
@@ -2689,17 +2676,12 @@ static void _enable_swap_info(struct swa
 	add_to_avail_list(si, true);
 }
 
-static void enable_swap_info(struct swap_info_struct *si, int prio,
-			     unsigned long *zeromap)
+/*
+ * Called after the swap device is ready, resurrect its percpu ref, it's now
+ * safe to reference it. Add it to the list to expose it to the allocator.
+ */
+static void enable_swap_info(struct swap_info_struct *si)
 {
-	spin_lock(&swap_lock);
-	spin_lock(&si->lock);
-	setup_swap_info(si, prio, zeromap);
-	spin_unlock(&si->lock);
-	spin_unlock(&swap_lock);
-	/*
-	 * Finished initializing swap device, now it's safe to reference it.
-	 */
 	percpu_ref_resurrect(&si->users);
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
@@ -2712,7 +2694,6 @@ static void reinsert_swap_info(struct sw
 {
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
-	setup_swap_info(si, si->prio, si->zeromap);
 	_enable_swap_info(si);
 	spin_unlock(&si->lock);
 	spin_unlock(&swap_lock);
@@ -3356,7 +3337,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
-	unsigned long *zeromap = NULL;
 	struct folio *folio = NULL;
 	struct inode *inode = NULL;
 	bool inced_nr_rotate_swap = false;
@@ -3467,9 +3447,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
 	 * be above MAX_PAGE_ORDER incase of a large swap file.
 	 */
-	zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(long),
-				    GFP_KERNEL | __GFP_ZERO);
-	if (!zeromap) {
+	si->zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(long),
+				     GFP_KERNEL | __GFP_ZERO);
+	if (!si->zeromap) {
 		error = -ENOMEM;
 		goto bad_swap_unlock_inode;
 	}
@@ -3538,10 +3518,17 @@ SYSCALL_DEFINE2(swapon, const char __use
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 
+	/*
+	 * The plist prio is negated because plist ordering is
+	 * low-to-high, while swap ordering is high-to-low
+	 */
+	si->prio = prio;
+	si->list.prio = -si->prio;
+	si->avail_list.prio = -si->prio;
 	si->swap_file = swap_file;
 
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
-	enable_swap_info(si, prio, zeromap);
+	enable_swap_info(si);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
@@ -3571,6 +3558,8 @@ bad_swap:
 	si->swap_map = NULL;
 	free_swap_cluster_info(si->cluster_info, si->max);
 	si->cluster_info = NULL;
+	kvfree(si->zeromap);
+	si->zeromap = NULL;
 	/*
 	 * Clear the SWP_USED flag after all resources are freed so
 	 * alloc_swap_info can reuse this si safely.
@@ -3578,7 +3567,6 @@ bad_swap:
 	spin_lock(&swap_lock);
 	si->flags = 0;
 	spin_unlock(&swap_lock);
-	kvfree(zeromap);
 	if (inced_nr_rotate_swap)
 		atomic_dec(&nr_rotate_swap);
 	if (swap_file)
_

Patches currently in -mm which might be from kasong@tencent.com are


