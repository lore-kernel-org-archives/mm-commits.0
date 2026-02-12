Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2D42DC792;
	Thu, 12 Feb 2026 23:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939649; cv=none; b=iLZ11mYQqc+bCJOYy3G4vobBGMhE7A8hwBa3VjZ69c2LcjMXa0Nir9NYDsYesiecB9RxSGVYrObJd1PcgLoXtwN8pUBh5IfRL4DaL+mI8la5Qp+B/HIT+feG6jYgqQLSCqJBgM8hsEyv/r48ueFF4Sf6UTmfz5sgzipDhzpxip0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939649; c=relaxed/simple;
	bh=wofHfJvml9/rRBtH0+CgP3N78m//CQHK21rd6ujOGTg=;
	h=Date:To:From:Subject:Message-Id; b=s/Jk5GlKHWWeVrz2exi287epykhqQYKVcYzngOo8xjY5Uz/aFtQ5qaRSSusoLqTT6MYVAYtbSQJNR6noXHZ26QURk1ELk9xUrZH846kwUyhcENfdHHDAaFeMgyaIQWwokmLm8vyBzM+Qvsmy8mAQ1VO8QNWrq0RGD+4UVfC9t9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VDZxiWDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VDZxiWDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973D3C4CEF7;
	Thu, 12 Feb 2026 23:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939648;
	bh=wofHfJvml9/rRBtH0+CgP3N78m//CQHK21rd6ujOGTg=;
	h=Date:To:From:Subject:From;
	b=VDZxiWDAt1KTdm937LDmw4dc8tHHy4U0KSmoib7cHOOgKBH26rrLonrFiGKWH3Ush
	 20tk/CO4UrSY6kFkbgsv+SYdNI+Ybh7CWT2XLRsakZcIkFy2RPzb2ibd4Z8cnjXWg9
	 bOvtqxqLnF4/x2F+Zwv40ZeCbJGLJ2GMdmtJI/EI=
Date: Thu, 12 Feb 2026 15:40:47 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,harry.yoo@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-skip-debug_check_no_objlocks_freed-with-fpi_trylock.patch removed from -mm tree
Message-Id: <20260212234048.973D3C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: skip debug_check_no_{obj,locks}_freed with FPI_TRYLOCK
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-skip-debug_check_no_objlocks_freed-with-fpi_trylock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Harry Yoo <harry.yoo@oracle.com>
Subject: mm/page_alloc: skip debug_check_no_{obj,locks}_freed with FPI_TRYLOCK
Date: Mon, 9 Feb 2026 15:26:39 +0900

When CONFIG_DEBUG_OBJECTS_FREE is enabled,
debug_check_no_{obj,locks}_freed() functions are called.

Since both of them spin on a lock, they are not safe to be called if the
FPI_TRYLOCK flag is specified.  This leads to a lockdep splat:

  ================================
  WARNING: inconsistent lock state
  6.19.0-rc5-slab-for-next+ #326 Tainted: G                 N
  --------------------------------
  inconsistent {INITIAL USE} -> {IN-NMI} usage.
  kunit_try_catch/9046 [HC2[2]:SC0[0]:HE0:SE1] takes:
  ffffffff84ed6bf8 (&obj_hash[i].lock){-.-.}-{2:2}, at: __debug_check_no_obj_freed+0xe0/0x300
  {INITIAL USE} state was registered at:
    lock_acquire+0xd9/0x2f0
    _raw_spin_lock_irqsave+0x4c/0x80
    __debug_object_init+0x9d/0x1f0
    debug_object_init+0x34/0x50
    __init_work+0x28/0x40
    init_cgroup_housekeeping+0x151/0x210
    init_cgroup_root+0x3d/0x140
    cgroup_init_early+0x30/0x240
    start_kernel+0x3e/0xcd0
    x86_64_start_reservations+0x18/0x30
    x86_64_start_kernel+0xf3/0x140
    common_startup_64+0x13e/0x148
  irq event stamp: 2998
  hardirqs last  enabled at (2997): [<ffffffff8298b77a>] exc_nmi+0x11a/0x240
  hardirqs last disabled at (2998): [<ffffffff8298b991>] sysvec_irq_work+0x11/0x110
  softirqs last  enabled at (1416): [<ffffffff813c1f72>] __irq_exit_rcu+0x132/0x1c0
  softirqs last disabled at (1303): [<ffffffff813c1f72>] __irq_exit_rcu+0x132/0x1c0

  other info that might help us debug this:
   Possible unsafe locking scenario:

         CPU0
         ----
    lock(&obj_hash[i].lock);
    <Interrupt>
      lock(&obj_hash[i].lock);

   *** DEADLOCK ***

Rename free_pages_prepare() to __free_pages_prepare(), add an fpi_t
parameter, and skip those checks if FPI_TRYLOCK is set.  To keep the fpi_t
definition in mm/page_alloc.c, add a wrapper function free_pages_prepare()
that always passes FPI_NONE and use it in mm/compaction.c.

Link: https://lkml.kernel.org/r/20260209062639.16577-1-harry.yoo@oracle.com
Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-skip-debug_check_no_objlocks_freed-with-fpi_trylock
+++ a/mm/page_alloc.c
@@ -1340,8 +1340,8 @@ static inline void pgalloc_tag_sub_pages
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
-__always_inline bool free_pages_prepare(struct page *page,
-			unsigned int order)
+__always_inline bool __free_pages_prepare(struct page *page,
+					  unsigned int order, fpi_t fpi_flags)
 {
 	int bad = 0;
 	bool skip_kasan_poison = should_skip_kasan_poison(page);
@@ -1434,7 +1434,7 @@ __always_inline bool free_pages_prepare(
 	page_table_check_free(page, order);
 	pgalloc_tag_sub(page, 1 << order);
 
-	if (!PageHighMem(page)) {
+	if (!PageHighMem(page) && !(fpi_flags & FPI_TRYLOCK)) {
 		debug_check_no_locks_freed(page_address(page),
 					   PAGE_SIZE << order);
 		debug_check_no_obj_freed(page_address(page),
@@ -1473,6 +1473,11 @@ __always_inline bool free_pages_prepare(
 	return true;
 }
 
+bool free_pages_prepare(struct page *page, unsigned int order)
+{
+	return __free_pages_prepare(page, order, FPI_NONE);
+}
+
 /*
  * Frees a number of pages from the PCP lists
  * Assumes all pages on list are in same zone.
@@ -1606,7 +1611,7 @@ static void __free_pages_ok(struct page
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
-	if (free_pages_prepare(page, order))
+	if (__free_pages_prepare(page, order, fpi_flags))
 		free_one_page(zone, page, pfn, order, fpi_flags);
 }
 
@@ -2970,7 +2975,7 @@ static void __free_frozen_pages(struct p
 		return;
 	}
 
-	if (!free_pages_prepare(page, order))
+	if (!__free_pages_prepare(page, order, fpi_flags))
 		return;
 
 	/*
@@ -3027,7 +3032,7 @@ void free_unref_folios(struct folio_batc
 		unsigned long pfn = folio_pfn(folio);
 		unsigned int order = folio_order(folio);
 
-		if (!free_pages_prepare(&folio->page, order))
+		if (!__free_pages_prepare(&folio->page, order, FPI_NONE))
 			continue;
 		/*
 		 * Free orders not handled on the PCP directly to the
_

Patches currently in -mm which might be from harry.yoo@oracle.com are


