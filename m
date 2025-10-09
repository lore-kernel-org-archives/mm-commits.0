Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C73E1C695
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 03:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759980700; cv=none; b=uhokY4hELGiw2WnF2IQSIN3D+5TT+x8giUdr1eGDKIOHyERc1PY2TxR9x2yoXrSyJMF2xDs+e/pPKRdPGXEBJK65dkBWBVWpAnTLzy8ZDyuAPPrbtmY7KxtNHyTj0hfnlpMpZzpywBFqGwM6Rs9ZIXmO7z390sEZgWBTQwtqeqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759980700; c=relaxed/simple;
	bh=Z8CbAzk1DS+8fYpWHpJcCVJkpot0TRTlQQfLZJPvZ1U=;
	h=Date:To:From:Subject:Message-Id; b=dXTRC7RbQ/ZYfuKwCVHCTHJlYidnh3TD+Lig5A6RJXCO9QVfYC1Tq/42DineFbcFXX1vTHkX6K9S9ZNaX2Ywv8Sy15LjuLDStjy7h9ah+ldTuVhcVCHE47J3sVAmmuW+hnhX2vljAmDr3+i9vWCOSCqO86iHTf3jYarZ4ce7j3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tKx2kzLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tKx2kzLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96955C4CEE7;
	Thu,  9 Oct 2025 03:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759980699;
	bh=Z8CbAzk1DS+8fYpWHpJcCVJkpot0TRTlQQfLZJPvZ1U=;
	h=Date:To:From:Subject:From;
	b=tKx2kzLO/w5t8oBuhrXTLuWC9EXXyWp4tIMmSPafMnZQzwzpRqiwVQ322FsNJIJkY
	 ec3+l+vBfy+VZzkaFxuIYKgGam0s1PcGYXCSZxKodKl1zI/Wnf7uGFO/y96HtlaT4T
	 RmSRVJaYD2m1afqs63x0/mM5gQx0BnDTFhRo4oPM=
Date: Wed, 08 Oct 2025 20:31:39 -0700
To: mm-commits@vger.kernel.org,iii@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,aleksei.nikiforov@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-fix-kmsan-kmalloc-hook-when-no-stack-depots-are-allocated-yet.patch added to mm-new branch
Message-Id: <20251009033139.96955C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmsan: Fix kmsan kmalloc hook when no stack depots are allocated yet
has been added to the -mm mm-new branch.  Its filename is
     mm-kmsan-fix-kmsan-kmalloc-hook-when-no-stack-depots-are-allocated-yet.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-fix-kmsan-kmalloc-hook-when-no-stack-depots-are-allocated-yet.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
Subject: mm/kmsan: Fix kmsan kmalloc hook when no stack depots are allocated yet
Date: Tue, 30 Sep 2025 13:56:01 +0200

If no stack depot is allocated yet, due to masking out __GFP_RECLAIM flags
kmsan called from kmalloc cannot allocate stack depot.  kmsan fails to
record origin and report issues.

Reusing flags from kmalloc without modifying them should be safe for kmsan.
For example, such chain of calls is possible:
test_uninit_kmalloc -> kmalloc -> __kmalloc_cache_noprof ->
slab_alloc_node -> slab_post_alloc_hook ->
kmsan_slab_alloc -> kmsan_internal_poison_memory.

Only when it is called in a context without flags present should
__GFP_RECLAIM flags be masked.

With this change all kmsan tests start working reliably.

Link: https://lkml.kernel.org/r/20250930115600.709776-2-aleksei.nikiforov@linux.ibm.com
Signed-off-by: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Marco Elver <elver@google.com>
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

mm-kmsan-fix-kmsan-kmalloc-hook-when-no-stack-depots-are-allocated-yet.patch

