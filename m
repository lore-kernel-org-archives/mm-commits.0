Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C3CC433FE
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240516AbiAWX6Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235346AbiAWX6Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:58:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCFFC06173D
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 15:58:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CADF60C34
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D367C340E3;
        Sun, 23 Jan 2022 23:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982303;
        bh=7i0vfyQ0yBARxBFndUhQAE5fAkl2yn+C6Q9y+fDELpw=;
        h=Date:From:To:Subject:From;
        b=fUoK7k2O5iXCEe/PWwJOKsiPLQMnRv7QzrK96N/nc5763IWlqvxXvQilInkfeXlAb
         Eum8t2eKQoeu8kUU0V+FEUSzjvx2KoxUa0Jm7HN6meU80HPuKMxOQw8txUwlWcvtD0
         0TFmpNh0I+m3LLAuOiPWpXUTsN8xqDJO1puoBJM8=
Date:   Sun, 23 Jan 2022 15:58:22 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, chris@chris-wilson.co.uk, dvyukov@google.com,
        elver@google.com, glider@google.com, gustavoars@kernel.org,
        imran.f.khan@oracle.com, jani.nikula@intel.com,
        mika.kuoppala@linux.intel.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, vbabka@suse.cz, vjitta@codeaurora.org
Subject:  [merged]
 lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save.patch
 removed from -mm tree
Message-ID: <20220123235822.LFYzRSFop%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: always do filter_irq_stacks() in stack_depot_save()
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: lib/stackdepot: always do filter_irq_stacks() in stack_depot_save()

The non-interrupt portion of interrupt stack traces before interrupt entry
is usually arbitrary.  Therefore, saving stack traces of interrupts (that
include entries before interrupt entry) to stack depot leads to unbounded
stackdepot growth.

As such, use of filter_irq_stacks() is a requirement to ensure stackdepot
can efficiently deduplicate interrupt stacks.

Looking through all current users of stack_depot_save(), none (except
KASAN) pass the stack trace through filter_irq_stacks() before passing it
on to stack_depot_save().

Rather than adding filter_irq_stacks() to all current users of
stack_depot_save(), it became clear that stack_depot_save() should simply
do filter_irq_stacks().

Link: https://lkml.kernel.org/r/20211130095727.2378739-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c  |   13 +++++++++++++
 mm/kasan/common.c |    1 -
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/lib/stackdepot.c~lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save
+++ a/lib/stackdepot.c
@@ -328,6 +328,9 @@ EXPORT_SYMBOL_GPL(stack_depot_fetch);
  * (allocates using GFP flags of @alloc_flags). If @can_alloc is %false, avoids
  * any allocations and will fail if no space is left to store the stack trace.
  *
+ * If the stack trace in @entries is from an interrupt, only the portion up to
+ * interrupt entry is saved.
+ *
  * Context: Any context, but setting @can_alloc to %false is required if
  *          alloc_pages() cannot be used from the current context. Currently
  *          this is the case from contexts where neither %GFP_ATOMIC nor
@@ -346,6 +349,16 @@ depot_stack_handle_t __stack_depot_save(
 	unsigned long flags;
 	u32 hash;
 
+	/*
+	 * If this stack trace is from an interrupt, including anything before
+	 * interrupt entry usually leads to unbounded stackdepot growth.
+	 *
+	 * Because use of filter_irq_stacks() is a requirement to ensure
+	 * stackdepot can efficiently deduplicate interrupt stacks, always
+	 * filter_irq_stacks() to simplify all callers' use of stackdepot.
+	 */
+	nr_entries = filter_irq_stacks(entries, nr_entries);
+
 	if (unlikely(nr_entries == 0) || stack_depot_disable)
 		goto fast_exit;
 
--- a/mm/kasan/common.c~lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save
+++ a/mm/kasan/common.c
@@ -36,7 +36,6 @@ depot_stack_handle_t kasan_save_stack(gf
 	unsigned int nr_entries;
 
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
-	nr_entries = filter_irq_stacks(entries, nr_entries);
 	return __stack_depot_save(entries, nr_entries, flags, can_alloc);
 }
 
_

Patches currently in -mm which might be from elver@google.com are


