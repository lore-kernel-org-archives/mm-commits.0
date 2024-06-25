Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3974A49635
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291619; cv=none; b=GPTOrLLwe1AngKNNZKCqRNXbKRKppXQBU9QyrrXoHC0Y5IMuwHl8nXaFTiuuyCjjQ1EVlFv6IlJF5VkBb0yCdldDhJhP6qZXA29eyk18utm9Us3Kg0HUW3LsBt2sSVlXnXvF6x6NqVStHl4cFibNetTFCvJVt00RC+RTBQerzNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291619; c=relaxed/simple;
	bh=8FaqUj4faQykARCL305tL0PJjrlO08jOKs2lDRHNsc8=;
	h=Date:To:From:Subject:Message-Id; b=OWtA3n/qQH/tyhrbpAzykKt9qC9IsD8N27gim34RGDdvop9r44JQTA6iAVHnkSJvDIfGvFsWEaFmsp9tymSwidt5pQ/Nk5cBmTzRk3GkB0aBsPnuzO7K2Kuv2nYwLIh0b3NoXfNDsEWBLBdebrku9AQMIYZJ3efB4ip6njgc+Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WTivYx/4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WTivYx/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF09C32782;
	Tue, 25 Jun 2024 05:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291619;
	bh=8FaqUj4faQykARCL305tL0PJjrlO08jOKs2lDRHNsc8=;
	h=Date:To:From:Subject:From;
	b=WTivYx/4y2ELR8iMZakgKnx93xm/bhcIf42BhESJN7l4R6vcCZRojpkjWpJcSAHHQ
	 on3wt+7380a+ZIBhJ6/LnpENXCAfT/q5YvoNI0hje65i3jtXBozWJ8HN5FDWlYw7gb
	 eSX06gS2pxqK0z8MVFdxEYPYh1XcZzv9n11iyiBg=
Date: Mon, 24 Jun 2024 22:00:18 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,tj@kernel.org,lstoakes@gmail.com,hch@infradead.org,dennis@kernel.org,cl@linux.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-use-__this_cpu_try_cmpxchg-in-preload_this_cpu_lock.patch removed from -mm tree
Message-Id: <20240625050019.0AF09C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: use __this_cpu_try_cmpxchg() in preload_this_cpu_lock()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-__this_cpu_try_cmpxchg-in-preload_this_cpu_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache.patch
fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache-fix.patch

