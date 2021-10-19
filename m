Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F90BC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 21:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19D616134F
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 21:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhJSVo7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 17:44:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhJSVo7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 17:44:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5A5D611CB;
        Tue, 19 Oct 2021 21:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634679766;
        bh=dU+F1qwzlCfn00SAn8y3F/p5xtg8AK+6XL2V/OCLvYg=;
        h=Date:From:To:Subject:From;
        b=ubLFZP5JJADfVu/Aaa8kaCpDyP+A6nw1SGS3kMm5fKjsEqHhc7tqDcexvCqban5Mq
         vkZ/LFfLG3sVeYq/9n0hPkMGRZ0PTOyVLiMOlJ3FlAtR08t9EmAQdA7rqbUS5d+eHX
         bQuW0XcDACQSKFNtojdULe//JbyEXLKHA/+xwGqE=
Date:   Tue, 19 Oct 2021 14:42:45 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, mm-commits@vger.kernel.org
Subject:  +
 kfence-default-to-dynamic-branch-instead-of-static-keys-mode.patch added to
 -mm tree
Message-ID: <20211019214245.2QHuPMF0m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: default to dynamic branch instead of static keys mode
has been added to the -mm tree.  Its filename is
     kfence-default-to-dynamic-branch-instead-of-static-keys-mode.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-default-to-dynamic-branch-instead-of-static-keys-mode.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-default-to-dynamic-branch-instead-of-static-keys-mode.patch

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
Subject: kfence: default to dynamic branch instead of static keys mode

We have observed that on very large machines with newer CPUs, the static
key/branch switching delay is on the order of milliseconds.  This is due
to the required broadcast IPIs, which simply does not scale well to
hundreds of CPUs (cores).  If done too frequently, this can adversely
affect tail latencies of various workloads.

One workaround is to increase the sample interval to several seconds,
while decreasing sampled allocation coverage, but the problem still exists
and could still increase tail latencies.

As already noted in the Kconfig help text, there are trade-offs: at lower
sample intervals the dynamic branch results in better performance;
however, at very large sample intervals, the static keys mode can result
in better performance -- careful benchmarking is recommended.

Our initial benchmarking showed that with large enough sample intervals
and workloads stressing the allocator, the static keys mode was slightly
better.  Evaluating and observing the possible system-wide side-effects of
the static-key-switching induced broadcast IPIs, however, was a blind spot
(in particular on large machines with 100s of cores).

Therefore, a major downside of the static keys mode is, unfortunately,
that it is hard to predict performance on new system architectures and
topologies, but also making conclusions about performance of new workloads
based on a limited set of benchmarks.

Most distributions will simply select the defaults, while targeting a
large variety of different workloads and system architectures.  As such,
the better default is CONFIG_KFENCE_STATIC_KEYS=n, and re-enabling it is
only recommended after careful evaluation.

For reference, on x86-64 the condition in kfence_alloc() generates exactly
2 instructions in the kmem_cache_alloc() fast-path:

 | ...
 | cmpl   $0x0,0x1a8021c(%rip)  # ffffffff82d560d0 <kfence_allocation_gate>
 | je     ffffffff812d6003      <kmem_cache_alloc+0x243>
 | ...

which, given kfence_allocation_gate is infrequently modified, should be
well predicted by most CPUs.

Link: https://lkml.kernel.org/r/20211019102524.2807208-2-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kfence.rst |   12 ++++++++----
 lib/Kconfig.kfence                 |   26 +++++++++++++++-----------
 2 files changed, 23 insertions(+), 15 deletions(-)

--- a/Documentation/dev-tools/kfence.rst~kfence-default-to-dynamic-branch-instead-of-static-keys-mode
+++ a/Documentation/dev-tools/kfence.rst
@@ -231,10 +231,14 @@ Guarded allocations are set up based on
 of the sample interval, the next allocation through the main allocator (SLAB or
 SLUB) returns a guarded allocation from the KFENCE object pool (allocation
 sizes up to PAGE_SIZE are supported). At this point, the timer is reset, and
-the next allocation is set up after the expiration of the interval. To "gate" a
-KFENCE allocation through the main allocator's fast-path without overhead,
-KFENCE relies on static branches via the static keys infrastructure. The static
-branch is toggled to redirect the allocation to KFENCE.
+the next allocation is set up after the expiration of the interval.
+
+When using ``CONFIG_KFENCE_STATIC_KEYS=y``, KFENCE allocations are "gated"
+through the main allocator's fast-path by relying on static branches via the
+static keys infrastructure. The static branch is toggled to redirect the
+allocation to KFENCE. Depending on sample interval, target workloads, and
+system architecture, this may perform better than the simple dynamic branch.
+Careful benchmarking is recommended.
 
 KFENCE objects each reside on a dedicated page, at either the left or right
 page boundaries selected at random. The pages to the left and right of the
--- a/lib/Kconfig.kfence~kfence-default-to-dynamic-branch-instead-of-static-keys-mode
+++ a/lib/Kconfig.kfence
@@ -25,17 +25,6 @@ menuconfig KFENCE
 
 if KFENCE
 
-config KFENCE_STATIC_KEYS
-	bool "Use static keys to set up allocations"
-	default y
-	depends on JUMP_LABEL # To ensure performance, require jump labels
-	help
-	  Use static keys (static branches) to set up KFENCE allocations. Using
-	  static keys is normally recommended, because it avoids a dynamic
-	  branch in the allocator's fast path. However, with very low sample
-	  intervals, or on systems that do not support jump labels, a dynamic
-	  branch may still be an acceptable performance trade-off.
-
 config KFENCE_SAMPLE_INTERVAL
 	int "Default sample interval in milliseconds"
 	default 100
@@ -56,6 +45,21 @@ config KFENCE_NUM_OBJECTS
 	  pages are required; with one containing the object and two adjacent
 	  ones used as guard pages.
 
+config KFENCE_STATIC_KEYS
+	bool "Use static keys to set up allocations" if EXPERT
+	depends on JUMP_LABEL
+	help
+	  Use static keys (static branches) to set up KFENCE allocations. This
+	  option is only recommended when using very large sample intervals, or
+	  performance has carefully been evaluated with this option.
+
+	  Using static keys comes with trade-offs that need to be carefully
+	  evaluated given target workloads and system architectures. Notably,
+	  enabling and disabling static keys invoke IPI broadcasts, the latency
+	  and impact of which is much harder to predict than a dynamic branch.
+
+	  Say N if you are unsure.
+
 config KFENCE_STRESS_TEST_FAULTS
 	int "Stress testing of fault handling and error reporting" if EXPERT
 	default 0
_

Patches currently in -mm which might be from elver@google.com are

lib-stackdepot-include-gfph.patch
lib-stackdepot-remove-unused-function-argument.patch
lib-stackdepot-introduce-__stack_depot_save.patch
kasan-common-provide-can_alloc-in-kasan_save_stack.patch
kasan-generic-introduce-kasan_record_aux_stack_noalloc.patch
workqueue-kasan-avoid-alloc_pages-when-recording-stack.patch
mm-fix-data-race-in-pagepoisoned.patch
stacktrace-move-filter_irq_stacks-to-kernel-stacktracec.patch
kfence-count-unexpectedly-skipped-allocations.patch
kfence-move-saving-stack-trace-of-allocations-into-__kfence_alloc.patch
kfence-limit-currently-covered-allocations-when-pool-nearly-full.patch
kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix.patch
kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix-fix.patch
kfence-add-note-to-documentation-about-skipping-covered-allocations.patch
kfence-test-use-kunit_skip-to-skip-tests.patch
kfence-shorten-critical-sections-of-alloc-free.patch
kfence-always-use-static-branches-to-guard-kfence_alloc.patch
kfence-default-to-dynamic-branch-instead-of-static-keys-mode.patch

