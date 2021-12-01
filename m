Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F370AC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  1 Dec 2021 02:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhLADCU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Nov 2021 22:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhLADCU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Nov 2021 22:02:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C50C061574
        for <mm-commits@vger.kernel.org>; Tue, 30 Nov 2021 18:58:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1D448CE1842
        for <mm-commits@vger.kernel.org>; Wed,  1 Dec 2021 02:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C970CC53FC7;
        Wed,  1 Dec 2021 02:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638327536;
        bh=zy+taVeXctLb1RP3ULxwWk+MdxwncuG+NSgVmpplX2c=;
        h=Date:From:To:Subject:From;
        b=SRBeL0ehaceeTAtj9533VSt7z32bJOcX6nvn+zTIhmloA7Y7C46xj2RDLK1zYtmZO
         zK97EMa7dU5NjYE8WwRca1cO72zx/4mdl2IO/N4OMED6heAswdTLM5OiwPKIZaoojt
         5lP6tiKuRXRGP2mqF5jsjA3cJO6cKIjnUBBpbgds=
Date:   Tue, 30 Nov 2021 18:58:55 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, chris@chris-wilson.co.uk, dvyukov@google.com,
        elver@google.com, glider@google.com, gustavoars@kernel.org,
        imran.f.khan@oracle.com, jani.nikula@intel.com,
        mika.kuoppala@linux.intel.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, vbabka@suse.cz, vjitta@codeaurora.org
Subject:  +
 lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save.patch added
 to -mm tree
Message-ID: <20211201025855.jcpQmEGpt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: always do filter_irq_stacks() in stack_depot_save()
has been added to the -mm tree.  Its filename is
     lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slab_common-use-warn-if-cache-still-has-objects-on-destroy.patch
kasan-test-add-globals-left-out-of-bounds-test.patch
kasan-add-ability-to-detect-double-kmem_cache_destroy.patch
kasan-test-add-test-case-for-double-kmem_cache_destroy.patch
panic-use-error_report_end-tracepoint-on-warnings.patch
lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save.patch

