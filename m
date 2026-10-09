Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E336E40803D
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525549; cv=none; b=GRRrEZO/+cez6dUxU+BIOmnBhgvCD1wrh8zBZ96WIySVx1Bm+RFHZ4Z9u3JEY9D7iqVKLW12s4tX6zXEXaqp2wFio3ZyGZhn1PL3RIEMmcr5mva6MJUBMf8WpDfNOklcZyCnoMGlbQBiWcHoxurGTQOar2wp9P6U+bxAKo5bDTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525549; c=relaxed/simple;
	bh=sUGIdwWDndTvOEwxLNbwi75yGwyx8mjKtFJeat3ppG8=;
	h=Date:To:From:Subject:Message-Id; b=fkaSzS/X0hl/uxHA/XZlJJdzPN6fR9Z5y8QkoAwwCUJTfLh3QQyb71oCVI+OQNl2MSS5mFAShj1h/rgjaDvcyQ86YsMcKHjZNk3ZRttPcvLSQmg+XUSg3G7i9wsKl8Ad+iuPyRx1RkofvxdqgO018QPH0f5imIDJhq7Zg0YJ4jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hrj/Gukm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hrj/Gukm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73171F00893;
	Fri,  9 Oct 2026 05:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525547;
	bh=0Wwn38pskPhS98Gr4AH6SAvZrr59hgbAgW3BQn9Kf/o=;
	h=Date:To:From:Subject;
	b=hrj/GukmxhC353KjfggHe5DZktJIIYBm2v1CHekqs1Ws3iEzUG0GjvxrDi3xbyBj6
	 0jiVpNv6UMXfVSHGf8eNDhV9kScvzfdq27ZV2bEVIcZeJC3wQ7ppafD+VhrvgmhE5r
	 MRwzXlwp4OfTqnuhoZbkV+MTLl2mLP6xMg0d2qfU=
Date: Thu, 08 Oct 2026 22:59:07 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,linux@rasmusvillemoes.dk,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-fix-lock-initialization-in-region-allocation-benchmark.patch removed from -mm tree
Message-Id: <20261009055907.B73171F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: fix lock initialization in region allocation benchmark
has been removed from the -mm tree.  Its filename was
     lib-fix-lock-initialization-in-region-allocation-benchmark.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <ynorov@nvidia.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/oe-lkp/202609101106.771b567e-lkp@intel.com
Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
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

Patches currently in -mm which might be from ynorov@nvidia.com are


