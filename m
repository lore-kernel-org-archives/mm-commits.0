Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A842D97A4;
	Tue, 27 Jan 2026 02:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482671; cv=none; b=jFEFNcKOAsIVK8+q8tQ6+pGoOMI5uKW3PxMtm3P4dhkBcT6Wo8SGutr+/UqtmWwok4gX6kkzMj7VBmxn7X5k2fIgLLWkBpIWoMRU35M7irZR+ZtIwYIwRvqUJA8QfhUpJyMZ31adljBvUQmi+mWuCwIIJ8iHeMVvlXXsIr/+yf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482671; c=relaxed/simple;
	bh=xxVVmvV15zSYzwVYT6lrc56XfX4XhWSQtjw5RcY2PVQ=;
	h=Date:To:From:Subject:Message-Id; b=NVkRGhs+d9Nn1dFHk11HZPXifUKo5WPpVWYG+xv/DKQHoxQfL/dq4nnzOett31Ew1OIHBfZvLU4KbAuc8gf7OMxAWd8TBMLSQ4m+pf0V+GEr9QAOuvTZLQ8NuRvh1MNqpgNUTUkQFF3z1YRGKMf26kZnEfpI/M4vWeidMmgiVvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jgXBvqEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jgXBvqEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27AFC2BC87;
	Tue, 27 Jan 2026 02:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769482670;
	bh=xxVVmvV15zSYzwVYT6lrc56XfX4XhWSQtjw5RcY2PVQ=;
	h=Date:To:From:Subject:From;
	b=jgXBvqEenzS1YAJR6vQ+8OgMBRnpggGaw8CnrMntcD1KvRpkpqzM9/PPSqcRjdO+y
	 5Quj5+3oHXgZDt2BWots+EQmv8MrKJ5TDSzIFlXzQG+k7H5VR7tPTAOGuueKCnVtQP
	 k4DEWPKPvRorj8IWcgHH88mm2m7E964uJR00zmEo=
Date: Mon, 26 Jan 2026 18:57:50 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,gregkh@linuxfoundation.org,glider@google.com,ernesto.martinezgarcia@tugraz.at,elver@google.com,dvyukov@google.com,pimyn@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kfence-randomize-the-freelist-on-initialization.patch removed from -mm tree
Message-Id: <20260127025750.C27AFC2BC87@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kfence: randomize the freelist on initialization
has been removed from the -mm tree.  Its filename was
     mm-kfence-randomize-the-freelist-on-initialization.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pimyn Girgis <pimyn@google.com>
Subject: mm/kfence: randomize the freelist on initialization
Date: Tue, 20 Jan 2026 17:15:10 +0100

Randomize the KFENCE freelist during pool initialization to make
allocation patterns less predictable.  This is achieved by shuffling the
order in which metadata objects are added to the freelist using
get_random_u32_below().

Additionally, ensure the error path correctly calculates the address range
to be reset if initialization fails, as the address increment logic has
been moved to a separate loop.

Link: https://lkml.kernel.org/r/20260120161510.3289089-1-pimyn@google.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Pimyn Girgis <pimyn@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Ernesto Martnez Garca <ernesto.martinezgarcia@tugraz.at>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/mm/kfence/core.c~mm-kfence-randomize-the-freelist-on-initialization
+++ a/mm/kfence/core.c
@@ -596,7 +596,7 @@ static void rcu_guarded_free(struct rcu_
 static unsigned long kfence_init_pool(void)
 {
 	unsigned long addr, start_pfn;
-	int i;
+	int i, rand;
 
 	if (!arch_kfence_init_pool())
 		return (unsigned long)__kfence_pool;
@@ -647,13 +647,27 @@ static unsigned long kfence_init_pool(vo
 		INIT_LIST_HEAD(&meta->list);
 		raw_spin_lock_init(&meta->lock);
 		meta->state = KFENCE_OBJECT_UNUSED;
-		meta->addr = addr; /* Initialize for validation in metadata_to_pageaddr(). */
-		list_add_tail(&meta->list, &kfence_freelist);
+		/* Use addr to randomize the freelist. */
+		meta->addr = i;
 
 		/* Protect the right redzone. */
-		if (unlikely(!kfence_protect(addr + PAGE_SIZE)))
+		if (unlikely(!kfence_protect(addr + 2 * i * PAGE_SIZE + PAGE_SIZE)))
 			goto reset_slab;
+	}
+
+	for (i = CONFIG_KFENCE_NUM_OBJECTS; i > 0; i--) {
+		rand = get_random_u32_below(i);
+		swap(kfence_metadata_init[i - 1].addr, kfence_metadata_init[rand].addr);
+	}
 
+	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
+		struct kfence_metadata *meta_1 = &kfence_metadata_init[i];
+		struct kfence_metadata *meta_2 = &kfence_metadata_init[meta_1->addr];
+
+		list_add_tail(&meta_2->list, &kfence_freelist);
+	}
+	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
+		kfence_metadata_init[i].addr = addr;
 		addr += 2 * PAGE_SIZE;
 	}
 
@@ -666,6 +680,7 @@ static unsigned long kfence_init_pool(vo
 	return 0;
 
 reset_slab:
+	addr += 2 * i * PAGE_SIZE;
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
 		struct page *page;
 
_

Patches currently in -mm which might be from pimyn@google.com are


