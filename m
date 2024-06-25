Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7067143899
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291685; cv=none; b=oAFYyhiwpkg4IoNQOPGdoBOJBs1SO5y2NXbJ4NOn77Fc5+BRGGKoGQBF28iNZtYWiycOGVm6hQ9HWStb7o1Pl2NaiHIKHyUS5lOv6hES7QT7qHOWsV0GmgKPjweUC274wuV2G76+NKHnQ9Rn/HBZ5zRI4j1auwLVkjWgqC6vb2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291685; c=relaxed/simple;
	bh=Owqtr0iEgQaygeSAFNaxfFaedLou2DQKDn7RIwCKgJI=;
	h=Date:To:From:Subject:Message-Id; b=qZim2zSZCiSF3y44QW5JGpl5c8OgBSMZm7K24Nl/K/AEN2h0NZXAun41843iUMa42U2b+7RUKO8s4aVyeyS5qxrX6e4T2y6bBW2o4CfRvHVdBywqBE7pRdOQGlmzq/S71JSdHXwgSmRNnPJp0KeKgNLulB30w7/9ceGnw/visNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1FdBTClw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1FdBTClw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1737C32782;
	Tue, 25 Jun 2024 05:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291685;
	bh=Owqtr0iEgQaygeSAFNaxfFaedLou2DQKDn7RIwCKgJI=;
	h=Date:To:From:Subject:From;
	b=1FdBTClwyBSq6c/TXx5k00yXq/eOm1a+/Dr349B5cGMsW4WGHvsdzvnKAQu+ElDjh
	 5jYNyt+kCGh4/kSOko2wWtet/brZa+hiwCMyHjmUiHXfuMVRL8vMqYHETan433lGUt
	 bTYNaIyHWO5TEf8uqNRU0kTtNX/KaMGuaRmUags0=
Date: Mon, 24 Jun 2024 22:01:25 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-print-mem_init-info-after-defer_init-is-done.patch removed from -mm tree
Message-Id: <20240625050125.A1737C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: print mem_init info after defer_init is done
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-print-mem_init-info-after-defer_init-is-done.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mm_init.c: print mem_init info after defer_init is done
Date: Tue, 11 Jun 2024 14:52:23 +0000

Current call flow looks like this:

start_kernel
  mm_core_init
    mem_init
    mem_init_print_info
  rest_init
    kernel_init
      kernel_init_freeable
        page_alloc_init_late
          deferred_init_memmap

If CONFIG_DEFERRED_STRUCT_PAGE_INIT, the time mem_init_print_info()
calls, pages are not totally initialized and freed to buddy.

This has one issue

  * nr_free_pages() just contains partial free pages in the system,
    which is not we expect.

Let's print the mem info after defer_init is done.

Also this would help changing totalram_pages accounting, since we plan
to move the accounting into __free_pages_core().

Link: https://lkml.kernel.org/r/20240611145223.16872-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-print-mem_init-info-after-defer_init-is-done
+++ a/mm/mm_init.c
@@ -2321,6 +2321,7 @@ void set_zone_contiguous(struct zone *zo
 	zone->contiguous = true;
 }
 
+static void __init mem_init_print_info(void);
 void __init page_alloc_init_late(void)
 {
 	struct zone *zone;
@@ -2347,6 +2348,8 @@ void __init page_alloc_init_late(void)
 	files_maxfiles_init();
 #endif
 
+	/* Accounting of total+free memory is stable at this point. */
+	mem_init_print_info();
 	buffer_init();
 
 	/* Discard memblock private memory */
@@ -2707,7 +2710,6 @@ void __init mm_core_init(void)
 	kmsan_init_shadow();
 	stack_depot_early_init();
 	mem_init();
-	mem_init_print_info();
 	kmem_cache_init();
 	/*
 	 * page_owner must be initialized after buddy is ready, and also after
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-sparse-nr_pages-wont-be-0.patch
mm-mm_initc-move-build-check-on-max_zonelists-out-of-ifdef.patch
mm-page_alloc-fix-a-typo-in-comment-about-gfp-flag.patch
mm-page_alloc-reword-the-comment-of-buddy_merge_likely.patch

