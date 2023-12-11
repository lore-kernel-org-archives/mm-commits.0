Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD00C4421
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OxsO06dF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A125C433C8;
	Mon, 11 Dec 2023 00:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256082;
	bh=vEgeaUm0Jy2tP61wMsezmtIChHeikX17ge1MNUBqG6M=;
	h=Date:To:From:Subject:From;
	b=OxsO06dFkQVsNWuA4s5F1b2p3PusFGvNJlN4uGHXUv2b1g06RU2P062F55Ny35V1q
	 bQil8JjIIV9THMw+/kw9cZqfBFYi/rlTU2oIO01db4zlDcG2733Ue4vRWBAG2WIkHN
	 6wlMsTrhZNg8oilBm34YFol5pLLR/Xd9wTvrYHzQ=
Date: Sun, 10 Dec 2023 16:54:42 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-print-disabled-message-only-if-truly-disabled.patch removed from -mm tree
Message-Id: <20231211005442.9A125C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/stackdepot: print disabled message only if truly disabled
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-print-disabled-message-only-if-truly-disabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: print disabled message only if truly disabled
Date: Mon, 20 Nov 2023 18:46:59 +0100

Patch series "stackdepot: allow evicting stack traces", v4.

Currently, the stack depot grows indefinitely until it reaches its
capacity.  Once that happens, the stack depot stops saving new stack
traces.

This creates a problem for using the stack depot for in-field testing and
in production.

For such uses, an ideal stack trace storage should:

1. Allow saving fresh stack traces on systems with a large uptime while
   limiting the amount of memory used to store the traces;
2. Have a low performance impact.

Implementing #1 in the stack depot is impossible with the current
keep-forever approach.  This series targets to address that.  Issue #2 is
left to be addressed in a future series.

This series changes the stack depot implementation to allow evicting
unneeded stack traces from the stack depot.  The users of the stack depot
can do that via new stack_depot_save_flags(STACK_DEPOT_FLAG_GET) and
stack_depot_put APIs.

Internal changes to the stack depot code include:

1. Storing stack traces in fixed-frame-sized slots (vs precisely-sized
   slots in the current implementation); the slot size is controlled via
   CONFIG_STACKDEPOT_MAX_FRAMES (default: 64 frames);
2. Keeping available slots in a freelist (vs keeping an offset to the next
   free slot);
3. Using a read/write lock for synchronization (vs a lock-free approach
   combined with a spinlock).

This series also integrates the eviction functionality into KASAN: the
tag-based modes evict stack traces when the corresponding entry leaves the
stack ring, and Generic KASAN evicts stack traces for objects once those
leave the quarantine.

With KASAN, despite wasting some space on rounding up the size of each
stack record, the total memory consumed by stack depot gets saturated due
to the eviction of irrelevant stack traces from the stack depot.

With the tag-based KASAN modes, the average total amount of memory used
for stack traces becomes ~0.5 MB (with the current default stack ring size
of 32k entries and the default CONFIG_STACKDEPOT_MAX_FRAMES of 64).  With
Generic KASAN, the stack traces take up ~1 MB per 1 GB of RAM (as the
quarantine's size depends on the amount of RAM).

However, with KMSAN, the stack depot ends up using ~4x more memory per a
stack trace than before.  Thus, for KMSAN, the stack depot capacity is
increased accordingly.  KMSAN uses a lot of RAM for shadow memory anyway,
so the increased stack depot memory usage will not make a significant
difference.

Other users of the stack depot do not save stack traces as often as KASAN
and KMSAN.  Thus, the increased memory usage is taken as an acceptable
trade-off.  In the future, these other users can take advantage of the
eviction API to limit the memory waste.

There is no measurable boot time performance impact of these changes for
KASAN on x86-64.  I haven't done any tests for arm64 modes (the stack
depot without performance optimizations is not suitable for intended use
of those anyway), but I expect a similar result.  Obtaining and copying
stack trace frames when saving them into stack depot is what takes the
most time.

This series does not yet provide a way to configure the maximum size of
the stack depot externally (e.g.  via a command-line parameter).  This
will be added in a separate series, possibly together with the performance
improvement changes.


This patch (of 22):

Currently, if stack_depot_disable=off is passed to the kernel command-line
after stack_depot_disable=on, stack depot prints a message that it is
disabled, while it is actually enabled.

Fix this by moving printing the disabled message to
stack_depot_early_init.  Place it before the
__stack_depot_early_init_requested check, so that the message is printed
even if early stack depot init has not been requested.

Also drop the stack_table = NULL assignment from disable_stack_depot, as
stack_table is NULL by default.

Link: https://lkml.kernel.org/r/cover.1700502145.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/73a25c5fff29f3357cd7a9330e85e09bc8da2cbe.1700502145.git.andreyknvl@google.com
Fixes: e1fdc403349c ("lib: stackdepot: add support to disable stack depot")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-print-disabled-message-only-if-truly-disabled
+++ a/lib/stackdepot.c
@@ -101,14 +101,7 @@ static int next_pool_required = 1;
 
 static int __init disable_stack_depot(char *str)
 {
-	int ret;
-
-	ret = kstrtobool(str, &stack_depot_disabled);
-	if (!ret && stack_depot_disabled) {
-		pr_info("disabled\n");
-		stack_table = NULL;
-	}
-	return 0;
+	return kstrtobool(str, &stack_depot_disabled);
 }
 early_param("stack_depot_disable", disable_stack_depot);
 
@@ -131,6 +124,15 @@ int __init stack_depot_early_init(void)
 	__stack_depot_early_init_passed = true;
 
 	/*
+	 * Print disabled message even if early init has not been requested:
+	 * stack_depot_init() will not print one.
+	 */
+	if (stack_depot_disabled) {
+		pr_info("disabled\n");
+		return 0;
+	}
+
+	/*
 	 * If KASAN is enabled, use the maximum order: KASAN is frequently used
 	 * in fuzzing scenarios, which leads to a large number of different
 	 * stack traces being stored in stack depot.
@@ -138,7 +140,11 @@ int __init stack_depot_early_init(void)
 	if (kasan_enabled() && !stack_bucket_number_order)
 		stack_bucket_number_order = STACK_BUCKET_NUMBER_ORDER_MAX;
 
-	if (!__stack_depot_early_init_requested || stack_depot_disabled)
+	/*
+	 * Check if early init has been requested after setting
+	 * stack_bucket_number_order: stack_depot_init() uses its value.
+	 */
+	if (!__stack_depot_early_init_requested)
 		return 0;
 
 	/*
_

Patches currently in -mm which might be from andreyknvl@google.com are


