Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFC813B2B1
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 18:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707935552; cv=none; b=oXZDAmgTrhRQj5vw0/7ocvA/ZKix7XNFpObVfSQUUMxN4Kf+kvwRqNF+bknswu+zEiXrGwQ76oVR0jDdK3uQPSqETapI7htE3LTJ/2Sfhudg72qCsVQCCyXktzOBJKwBuO2QXz0LHkkZTxbwO5NSXtBcC0AYBIBUumsVtHSNLsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707935552; c=relaxed/simple;
	bh=HLJ1Qp1fgVZ8eYLlV0r9S4yMrRIFihYiPmdDgxQH4bs=;
	h=Date:To:From:Subject:Message-Id; b=qvnbE9Ky3/7OpsHW71wAkmUoqFkHFZVnh+n8qR+zFRLWLUB+NeHTgsOEG1juZAKbrI0zY0upNv/zeiDPTAT/NdL6dakiuIbHs7Wl7q7uB+qXLEh11BdfaCTZfa1WZYTiYIU9OvzJ5rFyEjd2I6+aWx+Gisjog4Alap2N/yLw8o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FUclYxLK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FUclYxLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DEFC433C7;
	Wed, 14 Feb 2024 18:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707935552;
	bh=HLJ1Qp1fgVZ8eYLlV0r9S4yMrRIFihYiPmdDgxQH4bs=;
	h=Date:To:From:Subject:From;
	b=FUclYxLKs3QpHZ+wTneJLt+z6tNlF1+3V9gvDQRySnlN5nBEt+Ec9AcxAcNkBXOW0
	 4W/uk8+4Fr0SXQNx/TV8ldJlLR3LcBrVXIXNi9n8bhvY8lCHOelJD+Riq8DXwjMmYw
	 zDOJM5ZNGnjukVm69usQ03otmk8k665t+NzqjnZA=
Date: Wed, 14 Feb 2024 10:32:31 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch added to mm-unstable branch
Message-Id: <20240214183232.02DEFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/stackdepot: move stack_record struct definition into the header
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: lib/stackdepot: move stack_record struct definition into the header
Date: Wed, 14 Feb 2024 18:01:52 +0100

In order to move the heavy lifting into page_owner code, this one needs to
have access to the stack_record structure, which right now sits in
lib/stackdepot.c.  Move it to the stackdepot.h header so page_owner can
access stack_record's struct fields.

Link: https://lkml.kernel.org/r/20240214170157.17530-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |   47 +++++++++++++++++++++++++++++++++++
 lib/stackdepot.c           |   45 ---------------------------------
 2 files changed, 48 insertions(+), 44 deletions(-)

--- a/include/linux/stackdepot.h~lib-stackdepot-move-stack_record-struct-definition-into-the-header
+++ a/include/linux/stackdepot.h
@@ -30,6 +30,53 @@ typedef u32 depot_stack_handle_t;
  */
 #define STACK_DEPOT_EXTRA_BITS 5
 
+#define DEPOT_HANDLE_BITS (sizeof(depot_stack_handle_t) * 8)
+
+#define DEPOT_POOL_ORDER 2 /* Pool size order, 4 pages */
+#define DEPOT_POOL_SIZE (1LL << (PAGE_SHIFT + DEPOT_POOL_ORDER))
+#define DEPOT_STACK_ALIGN 4
+#define DEPOT_OFFSET_BITS (DEPOT_POOL_ORDER + PAGE_SHIFT - DEPOT_STACK_ALIGN)
+#define DEPOT_POOL_INDEX_BITS (DEPOT_HANDLE_BITS - DEPOT_OFFSET_BITS - \
+			       STACK_DEPOT_EXTRA_BITS)
+
+#ifdef CONFIG_STACKDEPOT
+/* Compact structure that stores a reference to a stack. */
+union handle_parts {
+	depot_stack_handle_t handle;
+	struct {
+		/* pool_index is offset by 1 */
+		u32 pool_index	: DEPOT_POOL_INDEX_BITS;
+		u32 offset	: DEPOT_OFFSET_BITS;
+		u32 extra	: STACK_DEPOT_EXTRA_BITS;
+	};
+};
+
+struct stack_record {
+	struct list_head hash_list;	/* Links in the hash table */
+	u32 hash;			/* Hash in hash table */
+	u32 size;			/* Number of stored frames */
+	union handle_parts handle;	/* Constant after initialization */
+	refcount_t count;
+	union {
+		unsigned long entries[CONFIG_STACKDEPOT_MAX_FRAMES];	/* Frames */
+		struct {
+			/*
+			 * An important invariant of the implementation is to
+			 * only place a stack record onto the freelist iff its
+			 * refcount is zero. Because stack records with a zero
+			 * refcount are never considered as valid, it is safe to
+			 * union @entries and freelist management state below.
+			 * Conversely, as soon as an entry is off the freelist
+			 * and its refcount becomes non-zero, the below must not
+			 * be accessed until being placed back on the freelist.
+			 */
+			struct list_head free_list;	/* Links in the freelist */
+			unsigned long rcu_state;	/* RCU cookie */
+		};
+	};
+};
+#endif
+
 typedef u32 depot_flags_t;
 
 /*
--- a/lib/stackdepot.c~lib-stackdepot-move-stack_record-struct-definition-into-the-header
+++ a/lib/stackdepot.c
@@ -36,55 +36,12 @@
 #include <linux/memblock.h>
 #include <linux/kasan-enabled.h>
 
-#define DEPOT_HANDLE_BITS (sizeof(depot_stack_handle_t) * 8)
-
-#define DEPOT_POOL_ORDER 2 /* Pool size order, 4 pages */
-#define DEPOT_POOL_SIZE (1LL << (PAGE_SHIFT + DEPOT_POOL_ORDER))
-#define DEPOT_STACK_ALIGN 4
-#define DEPOT_OFFSET_BITS (DEPOT_POOL_ORDER + PAGE_SHIFT - DEPOT_STACK_ALIGN)
-#define DEPOT_POOL_INDEX_BITS (DEPOT_HANDLE_BITS - DEPOT_OFFSET_BITS - \
-			       STACK_DEPOT_EXTRA_BITS)
 #define DEPOT_POOLS_CAP 8192
-/* The pool_index is offset by 1 so the first record does not have a 0 handle. */
+/* The pool_index is offset by 1 so the first record does not have a 0 handle */
 #define DEPOT_MAX_POOLS \
 	(((1LL << (DEPOT_POOL_INDEX_BITS)) - 1 < DEPOT_POOLS_CAP) ? \
 	 (1LL << (DEPOT_POOL_INDEX_BITS)) - 1 : DEPOT_POOLS_CAP)
 
-/* Compact structure that stores a reference to a stack. */
-union handle_parts {
-	depot_stack_handle_t handle;
-	struct {
-		u32 pool_index	: DEPOT_POOL_INDEX_BITS; /* pool_index is offset by 1 */
-		u32 offset	: DEPOT_OFFSET_BITS;
-		u32 extra	: STACK_DEPOT_EXTRA_BITS;
-	};
-};
-
-struct stack_record {
-	struct list_head hash_list;	/* Links in the hash table */
-	u32 hash;			/* Hash in hash table */
-	u32 size;			/* Number of stored frames */
-	union handle_parts handle;	/* Constant after initialization */
-	refcount_t count;
-	union {
-		unsigned long entries[CONFIG_STACKDEPOT_MAX_FRAMES];	/* Frames */
-		struct {
-			/*
-			 * An important invariant of the implementation is to
-			 * only place a stack record onto the freelist iff its
-			 * refcount is zero. Because stack records with a zero
-			 * refcount are never considered as valid, it is safe to
-			 * union @entries and freelist management state below.
-			 * Conversely, as soon as an entry is off the freelist
-			 * and its refcount becomes non-zero, the below must not
-			 * be accessed until being placed back on the freelist.
-			 */
-			struct list_head free_list;	/* Links in the freelist */
-			unsigned long rcu_state;	/* RCU cookie */
-		};
-	};
-};
-
 static bool stack_depot_disabled;
 static bool __stack_depot_early_init_requested __initdata = IS_ENABLED(CONFIG_STACKDEPOT_ALWAYS_INIT);
 static bool __stack_depot_early_init_passed __initdata;
_

Patches currently in -mm which might be from osalvador@suse.de are

lib-stackdepot-fix-first-entry-having-a-0-handle.patch
lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch
mmpage_owner-maintain-own-list-of-stack_records-structs.patch
mmpage_owner-implement-the-tracking-of-the-stacks-count.patch
mmpage_owner-display-all-stacks-and-their-count.patch
mmpage_owner-filter-out-stacks-by-a-threshold.patch
mmpage_owner-update-documentation-regarding-page_owner_stacks.patch

