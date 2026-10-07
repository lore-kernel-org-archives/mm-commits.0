Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBDE2264AB
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334386; cv=none; b=tHSqSHC7pql2Fn96C0m1zV8DlyRWy5KA2OQ0HvQioe81lALqz/5AopVZtglvoesTUsOMpQBaAm2pMqwQSFP/043slPPEVTVb5VnQmvmCgfVHXtXHcirjTUEGJTWn91qzlRV0QpeAQX9ur0sxwopFj/nZecmgLbyP3IJVhwGNCYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334386; c=relaxed/simple;
	bh=sTSqylURI+hsRioIa+/zs4/t/c/sN0IDBCS2t81bCb8=;
	h=Date:To:From:Subject:Message-Id; b=aloAs2r//21sNNWleiAAsTtmHem2qHENMop5mLI8r7W6aPGAXkWAqXFf++YIhh1ebN3vKTHM0WisoBsa/8czlnEsI4BG6oIb7PUbxlvoTI7Bd5kxB9sD+vxcjJx1bU6c+nIneG/ve5y/vPEGZ9yVFELxrXygvEBL5ef7cqNMMvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ybnu41KG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ybnu41KG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22161F0089B;
	Wed,  7 Oct 2026 00:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334384;
	bh=ekNOB7IaA/Ut1ECuuzXmLpiz0W/b6tK744ooLGp5W3c=;
	h=Date:To:From:Subject;
	b=Ybnu41KGz7xm4kTpPDYyMEY6+xyikByTWPGmMHTSaylxBAICSnY+Gw7+c0SXs4Ntj
	 hVDVw9BJdtQEivfsgAeFfnC9CHiWupG/CYzUjHPZl6fWvPn9IDsUvrBYGB5KX2DIeh
	 bXR85mDi75+eSwCJbJvzs3RtRXY1uH5Y5acWDnXY=
Date: Tue, 06 Oct 2026 17:53:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,ljs@kernel.org,hch@lst.de,hannes@cmpxchg.org,djwong@kernel.org,david@kernel.org,cem@kernel.org,brendan.jackman@linux.dev,brauner@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-replace-pf_kswapd-flag-with-kthread_func-check.patch removed from -mm tree
Message-Id: <20261007005304.C22161F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: replace PF_KSWAPD flag with kthread_func() check
has been removed from the -mm tree.  Its filename was
     mm-replace-pf_kswapd-flag-with-kthread_func-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: replace PF_KSWAPD flag with kthread_func() check
Date: Wed, 2 Sep 2026 21:16:52 +0800

The preceding commits removed the last consumer that propagated PF_KSWAPD
beyond kswapd itself (XFS btree split worker inheritance).  The only
remaining setter of PF_KSWAPD is kswapd(), and every current_is_kswapd()
caller only needs to check whether the current task *is* the kswapd
thread, not whether it inherited the flag.

Replace the flag-based test with kthread_func(current) == kswapd,
freeing the 0x00020000 PF flag bit.

Link: https://lore.kernel.org/20260902131653.1338227-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
---

 include/linux/sched.h                    |    2 +-
 include/linux/swap.h                     |    7 +------
 mm/vmscan.c                              |   10 ++++++++--
 tools/sched_ext/include/scx/common.bpf.h |    1 -
 4 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/sched.h~mm-replace-pf_kswapd-flag-with-kthread_func-check
+++ a/include/linux/sched.h
@@ -1810,7 +1810,7 @@ extern struct pid __rcu *cad_pid;
 #define PF_USER_WORKER		0x00004000	/* Kernel thread cloned from userspace thread */
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
 #define PF_KCOMPACTD		0x00010000	/* I am kcompactd */
-#define PF_KSWAPD		0x00020000	/* I am kswapd */
+#define PF__HOLE__00020000	0x00020000
 #define PF_MEMALLOC_NOFS	0x00040000	/* All allocations inherit GFP_NOFS. See memalloc_nfs_save() */
 #define PF_MEMALLOC_NOIO	0x00080000	/* All allocations inherit GFP_NOIO. See memalloc_noio_save() */
 #define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only against the bdi I write to,
--- a/include/linux/swap.h~mm-replace-pf_kswapd-flag-with-kthread_func-check
+++ a/include/linux/swap.h
@@ -25,12 +25,6 @@
 #define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
 				 SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE | \
 				 SWAP_FLAG_DISCARD_PAGES)
-
-static inline int current_is_kswapd(void)
-{
-	return current->flags & PF_KSWAPD;
-}
-
 /*
  * MAX_SWAPFILES defines the maximum number of swaptypes: things which can
  * be swapped to.  The swap type and the offset into that swap type are
@@ -339,6 +333,7 @@ void check_move_unevictable_folios(struc
 
 extern void __meminit kswapd_run(int nid);
 extern void __meminit kswapd_stop(int nid);
+bool current_is_kswapd(void);
 
 #ifdef CONFIG_SWAP
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
--- a/mm/vmscan.c~mm-replace-pf_kswapd-flag-with-kthread_func-check
+++ a/mm/vmscan.c
@@ -7539,7 +7539,7 @@ static int kswapd(void *p)
 	 * us from recursively trying to free more memory as we're
 	 * trying to free the first piece of memory in the first place).
 	 */
-	tsk->flags |= PF_MEMALLOC | PF_KSWAPD;
+	tsk->flags |= PF_MEMALLOC;
 	set_freezable();
 
 	WRITE_ONCE(pgdat->kswapd_order, 0);
@@ -7589,11 +7589,17 @@ kswapd_try_sleep:
 			goto kswapd_try_sleep;
 	}
 
-	tsk->flags &= ~(PF_MEMALLOC | PF_KSWAPD);
+	tsk->flags &= ~PF_MEMALLOC;
 
 	return 0;
 }
 
+bool current_is_kswapd(void)
+{
+	return kthread_func(current) == kswapd;
+}
+EXPORT_SYMBOL_GPL(current_is_kswapd);
+
 /*
  * A zone is low on free memory or too fragmented for high-order memory.  If
  * kswapd should reclaim (direct reclaim is deferred), wake it up for the zone's
--- a/tools/sched_ext/include/scx/common.bpf.h~mm-replace-pf_kswapd-flag-with-kthread_func-check
+++ a/tools/sched_ext/include/scx/common.bpf.h
@@ -32,7 +32,6 @@
 #define PF_IO_WORKER			0x00000010	/* Task is an IO worker */
 #define PF_WQ_WORKER			0x00000020	/* I'm a workqueue worker */
 #define PF_KCOMPACTD			0x00010000      /* I am kcompactd */
-#define PF_KSWAPD			0x00020000      /* I am kswapd */
 #define PF_KTHREAD			0x00200000	/* I am a kernel thread */
 #define PF_EXITING			0x00000004
 #define CLOCK_MONOTONIC			1
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-zswap-convert-zswap_invalidate-to-take-a-range.patch
mm-zswap-skip-xarray-walk-in-zswap_invalidate-when-zswap-is-unused.patch
mm-zswap-reuse-zswap_invalidate-in-zswap_store.patch
mm-mincore-use-per-vma-lock-during-page-table-walk.patch

