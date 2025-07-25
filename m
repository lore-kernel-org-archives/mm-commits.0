Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690C41373
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409676; cv=none; b=UVeUYHmjO/4AbFRUSZWbNOg6JA9XTVRtLO8z/iQ5Dq/xrN7Bc/Vq9FDZAJmuU4ozB92m8Q7n5EUkfB1YdZHtpqo/B1Pn6Y2YD8C+0i1TQ2U6ibU3zRtDho11431r6ZMgU6HYRuP+gr8mS2dl4iNCsKnWxSaQms2Iop24y998mDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409676; c=relaxed/simple;
	bh=aJLBOh2SxOePrub7QWi6EqBd7GC86PS9ix3Yi28jZd8=;
	h=Date:To:From:Subject:Message-Id; b=V/M4/5DysFDV76pmai06kMoeN0TP9gDUiiZ6izT70qvwx8NBXY1fO13kYpLZnd4KjMb+EJLtmmMJ8LHUgx9Rgbhl3WBdBWBC99K54PKalpJ2pck3QGI9zgo3+MPKyZ0LEEcAB7DzDGu+1DtJX52tzfkuRjV3CcrLRJ0BKOMaNCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sXMNh6zp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sXMNh6zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBB5C4CEED;
	Fri, 25 Jul 2025 02:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409675;
	bh=aJLBOh2SxOePrub7QWi6EqBd7GC86PS9ix3Yi28jZd8=;
	h=Date:To:From:Subject:From;
	b=sXMNh6zpMYcvOATeWKnLTTBaCJtSrbXmGwtb/vUQpnZQi7R1p7nQqfaHcamJR7oWs
	 WQ8TurBDXednRS2mpmxEZwSkBOVENljYjcbiiGnL87YE9/A6S14SpYkyIpr2kruaDI
	 h/OwjtEVYKkhSAOhOG9gOV2XGSmwo/lXdSMhH9sI=
Date: Thu, 24 Jul 2025 19:14:35 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rientjes@google.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-hold-shmem_swaplist-spinlock-not-mutex-much-less.patch removed from -mm tree
Message-Id: <20250725021435.DBBB5C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: hold shmem_swaplist spinlock (not mutex) much less
has been removed from the -mm tree.  Its filename was
     mm-shmem-hold-shmem_swaplist-spinlock-not-mutex-much-less.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/shmem: hold shmem_swaplist spinlock (not mutex) much less
Date: Wed, 16 Jul 2025 01:05:50 -0700 (PDT)

A flamegraph (from an MGLRU load) showed shmem_writeout()'s use of the
global shmem_swaplist_mutex worryingly hot: improvement is long overdue.

3.1 commit 6922c0c7abd3 ("tmpfs: convert shmem_writepage and enable swap")
apologized for extending shmem_swaplist_mutex across add_to_swap_cache(),
and hoped to find another way: yes, there may be lots of work to allocate
radix tree nodes in there.  Then 6.15 commit b487a2da3575 ("mm, swap:
simplify folio swap allocation") will have made it worse, by moving
shmem_writeout()'s swap allocation under that mutex too (but the worrying
flamegraph was observed even before that change).

There's a useful comment about pagelock no longer protecting from eviction
once moved to swap cache: but it's good till
shmem_delete_from_page_cache() replaces page pointer by swap entry, so
move the swaplist add between them.

We would much prefer to take the global lock once per inode than once per
page: given the possible races with shmem_unuse() pruning when !swapped
(and other tasks racing to swap other pages out or in), try the swaplist
add whenever swapped was incremented from 0 (but inode may already be on
the list - only unuse and evict bother to remove it).

This technique is more subtle than it looks (we're avoiding the very lock
which would make it easy), but works: whereas an unlocked list_empty()
check runs a risk of the inode being unqueued and left off the swaplist
forever, swapoff only completing when the page is faulted in or removed.

The need for a sleepable mutex went away in 5.1 commit b56a2d8af914 ("mm:
rid swapoff of quadratic complexity"): a spinlock works better now.

This commit is certain to take shmem_swaplist_mutex out of contention, and
has been seen to make a practical improvement (but there is likely to have
been an underlying issue which made its contention so visible).

Link: https://lkml.kernel.org/r/87beaec6-a3b0-ce7a-c892-1e1e5bd57aa3@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: David Rientjes <rientjes@google.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   59 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 26 deletions(-)

--- a/mm/shmem.c~mm-shmem-hold-shmem_swaplist-spinlock-not-mutex-much-less
+++ a/mm/shmem.c
@@ -292,7 +292,7 @@ bool vma_is_shmem(struct vm_area_struct
 }
 
 static LIST_HEAD(shmem_swaplist);
-static DEFINE_MUTEX(shmem_swaplist_mutex);
+static DEFINE_SPINLOCK(shmem_swaplist_lock);
 
 #ifdef CONFIG_TMPFS_QUOTA
 
@@ -432,10 +432,13 @@ static void shmem_free_inode(struct supe
  *
  * But normally   info->alloced == inode->i_mapping->nrpages + info->swapped
  * So mm freed is info->alloced - (inode->i_mapping->nrpages + info->swapped)
+ *
+ * Return: true if swapped was incremented from 0, for shmem_writeout().
  */
-static void shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
+static bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	bool first_swapped = false;
 	long freed;
 
 	spin_lock(&info->lock);
@@ -450,8 +453,11 @@ static void shmem_recalc_inode(struct in
 	 * to stop a racing shmem_recalc_inode() from thinking that a page has
 	 * been freed.  Compensate here, to avoid the need for a followup call.
 	 */
-	if (swapped > 0)
+	if (swapped > 0) {
+		if (info->swapped == swapped)
+			first_swapped = true;
 		freed += swapped;
+	}
 	if (freed > 0)
 		info->alloced -= freed;
 	spin_unlock(&info->lock);
@@ -459,6 +465,7 @@ static void shmem_recalc_inode(struct in
 	/* The quota case may block */
 	if (freed > 0)
 		shmem_inode_unacct_blocks(inode, freed);
+	return first_swapped;
 }
 
 bool shmem_charge(struct inode *inode, long pages)
@@ -1375,11 +1382,11 @@ static void shmem_evict_inode(struct ino
 			/* Wait while shmem_unuse() is scanning this inode... */
 			wait_var_event(&info->stop_eviction,
 				       !atomic_read(&info->stop_eviction));
-			mutex_lock(&shmem_swaplist_mutex);
+			spin_lock(&shmem_swaplist_lock);
 			/* ...but beware of the race if we peeked too early */
 			if (!atomic_read(&info->stop_eviction))
 				list_del_init(&info->swaplist);
-			mutex_unlock(&shmem_swaplist_mutex);
+			spin_unlock(&shmem_swaplist_lock);
 		}
 	}
 
@@ -1502,7 +1509,7 @@ int shmem_unuse(unsigned int type)
 	if (list_empty(&shmem_swaplist))
 		return 0;
 
-	mutex_lock(&shmem_swaplist_mutex);
+	spin_lock(&shmem_swaplist_lock);
 start_over:
 	list_for_each_entry_safe(info, next, &shmem_swaplist, swaplist) {
 		if (!info->swapped) {
@@ -1516,12 +1523,12 @@ start_over:
 		 * (igrab() would protect from unlink, but not from unmount).
 		 */
 		atomic_inc(&info->stop_eviction);
-		mutex_unlock(&shmem_swaplist_mutex);
+		spin_unlock(&shmem_swaplist_lock);
 
 		error = shmem_unuse_inode(&info->vfs_inode, type);
 		cond_resched();
 
-		mutex_lock(&shmem_swaplist_mutex);
+		spin_lock(&shmem_swaplist_lock);
 		if (atomic_dec_and_test(&info->stop_eviction))
 			wake_up_var(&info->stop_eviction);
 		if (error)
@@ -1532,7 +1539,7 @@ start_over:
 		if (!info->swapped)
 			list_del_init(&info->swaplist);
 	}
-	mutex_unlock(&shmem_swaplist_mutex);
+	spin_unlock(&shmem_swaplist_lock);
 
 	return error;
 }
@@ -1622,30 +1629,30 @@ try_split:
 		folio_mark_uptodate(folio);
 	}
 
-	/*
-	 * Add inode to shmem_unuse()'s list of swapped-out inodes,
-	 * if it's not already there.  Do it now before the folio is
-	 * moved to swap cache, when its pagelock no longer protects
-	 * the inode from eviction.  But don't unlock the mutex until
-	 * we've incremented swapped, because shmem_unuse_inode() will
-	 * prune a !swapped inode from the swaplist under this mutex.
-	 */
-	mutex_lock(&shmem_swaplist_mutex);
-	if (list_empty(&info->swaplist))
-		list_add(&info->swaplist, &shmem_swaplist);
-
 	if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
-		shmem_recalc_inode(inode, 0, nr_pages);
+		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
+
+		/*
+		 * Add inode to shmem_unuse()'s list of swapped-out inodes,
+		 * if it's not already there.  Do it now before the folio is
+		 * removed from page cache, when its pagelock no longer
+		 * protects the inode from eviction.  And do it now, after
+		 * we've incremented swapped, because shmem_unuse() will
+		 * prune a !swapped inode from the swaplist.
+		 */
+		if (first_swapped) {
+			spin_lock(&shmem_swaplist_lock);
+			if (list_empty(&info->swaplist))
+				list_add(&info->swaplist, &shmem_swaplist);
+			spin_unlock(&shmem_swaplist_lock);
+		}
+
 		swap_shmem_alloc(folio->swap, nr_pages);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
-		mutex_unlock(&shmem_swaplist_mutex);
 		BUG_ON(folio_mapped(folio));
 		return swap_writeout(folio, plug);
 	}
-	if (!info->swapped)
-		list_del_init(&info->swaplist);
-	mutex_unlock(&shmem_swaplist_mutex);
 	if (nr_pages > 1)
 		goto try_split;
 redirty:
_

Patches currently in -mm which might be from hughd@google.com are


