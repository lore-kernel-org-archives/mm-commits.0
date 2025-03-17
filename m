Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488352153E0
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188252; cv=none; b=Kv+BnHM2meIemZpcYfr1SkU+rI67AOfaDnnqk6tRYXa8UNs6APqAYhLqnS3zwYNtVOWS0gsqt1qkQ12CFbuB0SmikP1uSJJNAwe54VvtCXT6lWcutjTWfo5Yh/Zyg/xxE1NOzry6ix5wN4pr8fwAUeasYOCC8Q8q8iTgs2NyG2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188252; c=relaxed/simple;
	bh=mGH2ELLY2oYmH/NC0bXqDGN3tkH76/qb29/vW7zPY98=;
	h=Date:To:From:Subject:Message-Id; b=L0pq42HYvWEM+6GQSP0wpxQeqdJxznlH0qSkgke7rJBI0X3mN+4LJIkPHJCk58AJ/7ocuVs9aMO+OyuKR8tPH/skvyq4SJJQ37zoRLO3yxT2CQmMsdcpp1xWXeYBtlFAKcfJtg91750aX9GBh9+QMjse9ujEiWPolTx54kPZ5z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d49O7xKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d49O7xKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F781C4CEEC;
	Mon, 17 Mar 2025 05:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188252;
	bh=mGH2ELLY2oYmH/NC0bXqDGN3tkH76/qb29/vW7zPY98=;
	h=Date:To:From:Subject:From;
	b=d49O7xKteI8HqUdfd+ATDQzBj0nItbisxntWg1gFgebxPA6TE3UvfXABP1hN/XkS7
	 74H61p30R04o1wYtLFT0xAL9DCp59mPCSD1DVeuues0g0fe93YuvfhJH7mzw+RYrPY
	 femIoQcVBH9TIoLyKbiDx8Gev1k1AHh3OZ/e/2Qg=
Date: Sun, 16 Mar 2025 22:10:51 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-kmemleak-print-the-raw-pointers-for-debugging-purposes.patch removed from -mm tree
Message-Id: <20250317051052.1F781C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples: kmemleak: print the raw pointers for debugging purposes
has been removed from the -mm tree.  Its filename was
     samples-kmemleak-print-the-raw-pointers-for-debugging-purposes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: samples: kmemleak: print the raw pointers for debugging purposes
Date: Thu, 6 Feb 2025 11:45:37 +0000

The kmemleak-test.c module is meant to leak some pointers for debugging
the kmemleak detection, pointer information dumping.  It's no use if it
prints the hashed values of such pointers.

Change the printk() format from %p to %px.  While at it, also display the
raw __percpu pointer rather than this_cpu_ptr() since kmemleak now tracks
such pointers independently of the standard allocations.

Link: https://lkml.kernel.org/r/20250206114537.2597764-3-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kmemleak/kmemleak-test.c |   36 ++++++++++++++---------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/samples/kmemleak/kmemleak-test.c~samples-kmemleak-print-the-raw-pointers-for-debugging-purposes
+++ a/samples/kmemleak/kmemleak-test.c
@@ -40,25 +40,25 @@ static int kmemleak_test_init(void)
 	pr_info("Kmemleak testing\n");
 
 	/* make some orphan objects */
-	pr_info("kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
-	pr_info("kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
-	pr_info("kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
-	pr_info("kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
-	pr_info("kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
-	pr_info("kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
-	pr_info("kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
-	pr_info("kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
+	pr_info("kmalloc(32) = 0x%px\n", kmalloc(32, GFP_KERNEL));
+	pr_info("kmalloc(32) = 0x%px\n", kmalloc(32, GFP_KERNEL));
+	pr_info("kmalloc(1024) = 0x%px\n", kmalloc(1024, GFP_KERNEL));
+	pr_info("kmalloc(1024) = 0x%px\n", kmalloc(1024, GFP_KERNEL));
+	pr_info("kmalloc(2048) = 0x%px\n", kmalloc(2048, GFP_KERNEL));
+	pr_info("kmalloc(2048) = 0x%px\n", kmalloc(2048, GFP_KERNEL));
+	pr_info("kmalloc(4096) = 0x%px\n", kmalloc(4096, GFP_KERNEL));
+	pr_info("kmalloc(4096) = 0x%px\n", kmalloc(4096, GFP_KERNEL));
 #ifndef CONFIG_MODULES
-	pr_info("kmem_cache_alloc(files_cachep) = %p\n",
+	pr_info("kmem_cache_alloc(files_cachep) = 0x%px\n",
 		kmem_cache_alloc(files_cachep, GFP_KERNEL));
-	pr_info("kmem_cache_alloc(files_cachep) = %p\n",
+	pr_info("kmem_cache_alloc(files_cachep) = 0x%px\n",
 		kmem_cache_alloc(files_cachep, GFP_KERNEL));
 #endif
-	pr_info("vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = 0x%px\n", vmalloc(64));
+	pr_info("vmalloc(64) = 0x%px\n", vmalloc(64));
+	pr_info("vmalloc(64) = 0x%px\n", vmalloc(64));
+	pr_info("vmalloc(64) = 0x%px\n", vmalloc(64));
+	pr_info("vmalloc(64) = 0x%px\n", vmalloc(64));
 
 	/*
 	 * Add elements to a list. They should only appear as orphan
@@ -66,7 +66,7 @@ static int kmemleak_test_init(void)
 	 */
 	for (i = 0; i < 10; i++) {
 		elem = kzalloc(sizeof(*elem), GFP_KERNEL);
-		pr_info("kzalloc(sizeof(*elem)) = %p\n", elem);
+		pr_info("kzalloc(sizeof(*elem)) = 0x%px\n", elem);
 		if (!elem)
 			return -ENOMEM;
 		INIT_LIST_HEAD(&elem->list);
@@ -75,11 +75,11 @@ static int kmemleak_test_init(void)
 
 	for_each_possible_cpu(i) {
 		per_cpu(kmemleak_test_pointer, i) = kmalloc(129, GFP_KERNEL);
-		pr_info("kmalloc(129) = %p\n",
+		pr_info("kmalloc(129) = 0x%px\n",
 			per_cpu(kmemleak_test_pointer, i));
 	}
 
-	pr_info("__alloc_percpu(64, 4) = %p\n", __alloc_percpu(64, 4));
+	pr_info("__alloc_percpu(64, 4) = 0x%px\n", __alloc_percpu(64, 4));
 
 	return 0;
 }
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


