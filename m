Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DA1C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 02:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbiKWCxo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 21:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbiKWCx1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 21:53:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590838DA42
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 18:53:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E921A619FE
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 02:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDEBC433D6;
        Wed, 23 Nov 2022 02:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669172005;
        bh=PeCYU/LR+IyqHKCjWhufMvFNz2c0I/u/p5XzqDAgdQs=;
        h=Date:To:From:Subject:From;
        b=F4CqpgpN1ZqpeXefFMSzi/d4wJWhjv1iBxE2GoFYow9WmiYWojtsxtvsHzwX0uGLa
         AgqXuNf/itFh6QPjUIeInnEIlnzChtG+6iZM5u57e/JBnTQBj7dy1giUPiBAc7Z+Ww
         ZPPzvnNzVNsW7yEq8qbfme3zm0LmomeXwXHLVCaA=
Date:   Tue, 22 Nov 2022 18:53:24 -0800
To:     mm-commits@vger.kernel.org, glider@google.com, feng.tang@intel.com,
        42.hyeyoo@gmail.com, elver@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kfence-fix-stack-trace-pruning.patch removed from -mm tree
Message-Id: <20221123025325.4FDEBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kfence: fix stack trace pruning
has been removed from the -mm tree.  Its filename was
     kfence-fix-stack-trace-pruning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: fix stack trace pruning
Date: Fri, 18 Nov 2022 16:22:16 +0100

Commit b14051352465 ("mm/sl[au]b: generalize kmalloc subsystem")
refactored large parts of the kmalloc subsystem, resulting in the stack
trace pruning logic done by KFENCE to no longer work.

While b14051352465 attempted to fix the situation by including
'__kmem_cache_free' in the list of functions KFENCE should skip through,
this only works when the compiler actually optimized the tail call from
kfree() to __kmem_cache_free() into a jump (and thus kfree() _not_
appearing in the full stack trace to begin with).

In some configurations, the compiler no longer optimizes the tail call
into a jump, and __kmem_cache_free() appears in the stack trace.  This
means that the pruned stack trace shown by KFENCE would include kfree()
which is not intended - for example:

 | BUG: KFENCE: invalid free in kfree+0x7c/0x120
 |
 | Invalid free of 0xffff8883ed8fefe0 (in kfence-#126):
 |  kfree+0x7c/0x120
 |  test_double_free+0x116/0x1a9
 |  kunit_try_run_case+0x90/0xd0
 | [...]

Fix it by moving __kmem_cache_free() to the list of functions that may be
tail called by an allocator entry function, making the pruning logic work
in both the optimized and unoptimized tail call cases.

Link: https://lkml.kernel.org/r/20221118152216.3914899-1-elver@google.com
Fixes: b14051352465 ("mm/sl[au]b: generalize kmalloc subsystem")
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/report.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/kfence/report.c~kfence-fix-stack-trace-pruning
+++ a/mm/kfence/report.c
@@ -75,18 +75,23 @@ static int get_stack_skipnr(const unsign
 
 		if (str_has_prefix(buf, ARCH_FUNC_PREFIX "kfence_") ||
 		    str_has_prefix(buf, ARCH_FUNC_PREFIX "__kfence_") ||
+		    str_has_prefix(buf, ARCH_FUNC_PREFIX "__kmem_cache_free") ||
 		    !strncmp(buf, ARCH_FUNC_PREFIX "__slab_free", len)) {
 			/*
-			 * In case of tail calls from any of the below
-			 * to any of the above.
+			 * In case of tail calls from any of the below to any of
+			 * the above, optimized by the compiler such that the
+			 * stack trace would omit the initial entry point below.
 			 */
 			fallback = skipnr + 1;
 		}
 
-		/* Also the *_bulk() variants by only checking prefixes. */
+		/*
+		 * The below list should only include the initial entry points
+		 * into the slab allocators. Includes the *_bulk() variants by
+		 * checking prefixes.
+		 */
 		if (str_has_prefix(buf, ARCH_FUNC_PREFIX "kfree") ||
 		    str_has_prefix(buf, ARCH_FUNC_PREFIX "kmem_cache_free") ||
-		    str_has_prefix(buf, ARCH_FUNC_PREFIX "__kmem_cache_free") ||
 		    str_has_prefix(buf, ARCH_FUNC_PREFIX "__kmalloc") ||
 		    str_has_prefix(buf, ARCH_FUNC_PREFIX "kmem_cache_alloc"))
 			goto found;
_

Patches currently in -mm which might be from elver@google.com are


