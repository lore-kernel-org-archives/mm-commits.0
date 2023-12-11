Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6176E4421
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hKMFrPdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80A2C433CA;
	Mon, 11 Dec 2023 00:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256107;
	bh=eJZjL8nkJw0Ht6AuRkQY/L8kM8YsCM5RDDv/1f6TkHU=;
	h=Date:To:From:Subject:From;
	b=hKMFrPdYUCnAVjGFC/d0K5yz+0U8SUIGU1QMAT1m6C1i1HO9kcZiL9rQlGnQ/pzNL
	 olRZkv3PPECBOXZ7YFu/eEuVo7kjNGR2OiqgUxIDdDy+h/DFsA0QEfTYKg4MY/6w3L
	 QfLwMJ5I52Eq0cMm1STaeVBkk9Q9gmqIwDIKcgII=
Date: Sun, 10 Dec 2023 16:55:07 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-adjust-depot_pools_cap-for-kmsan.patch removed from -mm tree
Message-Id: <20231211005507.D80A2C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/stackdepot: adjust DEPOT_POOLS_CAP for KMSAN
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-adjust-depot_pools_cap-for-kmsan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: adjust DEPOT_POOLS_CAP for KMSAN
Date: Mon, 20 Nov 2023 18:47:20 +0100

KMSAN is frequently used in fuzzing scenarios and thus saves a lot of
stack traces.  As KMSAN does not support evicting stack traces from the
stack depot, the stack depot capacity might be reached quickly with large
stack records.

Adjust the maximum number of stack depot pools for this case.

The average size of a stack trace saved into the stack depot is ~16
frames.  Thus, adjust the maximum pools number accordingly to keep the
maximum number of stack traces that can be saved into the stack depot
similar to the one that was allowed before the stack trace eviction
changes.

Link: https://lkml.kernel.org/r/301a115cf7ce8ddb42ef6de9151c2bb76ba728fc.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/lib/stackdepot.c~lib-stackdepot-adjust-depot_pools_cap-for-kmsan
+++ a/lib/stackdepot.c
@@ -41,7 +41,17 @@
 #define DEPOT_OFFSET_BITS (DEPOT_POOL_ORDER + PAGE_SHIFT - DEPOT_STACK_ALIGN)
 #define DEPOT_POOL_INDEX_BITS (DEPOT_HANDLE_BITS - DEPOT_OFFSET_BITS - \
 			       STACK_DEPOT_EXTRA_BITS)
+#if IS_ENABLED(CONFIG_KMSAN) && CONFIG_STACKDEPOT_MAX_FRAMES >= 32
+/*
+ * KMSAN is frequently used in fuzzing scenarios and thus saves a lot of stack
+ * traces. As KMSAN does not support evicting stack traces from the stack
+ * depot, the stack depot capacity might be reached quickly with large stack
+ * records. Adjust the maximum number of stack depot pools for this case.
+ */
+#define DEPOT_POOLS_CAP (8192 * (CONFIG_STACKDEPOT_MAX_FRAMES / 16))
+#else
 #define DEPOT_POOLS_CAP 8192
+#endif
 #define DEPOT_MAX_POOLS \
 	(((1LL << (DEPOT_POOL_INDEX_BITS)) < DEPOT_POOLS_CAP) ? \
 	 (1LL << (DEPOT_POOL_INDEX_BITS)) : DEPOT_POOLS_CAP)
_

Patches currently in -mm which might be from andreyknvl@google.com are


