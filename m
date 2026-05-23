Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE131E5B88
	for <mm-commits@vger.kernel.org>; Sat, 23 May 2026 02:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779503493; cv=none; b=fHIc46r6sU4F6kF3PNG+zmE9G5kUhR7mn2mB+rLdtXf1inci0xFn7iBYRpDJHylpNeiARGEYrCj98WsyMD0rImUzLpOtcG3pxL5MWDoeWS9mLwoqMHM+HJL6Jm1kDqk2BuXcvdbdS+X/7FIA9TkHsOk/mGfMs7pjVeXH23CF2N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779503493; c=relaxed/simple;
	bh=4X4vPTHjRyRpVVRvIpDx1PTG7Fn5dnMu8HPShsG8bXk=;
	h=Date:To:From:Subject:Message-Id; b=TjWRAGlf7QdiQCV2fBEVbbUzmIqJUAkAKdCgmYBwLOk0g5lJo6dSddkMw2DEGGRBOmEpTq9qgDDC1c9g00o7LJwCjlAyfunWR9/IJXygr8E+wPd1BAvd8UiXoGTrxjEp+cN5NRxoY522PTbgcLGjK7BPwgcaiH+3/hHKueT4PaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IxRDJ3lk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IxRDJ3lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5E71F000E9;
	Sat, 23 May 2026 02:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779503492;
	bh=rgh9/ZR2m11dlELURHuxCS8umr+KSLK4EFJCizWOWHI=;
	h=Date:To:From:Subject;
	b=IxRDJ3lkzzhCk+YSXzT628G9TXPKGwfWwfy3qdxkSy1hE0PofWP7AD5yRRaA+obQF
	 bA6m4970wOG2kaVGx2bE9JCcT5kOTGp3qtO+I0VAYLuUgSbAGBPCcTOSOgKiPv36Q5
	 YMgubxbSmtrLQqkaH4gJCEhIrl95ofITeHjYpVm0=
Date: Fri, 22 May 2026 19:31:31 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,oliver.sang@intel.com,muchun.song@linux.dev,mhocko@kernel.org,joshua.hahnjy@gmail.com,harry@kernel.org,hannes@cmpxchg.org,alex@ghiti.fr,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch added to mm-new branch
Message-Id: <20260523023132.3A5E71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: uint16_t for nr_bytes in obj_stock_pcp
has been added to the -mm mm-new branch.  Its filename is
     memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: uint16_t for nr_bytes in obj_stock_pcp
Date: Thu, 21 May 2026 18:19:06 -0700

Currently struct obj_stock_pcp stores nr_bytes in an 'unsigned int' which
is 4 bytes on 64-bit machines.  Switch the field to uint16_t to shrink the
per-CPU cache.

The kernel supports PAGE_SIZE_4KB, _8KB, _16KB, _32KB, _64KB and _256KB
(see HAVE_PAGE_SIZE_* in arch/Kconfig).  After the PAGE_SIZE-aligned flush
in __refill_obj_stock(), the sub-page remainder fits in uint16_t up
through 64KiB pages where PAGE_SIZE - 1 == U16_MAX, but on 256KiB pages
PAGE_SIZE - 1 == 0x3FFFF exceeds U16_MAX.  The accumulator also needs to
stay within uint16_t between page-aligned flushes on 64KiB pages where
PAGE_SIZE itself is U16_MAX + 1.

Accumulate the new total in an 'unsigned int' local, then:

  1. Flush whenever the accumulator would hit U16_MAX. Together with
     the existing allow_uncharge flush at PAGE_SIZE, this keeps the
     uint16_t safe on PAGE_SIZE <= 64KiB.

  2. On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on hexagon and
     powerpc 44x), push any sub-page remainder above U16_MAX into
     objcg->nr_charged_bytes via atomic_add before storing back, so
     the store cannot silently truncate. The PAGE_SHIFT > 16 guard
     folds the branch out at compile time on smaller page sizes.

Link: https://lore.kernel.org/20260522011908.1669332-3-shakeel.butt@linux.dev
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp
+++ a/mm/memcontrol.c
@@ -2020,8 +2020,8 @@ static DEFINE_PER_CPU_ALIGNED(struct mem
 
 struct obj_stock_pcp {
 	local_trylock_t lock;
-	unsigned int nr_bytes;
 	struct obj_cgroup *cached_objcg;
+	uint16_t nr_bytes;
 	int16_t node_id;
 	int nr_slab_reclaimable_b;
 	int nr_slab_unreclaimable_b;
@@ -3334,6 +3334,7 @@ static void __refill_obj_stock(struct ob
 			       bool allow_uncharge)
 {
 	unsigned int nr_pages = 0;
+	unsigned int stock_nr_bytes;
 
 	if (!stock) {
 		nr_pages = nr_bytes >> PAGE_SHIFT;
@@ -3342,21 +3343,41 @@ static void __refill_obj_stock(struct ob
 		goto out;
 	}
 
+	stock_nr_bytes = stock->nr_bytes;
 	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
-		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
+		stock_nr_bytes = atomic_read(&objcg->nr_charged_bytes)
 				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
 		WRITE_ONCE(stock->cached_objcg, objcg);
 
 		allow_uncharge = true;	/* Allow uncharge when objcg changes */
 	}
-	stock->nr_bytes += nr_bytes;
+	stock_nr_bytes += nr_bytes;
 
-	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
-		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
-		stock->nr_bytes &= (PAGE_SIZE - 1);
+	/* Since stock->nr_bytes is uint16_t, don't refill >= U16_MAX */
+	if ((allow_uncharge && (stock_nr_bytes > PAGE_SIZE)) ||
+	    stock_nr_bytes > U16_MAX) {
+		nr_pages = stock_nr_bytes >> PAGE_SHIFT;
+		stock_nr_bytes &= (PAGE_SIZE - 1);
+
+		/*
+		 * On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on
+		 * hexagon and powerpc 44x), the sub-page remainder can
+		 * still exceed U16_MAX. Push the excess back to
+		 * objcg->nr_charged_bytes so the store into uint16_t
+		 * cannot silently truncate; folded out at compile time
+		 * on smaller page sizes.
+		 */
+		if (PAGE_SHIFT > 16 && stock_nr_bytes > U16_MAX) {
+			unsigned int kept = stock_nr_bytes & U16_MAX;
+
+			atomic_add(stock_nr_bytes - kept,
+				   &objcg->nr_charged_bytes);
+			stock_nr_bytes = kept;
+		}
 	}
+	stock->nr_bytes = stock_nr_bytes;
 
 out:
 	if (nr_pages)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-use-round-robin-victim-selection-in-refill_stock.patch
memcg-store-node_id-instead-of-pglist_data-pointer.patch
memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch
memcg-int16_t-for-cached-slab-stats.patch
memcg-multi-objcg-charge-support.patch

