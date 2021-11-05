Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B19C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0876E61131
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhKESuC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhKESt7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:49:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFE75611C0;
        Fri,  5 Nov 2021 18:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636138039;
        bh=nQxvm7hfe+FON5r3TLrsJHplyxcp/JFTh4YOzbG0SAQ=;
        h=Date:From:To:Subject:From;
        b=whYI7I6n5lNhGAt0El40a5SK9Ji4AmY7eKbFsVmXvNfY4OuWwCt5vvgq/PzqtYma2
         KNi3EZHHqcETJQYwDDhY/X3nA692kN8NMU2jIuDfFbpqcwlFKYJ0DvNb4nVHOLndpR
         l7UA8gx6d9HIHF7TFOSnfEycRpW0PT808dYpleI8=
Date:   Fri, 05 Nov 2021 11:47:19 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, elver@google.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?kfence-limit-currently-covered-allocations-when-pool-nearl?=
 =?US-ASCII?Q?y-full-fix-fix.patch?= removed from -mm tree
Message-ID: <20211105184719.0tcuKJdDb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fixup! kfence: limit currently covered allocations when pool nearly full
has been removed from the -mm tree.  Its filename was
     kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix-fix.patch

This patch was dropped because it was folded into kfence-limit-currently-covered-allocations-when-pool-nearly-full.patch

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: fixup! kfence: limit currently covered allocations when pool nearly full

Fix 32 bit. size_t is UL on 64-bit only; just cast it to size_t

mm/kfence/core.c: In function `get_alloc_stack_hash':
./include/linux/minmax.h:20:28: warning: comparison of distinct pointer types lacks a cast
   20 |  (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
      |                            ^~
./include/linux/minmax.h:26:4: note: in expansion of macro `__typecheck'
   26 |   (__typecheck(x, y) && __no_side_effects(x, y))
      |    ^~~~~~~~~~~
./include/linux/minmax.h:36:24: note: in expansion of macro `__safe_cmp'
   36 |  __builtin_choose_expr(__safe_cmp(x, y), \
      |                        ^~~~~~~~~~
./include/linux/minmax.h:45:19: note: in expansion of macro `__careful_cmp'
   45 | #define min(x, y) __careful_cmp(x, y, <)
      |                   ^~~~~~~~~~~~~
mm/kfence/core.c:177:16: note: in expansion of macro `min'
  177 |  num_entries = min(num_entries, UNIQUE_ALLOC_STACK_DEPTH);
      |                ^~~

Link: https://lkml.kernel.org/r/YVQ0fE4Yil2EX8FI@elver.google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kfence/core.c~kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix-fix
+++ a/mm/kfence/core.c
@@ -130,7 +130,7 @@ atomic_t kfence_allocation_gate = ATOMIC
 static atomic_t alloc_covered[ALLOC_COVERED_SIZE];
 
 /* Stack depth used to determine uniqueness of an allocation. */
-#define UNIQUE_ALLOC_STACK_DEPTH 8UL
+#define UNIQUE_ALLOC_STACK_DEPTH ((size_t)8)
 
 /*
  * Randomness for stack hashes, making the same collisions across reboots and
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
kfence-add-note-to-documentation-about-skipping-covered-allocations.patch
kfence-test-use-kunit_skip-to-skip-tests.patch
kfence-shorten-critical-sections-of-alloc-free.patch
kfence-always-use-static-branches-to-guard-kfence_alloc.patch
kfence-default-to-dynamic-branch-instead-of-static-keys-mode.patch

