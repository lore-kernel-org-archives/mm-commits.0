Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2145F468D
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WRgUZgvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF41FC433C8;
	Mon, 11 Dec 2023 00:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256093;
	bh=oi2dPbcyAt/nha8eakiHt8fcVxUL0enJMSIxGKLM0e8=;
	h=Date:To:From:Subject:From;
	b=WRgUZgvtULlGMDPC8ncfhyKsw96YI9t+AVZNds2hIVWHck0cNP2QsNJyCf2Iul55h
	 lL//M7MkvmiATOYqGsBFOahbmgqQwX++G9JaBdHMwe6cmkamUKKpboOgGdVE3+CQsF
	 tX8rUXCiDLSVL8Ul2jv5S2S2X72IX46a3hDF42y0=
Date: Sun, 10 Dec 2023 16:54:52 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-store-next-pool-pointer-in-new_pool.patch removed from -mm tree
Message-Id: <20231211005452.DF41FC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/stackdepot: store next pool pointer in new_pool
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-store-next-pool-pointer-in-new_pool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: store next pool pointer in new_pool
Date: Mon, 20 Nov 2023 18:47:08 +0100

Instead of using the last pointer in stack_pools for storing the pointer
to a new pool (which does not yet store any stack records), use a new
new_pool variable.

This a purely code readability change: it seems more logical to store the
pointer to a pool with a special meaning in a dedicated variable.

Link: https://lkml.kernel.org/r/448bc18296c16bef95cb3167697be6583dcc8ce3.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/lib/stackdepot.c~lib-stackdepot-store-next-pool-pointer-in-new_pool
+++ a/lib/stackdepot.c
@@ -85,6 +85,8 @@ static unsigned int stack_hash_mask;
 
 /* Array of memory regions that store stack traces. */
 static void *stack_pools[DEPOT_MAX_POOLS];
+/* Newly allocated pool that is not yet added to stack_pools. */
+static void *new_pool;
 /* Currently used pool in stack_pools. */
 static int pool_index;
 /* Offset to the unused space in the currently used pool. */
@@ -241,7 +243,7 @@ static void depot_keep_new_pool(void **p
 	 * as long as we do not exceed the maximum number of pools.
 	 */
 	if (pool_index + 1 < DEPOT_MAX_POOLS) {
-		stack_pools[pool_index + 1] = *prealloc;
+		new_pool = *prealloc;
 		*prealloc = NULL;
 	}
 
@@ -272,6 +274,8 @@ static bool depot_update_pools(size_t re
 		 * stack_depot_fetch().
 		 */
 		WRITE_ONCE(pool_index, pool_index + 1);
+		stack_pools[pool_index] = new_pool;
+		new_pool = NULL;
 		pool_offset = 0;
 
 		/*
_

Patches currently in -mm which might be from andreyknvl@google.com are


