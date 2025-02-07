Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9642179A3
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 00:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738889142; cv=none; b=MUxTXidyJun6vY9nq/xp4C3+mLeqRwnB5ZdJeQ4oAD+RjuD3Nvp3ca7/Wf2JhdU5YNwcw3zX4gVdVAH5kiDhiMTGpm7JLAvx/Xwc7zSMgzUNlvDz9HVLOjHOYRP+LTVykeOvalTOxvaf2f3zK3M7o7pgv2G5LPaE9vvBVmgrLfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738889142; c=relaxed/simple;
	bh=1tu9hc/y7kZpH6veSHRwo4X6qGZdGeLHZURV6ggq+N8=;
	h=Date:To:From:Subject:Message-Id; b=WwmQfNsqGGmppj2j8+svHdwWnSujyYjE4N3nY/Zj5dpbIaIEf4hf0TUU9EtNq2GAN0fJDogQFp9wsrJS19ERam2HaitlqBUMnNqY+7S1es/2uyNa5v1EVB5xv+w4Vn4NPjwavyGdSEg/6RpBMz3mamqEqFGjvEVAPQ30C3e19As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=klfNVyQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="klfNVyQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24408C4CEDF;
	Fri,  7 Feb 2025 00:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738889142;
	bh=1tu9hc/y7kZpH6veSHRwo4X6qGZdGeLHZURV6ggq+N8=;
	h=Date:To:From:Subject:From;
	b=klfNVyQ8utwvC6i8J8nEyq+NMvwa7+hlBbg6no4Z1zOxpJ93eEt2T97aHet4Mmj24
	 fWnOJLgbAg1KF46zbSBAmr5Sn/CfIUbvrzAlruv1yrBc12iHW5UYb8dFkbp5LipAfV
	 DhU+LkvK6Y2pqRSLwWZaMfeqU8vtiYvywOkh1c4I=
Date: Thu, 06 Feb 2025 16:45:41 -0800
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-kmemleak-print-the-raw-pointers-for-debugging-purposes.patch added to mm-unstable branch
Message-Id: <20250207004542.24408C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples: kmemleak: print the raw pointers for debugging purposes
has been added to the -mm mm-unstable branch.  Its filename is
     samples-kmemleak-print-the-raw-pointers-for-debugging-purposes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-kmemleak-print-the-raw-pointers-for-debugging-purposes.patch

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

mm-kmemleak-add-support-for-dumping-physical-and-__percpu-object-info.patch
samples-kmemleak-print-the-raw-pointers-for-debugging-purposes.patch

