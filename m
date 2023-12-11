Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A11C4690
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yyhyKBIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93BEC433C8;
	Mon, 11 Dec 2023 00:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256085;
	bh=LWLMPLu8hXGI97qGMhnBpDc3DNK9OASpleEZjcQIiNc=;
	h=Date:To:From:Subject:From;
	b=yyhyKBINBnSGJoQLdnMQzmn3LAPQOMvMHpW/oeeaWojGaYOw2A2gsKvTEPlYxJTFR
	 KPXHeWsOvydj/g6q58QgdZSYndEsXkzVxIRBV2eqg3sTcOm+zghNzlMM2bnjRMqBz+
	 8QpjpmZlcB57oswq4lLfAxUVFQ718pjP7jBr4kL8=
Date: Sun, 10 Dec 2023 16:54:45 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-drop-valid-bit-from-handles.patch removed from -mm tree
Message-Id: <20231211005445.C93BEC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/stackdepot: drop valid bit from handles
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-drop-valid-bit-from-handles.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: drop valid bit from handles
Date: Mon, 20 Nov 2023 18:47:02 +0100

Stack depot doesn't use the valid bit in handles in any way, so drop it.

Link: https://lkml.kernel.org/r/34969bba2ca6e012c6ad071767197dee64dc5723.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-drop-valid-bit-from-handles
+++ a/lib/stackdepot.c
@@ -32,13 +32,12 @@
 
 #define DEPOT_HANDLE_BITS (sizeof(depot_stack_handle_t) * 8)
 
-#define DEPOT_VALID_BITS 1
 #define DEPOT_POOL_ORDER 2 /* Pool size order, 4 pages */
 #define DEPOT_POOL_SIZE (1LL << (PAGE_SHIFT + DEPOT_POOL_ORDER))
 #define DEPOT_STACK_ALIGN 4
 #define DEPOT_OFFSET_BITS (DEPOT_POOL_ORDER + PAGE_SHIFT - DEPOT_STACK_ALIGN)
-#define DEPOT_POOL_INDEX_BITS (DEPOT_HANDLE_BITS - DEPOT_VALID_BITS - \
-			       DEPOT_OFFSET_BITS - STACK_DEPOT_EXTRA_BITS)
+#define DEPOT_POOL_INDEX_BITS (DEPOT_HANDLE_BITS - DEPOT_OFFSET_BITS - \
+			       STACK_DEPOT_EXTRA_BITS)
 #define DEPOT_POOLS_CAP 8192
 #define DEPOT_MAX_POOLS \
 	(((1LL << (DEPOT_POOL_INDEX_BITS)) < DEPOT_POOLS_CAP) ? \
@@ -50,7 +49,6 @@ union handle_parts {
 	struct {
 		u32 pool_index	: DEPOT_POOL_INDEX_BITS;
 		u32 offset	: DEPOT_OFFSET_BITS;
-		u32 valid	: DEPOT_VALID_BITS;
 		u32 extra	: STACK_DEPOT_EXTRA_BITS;
 	};
 };
@@ -309,7 +307,6 @@ depot_alloc_stack(unsigned long *entries
 	stack->size = size;
 	stack->handle.pool_index = pool_index;
 	stack->handle.offset = pool_offset >> DEPOT_STACK_ALIGN;
-	stack->handle.valid = 1;
 	stack->handle.extra = 0;
 	memcpy(stack->entries, entries, flex_array_size(stack, entries, size));
 	pool_offset += required_size;
_

Patches currently in -mm which might be from andreyknvl@google.com are


