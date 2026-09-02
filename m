Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5438E4AD4B6
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 20:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788381887; cv=none; b=qIhu2q+kyT9Dn8jyPUqLDiEba4bLwJVl9sSgdUYFWgSNojLH1uzx9nBO/v4Dh3H97I/DheXbdMVcKNttfQo8mH0fdkpv7fSb/bcvn83m88di4tc6p6n2K1Fdsu0jHxQ06qKd1c1xJ95MAayxAG6hAlF2Qk/8hlV/ehk1vHbhbM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788381887; c=relaxed/simple;
	bh=VzgVqDOVK0dAapGilgg+CmituN8rcQ8PU6RKVG9Absk=;
	h=Date:To:From:Subject:Message-Id; b=UT5Lgj0fBCyq00znPEyfSv55qW4BXBcl/2kGl6ydinTiUDfUvb0SglLno4un9yY+jmtKwk8Ohz7PbQx5ybcxY9l/SpV2whgABRgRNEPJf3yih9Fbzswzm10tdFq1aYqG4j5a/MC1CHccPuEkyJZ3YdAdWHFQu3XsBDmeGrwbIlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bJOB5q4h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bJOB5q4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212251F000E9;
	Wed,  2 Sep 2026 20:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788381883;
	bh=3ueP6oAT0HC8YPa7MybEwbDOjn3I+/hzV1H/Z5gAwoc=;
	h=Date:To:From:Subject;
	b=bJOB5q4hTDE/T2rOYPquNNYfAeAUGht/NmZqm/fRCzJJq99tHRgT/WboNuw7EJluq
	 D7g6u3YMFRTJ+KtZmGOV/3iSl1oRHk0g5j7xfv5bj1Gmb6fIvd4cZ5jV46E1ZqdtaC
	 jP3UDEfoLkBlrK2vlpGiF1hV1+0U27ZdjYtgfwhE=
Date: Wed, 02 Sep 2026 13:44:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,ljs@kernel.org,hch@lst.de,hannes@cmpxchg.org,djwong@kernel.org,david@kernel.org,cem@kernel.org,brendan.jackman@linux.dev,brauner@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-pf_kswapd-flag-with-kthread_func-check.patch added to mm-new branch
Message-Id: <20260902204443.212251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: replace PF_KSWAPD flag with kthread_func() check
has been added to the -mm mm-new branch.  Its filename is
     mm-replace-pf_kswapd-flag-with-kthread_func-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-pf_kswapd-flag-with-kthread_func-check.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h                    |    2 +-
 include/linux/swap.h                     |    7 +------
 mm/vmscan.c                              |   10 ++++++++--
 tools/sched_ext/include/scx/common.bpf.h |    1 -
 4 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/sched.h~mm-replace-pf_kswapd-flag-with-kthread_func-check
+++ a/include/linux/sched.h
@@ -1809,7 +1809,7 @@ extern struct pid *cad_pid;
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

xfs-remove-dead-kswapd-flag-inheritance-from-btree-split-worker.patch
iomap-simplify-writepages-reclaim-guard.patch
mm-replace-pf_kswapd-flag-with-kthread_func-check.patch
mm-replace-pf_kcompactd-flag-with-kthread_func-check.patch

