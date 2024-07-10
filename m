Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABF9195B14
	for <mm-commits@vger.kernel.org>; Wed, 10 Jul 2024 18:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720636932; cv=none; b=ZfUX5rOJMTWIdtDDzU3ZEz7oZIcrDVwvtBz4Vt+gxggH482VAftzkw7Pdr2l7gOVXbJ6W1wXeH62r3PnGVUFuTlodhBbOEpIIITpKIp9YwwApqOoZJqmha+7F1cZKaHjGl0P5tJIrLf/3PKJrpqwzH9+OvprgC81INEthdUUi+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720636932; c=relaxed/simple;
	bh=zxHMDe15pREJc6Njfqe3vDauTl6CsmFDlp2DRkRQ+Oc=;
	h=Date:To:From:Subject:Message-Id; b=XbLgn72JZ/xlO8wIimGzJbpB5tpy1NAzRwrIljiLwl1DYvn0BmEnQgSMtbvoq7Va8ZgXbH+9XgtMn3HRdajayCow7qljSk2hG838GhXGoFK60d+HyLbop1hiZTqHbRnb3qFcfDeHPKzv4vGpoCpdu2Iet2hmOhI1rZDc1OD3qiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Le2NT/72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Le2NT/72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83584C32786;
	Wed, 10 Jul 2024 18:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720636931;
	bh=zxHMDe15pREJc6Njfqe3vDauTl6CsmFDlp2DRkRQ+Oc=;
	h=Date:To:From:Subject:From;
	b=Le2NT/72H71uRVZQO/SiOAKgJeoEmaTMMJYSpoxGFHmRj18V65yrC43X39xHHGq73
	 K4KNfMJALOsBs89demYUKXe9CCgHqjrR+Yy2Z0ijJi4SFFCzcQQPhRTRvjhhM2wCl6
	 9OnYrD9aE9EQmtMk1iYhFdgQzn9xYWby/6gQHp8c=
Date: Wed, 10 Jul 2024 11:42:11 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,shakeel.butt@linux.dev,oliver.sang@intel.com,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chengming.zhou@linux.dev,ak@linux.intel.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-initialize-zeromap-to-null-at-swapon-and-set-it-to-null-at-swapoff.patch added to mm-unstable branch
Message-Id: <20240710184211.83584C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: initialize zeromap to NULL at swapon and set it to NULL at swapoff
has been added to the -mm mm-unstable branch.  Its filename is
     mm-initialize-zeromap-to-null-at-swapon-and-set-it-to-null-at-swapoff.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-initialize-zeromap-to-null-at-swapon-and-set-it-to-null-at-swapoff.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm: initialize zeromap to NULL at swapon and set it to NULL at swapoff
Date:   Wed Jul 10 11:21:56 2024 +0100

If swapon fails before zeromap is initialized, kvfree should operate on a
NULL pointer.

Link: https://lkml.kernel.org/r/053bd429-ae19-4beb-a733-a7a838b1e010@gmail.com
Fixes: 127f851ba92f ("mm: store zero pages to be swapped out in a bitmap")
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202407101031.c6c3c651-lkp@intel.com
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/mm/swapfile.c~mm-initialize-zeromap-to-null-at-swapon-and-set-it-to-null-at-swapoff
+++ a/mm/swapfile.c
@@ -2524,6 +2524,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	struct address_space *mapping;
 	struct inode *inode;
 	struct filename *pathname;
+	unsigned long *zeromap;
 	int err, found = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -2641,6 +2642,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	p->max = 0;
 	swap_map = p->swap_map;
 	p->swap_map = NULL;
+	zeromap = p->zeromap;
+	p->zeromap = NULL;
 	cluster_info = p->cluster_info;
 	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
@@ -2653,7 +2656,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	free_percpu(p->cluster_next_cpu);
 	p->cluster_next_cpu = NULL;
 	vfree(swap_map);
-	kvfree(p->zeromap);
+	kvfree(zeromap);
 	kvfree(cluster_info);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
@@ -3105,6 +3108,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	struct page *page = NULL;
 	struct inode *inode = NULL;
 	bool inced_nr_rotate_swap = false;
+	unsigned long *zeromap = NULL;
 
 	if (swap_flags & ~SWAP_FLAGS_VALID)
 		return -EINVAL;
@@ -3181,15 +3185,16 @@ SYSCALL_DEFINE2(swapon, const char __use
 	}
 
 	/*
-	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
-	 * be above MAX_PAGE_ORDER incase of a large swap file.
+	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order
+	 * might be above MAX_PAGE_ORDER incase of a large swap file.
 	 */
-	p->zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(long),
-				    GFP_KERNEL | __GFP_ZERO);
-	if (!p->zeromap) {
+	zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(long),
+				 GFP_KERNEL | __GFP_ZERO);
+	if (!zeromap) {
 		error = -ENOMEM;
 		goto bad_swap_unlock_inode;
 	}
+	p->zeromap = zeromap;
 
 	if (p->bdev && bdev_stable_writes(p->bdev))
 		p->flags |= SWP_STABLE_WRITES;
@@ -3345,7 +3350,7 @@ bad_swap:
 	p->flags = 0;
 	spin_unlock(&swap_lock);
 	vfree(swap_map);
-	kvfree(p->zeromap);
+	kvfree(zeromap);
 	kvfree(cluster_info);
 	if (inced_nr_rotate_swap)
 		atomic_dec(&nr_rotate_swap);
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-initialize-zeromap-to-null-at-swapon-and-set-it-to-null-at-swapoff.patch

