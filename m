Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20AC111A8
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560216; cv=none; b=dzDMu1W81y6/bGzWgvTr7Zm38BljgeQVB+Z9cgWQ6VjJ3yb12dtKTQ1flimrbKokaaBTdfnvmMhWhphyrMYQVjSTSjUzuSWabjQYtIW9yJ2ccYFOSrEyyEhZ6lyOG/Ji9wtr+1uLwBP+1ddAsWsU1gKTneJI8P2gpIZio3t6WgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560216; c=relaxed/simple;
	bh=h3tWrCW1XZSDq41k7dx0EHdvpOvEuRPzWEiBwdpXNnE=;
	h=Date:To:From:Subject:Message-Id; b=cTkQ7Z/bGLyrKguYx/LgbbcuV1mXF5uHMFobgIeE8cJz0nVRTNqGoEBhS1GIq/QC0AnH6n1+L61WWC1fW4U3Z5IvpZAUlPnMhJVO2ZX+BqtPmjboHYqZWBj5QdYLekC4hG6XPEdhwc2IYNPZYZt7OOmrw5+fA65T5qKFVOLrjbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gppyWFju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gppyWFju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1CFC433C7;
	Thu, 22 Feb 2024 00:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560216;
	bh=h3tWrCW1XZSDq41k7dx0EHdvpOvEuRPzWEiBwdpXNnE=;
	h=Date:To:From:Subject:From;
	b=gppyWFju3qVcpRIhY/CyOUVk/4GGN9P+mAiuNo5vodv4fqxBoCgjifIqX67QI6b0l
	 Dv/Qvl+5Z5y++UPk/KvkzAlKvaPRIMNt4PYqj+SiOqs6+k7yMztnIm78nKRqajU/xO
	 GTglIS9oDYR3lKrpUzso5tf25RozI2UfPuH96FBQ=
Date: Wed, 21 Feb 2024 16:03:35 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,rppt@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,mgorman@techsingularity.net,kent.overstreet@linux.dev,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-document-memalloc_noreclaim_save-and-memalloc_pin_save.patch removed from -mm tree
Message-Id: <20240222000336.4D1CFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: document memalloc_noreclaim_save() and memalloc_pin_save()
has been removed from the -mm tree.  Its filename was
     mm-document-memalloc_noreclaim_save-and-memalloc_pin_save.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: document memalloc_noreclaim_save() and memalloc_pin_save()
Date: Mon, 12 Feb 2024 19:29:51 +0100

The memalloc_noreclaim_save() function currently has no documentation
comment, so the implications of its usage are not obvious.  Namely that it
not only prevents entering reclaim (as the name suggests), but also allows
using all memory reserves and thus should be only used in contexts that
are allocating memory to free memory.  This may lead to new improper
usages being added.

Thus add a documenting comment, based on the description of
__GFP_MEMALLOC.  While at it, also document memalloc_pin_save() so that
all the memalloc_ scopes are documented.  For those already documented,
add missing Return: descriptions, and mark Context: description per
kernel-docs style guide.

In the comments describing the relevant PF_MEMALLOC flags, refer to their
scope setting functions.

[vbabka@suse.cz: fix issues that Mike pointed out]
  Link: https://lkml.kernel.org/r/20240215095827.13756-2-vbabka@suse.cz
Link: https://lkml.kernel.org/r/20240212182950.32730-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h    |    9 +++---
 include/linux/sched/mm.h |   55 +++++++++++++++++++++++++++++++++++--
 2 files changed, 58 insertions(+), 6 deletions(-)

--- a/include/linux/sched.h~mm-document-memalloc_noreclaim_save-and-memalloc_pin_save
+++ a/include/linux/sched.h
@@ -1624,15 +1624,15 @@ extern struct pid *cad_pid;
 #define PF_SUPERPRIV		0x00000100	/* Used super-user privileges */
 #define PF_DUMPCORE		0x00000200	/* Dumped core */
 #define PF_SIGNALED		0x00000400	/* Killed by a signal */
-#define PF_MEMALLOC		0x00000800	/* Allocating memory */
+#define PF_MEMALLOC		0x00000800	/* Allocating memory to free memory. See memalloc_noreclaim_save() */
 #define PF_NPROC_EXCEEDED	0x00001000	/* set_user() noticed that RLIMIT_NPROC was exceeded */
 #define PF_USED_MATH		0x00002000	/* If unset the fpu must be initialized before use */
 #define PF_USER_WORKER		0x00004000	/* Kernel thread cloned from userspace thread */
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
 #define PF__HOLE__00010000	0x00010000
 #define PF_KSWAPD		0x00020000	/* I am kswapd */
-#define PF_MEMALLOC_NOFS	0x00040000	/* All allocation requests will inherit GFP_NOFS */
-#define PF_MEMALLOC_NOIO	0x00080000	/* All allocation requests will inherit GFP_NOIO */
+#define PF_MEMALLOC_NOFS	0x00040000	/* All allocations inherit GFP_NOFS. See memalloc_nfs_save() */
+#define PF_MEMALLOC_NOIO	0x00080000	/* All allocations inherit GFP_NOIO. See memalloc_noio_save() */
 #define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only against the bdi I write to,
 						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
@@ -1642,7 +1642,8 @@ extern struct pid *cad_pid;
 #define PF__HOLE__02000000	0x02000000
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
 #define PF_MCE_EARLY		0x08000000      /* Early kill for mce process policy */
-#define PF_MEMALLOC_PIN		0x10000000	/* Allocation context constrained to zones which allow long term pinning. */
+#define PF_MEMALLOC_PIN		0x10000000	/* Allocations constrained to zones which allow long term pinning.
+						 * See memalloc_pin_save() */
 #define PF__HOLE__20000000	0x20000000
 #define PF__HOLE__40000000	0x40000000
 #define PF_SUSPEND_TASK		0x80000000      /* This thread called freeze_processes() and should not be frozen */
--- a/include/linux/sched/mm.h~mm-document-memalloc_noreclaim_save-and-memalloc_pin_save
+++ a/include/linux/sched/mm.h
@@ -315,7 +315,8 @@ static inline void might_alloc(gfp_t gfp
  * point of view. Use memalloc_noio_restore to end the scope with flags
  * returned by this function.
  *
- * This function is safe to be used from any context.
+ * Context: This function is safe to be used from any context.
+ * Return: The saved flags to be passed to memalloc_noio_restore.
  */
 static inline unsigned int memalloc_noio_save(void)
 {
@@ -346,7 +347,8 @@ static inline void memalloc_noio_restore
  * point of view. Use memalloc_nofs_restore to end the scope with flags
  * returned by this function.
  *
- * This function is safe to be used from any context.
+ * Context: This function is safe to be used from any context.
+ * Return: The saved flags to be passed to memalloc_nofs_restore.
  */
 static inline unsigned int memalloc_nofs_save(void)
 {
@@ -368,6 +370,29 @@ static inline void memalloc_nofs_restore
 	current->flags = (current->flags & ~PF_MEMALLOC_NOFS) | flags;
 }
 
+/**
+ * memalloc_noreclaim_save - Marks implicit __GFP_MEMALLOC scope.
+ *
+ * This function marks the beginning of the __GFP_MEMALLOC allocation scope.
+ * All further allocations will implicitly add the __GFP_MEMALLOC flag, which
+ * prevents entering reclaim and allows access to all memory reserves. This
+ * should only be used when the caller guarantees the allocation will allow more
+ * memory to be freed very shortly, i.e. it needs to allocate some memory in
+ * the process of freeing memory, and cannot reclaim due to potential recursion.
+ *
+ * Users of this scope have to be extremely careful to not deplete the reserves
+ * completely and implement a throttling mechanism which controls the
+ * consumption of the reserve based on the amount of freed memory. Usage of a
+ * pre-allocated pool (e.g. mempool) should be always considered before using
+ * this scope.
+ *
+ * Individual allocations under the scope can opt out using __GFP_NOMEMALLOC
+ *
+ * Context: This function should not be used in an interrupt context as that one
+ *          does not give PF_MEMALLOC access to reserves.
+ *          See __gfp_pfmemalloc_flags().
+ * Return: The saved flags to be passed to memalloc_noreclaim_restore.
+ */
 static inline unsigned int memalloc_noreclaim_save(void)
 {
 	unsigned int flags = current->flags & PF_MEMALLOC;
@@ -375,11 +400,29 @@ static inline unsigned int memalloc_nore
 	return flags;
 }
 
+/**
+ * memalloc_noreclaim_restore - Ends the implicit __GFP_MEMALLOC scope.
+ * @flags: Flags to restore.
+ *
+ * Ends the implicit __GFP_MEMALLOC scope started by memalloc_noreclaim_save
+ * function. Always make sure that the given flags is the return value from the
+ * pairing memalloc_noreclaim_save call.
+ */
 static inline void memalloc_noreclaim_restore(unsigned int flags)
 {
 	current->flags = (current->flags & ~PF_MEMALLOC) | flags;
 }
 
+/**
+ * memalloc_pin_save - Marks implicit ~__GFP_MOVABLE scope.
+ *
+ * This function marks the beginning of the ~__GFP_MOVABLE allocation scope.
+ * All further allocations will implicitly remove the __GFP_MOVABLE flag, which
+ * will constraint the allocations to zones that allow long term pinning, i.e.
+ * not ZONE_MOVABLE zones.
+ *
+ * Return: The saved flags to be passed to memalloc_pin_restore.
+ */
 static inline unsigned int memalloc_pin_save(void)
 {
 	unsigned int flags = current->flags & PF_MEMALLOC_PIN;
@@ -388,6 +431,14 @@ static inline unsigned int memalloc_pin_
 	return flags;
 }
 
+/**
+ * memalloc_pin_restore - Ends the implicit ~__GFP_MOVABLE scope.
+ * @flags: Flags to restore.
+ *
+ * Ends the implicit ~__GFP_MOVABLE scope started by memalloc_pin_save function.
+ * Always make sure that the given flags is the return value from the pairing
+ * memalloc_pin_save call.
+ */
 static inline void memalloc_pin_restore(unsigned int flags)
 {
 	current->flags = (current->flags & ~PF_MEMALLOC_PIN) | flags;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-vmscan-prevent-infinite-loop-for-costly-gfp_noio-__gfp_retry_mayfail-allocations.patch

