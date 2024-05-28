Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC36487A7
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 19:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716923263; cv=none; b=La54M5uz+wgt0dLFmE+JXdNI7WUtDG2tB2hmVkpNNAg/1j3gmk6GqQ8p/CVpQ6HNGs/T7fhtqB9AeRi7lgQF2/oWE8Yc1WbGiJ+0q6PP50tMKF6vAp71TB5PJBLhB8naAvCotqHw9TQN1K4WI16UlBHyuEYg57xl5VJLE0I30K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716923263; c=relaxed/simple;
	bh=Uh9IQ4yB/7Ln9/r7KBD/zuldh9X4AKVC8QuGBZckvmM=;
	h=Date:To:From:Subject:Message-Id; b=F0XRWTTeJiPW1eVedrhKZWhuKxiGlSCaR8I1FXMFlriWYuvRePhqAcVtifK4yOWMd1bRVDBDxCVT//GQ6c2eA5GtT5bV2BIJxEXMxxX64q2ffdwD2o4uXl1CoYLrYMJJdF7eAO1BMoePYlJSFnK4DyGqYOlD+LtXAyCXLgKAJDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MSyupaGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MSyupaGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D25C3277B;
	Tue, 28 May 2024 19:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716923263;
	bh=Uh9IQ4yB/7Ln9/r7KBD/zuldh9X4AKVC8QuGBZckvmM=;
	h=Date:To:From:Subject:From;
	b=MSyupaGO5rDaF7ypuRA29KQW1g31HaKLE03tFWnWYWvSUBAbq7EZnf/ew3ZicWw1z
	 b9VsddubJUNwe1e9akBXNtpbhLaWmZNwjSLDf8h/+yWqLT+FfhP//hnwgd8iHtODdS
	 YVIYqRmziHgC9Q252742xreO76X2b+w1IcQALzUU=
Date: Tue, 28 May 2024 12:07:42 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,tj@kernel.org,lstoakes@gmail.com,hch@infradead.org,dennis@kernel.org,cl@linux.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-__this_cpu_try_cmpxchg-in-preload_this_cpu_lock.patch added to mm-unstable branch
Message-Id: <20240528190743.39D25C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: use __this_cpu_try_cmpxchg() in preload_this_cpu_lock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-use-__this_cpu_try_cmpxchg-in-preload_this_cpu_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-use-__this_cpu_try_cmpxchg-in-preload_this_cpu_lock.patch

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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: mm/vmalloc: use __this_cpu_try_cmpxchg() in preload_this_cpu_lock()
Date: Tue, 28 May 2024 16:43:14 +0200

Use __this_cpu_try_cmpxchg() instead of __this_cpu_cmpxchg (*ptr, old,
new) == old in preload_this_cpu_lock().  x86 CMPXCHG instruction returns
success in ZF flag, so this change saves a compare after cmpxchg.

The generated code improves from:

    4bb6:	48 85 f6             	test   %rsi,%rsi
    4bb9:	0f 84 10 fa ff ff    	je     45cf <...>
    4bbf:	4c 89 e8             	mov    %r13,%rax
    4bc2:	65 48 0f b1 35 00 00 	cmpxchg %rsi,%gs:0x0(%rip)
    4bc9:	00 00
    4bcb:	48 85 c0             	test   %rax,%rax
    4bce:	0f 84 fb f9 ff ff    	je     45cf <...>

to:

    4bb6:	48 85 f6             	test   %rsi,%rsi
    4bb9:	0f 84 10 fa ff ff    	je     45cf <...>
    4bbf:	4c 89 e8             	mov    %r13,%rax
    4bc2:	65 48 0f b1 35 00 00 	cmpxchg %rsi,%gs:0x0(%rip)
    4bc9:	00 00
    4bcb:	0f 84 fe f9 ff ff    	je     45cf <...>

No functional change intended.

Link: https://lkml.kernel.org/r/20240528144345.5980-2-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-__this_cpu_try_cmpxchg-in-preload_this_cpu_lock
+++ a/mm/vmalloc.c
@@ -1816,7 +1816,7 @@ static void free_vmap_area(struct vmap_a
 static inline void
 preload_this_cpu_lock(spinlock_t *lock, gfp_t gfp_mask, int node)
 {
-	struct vmap_area *va = NULL;
+	struct vmap_area *va = NULL, *tmp;
 
 	/*
 	 * Preload this CPU with one extra vmap_area object. It is used
@@ -1832,7 +1832,8 @@ preload_this_cpu_lock(spinlock_t *lock,
 
 	spin_lock(lock);
 
-	if (va && __this_cpu_cmpxchg(ne_fit_preload_node, NULL, va))
+	tmp = NULL;
+	if (va && !__this_cpu_try_cmpxchg(ne_fit_preload_node, &tmp, va))
 		kmem_cache_free(vmap_area_cachep, va);
 }
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are

percpu-add-__this_cpu_try_cmpxchg.patch
mm-vmalloc-use-__this_cpu_try_cmpxchg-in-preload_this_cpu_lock.patch
fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache.patch
fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache-fix.patch

