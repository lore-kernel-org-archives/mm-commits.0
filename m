Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4897F46AE
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tMN4NPRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BFFC433C9;
	Mon, 11 Dec 2023 00:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256088;
	bh=M1aLtlI8mviVARzi+aRKyb+tnEMsXBSFF+JzKaA2axk=;
	h=Date:To:From:Subject:From;
	b=tMN4NPRrOaL65oPjUGh7UC5Aa3ZzRPewv2U/7SSQuNTldVHmtdMwNVZcdHYHVBLoY
	 kQ/CGub3rXSjn4mHJiAjt373UwnOxV3uO3OPXBJAbyiP8aeZlbED7kAVBpgDNtzzLj
	 JkBse6Jxn7SZFlTfLIGcq5pDRXatX5VQ7cFFe+Vk=
Date: Sun, 10 Dec 2023 16:54:47 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-use-fixed-sized-slots-for-stack-records.patch removed from -mm tree
Message-Id: <20231211005448.15BFFC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/stackdepot: use fixed-sized slots for stack records
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-use-fixed-sized-slots-for-stack-records.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: use fixed-sized slots for stack records
Date: Mon, 20 Nov 2023 18:47:04 +0100

Instead of storing stack records in stack depot pools one right after
another, use fixed-sized slots.

Add a new Kconfig option STACKDEPOT_MAX_FRAMES that allows to select the
size of the slot in frames.  Use 64 as the default value, which is the
maximum stack trace size both KASAN and KMSAN use right now.

Also add descriptions for other stack depot Kconfig options.

This is preparatory patch for implementing the eviction of stack records
from the stack depot.

Link: https://lkml.kernel.org/r/dce7d030a99ff61022509665187fac45b0827298.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig      |   10 ++++++++++
 lib/stackdepot.c |   13 +++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

--- a/lib/Kconfig~lib-stackdepot-use-fixed-sized-slots-for-stack-records
+++ a/lib/Kconfig
@@ -713,10 +713,20 @@ config ARCH_STACKWALK
 config STACKDEPOT
 	bool
 	select STACKTRACE
+	help
+	  Stack depot: stack trace storage that avoids duplication
 
 config STACKDEPOT_ALWAYS_INIT
 	bool
 	select STACKDEPOT
+	help
+	  Always initialize stack depot during early boot
+
+config STACKDEPOT_MAX_FRAMES
+	int "Maximum number of frames in trace saved in stack depot"
+	range 1 256
+	default 64
+	depends on STACKDEPOT
 
 config REF_TRACKER
 	bool
--- a/lib/stackdepot.c~lib-stackdepot-use-fixed-sized-slots-for-stack-records
+++ a/lib/stackdepot.c
@@ -58,9 +58,12 @@ struct stack_record {
 	u32 hash;			/* Hash in the hash table */
 	u32 size;			/* Number of stored frames */
 	union handle_parts handle;
-	unsigned long entries[];	/* Variable-sized array of frames */
+	unsigned long entries[CONFIG_STACKDEPOT_MAX_FRAMES];	/* Frames */
 };
 
+#define DEPOT_STACK_RECORD_SIZE \
+	ALIGN(sizeof(struct stack_record), 1 << DEPOT_STACK_ALIGN)
+
 static bool stack_depot_disabled;
 static bool __stack_depot_early_init_requested __initdata = IS_ENABLED(CONFIG_STACKDEPOT_ALWAYS_INIT);
 static bool __stack_depot_early_init_passed __initdata;
@@ -264,9 +267,7 @@ static struct stack_record *
 depot_alloc_stack(unsigned long *entries, int size, u32 hash, void **prealloc)
 {
 	struct stack_record *stack;
-	size_t required_size = struct_size(stack, entries, size);
-
-	required_size = ALIGN(required_size, 1 << DEPOT_STACK_ALIGN);
+	size_t required_size = DEPOT_STACK_RECORD_SIZE;
 
 	/* Check if there is not enough space in the current pool. */
 	if (unlikely(pool_offset + required_size > DEPOT_POOL_SIZE)) {
@@ -301,6 +302,10 @@ depot_alloc_stack(unsigned long *entries
 	if (stack_pools[pool_index] == NULL)
 		return NULL;
 
+	/* Limit number of saved frames to CONFIG_STACKDEPOT_MAX_FRAMES. */
+	if (size > CONFIG_STACKDEPOT_MAX_FRAMES)
+		size = CONFIG_STACKDEPOT_MAX_FRAMES;
+
 	/* Save the stack trace. */
 	stack = stack_pools[pool_index] + pool_offset;
 	stack->hash = hash;
_

Patches currently in -mm which might be from andreyknvl@google.com are


