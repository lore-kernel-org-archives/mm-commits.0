Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2400E5A513C
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 20:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789159161; cv=none; b=EHxevxY5GbMIzdE3OitL1wju0tbbhT6jvRyaYWXO838PBmV82YHGVTCrpud5yIGt/cQzKnjw1RFe3POaBhpKAyiVPAPdLrrv5vsPEm6VVAatl8JxbOhCBvyUsOmgfkaiEqkaFaSxoDGk0y3lkMwz7ZjzPY58hzO1hRYKuaGtCsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789159161; c=relaxed/simple;
	bh=Dw+xWmgWe30kDiqe8ljICXM5nUZnmcQTAn5NauTr5as=;
	h=Date:To:From:Subject:Message-Id; b=Gdx/gWszuL6YfqLppTP5NOTnt2CzhYE9ltXdemgpLb7Fvi3l6A25PeoYQOH1mK5jfIaPx0aIYkPFwRsuMWsl+668MSNgBvPSa7U5v7b/NREwnnwHybHv4QS0rJL8SKIwR4L5e2iLZqvPvJxHRnbrtU0IEQlZjU/mmjW3u2l56ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NAUJMPoH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NAUJMPoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5581F000FF;
	Fri, 11 Sep 2026 20:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789159155;
	bh=fbePu2BWHwfG4pb5ntfbGrbAPZY0Ao2rNv0GD83Npwo=;
	h=Date:To:From:Subject;
	b=NAUJMPoHETXx/hmBCYtACPMtSEHEp68k6REaIk+OAYXhhopmQ6mO/V6aTN7XIL7LX
	 BjOMIIOaJOvpeLcCIb4qE5eZ0FOHoYqmj/Q/EXaK2l868kPoQA1iJ5sHxlTwAuG/Sl
	 8YpmcmZ7w/2pNFNg8fAKLa5cPiIXve5tuHsLkQMw=
Date: Fri, 11 Sep 2026 13:39:15 -0700
To: mm-commits@vger.kernel.org,ynorov@nvidia.com,willy@infradead.org,linux@rasmusvillemoes.dk,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-fix-lock-initialization-in-region-allocation-benchmark.patch added to mm-new branch
Message-Id: <20260911203915.CC5581F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: fix lock initialization in region allocation benchmark
has been added to the -mm mm-new branch.  Its filename is
     lib-fix-lock-initialization-in-region-allocation-benchmark.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-fix-lock-initialization-in-region-allocation-benchmark.patch

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
From: Yury Norov <yury.norov@gmail.com>
Subject: lib: fix lock initialization in region allocation benchmark
Date: Fri, 11 Sep 2026 11:52:43 -0400

The Maple Tree benchmark uses MTREE_INIT() for a stack-allocated tree. 
Its static spinlock initializer leaves lockdep to use the lock address as
the class key.  Since the address is on the stack, the first allocation
triggers "INFO: trying to register non-static key" and disables lockdep.

The IDA benchmark has the same problem through IDA_INIT(), but runs after
Maple Tree and therefore encounters an already disabled lockdep.

Use mt_init_flags() and ida_init() to initialize the locks with persistent
lock-class keys.  Keep initialization outside the timed allocation paths.

Link: https://lore.kernel.org/20260911155244.1406122-1-ynorov@nvidia.com
Fixes: f4806cc63cc6 ("lib: test bitmap vs IDA vs Maple Tree performance for region allocations")
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Closes: https://lore.kernel.org/oe-lkp/202609101106.771b567e-lkp@intel.com
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/region_alloc_benchmark.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/lib/region_alloc_benchmark.c~lib-fix-lock-initialization-in-region-allocation-benchmark
+++ a/lib/region_alloc_benchmark.c
@@ -78,11 +78,13 @@ static size_t __init ida_size(unsigned l
 
 static unsigned long __init benchmark_ida(unsigned long cap)
 {
-	struct ida ida = IDA_INIT(ida);
+	struct ida ida;
 	unsigned long cnt, idx, off, nr_ids = 0;
 	ktime_t alloc_time, free_time;
 	int id = -ENOSPC;
 
+	ida_init(&ida);
+
 	alloc_time = ktime_get();
 	for (cnt = 0; cnt <= cap; cnt++) {
 		for (off = 0; off < reg_sz[cnt]; off++) {
@@ -125,12 +127,14 @@ static unsigned long __init benchmark_id
 
 static unsigned long __init benchmark_maple_tree(unsigned long cap)
 {
-	struct maple_tree mt = MTREE_INIT(mt, MT_FLAGS_ALLOC_RANGE);
+	struct maple_tree mt;
 	unsigned long cnt, idx;
 	ktime_t alloc_time, free_time;
 	size_t sz;
 	int ret;
 
+	mt_init_flags(&mt, MT_FLAGS_ALLOC_RANGE);
+
 	alloc_time = ktime_get();
 	for (cnt = 0; cnt <= cap; cnt++) {
 		ret = mtree_alloc_range(&mt, &idx, xa_mk_value(cnt + 1),
_

Patches currently in -mm which might be from yury.norov@gmail.com are

lib-fix-lock-initialization-in-region-allocation-benchmark.patch

