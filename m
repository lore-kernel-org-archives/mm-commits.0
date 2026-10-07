Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF71B3242B2
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334383; cv=none; b=Xe+mfGRnxoqFV5nhnFb/E6nBiPAOdAZfana2UcHUWMiNgZ9eTIBRQotBeicxMeT7Zb19Igjji7mh1Vgk3i8JhwYxPZjf24Wv0+VFgPa6qydsZknE95qc/E+xCCJQvA26ItUKiuIfXuXyskwaMkk6VVrkQyb3+SW+jDjWLSBxZrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334383; c=relaxed/simple;
	bh=xDYXV29KSWclN6vNhJTJv9eMkzpJyOMCNh2qN350Q68=;
	h=Date:To:From:Subject:Message-Id; b=PjQkNxO/FGVQ+TP6RWAUR8jcFXGzKB5H+8YEqueasg9OiczkdczmEYkjg1lGTxJuBD2QWifr/SQ0GeOE0nCqNLkChFAPDxaxCdaClyU2d5v8yug6gU1oj5HT+a3c7toWMMuERnqrcAXpWYqLd2UB2NF3shIqdsEAio5ae5ehqao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t+2XH7BY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t+2XH7BY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1941F0089B;
	Wed,  7 Oct 2026 00:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334382;
	bh=LAInxbkrlNL5atzfljc+4y08qt8E0h0ALVCJVkXeYmc=;
	h=Date:To:From:Subject;
	b=t+2XH7BYsKYt8nmOagxXUo6LgdcscvntA9gQJ3e8xtYkIOZD6WoyrGKOwoao9Q4SG
	 W8LhL5qXGIc9fTHrQRjS/BnMH8AEoTiLfy2TPIAzUBMCl+lp6q4DuHnBi18WxGqWMZ
	 AuJof0rQF6rBXNSo6UNlU/R1mwMyfo0vSCW0wd7w=
Date: Tue, 06 Oct 2026 17:53:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,ljs@kernel.org,hch@lst.de,hannes@cmpxchg.org,djwong@kernel.org,david@kernel.org,cem@kernel.org,brendan.jackman@linux.dev,brauner@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xfs-remove-dead-kswapd-flag-inheritance-from-btree-split-worker.patch removed from -mm tree
Message-Id: <20261007005302.9D1941F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xfs: remove dead kswapd flag inheritance from btree split worker
has been removed from the -mm tree.  Its filename was
     xfs-remove-dead-kswapd-flag-inheritance-from-btree-split-worker.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: xfs: remove dead kswapd flag inheritance from btree split worker
Date: Wed, 2 Sep 2026 21:16:50 +0800

Patch series "mm: replace PF_KCOMPACTD/PF_KSWAPD with kthread_func()".

The task_struct->flags field is a limited 32-bit resource.  Two flag bits,
PF_KCOMPACTD and PF_KSWAPD, are used to identify whether a kernel thread
is kcompactd or kswapd.  Converting these to use kthread_func() frees up
two valuable flag bits for future use.


This patch (of 4):

Commit 1f6d64829db7 ("xfs: block allocation work needs to be kswapd
aware") added PF_MEMALLOC | PF_KSWAPD inheritance to
xfs_btree_split_worker() so that block allocation offloaded from kswapd to
a workqueue thread could access emergency memory reserves and avoid
reclaim throttling.

pageout() no longer calls ->writepage() for filesystem folios -- it
returns PAGE_ACTIVATE for non-shmem, non-anon pages.  kswapd therefore
never enters XFS writeback and cannot reach btree split.  The only path
that offloads btree splits is unwritten extent conversion at IO completion
(xfs_end_io -> xfs_iomap_write_unwritten), which runs in a workqueue
context where current_is_kswapd() is always false.

Let's remove the dead kswapd flag and related codes.

Link: https://lore.kernel.org/20260902131653.1338227-1-wangkefeng.wang@huawei.com
Link: https://lore.kernel.org/20260902131653.1338227-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 fs/xfs/libxfs/xfs_btree.c |   18 +-----------------
 fs/xfs/xfs_platform.h     |    4 ----
 2 files changed, 1 insertion(+), 21 deletions(-)

--- a/fs/xfs/libxfs/xfs_btree.c~xfs-remove-dead-kswapd-flag-inheritance-from-btree-split-worker
+++ a/fs/xfs/libxfs/xfs_btree.c
@@ -2994,7 +2994,6 @@ struct xfs_btree_split_args {
 	struct xfs_btree_cur	**curp;
 	int			*stat;		/* success/failure */
 	int			result;
-	bool			kswapd;	/* allocation in kswapd context */
 	struct completion	*done;
 	struct work_struct	work;
 };
@@ -3008,33 +3007,18 @@ xfs_btree_split_worker(
 {
 	struct xfs_btree_split_args	*args = container_of(work,
 						struct xfs_btree_split_args, work);
-	unsigned long		pflags;
-	unsigned long		new_pflags = 0;
-
-	/*
-	 * we are in a transaction context here, but may also be doing work
-	 * in kswapd context, and hence we may need to inherit that state
-	 * temporarily to ensure that we don't block waiting for memory reclaim
-	 * in any way.
-	 */
-	if (args->kswapd)
-		new_pflags |= PF_MEMALLOC | PF_KSWAPD;
-
-	current_set_flags_nested(&pflags, new_pflags);
 	xfs_trans_set_context(args->cur->bc_tp);
 
 	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
 					 args->key, args->curp, args->stat);
 
 	xfs_trans_clear_context(args->cur->bc_tp);
-	current_restore_flags_nested(&pflags, new_pflags);
 
 	/*
 	 * Do not access args after complete() has run here. We don't own args
 	 * and the owner may run and free args before we return here.
 	 */
 	complete(args->done);
-
 }
 
 /*
@@ -3078,7 +3062,7 @@ xfs_btree_split(
 	args.curp = curp;
 	args.stat = stat;
 	args.done = &done;
-	args.kswapd = current_is_kswapd();
+
 	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
 	queue_work(xfs_alloc_wq, &args.work);
 	wait_for_completion(&done);
--- a/fs/xfs/xfs_platform.h~xfs-remove-dead-kswapd-flag-inheritance-from-btree-split-worker
+++ a/fs/xfs/xfs_platform.h
@@ -115,10 +115,6 @@ typedef __u32			xfs_nlink_t;
 #define xfs_blockgc_secs	xfs_params.blockgc_timer.val
 
 #define current_cpu()		(raw_smp_processor_id())
-#define current_set_flags_nested(sp, f)		\
-		(*(sp) = current->flags, current->flags |= (f))
-#define current_restore_flags_nested(sp, f)	\
-		(current->flags = ((current->flags & ~(f)) | (*(sp) & (f))))
 
 #define NBBY		8		/* number of bits per byte */
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-zswap-convert-zswap_invalidate-to-take-a-range.patch
mm-zswap-skip-xarray-walk-in-zswap_invalidate-when-zswap-is-unused.patch
mm-zswap-reuse-zswap_invalidate-in-zswap_store.patch
mm-mincore-use-per-vma-lock-during-page-table-walk.patch

