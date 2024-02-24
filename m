Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4B64688
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739359; cv=none; b=iXHJXZBElZmu8PzSiLAymhTwXFmkJI9t+4T5mc34hySJNz+DVgiL3AM9LgObjRNPTJYr/vdsxh1vRAYEw0LPWHmu3P/Wo9OGNRIefXSI4prYGBogXwW6TXnLzbxB5l+Wn5iepXUJOxdRrj4C19C1R9VIFOWurs5fq17/09J5eGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739359; c=relaxed/simple;
	bh=z8trJFuopElZ/3uPpFMyLQteUPk2zw9tvQrxKiPlZi4=;
	h=Date:To:From:Subject:Message-Id; b=mIMVCYzF8U+LCmQUGk0xgjuYxQ8bgJ2SuCMXXSTRBtXkdvaVLGO9pz8N/ytZWOvscgXvlyor+fZKV95lfT0PQFaFQTncy76AeDoQv1a+XqK+MFYw/aM2trg+CX9BpYT/WSOMvzTZkKhYhtBdWK13fqu+GsyOSDuv3p4JjGTGW2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TDjAM8z5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TDjAM8z5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC88C43390;
	Sat, 24 Feb 2024 01:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739358;
	bh=z8trJFuopElZ/3uPpFMyLQteUPk2zw9tvQrxKiPlZi4=;
	h=Date:To:From:Subject:From;
	b=TDjAM8z544umfzOQPYLZAd6MfHLpYhYR5w66H4ppRYKZ9ruH+UssoJ+GzNIyyQXA9
	 kXwQUOqqx72JE2E404Bk/7g9gHE8qNT9vgoZs3Br7raElPRFjQQFD7XuNjYVOtJH1g
	 weqItkEF765+9Qjdnli4CBrjhRr4KW/NVDDIbF5M=
Date: Fri, 23 Feb 2024 17:49:17 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch removed from -mm tree
Message-Id: <20240224014918.6CC88C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/stackdepot: move stack_record struct definition into the header
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: lib/stackdepot: move stack_record struct definition into the header
Date: Thu, 15 Feb 2024 22:59:02 +0100

In order to move the heavy lifting into page_owner code, this one needs to
have access to the stack_record structure, which right now sits in
lib/stackdepot.c.  Move it to the stackdepot.h header so page_owner can
access stack_record's struct fields.

Link: https://lkml.kernel.org/r/20240215215907.20121-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |   47 +++++++++++++++++++++++++++++++++++
 lib/stackdepot.c           |   43 --------------------------------
 2 files changed, 47 insertions(+), 43 deletions(-)

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
 /* The pool_index is offset by 1 so the first record does not have a 0 handle. */
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


