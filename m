Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1622E8DE3;
	Mon, 10 Nov 2025 05:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752018; cv=none; b=lds4vqZx5lHar5g0GbPz/ZxTYi5g6AvY9TNf8OVfavm7oZOAu0wP/05lzjmTntWR205kT+AcSpuFTg35uodEAnzTrIymHpE6y9+XHYM/07b3lkvnCJQ05ikpaMVkoeJI+7z/RQR6snoO8Rq4Fyrydp7IBodQLcnmHMng2asF0+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752018; c=relaxed/simple;
	bh=JOLdOnkdqDObZYl0egZnAJ1dB29mHZixKPqrbEmOzZE=;
	h=Date:To:From:Subject:Message-Id; b=M5LdPbj9q+xC+BjBMA/PJSLfSkaLlKk/bXByg1YDhVadcfbGu+mEfR6BxwIYuESXo5I7awAVR9B9wn7EzWFMFPMSShdeqxpficekBt4wA7eGVLLw+Ng2ICcbTUZVU/u55NDjau6LdQLL13DEAliq33TI2c6soA1Cds9Wgx+fBV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zyzdz6M6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zyzdz6M6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AB7C116B1;
	Mon, 10 Nov 2025 05:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752018;
	bh=JOLdOnkdqDObZYl0egZnAJ1dB29mHZixKPqrbEmOzZE=;
	h=Date:To:From:Subject:From;
	b=Zyzdz6M69Sw2nFQnrTf/vHSzW7BbBqikffpVEG3M1ltTsX/6B6qnuOy7y7OMsMQSc
	 sBdyvkm2dgiPleKdmcKTL6/bxQEbbkvPbcRsrFl/ZklS/FNeAT0BjHLg79kGfIpKRY
	 9lFIr+fSvJtZLRqWwfr7s8luwhVQ3IsSDG+sZCfM=
Date: Sun, 09 Nov 2025 21:20:17 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,iii@linux.ibm.com,glider@google.com,elver@google.com,ebiggers@kernel.org,dvyukov@google.com,ast@kernel.org,aleksei.nikiforov@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kmsan-fix-kmsan-kmalloc-hook-when-no-stack-depots-are-allocated-yet.patch removed from -mm tree
Message-Id: <20251110052018.04AB7C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kmsan: fix kmsan kmalloc hook when no stack depots are allocated yet
has been removed from the -mm tree.  Its filename was
     mm-kmsan-fix-kmsan-kmalloc-hook-when-no-stack-depots-are-allocated-yet.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
Subject: mm/kmsan: fix kmsan kmalloc hook when no stack depots are allocated yet
Date: Tue, 30 Sep 2025 13:56:01 +0200

If no stack depot is allocated yet, due to masking out __GFP_RECLAIM flags
kmsan called from kmalloc cannot allocate stack depot.  kmsan fails to
record origin and report issues.  This may result in KMSAN failing to
report issues.

Reusing flags from kmalloc without modifying them should be safe for kmsan.
For example, such chain of calls is possible:
test_uninit_kmalloc -> kmalloc -> __kmalloc_cache_noprof ->
slab_alloc_node -> slab_post_alloc_hook ->
kmsan_slab_alloc -> kmsan_internal_poison_memory.

Only when it is called in a context without flags present should
__GFP_RECLAIM flags be masked.

With this change all kmsan tests start working reliably.

Eric reported:

: Yes, KMSAN seems to be at least partially broken currently.  Besides the
: fact that the kmsan KUnit test is currently failing (which I reported at
: https://lore.kernel.org/r/20250911175145.GA1376@sol), I've confirmed that
: the poly1305 KUnit test causes a KMSAN warning with Aleksei's patch
: applied but does not cause a warning without it.  The warning did get
: reached via syzbot somehow
: (https://lore.kernel.org/r/751b3d80293a6f599bb07770afcef24f623c7da0.1761026343.git.xiaopei01@kylinos.cn/),
: so KMSAN must still work in some cases.  But it didn't work for me.

Link: https://lkml.kernel.org/r/20250930115600.709776-2-aleksei.nikiforov@linux.ibm.com
Link: https://lkml.kernel.org/r/20251022030213.GA35717@sol
Fixes: 97769a53f117 ("mm, bpf: Introduce try_alloc_pages() for opportunistic page allocation")
Signed-off-by: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Eric Biggers <ebiggers@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/core.c   |    3 ---
 mm/kmsan/hooks.c  |    6 ++++--
 mm/kmsan/shadow.c |    2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

--- a/mm/kmsan/core.c~mm-kmsan-fix-kmsan-kmalloc-hook-when-no-stack-depots-are-allocated-yet
+++ a/mm/kmsan/core.c
@@ -72,9 +72,6 @@ depot_stack_handle_t kmsan_save_stack_wi
 
 	nr_entries = stack_trace_save(entries, KMSAN_STACK_DEPTH, 0);
 
-	/* Don't sleep. */
-	flags &= ~(__GFP_DIRECT_RECLAIM | __GFP_KSWAPD_RECLAIM);
-
 	handle = stack_depot_save(entries, nr_entries, flags);
 	return stack_depot_set_extra_bits(handle, extra);
 }
--- a/mm/kmsan/hooks.c~mm-kmsan-fix-kmsan-kmalloc-hook-when-no-stack-depots-are-allocated-yet
+++ a/mm/kmsan/hooks.c
@@ -84,7 +84,8 @@ void kmsan_slab_free(struct kmem_cache *
 	if (s->ctor)
 		return;
 	kmsan_enter_runtime();
-	kmsan_internal_poison_memory(object, s->object_size, GFP_KERNEL,
+	kmsan_internal_poison_memory(object, s->object_size,
+				     GFP_KERNEL & ~(__GFP_RECLAIM),
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
 }
@@ -114,7 +115,8 @@ void kmsan_kfree_large(const void *ptr)
 	kmsan_enter_runtime();
 	page = virt_to_head_page((void *)ptr);
 	KMSAN_WARN_ON(ptr != page_address(page));
-	kmsan_internal_poison_memory((void *)ptr, page_size(page), GFP_KERNEL,
+	kmsan_internal_poison_memory((void *)ptr, page_size(page),
+				     GFP_KERNEL & ~(__GFP_RECLAIM),
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
 }
--- a/mm/kmsan/shadow.c~mm-kmsan-fix-kmsan-kmalloc-hook-when-no-stack-depots-are-allocated-yet
+++ a/mm/kmsan/shadow.c
@@ -208,7 +208,7 @@ void kmsan_free_page(struct page *page,
 		return;
 	kmsan_enter_runtime();
 	kmsan_internal_poison_memory(page_address(page), page_size(page),
-				     GFP_KERNEL,
+				     GFP_KERNEL & ~(__GFP_RECLAIM),
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
 }
_

Patches currently in -mm which might be from aleksei.nikiforov@linux.ibm.com are


