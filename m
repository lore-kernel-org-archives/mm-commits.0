Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EF749EC7D
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 20:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788381881; cv=none; b=ma+Dfe6+dys+cfM8b3x4lRO5GK98aT6Ds0RAkNEuVWsmX5Gtm8MKkWwW/WZHtF7WITXv5ZamU1liDozIgmc8K7js+aQWJ9sObsUy0ujX/HVIojYmYBipE95BCw2i1KiykOoFjqRb8scKK4HhmaPXCPWREMRF5JFVttxtGzB2V+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788381881; c=relaxed/simple;
	bh=/+Bhl2hO42Lp1uWXWvf3hMLCXkGZE3kdavq5LKDaS24=;
	h=Date:To:From:Subject:Message-Id; b=cO7+XPmcNkWAbnX6TO1OsaKasqxbz147zJBD9H0+o+0TnH4HlHNbmk5tixAV9U9fnjFRgsWJcd9YtMB2QfaWLCi9zY8pBafX1ivjQr6JMOk9siwoNS7O31p7RtNn/NOe8rLSBEEbEay9QXuHmk59/et6yszV5uSLDSJA6aJZNOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FRkvubfO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FRkvubfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DFC1F000E9;
	Wed,  2 Sep 2026 20:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788381878;
	bh=0a65YSq4sJ+igj4Dju0e3Uy4nMwQkL/UTtbL6WPfGPs=;
	h=Date:To:From:Subject;
	b=FRkvubfOEppYxt6e9JI4ZaqP3ikPWTR/8e1QzFvOOsAvCP93Ip9zE+yu1HqOr/Wqy
	 IpwCa41ULBucfJD5DvIsijh4g74PBm3rkeOOzZO2siitj7FkOQ+clg/ywOsxHNxDa/
	 vU68YTzNKYxjD/ebAQrniTnKEspW20wS96wB3n64=
Date: Wed, 02 Sep 2026 13:44:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,ljs@kernel.org,hch@lst.de,hannes@cmpxchg.org,djwong@kernel.org,david@kernel.org,cem@kernel.org,brendan.jackman@linux.dev,brauner@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xfs-remove-dead-kswapd-flag-inheritance-from-btree-split-worker.patch added to mm-new branch
Message-Id: <20260902204438.66DFC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xfs: remove dead kswapd flag inheritance from btree split worker
has been added to the -mm mm-new branch.  Its filename is
     xfs-remove-dead-kswapd-flag-inheritance-from-btree-split-worker.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xfs-remove-dead-kswapd-flag-inheritance-from-btree-split-worker.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

xfs-remove-dead-kswapd-flag-inheritance-from-btree-split-worker.patch
iomap-simplify-writepages-reclaim-guard.patch
mm-replace-pf_kswapd-flag-with-kthread_func-check.patch
mm-replace-pf_kcompactd-flag-with-kthread_func-check.patch

