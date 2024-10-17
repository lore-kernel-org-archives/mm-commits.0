Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED13F1925B2
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 07:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150121; cv=none; b=J+mUgcR+Vm9CMxir/2zdp5k4izV5Kk5chUhEwFvFuaoz4yrldTyQyb3nQB08jqmN1GUAOAP9EvuA8O2beawrlYvGMpe3UFlSWGrZ9JKof03yNGOJFaCUgwPgBTS55YwWbG0ixvJ4HOx6nNaEL+FYOj9o2OXwwMcILoMGgY9Xt0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150121; c=relaxed/simple;
	bh=gCXRoCVg/7Lzvj4EedQS+uHk5TeFpIc4PACH+Z3fLkE=;
	h=Date:To:From:Subject:Message-Id; b=S/7arFyUyLTS6+nGW8WowVd9XeXA/msoblf8zB7XJrOhsyxgFyjc9FrEzZ7q4aMTun9H22fUzFqbjuyMYE03n2fviaHxiyjIy6Mzo/fd048hoqYBRjKKFwTwLcOCDQhaDHh/Xz1r+/xVfm+Ho5dFuZgWNnGfPtJqw+RwGTpwHqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FceqkRdG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FceqkRdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C196CC4CEC3;
	Thu, 17 Oct 2024 07:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150120;
	bh=gCXRoCVg/7Lzvj4EedQS+uHk5TeFpIc4PACH+Z3fLkE=;
	h=Date:To:From:Subject:From;
	b=FceqkRdGk2RBRAiPAfz4INV02ligxw0Hk5i8oJWQpvvo7c/6Ptjuy24YNfEolU88T
	 YIGdWPSoGGMaAqmSBs4in/1l4IQcD271Z5Tkw5fcbB1e8j6FhzjyLGX/Bn8/Q95uim
	 HVL7TIXZCoPPOSwgvz0AI1ElL5j1nmDMGOK+a/F8=
Date: Thu, 17 Oct 2024 00:28:40 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,lkp@intel.com,iamjoonsoo.kim@lge.com,dennis@kernel.org,cl@linux.com,arnd@kernel.org,arnd@arndb.de,42.hyeyoo@gmail.com,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-percpu-increase-percpu_dynamic_size_shift-on-certain-builds.patch removed from -mm tree
Message-Id: <20241017072840.C196CC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: percpu: increase PERCPU_DYNAMIC_SIZE_SHIFT on certain builds.
has been removed from the -mm tree.  Its filename was
     mm-percpu-increase-percpu_dynamic_size_shift-on-certain-builds.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm: percpu: increase PERCPU_DYNAMIC_SIZE_SHIFT on certain builds.
Date: Mon, 7 Oct 2024 16:30:49 +0200

Arnd reported a build failure due to the BUILD_BUG_ON() statement in
alloc_kmem_cache_cpus().  The test

  PERCPU_DYNAMIC_EARLY_SIZE < NR_KMALLOC_TYPES * KMALLOC_SHIFT_HIGH * sizeof(struct kmem_cache_cpu)

The factors that increase the right side of the equation:
- PAGE_SIZE > 4KiB increases KMALLOC_SHIFT_HIGH
- For the local_lock_t in kmem_cache_cpu:
  - PREEMPT_RT adds an actual lock.
  - LOCKDEP increases the size of the lock.
  - LOCK_STAT adds additional bytes plus padding to the lockdep
    structure.

The net difference with and without PREEMPT_RT is 88 bytes for the
lock_lock_t, 96 bytes for kmem_cache_cpu due to additional padding.  This
is enough to exceed the 80KiB limit with 16KiB page size - the 8KiB page
size is fine.

Increase PERCPU_DYNAMIC_SIZE_SHIFT to 13 on configs with PAGE_SIZE larger
than 4KiB and LOCKDEP enabled.

Link: https://lkml.kernel.org/r/20241007143049.gyMpEu89@linutronix.de
Fixes: d8fccd9ca5f9 ("arm64: Allow to enable PREEMPT_RT.")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410020326.iaZIteIx-lkp@intel.com/
Reported-by: Arnd Bergmann <arnd@kernel.org>
Closes: https://lore.kernel.org/20241004095702.637528-1-arnd@kernel.org
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/percpu.h~mm-percpu-increase-percpu_dynamic_size_shift-on-certain-builds
+++ a/include/linux/percpu.h
@@ -41,7 +41,11 @@
 					 PCPU_MIN_ALLOC_SHIFT)
 
 #ifdef CONFIG_RANDOM_KMALLOC_CACHES
-#define PERCPU_DYNAMIC_SIZE_SHIFT      12
+# if defined(CONFIG_LOCKDEP) && !defined(CONFIG_PAGE_SIZE_4KB)
+# define PERCPU_DYNAMIC_SIZE_SHIFT      13
+# else
+# define PERCPU_DYNAMIC_SIZE_SHIFT      12
+#endif /* LOCKDEP and PAGE_SIZE > 4KiB */
 #else
 #define PERCPU_DYNAMIC_SIZE_SHIFT      10
 #endif
_

Patches currently in -mm which might be from bigeasy@linutronix.de are


