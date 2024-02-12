Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5972B4E1D2
	for <mm-commits@vger.kernel.org>; Mon, 12 Feb 2024 22:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707776153; cv=none; b=D5eV0C9lgibnt7GrArZgXliyj0X43Q4GE5gyljX+VJmXlPj5Iv4p0eKcjqhTLQiZnp3zc/S8pJOzsV1otaUs1u1fsGKxaEfEFnEPxxJ3htDuOBpeIJFV3C+QiardXPfqDRT5bPSRdKJ51XAM5ffuBRwUClCqRlX0E7Ik5SwKJ70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707776153; c=relaxed/simple;
	bh=zRstX4u9UL+ttoxiJhJsdreWFv2nam0X+S6wbYWQRyE=;
	h=Date:To:From:Subject:Message-Id; b=qHncmpFdlK3YjpQhoTrmcfbqFSmCKio6OkcQ/Jh/SvswlQESZihORTcPNeZe9+FOUahSUo1/z5/IKLGue79w9UdNDCzOlTbi+jtSi9MzZuQbIoWHunVQ+qDFp6+ztW1TvNXPISTP9LzbqPsZuO4Vh3Kt4g1xVqPH2SzIlKEGugw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wGrl/bNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wGrl/bNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA71DC433F1;
	Mon, 12 Feb 2024 22:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707776152;
	bh=zRstX4u9UL+ttoxiJhJsdreWFv2nam0X+S6wbYWQRyE=;
	h=Date:To:From:Subject:From;
	b=wGrl/bNB8o/XehD0+xaexraxqhHpWi38jrF/qwnuh1tagjglgOq5kVsC/r+umDGLW
	 RXqn3QwVCpoklA6uy4poTGiqlcMO3kfsIfJkxJk4v6dXgOjpiloT+38p/paCK/vAVj
	 VRoo606oJS2KUUMtH9YifVT8OwiqPe/dv3ROZElw=
Date: Mon, 12 Feb 2024 14:15:52 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,rppt@linux.ibm.com,pasha.tatashin@soleen.com,mhocko@kernel.org,mgorman@techsingularity.net,kent.overstreet@gmail.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-document-memalloc_noreclaim_save-and-memalloc_pin_save.patch added to mm-unstable branch
Message-Id: <20240212221552.CA71DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: document memalloc_noreclaim_save() and memalloc_pin_save()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-document-memalloc_noreclaim_save-and-memalloc_pin_save.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-document-memalloc_noreclaim_save-and-memalloc_pin_save.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: document memalloc_noreclaim_save() and memalloc_pin_save()
Date: Mon, 12 Feb 2024 19:29:51 +0100

memalloc_noreclaim_save() currently has no documentation comment, so the
implications of its usage are not obvious.  Namely that it not only
prevents entering reclaim (as the name suggests), but also allows using
all memory reserves and thus should be only used in contexts that are
allocating memory to free memory.  This may lead to new improper usages
being added.

Thus add a documenting comment, based on the description of
__GFP_MEMALLOC. While at it, also document memalloc_pin_save() so that
all the memalloc_ scopes are documented. In the comments describing the
relevant PF_MEMALLOC flags, refer to their scope setting functions.

Link: https://lkml.kernel.org/r/20240212182950.32730-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h    |    9 ++++---
 include/linux/sched/mm.h |   45 +++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 4 deletions(-)

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
@@ -368,6 +368,27 @@ static inline void memalloc_nofs_restore
 	current->flags = (current->flags & ~PF_MEMALLOC_NOFS) | flags;
 }
 
+/**
+ * memalloc_noreclaim_save - Marks implicit __GFP_MEMALLOC scope.
+ *
+ * This functions marks the beginning of the __GFP_MEMALLOC allocation scope.
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
+ * This function should not be used in an interrupt context as that one does not
+ * give PF_MEMALLOC access to reserves, see __gfp_pfmemalloc_flags().
+ */
 static inline unsigned int memalloc_noreclaim_save(void)
 {
 	unsigned int flags = current->flags & PF_MEMALLOC;
@@ -375,11 +396,27 @@ static inline unsigned int memalloc_nore
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
+ * This functions marks the beginning of the ~__GFP_MOVABLE allocation scope.
+ * All further allocations will implicitly remove the __GFP_MOVABLE flag, which
+ * will constraint the allocations to zones that allow long term pinning, i.e.
+ * not ZONE_MOVABLE zones.
+ */
 static inline unsigned int memalloc_pin_save(void)
 {
 	unsigned int flags = current->flags & PF_MEMALLOC_PIN;
@@ -388,6 +425,14 @@ static inline unsigned int memalloc_pin_
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

mm-document-memalloc_noreclaim_save-and-memalloc_pin_save.patch

